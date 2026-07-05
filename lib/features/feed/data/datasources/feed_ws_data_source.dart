import 'dart:convert';

import 'package:ntfyd/core/network/ws_connector.dart';
import 'package:ntfyd/core/network/ws_state.dart';
import 'package:ntfyd/features/feed/domain/entities/feed_connection_state.dart';

/// Decodes JSON frames from a [WsConnector] and maps its [WsState] to the
/// domain-level [FeedConnectionState]. Wraps an already-constructed
/// [WsConnector] rather than building one itself, so tests can supply a
/// [WsConnector] wired to a fake channel factory without this class
/// needing to know anything about credentials or base URLs.
class FeedWsDataSource {
  FeedWsDataSource(this._connector);

  final WsConnector _connector;

  /// Decoded JSON frames; frames that fail to decode as a JSON object are
  /// dropped (matches [WsConnector]'s own tolerant handling upstream).
  Stream<Map<String, dynamic>> get frames => _connector.frames
      .map(_tryDecode)
      .where((event) => event != null)
      .cast<Map<String, dynamic>>();

  Stream<FeedConnectionState> get connectionState =>
      _connector.stateStream.map(_mapState);

  Future<void> connect() => _connector.connect();

  Future<void> disconnect() => _connector.dispose();

  Map<String, dynamic>? _tryDecode(String frame) {
    try {
      final decoded = jsonDecode(frame);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  static FeedConnectionState _mapState(WsState state) => switch (state) {
    WsConnecting() => FeedConnectionState.connecting,
    WsConnected() => FeedConnectionState.live,
    WsReconnecting() => FeedConnectionState.reconnecting,
    WsDisconnected() => FeedConnectionState.offline,
  };
}
