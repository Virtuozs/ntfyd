import 'package:drift/drift.dart' show Value;
import 'package:ntfyd/core/database/app_database.dart' as db;
import 'package:ntfyd/core/database/value_objects/group_with_members.dart';
import 'package:ntfyd/core/database/value_objects/message_filter.dart';
import 'package:ntfyd/features/groups/domain/entities/group.dart';
import 'package:ntfyd/features/groups/domain/entities/group_membership.dart';

/// Maps between the Drift [GroupWithMembers] join result and the domain
/// [Group] entity. Only the priority half of [MessageFilter] is persisted
/// (as a CSV `filterPriorities` column) — tag-based filtering is deferred.
class GroupMapper {
  static Group toDomain(GroupWithMembers row) {
    return Group(
      id: row.group.id,
      name: row.group.name,
      color: row.group.color,
      sortOrder: row.group.sortOrder,
      filter: _filterFromCsv(row.group.filterPriorities),
      members: row.members
          .map((m) => GroupMembership(serverId: m.serverId, topic: m.topic))
          .toSet(),
    );
  }

  static (db.GroupsCompanion, List<db.GroupMembersCompanion>) toCompanions(
    Group group,
  ) {
    final groupCompanion = db.GroupsCompanion.insert(
      id: group.id,
      name: group.name,
      color: Value(group.color),
      sortOrder: Value(group.sortOrder),
      filterPriorities: Value(_filterToCsv(group.filter)),
    );

    final memberCompanions = group.members
        .map(
          (m) => db.GroupMembersCompanion.insert(
            groupId: group.id,
            serverId: m.serverId,
            topic: m.topic,
          ),
        )
        .toList();

    return (groupCompanion, memberCompanions);
  }

  static MessageFilter? _filterFromCsv(String? csv) {
    if (csv == null || csv.isEmpty) return null;
    final priorities = csv.split(',').map(int.parse).toSet();
    return MessageFilter(priorities: priorities);
  }

  static String? _filterToCsv(MessageFilter? filter) {
    if (filter == null || filter.priorities.isEmpty) return null;
    return filter.priorities.join(',');
  }
}
