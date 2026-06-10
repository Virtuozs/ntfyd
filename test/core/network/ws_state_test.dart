import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/network/ws_state.dart';

void main() {
  group('WsState => construction and field access', () {
    test('WsConnecting contructs correctly', () {
      const state = WsState.connecting();

      expect(state, isA<WsConnecting>());
    });

    test('WsConnected constructs correctly', () {
      const state = WsState.connected();

      expect(state, isA<WsConnected>());
    });

    test('WsReconnecting holds attempt number', () {
      const state = WsState.reconnecting(attempt: 3);

      expect((state as WsReconnecting).attempt, 3);
    });

    test('wsDisconnected holds optional reason', () {
      const state = WsState.disconnected(reason: 'Server Closed');
      expect((state as WsDisconnected).reason, 'Server Closed');
    });

    test('WsDisconnected is nullable', () {
      const state = WsState.disconnected();
      expect((state as WsDisconnected).reason, isNull);
    });
  });

  group('WsState => exhaustive when()', () {
    test('when() properly routes each variant to correct branch', () {
      final states = <WsState>[
        const WsState.connecting(),
        const WsState.connected(),
        const WsState.reconnecting(attempt: 3),
        const WsState.disconnected(reason: 'test'),
      ];

      final expected = [
        'connecting',
        'connected',
        'reconnecting',
        'disconnected',
      ];

      for (var i = 0; i < states.length; i++) {
        final label = states[i].when(
          connecting: () => 'connecting',
          connected: () => 'connected',
          reconnecting: (attempt) => 'reconnecting',
          disconnected: (reason) => 'disconnected',
        );
        expect(label, expected[i]);
      }
    });
  });

  group('WsState => Freezed Equality', () {
    test('two WsConnected instances are equal', () {
      const a = WsState.connected();
      const b = WsState.connected();

      expect(a, equals(b));
    });

    test('two WsReconnecting with same attempt are equal', () {
      const a = WsState.reconnecting(attempt: 3);
      const b = WsState.reconnecting(attempt: 3);

      expect(a, equals(b));
    });

    test('two WsReconnecting with different attempt are not equal', () {
      const a = WsState.reconnecting(attempt: 2);
      const b = WsState.reconnecting(attempt: 3);

      expect(a, isNot(equals(b)));
    });

    test('WsConnected and WsConnecting are not the same', () {
      const a = WsState.connected();
      const b = WsState.connecting();

      expect(a, isNot(equals(b)));
    });
  });
}
