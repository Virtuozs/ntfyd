import 'package:drift/drift.dart';
import 'package:ntfyd/core/database/app_database.dart';
import 'package:ntfyd/core/database/tables/group_members_table.dart';
import 'package:ntfyd/core/database/tables/groups_table.dart';
import 'package:ntfyd/core/database/tables/notification_messages_table.dart';
import 'package:ntfyd/core/database/value_objects/group_with_members.dart';
import 'package:ntfyd/core/database/value_objects/message_filter.dart';
import 'package:rxdart/rxdart.dart';

part 'group_dao.g.dart';

@DriftAccessor(tables: [Groups, GroupMembers, NotificationMessages])
class GroupDao extends DatabaseAccessor<AppDatabase> with _$GroupDaoMixin {
  GroupDao(super.db);

  Stream<List<GroupWithMembers>> watchAll() {
    final groupStream = select(groups).watch();
    final memberStream = select(groupMembers).watch();

    return Rx.combineLatest2(groupStream, memberStream, (
      List<Group> allGroups,
      List<GroupMember> allMembers,
    ) {
      return allGroups.map((g) {
        final members = allMembers.where((m) => m.groupId == g.id).toList();
        return GroupWithMembers(group: g, members: members);
      }).toList();
    });
  }

  Future<void> upsert(
    GroupsCompanion group,
    List<GroupMembersCompanion> members,
  ) {
    return transaction(() async {
      await into(groups).insertOnConflictUpdate(group);

      // Resolve groupId either from the companion or the existing row.
      final groupId = group.id.value;

      // Replace all members: delete existing, insert new set.

      await (delete(
        groupMembers,
      )..where((t) => t.groupId.equals(groupId))).go();

      for (final member in members) {
        await into(groupMembers).insertOnConflictUpdate(member);
      }
    });
  }

  Future<void> deleteGroup(String groupId) {
    return (delete(groups)..where((t) => t.id.equals(groupId))).go();
  }

  /// Return merged feed of messages from all member (serverId, topic)
  Stream<List<NotificationMessage>> watchFeedForGroup(
    String groupId, {
    MessageFilter? filter,
  }) {
    return select(groupMembers).watch().asyncExpand((allMembers) {
      final memberRows = allMembers.where((m) => m.groupId == groupId).toList();

      if (memberRows.isEmpty) {
        return Stream.value(<NotificationMessage>[]);
      }

      // Build OR conditions for each (serverId, topic) pair.
      final query = select(notificationMessages)
        ..where((t) {
          Expression<bool> condition = const Constant(false);
          for (final m in memberRows) {
            condition =
                condition |
                (t.serverId.equals(m.serverId) & t.topic.equals(m.topic));
          }
          return condition;
        });

      if (filter != null && filter.priorities.isNotEmpty) {
        query.where((t) => t.priority.isIn(filter.priorities));
      }

      query.orderBy([
        (t) => OrderingTerm(expression: t.isPinned, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.time, mode: OrderingMode.desc),
      ]);

      return query.watch();
    });
  }

  /// Return all messages across all topics and servers
  Stream<List<NotificationMessage>> watchAllFeed({MessageFilter? filter}) {
    final query = select(notificationMessages);

    if (filter != null && filter.priorities.isNotEmpty) {
      query.where((t) => t.priority.isIn(filter.priorities));
    }

    query.orderBy([
      (t) => OrderingTerm(expression: t.isPinned, mode: OrderingMode.desc),
      (t) => OrderingTerm(expression: t.time, mode: OrderingMode.desc),
    ]);

    return query.watch();
  }
}
