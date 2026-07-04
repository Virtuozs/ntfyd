import 'package:drift/drift.dart' show Value;
import 'package:ntfyd/core/database/app_database.dart' as db;
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';

/// Maps between the Drift-generated [db.Subscription] row and the domain
/// [Subscription] entity.
///
/// [Subscription.muted]/[Subscription.pinned] map to/from `0`/`1`.
/// [Subscription.createdAt] maps to/from epoch milliseconds, treated as UTC
/// (matches [ServerConfigMapper]'s convention).
class SubscriptionMapper {
  static Subscription toDomain(db.Subscription row) {
    return Subscription(
      id: row.id,
      serverId: row.serverId,
      topic: row.topic,
      displayName: row.displayName,
      priorityThreshold: row.priorityThreshold,
      muted: row.muted == 1,
      pinned: row.pinned == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        row.createdAt,
        isUtc: true,
      ),
    );
  }

  static db.SubscriptionsCompanion toCompanion(Subscription entity) {
    return db.SubscriptionsCompanion.insert(
      id: entity.id,
      serverId: entity.serverId,
      topic: entity.topic,
      displayName: entity.displayName,
      priorityThreshold: Value(entity.priorityThreshold),
      muted: Value(entity.muted ? 1 : 0),
      pinned: Value(entity.pinned ? 1 : 0),
      createdAt: entity.createdAt.toUtc().millisecondsSinceEpoch,
    );
  }
}
