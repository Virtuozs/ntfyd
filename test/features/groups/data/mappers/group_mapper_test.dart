import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/database/app_database.dart' as db;
import 'package:ntfyd/core/database/value_objects/group_with_members.dart';
import 'package:ntfyd/core/database/value_objects/message_filter.dart';
import 'package:ntfyd/features/groups/data/mappers/group_mapper.dart';
import 'package:ntfyd/features/groups/domain/entities/group.dart';
import 'package:ntfyd/features/groups/domain/entities/group_membership.dart';

void main() {
  group('GroupMapper.toDomain', () {
    test('maps a group with members and a priority filter', () {
      final row = GroupWithMembers(
        group: const db.Group(
          id: 'grp-1',
          name: 'Homelab',
          color: 0xFF0000FF,
          sortOrder: 2,
          filterPriorities: '4,5',
        ),
        members: const [
          db.GroupMember(groupId: 'grp-1', serverId: 'srv-1', topic: 'alerts'),
          db.GroupMember(groupId: 'grp-1', serverId: 'srv-2', topic: 'backups'),
        ],
      );

      final group = GroupMapper.toDomain(row);

      expect(group.id, 'grp-1');
      expect(group.name, 'Homelab');
      expect(group.color, 0xFF0000FF);
      expect(group.sortOrder, 2);
      expect(group.filter, const MessageFilter(priorities: {4, 5}));
      expect(
        group.members,
        {
          const GroupMembership(serverId: 'srv-1', topic: 'alerts'),
          const GroupMembership(serverId: 'srv-2', topic: 'backups'),
        },
      );
    });

    test('maps a group with no filter and no members', () {
      final row = GroupWithMembers(
        group: const db.Group(id: 'grp-1', name: 'Homelab', sortOrder: 0),
        members: const [],
      );

      final group = GroupMapper.toDomain(row);

      expect(group.filter, isNull);
      expect(group.members, isEmpty);
    });
  });

  group('GroupMapper.toCompanions', () {
    test('builds a GroupsCompanion and one GroupMembersCompanion per member', () {
      final group = Group(
        id: 'grp-1',
        name: 'Homelab',
        color: 0xFF0000FF,
        sortOrder: 1,
        filter: const MessageFilter(priorities: {3, 4, 5}),
        members: {
          const GroupMembership(serverId: 'srv-1', topic: 'alerts'),
        },
      );

      final (groupCompanion, memberCompanions) = GroupMapper.toCompanions(group);

      expect(groupCompanion.id.value, 'grp-1');
      expect(groupCompanion.name.value, 'Homelab');
      expect(groupCompanion.color.value, 0xFF0000FF);
      expect(groupCompanion.sortOrder.value, 1);
      expect(groupCompanion.filterPriorities.value, '3,4,5');
      expect(memberCompanions, hasLength(1));
      expect(memberCompanions.single.groupId.value, 'grp-1');
      expect(memberCompanions.single.serverId.value, 'srv-1');
      expect(memberCompanions.single.topic.value, 'alerts');
    });

    test('encodes a null filter as a null filterPriorities', () {
      final group = Group(id: 'grp-1', name: 'Homelab');

      final (groupCompanion, _) = GroupMapper.toCompanions(group);

      expect(groupCompanion.filterPriorities.value, isNull);
    });

    test('encodes an empty-priorities filter as a null filterPriorities', () {
      final group = Group(
        id: 'grp-1',
        name: 'Homelab',
        filter: const MessageFilter(),
      );

      final (groupCompanion, _) = GroupMapper.toCompanions(group);

      expect(groupCompanion.filterPriorities.value, isNull);
    });
  });
}
