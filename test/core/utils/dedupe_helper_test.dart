import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/utils/dedupe_helper.dart';

class FakeMessage implements Deduplicable {
  const FakeMessage({
    required this.serverId,
    required this.id,
    required this.receivedAt,
    this.label = '',
  });

  @override
  final String serverId;
  @override
  final String id;
  @override
  final DateTime receivedAt;
  final String label;
}

void main() {
  group('dedupeMessages', () {
    test('two rows with same (serverId, id) -> only one retained', () {
      final rows = [
        FakeMessage(
          serverId: 'srv-1',
          id: 'msg-1',
          receivedAt: DateTime(2026, 1, 1, 10, 0),
          label: 'first',
        ),
        FakeMessage(
          serverId: 'srv-1',
          id: 'msg-1',
          receivedAt: DateTime(2026, 1, 1, 11, 0),
          label: 'second',
        ),
      ];

      final result = dedupeMessages(rows);

      expect(result.length, equals(1));
    });

    test('row with latest receivedAt is retained', () {
      final older = FakeMessage(
        serverId: 'srv-1',
        id: 'msg-1',
        receivedAt: DateTime(2026, 1, 1, 10, 0),
        label: 'older',
      );
      final newer = FakeMessage(
        serverId: 'srv-1',
        id: 'msg-1',
        receivedAt: DateTime(2026, 1, 1, 11, 0),
        label: 'newer',
      );

      final result = dedupeMessages([older, newer]);

      expect(result.single.label, equals('newer'));
    });

    test('different (serverId, id) pairs are both retained', () {
      final rows = [
        FakeMessage(
          serverId: 'srv-1',
          id: 'msg-1',
          receivedAt: DateTime(2026, 1, 1),
        ),
        FakeMessage(
          serverId: 'srv-1',
          id: 'msg-2',
          receivedAt: DateTime(2026, 1, 1),
        ),
        FakeMessage(
          serverId: 'srv-2',
          id: 'msg-1', // same id, different server
          receivedAt: DateTime(2026, 1, 1),
        ),
      ];

      final result = dedupeMessages(rows);

      expect(result.length, equals(3));
    });

    test('empty list returns empty list', () {
      expect(dedupeMessages(<FakeMessage>[]), isEmpty);
    });

    test('order of latest-wins is independent of input order', () {
      final newer = FakeMessage(
        serverId: 'srv-1',
        id: 'msg-1',
        receivedAt: DateTime(2026, 1, 1, 11, 0),
        label: 'newer',
      );
      final older = FakeMessage(
        serverId: 'srv-1',
        id: 'msg-1',
        receivedAt: DateTime(2026, 1, 1, 10, 0),
        label: 'older',
      );

      final result = dedupeMessages([newer, older]);

      expect(result.single.label, equals('newer'));
    });
  });
}
