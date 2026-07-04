import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/database/app_database.dart' as db;
import 'package:ntfyd/features/subscription/data/mappers/subscription_mapper.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';

void main() {
  final now = DateTime.utc(2026, 1, 1);

  final row = db.Subscription(
    id: 'sub-1',
    serverId: 'srv-1',
    topic: 'alerts',
    displayName: 'Alerts',
    priorityThreshold: 3,
    muted: 1,
    pinned: 0,
    createdAt: now.millisecondsSinceEpoch,
  );

  final entity = Subscription(
    id: 'sub-1',
    serverId: 'srv-1',
    topic: 'alerts',
    displayName: 'Alerts',
    priorityThreshold: 3,
    muted: true,
    pinned: false,
    createdAt: now,
  );

  group('SubscriptionMapper', () {
    test('toDomain maps a Drift row to a domain entity', () {
      expect(SubscriptionMapper.toDomain(row), equals(entity));
    });

    test('toCompanion maps a domain entity to an insert companion', () {
      final companion = SubscriptionMapper.toCompanion(entity);

      expect(companion.id.value, 'sub-1');
      expect(companion.serverId.value, 'srv-1');
      expect(companion.topic.value, 'alerts');
      expect(companion.displayName.value, 'Alerts');
      expect(companion.priorityThreshold.value, 3);
      expect(companion.muted.value, 1);
      expect(companion.pinned.value, 0);
      expect(companion.createdAt.value, now.millisecondsSinceEpoch);
    });
  });
}
