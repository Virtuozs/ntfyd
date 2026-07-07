import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/database/value_objects/message_filter.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/groups/domain/entities/group.dart';
import 'package:ntfyd/features/groups/domain/entities/group_membership.dart';

void main() {
  group('GroupMembership', () {
    test('two memberships with the same serverId/topic are equal', () {
      expect(
        const GroupMembership(serverId: 'srv-1', topic: 'alerts'),
        const GroupMembership(serverId: 'srv-1', topic: 'alerts'),
      );
    });
  });

  group('Group.validate', () {
    test('returns a valid Group for a non-empty name', () {
      final result = Group.validate(id: 'grp-1', name: 'Homelab');

      expect(result.isSuccess, isTrue);
      expect(result.valueOrThrow.id, 'grp-1');
      expect(result.valueOrThrow.name, 'Homelab');
      expect(result.valueOrThrow.members, isEmpty);
      expect(result.valueOrThrow.sortOrder, 0);
    });

    test('trims the name', () {
      final result = Group.validate(id: 'grp-1', name: '  Homelab  ');

      expect(result.valueOrThrow.name, 'Homelab');
    });

    test('returns ValidationFailure for a blank name', () {
      final result = Group.validate(id: 'grp-1', name: '   ');

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<ValidationFailure>());
    });

    test('carries members, color, filter, and sortOrder through', () {
      final members = {const GroupMembership(serverId: 'srv-1', topic: 'alerts')};
      const filter = MessageFilter(priorities: {4, 5});

      final result = Group.validate(
        id: 'grp-1',
        name: 'Homelab',
        color: 0xFF0000FF,
        members: members,
        filter: filter,
        sortOrder: 2,
      );

      expect(result.valueOrThrow.members, members);
      expect(result.valueOrThrow.color, 0xFF0000FF);
      expect(result.valueOrThrow.filter, filter);
      expect(result.valueOrThrow.sortOrder, 2);
    });
  });
}
