import 'dart:async';

import 'package:ntfyd/core/network/backoff_strategy.dart';
import 'package:ntfyd/core/network/ws_connector.dart';
import 'package:ntfyd/core/network/ws_state.dart';
import 'package:test/test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// A hand-rolled WebSocketChannel test double. Only `stream` and `sink` are
/// exercised by WsConnector, so everything else is satisfied via noSuchMethod.
class FakeWebSocketChannel implements WebSocketChannel {
  FakeWebSocketChannel() : controller = StreamController<dynamic>();

  final StreamController<dynamic> controller;
  final List<dynamic> sent = <dynamic>[];
  bool closed = false;

  /// Push a raw text frame to listeners.
  void emit(String frame) => controller.add(frame);

  /// Push a stream error (e.g. simulated socket failure).
  void emitError(Object error) => controller.addError(error);

  /// Close the inbound stream, triggering the connector's onDone -> reconnect.
  Future<void> simulateDisconnect() => controller.close();

  @override
  Stream<dynamic> get stream => controller.stream;

  @override
  WebSocketSink get sink => _FakeSink(this);

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeSink implements WebSocketSink {
  _FakeSink(this.channel);

  final FakeWebSocketChannel channel;

  @override
  void add(dynamic data) => channel.sent.add(data);

  @override
  Future<void> close([int? closeCode, String? closeReason]) async {
    channel.closed = true;
    if (!channel.controller.isClosed) {
      await channel.controller.close();
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// Flush pending microtasks/events so async reconnect chains settle.
Future<void> pump([int times = 6]) async {
  for (var i = 0; i < times; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  // Zero jitter => BackoffStrategy.next(attempt) is deterministic.
  const backoff = BackoffStrategy(
    initial: Duration(seconds: 1),
    max: Duration(seconds: 60),
    jitter: 0,
  );

  late List<FakeWebSocketChannel> channels;
  late int factoryCalls;
  late List<Uri> requestedUris;
  late List<Map<String, dynamic>?> requestedHeaders;
  late List<Duration> recordedDelays;

  setUp(() {
    channels = <FakeWebSocketChannel>[];
    factoryCalls = 0;
    requestedUris = <Uri>[];
    requestedHeaders = <Map<String, dynamic>?>[];
    recordedDelays = <Duration>[];
  });

  WsChannelFactory queueFactory() {
    return (Uri uri, {Map<String, dynamic>? headers}) {
      requestedUris.add(uri);
      requestedHeaders.add(headers);
      final channel = channels[factoryCalls];
      factoryCalls++;
      return channel;
    };
  }

  Future<void> fakeDelay(Duration duration) async {
    recordedDelays.add(duration);
  }

  WsConnector buildConnector({
    String baseUrl = 'https://ntfy.sh',
    String topic = 'mytopic',
    String? authHeader,
  }) {
    return WsConnector(
      baseUrl: baseUrl,
      topic: topic,
      authHeader: authHeader,
      channelFactory: queueFactory(),
      backoff: backoff,
      delay: fakeDelay,
    );
  }

  group('handshake', () {
    test('emits WsConnected after the open frame', () async {
      channels = [FakeWebSocketChannel()];
      final connector = buildConnector();
      final states = <WsState>[];
      connector.stateStream.listen(states.add);

      await connector.connect();
      channels[0].emit('{"id":"a1","event":"open","topic":"mytopic"}');
      await pump();

      expect(states, contains(const WsState.connecting()));
      expect(states, contains(const WsState.connected()));

      await connector.disconnect();
    });

    test(
      'connects to wss with the correct path and no since on first attempt',
      () async {
        channels = [FakeWebSocketChannel()];
        final connector = buildConnector(topic: 'topicX');

        await connector.connect();
        await pump();

        final uri = requestedUris.single;
        expect(uri.scheme, 'wss');
        expect(uri.host, 'ntfy.sh');
        expect(uri.path, '/topicX/ws');
        expect(uri.queryParameters.containsKey('since'), isFalse);

        await connector.disconnect();
      },
    );

    test('attaches Authorization header (never in the URL) per NFR3', () async {
      channels = [FakeWebSocketChannel()];
      final connector = buildConnector(authHeader: 'Bearer tk_secret');

      await connector.connect();
      await pump();

      expect(requestedHeaders.single, {'Authorization': 'Bearer tk_secret'});
      expect(requestedUris.single.toString(), isNot(contains('tk_secret')));

      await connector.disconnect();
    });
  });

  group('reconnect', () {
    test(
      'emits WsReconnecting(attempt: 1) after a simulated disconnect',
      () async {
        channels = [FakeWebSocketChannel(), FakeWebSocketChannel()];
        final connector = buildConnector();
        final states = <WsState>[];
        connector.stateStream.listen(states.add);

        await connector.connect();
        channels[0].emit('{"id":"a1","event":"open","topic":"mytopic"}');
        await pump();
        await channels[0].simulateDisconnect();
        await pump();

        expect(states, contains(const WsState.reconnecting(attempt: 1)));
        expect(factoryCalls, 2); // a fresh channel was created for the retry

        await connector.disconnect();
      },
    );

    test(
      'respects backoff: delays by next(0)==initial, not immediately',
      () async {
        channels = [FakeWebSocketChannel(), FakeWebSocketChannel()];
        final connector = buildConnector();

        await connector.connect();
        channels[0].emit('{"id":"a1","event":"open","topic":"mytopic"}');
        await pump();
        await channels[0].simulateDisconnect();
        await pump();

        expect(recordedDelays, isNotEmpty);
        expect(recordedDelays.first, const Duration(seconds: 1));

        await connector.disconnect();
      },
    );

    test('passes since=<lastMessageId> on reconnect', () async {
      channels = [FakeWebSocketChannel(), FakeWebSocketChannel()];
      final connector = buildConnector(topic: 'topicX');

      await connector.connect();
      channels[0].emit('{"id":"a1","event":"open","topic":"topicX"}');
      channels[0].emit(
        '{"id":"msg-123","event":"message","topic":"topicX","message":"hi"}',
      );
      await pump();
      await channels[0].simulateDisconnect();
      await pump();

      expect(connector.lastMessageId, 'msg-123');
      expect(requestedUris.length, 2);
      expect(requestedUris[1].path, '/topicX/ws');
      expect(requestedUris[1].queryParameters['since'], 'msg-123');

      await connector.disconnect();
    });

    test('keepalive frames do not advance lastMessageId', () async {
      channels = [FakeWebSocketChannel()];
      final connector = buildConnector();

      await connector.connect();
      channels[0].emit('{"id":"k1","event":"keepalive","topic":"mytopic"}');
      await pump();

      expect(connector.lastMessageId, isNull);

      await connector.disconnect();
    });
  });

  group('frames + disconnect', () {
    test('forwards raw frames downstream untouched', () async {
      channels = [FakeWebSocketChannel()];
      final connector = buildConnector();
      final received = <String>[];
      connector.frames.listen(received.add);

      await connector.connect();
      const raw =
          '{"id":"a1","event":"message","topic":"mytopic","message":"x"}';
      channels[0].emit(raw);
      await pump();

      expect(received, contains(raw));

      await connector.disconnect();
    });

    test('disconnect emits WsDisconnected and stops reconnecting', () async {
      channels = [FakeWebSocketChannel()];
      final connector = buildConnector();
      final states = <WsState>[];
      connector.stateStream.listen(states.add);

      await connector.connect();
      channels[0].emit('{"id":"a1","event":"open","topic":"mytopic"}');
      await pump();
      await connector.disconnect();
      await pump();

      expect(states.last, const WsState.disconnected(reason: 'client'));
      expect(factoryCalls, 1); // no retry was attempted
    });
  });
}
