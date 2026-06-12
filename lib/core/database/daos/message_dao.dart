import 'package:drift/drift.dart';
import 'package:ntfyd/core/database/app_database.dart';
import 'package:ntfyd/core/database/tables/notification_messages_table.dart';
import 'package:ntfyd/core/database/value_objects/message_filter.dart';

part 'message_dao.g.dart';

@DriftAccessor(tables: [NotificationMessages])
class MessageDao extends DatabaseAccessor<AppDatabase> with _$MessageDaoMixin {
  MessageDao(super.db);

  /// Returns message ordered: pinned first, then by time DESC.
  /// Applies [filter] when provided
  Stream<List<NotificationMessage>> watchByTopic(
    String serverId,
    String topic, {
    MessageFilter? filter,
  }) {
    final query = select(notificationMessages)
      ..where((t) => t.serverId.equals(serverId) & t.topic.equals(topic));

    if (filter != null && filter.priorities.isNotEmpty) {
      query.where((t) => t.priority.isIn(filter.priorities));
    }

    // Note: tags and filter requires substring matching on the JSON-encoded tags column.
    // so it will be defered later

    query.orderBy([
      (t) => OrderingTerm(expression: t.isPinned, mode: OrderingMode.desc),
      (t) => OrderingTerm(expression: t.time, mode: OrderingMode.desc),
    ]);

    return query.watch();
  }

  Future<void> insertOrReplace(NotificationMessagesCompanion row) {
    return into(notificationMessages).insertOnConflictUpdate(row);
  }

  Future<void> markRead(String serverId, String id, bool read) {
    return (update(notificationMessages)
          ..where((t) => t.serverId.equals(serverId) & t.id.equals(id)))
        .write(NotificationMessagesCompanion(isRead: Value(read ? 1 : 0)));
  }

  Future<void> togglePin(String serverId, String id) async {
    final row = await (select(
      notificationMessages,
    )..where((t) => t.serverId.equals(serverId) & t.id.equals(id))).getSingle();

    final newValue = row.isPinned == 1 ? 0 : 1;

    await (update(notificationMessages)
          ..where((t) => t.serverId.equals(serverId) & t.id.equals(id)))
        .write(NotificationMessagesCompanion(isPinned: Value(newValue)));
  }

  Future<void> deleteById(String serverId, String id) {
    return (delete(
      notificationMessages,
    )..where((t) => t.serverId.equals(serverId) & t.id.equals(id))).go();
  }

  Future<void> clearByTopic(String serverId, String topic) {
    return (delete(
      notificationMessages,
    )..where((t) => t.serverId.equals(serverId) & t.topic.equals(topic))).go();
  }

  /// Return the ID of the message with latest [time] for the given (serverId, topic).
  /// Used for since= catch-uo.
  Future<String?> getLastId(String serverId, String topic) async {
    final query = select(notificationMessages)
      ..where((t) => t.serverId.equals(serverId) & t.topic.equals(topic))
      ..orderBy([
        (t) => OrderingTerm(expression: t.time, mode: OrderingMode.desc),
      ])
      ..limit(1);

    final row = await query.getSingleOrNull();
    return row?.id;
  }

  /// Delete messages where expires < now in (Unix seconds).
  Future<void> purgeExpired() {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return (delete(
      notificationMessages,
    )..where((t) => t.expires.isSmallerThanValue(now))).go();
  }

  /// Delete messages exceeding retention policy
  /// [maxAgeDays] == 0 => delete all (regardless of age),
  /// [maxRows] == 0 => delete all (regardless of count).
  Future<void> purgeByRetention(int maxAgeDays, int maxRows) async {
    if (maxAgeDays <= 0 || maxRows <= 0) {
      await delete(notificationMessages).go();
      return;
    }

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final cutoff = now - (maxAgeDays * 86400);

    // Delete rows older than the age cutoff.
    await (delete(
      notificationMessages,
    )..where((t) => t.time.isSmallerThanValue(cutoff))).go();

    // Enforce row count limit: delete oldest rows beyond maxRows,
    // across the entire table (global limit per spec wording).
    final remaining =
        await (select(notificationMessages)..orderBy([
              (t) => OrderingTerm(expression: t.time, mode: OrderingMode.desc),
            ]))
            .get();

    if (remaining.length > maxRows) {
      final toDelete = remaining.sublist(maxRows);
      for (final row in toDelete) {
        await (delete(notificationMessages)..where(
              (t) => t.serverId.equals(row.serverId) & t.id.equals(row.id),
            ))
            .go();
      }
    }
  }

  Stream<int> watchUnreadCount(String serverId, String topic) {
    final query = select(notificationMessages)
      ..where(
        (t) =>
            t.serverId.equals(serverId) &
            t.topic.equals(topic) &
            t.isRead.equals(0),
      );

    return query.watch().map((rows) => rows.length);
  }
}
