import 'dart:async';
import 'dart:convert';

import 'package:ntfyd/core/network/backoff_strategy.dart';
import 'package:ntfyd/core/network/ws_state.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Creates a [WebSocketChannel] for [uri]. The connector calls this once per
/// (re)connect attempt, since a closed channel cannot be reopened. Injected so
/// tests can supply a fake channel; production uses [_defaultChannelFactory].
typedef WsChannelFactory =
    WebSocketChannel Function(Uri uri, {Map<String, dynamic>? headers});

/// Suspends for [duration]. Injected so tests can record the requested delay
/// and return immediately instead of waiting on the wall clock.
typedef DelayFn = Future<void> Function(Duration duration);

WebSocketChannel _defaultChannelFactory(
  Uri uri, {
  Map<String, dynamic>? headers,
}) {
  return IOWebSocketChannel.connect(uri, headers: headers);
}

/// Manages a single persistent WebSocket subscription to one ntfy topic.
///
/// Responsibilities:
///   - Connect to `ws(s)://{baseUrl}/{topic}/ws` with an optional
///     `Authorization` header (never a query string — NFR3).
///   - Expose a [Stream] of raw JSON frames; the data layer maps them.
///   - Reconnect on drop with exponential backoff + jitter ([BackoffStrategy]).
///   - Resume from the last seen `message` id via `?since=` on reconnect.
class WsConnector {
  WsConnector({
    required this.baseUrl,
    required this.topic,
    this.authHeader,
    WsChannelFactory? channelFactory,
    BackoffStrategy? backoff,
    DelayFn? delay,
  }) : channelFactory = channelFactory ?? _defaultChannelFactory,
       backoff =
           backoff ??
           const BackoffStrategy(
             initial: Duration(seconds: 1),
             max: Duration(seconds: 60),
           ),
       delay = delay ?? Future<void>.delayed;

  final String baseUrl;
  final String topic;
  final String? authHeader;
  final WsChannelFactory channelFactory;
  final BackoffStrategy backoff;
  final DelayFn delay;

  bool _reconnecting = false;

  final StreamController<String> _framesController =
      StreamController<String>.broadcast();
  final StreamController<WsState> _stateController =
      StreamController<WsState>.broadcast();

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  String? _lastMessageId;
  int _attempt = 0;
  bool _manuallyClosed = false;

  /// Raw JSON text frames exactly as received from the server.
  Stream<String> get frames => _framesController.stream;

  /// Connection lifecycle (connecting / connected / reconnecting / disconnected).
  Stream<WsState> get stateStream => _stateController.stream;

  /// Id of the last `message` event seen; used for `since=` catch-up.
  String? get lastMessageId => _lastMessageId;

  Future<void> connect() async {
    _manuallyClosed = false;
    _attempt = 0;
    await _open();
  }

  Future<void> _open() async {
    _stateController.add(const WsState.connecting());
    final Uri uri = _buildUri();
    final Map<String, dynamic>? headers = authHeader == null
        ? null
        : <String, dynamic>{'Authorization': authHeader};

    try {
      final WebSocketChannel channel = channelFactory(uri, headers: headers);
      _channel = channel;
      _subscription = channel.stream.listen(
        _onFrame,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: true,
      );
    } catch (error) {
      await _scheduleReconnect(error.toString());
    }
  }

  void _onFrame(dynamic raw) {
    final String frame = raw is String ? raw : raw.toString();
    final Map<String, dynamic>? event = _tryDecode(frame);
    final Object? eventType = event?['event'];

    if (eventType == 'open') {
      _attempt = 0;
      _stateController.add(const WsState.connected());
    } else if (eventType == 'message') {
      final Object? id = event?['id'];
      if (id is String) _lastMessageId = id;
    }
    // keepalive / message_delete / message_clear: forwarded raw, no id update.

    _framesController.add(frame);
  }

  Map<String, dynamic>? _tryDecode(String frame) {
    try {
      final dynamic decoded = jsonDecode(frame);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  void _onError(Object error, [StackTrace? stackTrace]) {
    unawaited(_scheduleReconnect(error.toString()));
  }

  void _onDone() {
    if (_manuallyClosed) return;
    unawaited(_scheduleReconnect('connection closed'));
  }

  Future<void> _scheduleReconnect(String reason) async {
    if (_manuallyClosed || _reconnecting) return;

    _reconnecting = true;

    try {
      await _subscription?.cancel();
      _subscription = null;

      await _channel?.sink.close();
      _channel = null;

      _attempt++;
      _stateController.add(WsState.reconnecting(attempt: _attempt));

      // next(0) == initial for the first retry (deterministic when jitter == 0).
      await delay(backoff.next(_attempt - 1));

      if (_manuallyClosed) return;
      await _open();
    } finally {
      _reconnecting = false;
    }
  }

  Future<void> disconnect() async {
    _manuallyClosed = true;
    await _subscription?.cancel();
    _subscription = null;
    await _channel?.sink.close();
    _channel = null;
    _stateController.add(const WsState.disconnected(reason: 'client'));
  }

  /// Releases all stream controllers. Call when the connector is discarded.
  Future<void> dispose() async {
    await disconnect();
    await _framesController.close();
    await _stateController.close();
  }

  Uri _buildUri() {
    String normalized = baseUrl.trim();
    while (normalized.endsWith('/')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }

    final Uri parsed = Uri.parse(normalized);
    final String wsScheme = parsed.scheme == 'https'
        ? 'wss'
        : parsed.scheme == 'http'
        ? 'ws'
        : parsed.scheme; // already ws/wss

    final String path = '${parsed.path}/$topic/ws';
    final Map<String, String> query = <String, String>{};
    if (_lastMessageId != null) {
      query['since'] = _lastMessageId!;
    }

    return parsed.replace(
      scheme: wsScheme,
      path: path,
      queryParameters: query.isEmpty ? null : query,
    );
  }
}
