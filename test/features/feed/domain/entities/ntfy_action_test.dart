import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/features/feed/domain/entities/ntfy_action.dart';

void main() {
  group('NtfyAction', () {
    test('ViewAction holds label/url and defaults clear to false', () {
      const action = NtfyAction.view(label: 'Open', url: 'https://example.com');

      expect(action, isA<ViewAction>());
      action.when(
        view: (label, url, clear) {
          expect(label, 'Open');
          expect(url, 'https://example.com');
          expect(clear, isFalse);
        },
        http: (_, __, ___, ____, _____, ______) => fail('expected view'),
        broadcast: (_, __, ___, ____) => fail('expected view'),
        copy: (_, __, ___) => fail('expected view'),
      );
    });

    test('HttpAction defaults method to POST and headers to empty map', () {
      const action = NtfyAction.http(
        label: 'Ping',
        url: 'https://example.com/ping',
      );

      expect(action, isA<HttpAction>());
      action.when(
        view: (_, __, ___) => fail('expected http'),
        http: (label, url, method, headers, body, clear) {
          expect(method, 'POST');
          expect(headers, isEmpty);
          expect(body, isNull);
          expect(clear, isFalse);
        },
        broadcast: (_, __, ___, ____) => fail('expected http'),
        copy: (_, __, ___) => fail('expected http'),
      );
    });

    test('BroadcastAction defaults intent to io.heckel.ntfy.USER_ACTION', () {
      const action = NtfyAction.broadcast(label: 'Trigger');

      action.when(
        view: (_, __, ___) => fail('expected broadcast'),
        http: (_, __, ___, ____, _____, ______) => fail('expected broadcast'),
        broadcast: (label, intent, extras, clear) {
          expect(intent, 'io.heckel.ntfy.USER_ACTION');
          expect(extras, isEmpty);
        },
        copy: (_, __, ___) => fail('expected broadcast'),
      );
    });

    test('CopyAction holds label/value', () {
      const action = NtfyAction.copy(label: 'Copy code', value: '123456');

      action.when(
        view: (_, __, ___) => fail('expected copy'),
        http: (_, __, ___, ____, _____, ______) => fail('expected copy'),
        broadcast: (_, __, ___, ____) => fail('expected copy'),
        copy: (label, value, clear) {
          expect(label, 'Copy code');
          expect(value, '123456');
        },
      );
    });
  });
}
