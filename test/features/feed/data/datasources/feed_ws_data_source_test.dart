import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/network/backoff_strategy.dart';
import 'package:ntfyd/core/network/ws_connector.dart';
import 'package:ntfyd/features/feed/data/datasources/feed_ws_data_source.dart';
import 'package:ntfyd/features/feed/domain/entities/feed_connection_state.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Hand-rolled WebSocketChannel test double (same shape as
/// `test/core/network/ws_connector_test.dart`'s). Only `stream`/`sink` are
/// exercised by [WsConnector].
class FakeWebSocketChannel implements WebSocketChannel {
  FakeWebSocketChannel() : controller = StreamController<dynamic>();

  final StreamController<dynamic> controller;

  void emit(String frame) => controller.add(frame);

  @override
  Stream<dynamic> get stream => controller.stream;

  @override
  WebSocketSink get sink => _FakeSink(controller);

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeSink implements WebSocketSink {
  _FakeSink(this.controller);

  final StreamController<dynamic> controller;

  @override
  void add(dynamic data) {}

  @override
  Future<void> close([int? closeCode, String? closeReason]) async {
    if (!controller.isClosed) await controller.close();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

Future<void> pump([int times = 4]) async {
  for (var i = 0; i < times; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  const backoff = BackoffStrategy(
    initial: Duration(seconds: 1),
    max: Duration(seconds: 60),
    jitter: 0,
  );

  late FakeWebSocketChannel channel;
  late WsConnector connector;
  late FeedWsDataSource dataSource;

  setUp(() {
    channel = FakeWebSocketChannel();
    connector = WsConnector(
      baseUrl: 'https://ntfy.sh',
      topic: 'alerts',
      channelFactory: (_, {headers}) => channel,
      backoff: backoff,
      delay: (_) async {},
    );
    dataSource = FeedWsDataSource(connector);
  });

  tearDown(() async {
    await connector.dispose();
  });

  group('frames', () {
    test('decodes a valid JSON object frame', () async {
      final frames = <Map<String, dynamic>>[];
      dataSource.frames.listen(frames.add);

      await dataSource.connect();
      channel.emit(
        '{"id":"msg-1","event":"message","time":1751700000,"topic":"alerts"}',
      );
      await pump();

      expect(frames, hasLength(1));
      expect(frames.first['id'], 'msg-1');
      expect(frames.first['event'], 'message');
    });

    test('drops frames that are not valid JSON objects', () async {
      final frames = <Map<String, dynamic>>[];
      dataSource.frames.listen(frames.add);

      await dataSource.connect();
      channel.emit('not json');
      channel.emit('[1, 2, 3]');
      await pump();

      expect(frames, isEmpty);
    });
  });

  group('connectionState', () {
    test('maps connecting -> connecting, then open frame -> live', () async {
      final states = <FeedConnectionState>[];
      dataSource.connectionState.listen(states.add);

      await dataSource.connect();
      await pump();
      channel.emit('{"event":"open","topic":"alerts"}');
      await pump();

      expect(states, [
        FeedConnectionState.connecting,
        FeedConnectionState.live,
      ]);
    });
  });
}
