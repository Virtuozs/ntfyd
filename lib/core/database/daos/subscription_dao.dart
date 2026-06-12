import 'package:drift/drift.dart';
import 'package:ntfyd/core/database/app_database.dart';
import 'package:ntfyd/core/database/tables/subscriptions_table.dart';

part 'subscription_dao.g.dart';

@DriftAccessor(tables: [Subscriptions])
class SubscriptionDao extends DatabaseAccessor<AppDatabase>
    with _$SubscriptionDaoMixin {
  SubscriptionDao(super.db);

  Stream<List<Subscription>> watchByServer(String serverId) {
    return (select(
      subscriptions,
    )..where((t) => t.serverId.equals(serverId))).watch();
  }

  Future<Subscription?> findByTopic(String serverId, String topic) {
    return (select(subscriptions)
          ..where((t) => t.serverId.equals(serverId) & t.topic.equals(topic)))
        .getSingleOrNull();
  }

  Future<void> upsert(SubscriptionsCompanion row) {
    return into(subscriptions).insertOnConflictUpdate(row);
  }

  Future<void> deleteByTopic(String serverId, String topic) {
    return (delete(
      subscriptions,
    )..where((t) => t.serverId.equals(serverId) & t.topic.equals(topic))).go();
  }

  Future<void> togglePin(String id) {
    return _toggleBoolColumn(id, (t) => t.pinned);
  }

  Future<void> toggleMute(String id) {
    return _toggleBoolColumn(id, (t) => t.muted);
  }

  Future<void> _toggleBoolColumn(
    String id,
    GeneratedColumn<int> Function($SubscriptionsTable t) column,
  ) async {
    final row = await (select(
      subscriptions,
    )..where((t) => t.id.equals(id))).getSingle();

    final isPinnedColumn = column(subscriptions) == subscriptions.pinned;
    final currentValue = isPinnedColumn ? row.pinned : row.muted;
    final newValue = currentValue == 1 ? 0 : 1;

    final companion = isPinnedColumn
        ? SubscriptionsCompanion(pinned: Value(newValue))
        : SubscriptionsCompanion(muted: Value(newValue));

    await (update(
      subscriptions,
    )..where((t) => t.id.equals(id))).write(companion);
  }
}
