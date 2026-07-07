// test/features/groups/data/repositories/group_repository_impl_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/database/app_database.dart' as db;
import 'package:ntfyd/core/database/daos/group_dao.dart';
import 'package:ntfyd/core/database/value_objects/group_with_members.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/groups/data/repositories/group_repository_impl.dart';
import 'package:ntfyd/features/groups/domain/entities/group.dart';
import 'package:ntfyd/features/groups/domain/entities/group_membership.dart';

class MockGroupDao extends Mock implements GroupDao {}

void main() {
  late MockGroupDao dao;
  late GroupRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(const db.GroupsCompanion());
    registerFallbackValue(const <db.GroupMembersCompanion>[]);
  });

  setUp(() {
    dao = MockGroupDao();
    repository = GroupRepositoryImpl(dao);
  });

  group('watchAll', () {
    test('maps every dao row to a domain Group', () async {
      final row = GroupWithMembers(
        group: const db.Group(id: 'grp-1', name: 'Homelab', sortOrder: 0),
        members: const [],
      );
      when(() => dao.watchAll()).thenAnswer((_) => Stream.value([row]));

      final result = await repository.watchAll().first;

      expect(result, hasLength(1));
      expect(result.single.id, 'grp-1');
      expect(result.single.name, 'Homelab');
    });
  });

  group('save', () {
    test('upserts and returns Success(group) on success', () async {
      when(() => dao.upsert(any(), any())).thenAnswer((_) async {});
      final group = Group(id: 'grp-1', name: 'Homelab');

      final result = await repository.save(group);

      expect(result.isSuccess, isTrue);
      expect(result.valueOrThrow, group);
      verify(() => dao.upsert(any(), any())).called(1);
    });

    test('returns Failure.cache when dao.upsert throws', () async {
      when(() => dao.upsert(any(), any())).thenThrow(Exception('db error'));

      final result = await repository.save(Group(id: 'grp-1', name: 'Homelab'));

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<CacheFailure>());
    });
  });

  group('delete', () {
    test('delegates to dao.deleteGroup', () async {
      when(() => dao.deleteGroup('grp-1')).thenAnswer((_) async {});

      final result = await repository.delete('grp-1');

      expect(result.isSuccess, isTrue);
      verify(() => dao.deleteGroup('grp-1')).called(1);
    });

    test('returns Failure.cache when dao throws', () async {
      when(() => dao.deleteGroup('grp-1')).thenThrow(Exception('db error'));

      final result = await repository.delete('grp-1');

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<CacheFailure>());
    });
  });

  group('watchFeed', () {
    final now = DateTime.utc(2026, 1, 1);
    final messageRow = db.NotificationMessage(
      id: 'msg-1',
      serverId: 'srv-1',
      topic: 'alerts',
      time: now.millisecondsSinceEpoch ~/ 1000,
      event: 'message',
      priority: 3,
      isMarkdown: 1,
      isRead: 0,
      isPinned: 0,
      receivedAt: now.millisecondsSinceEpoch ~/ 1000,
    );

    test('groupId == null reads from watchAllFeed', () async {
      when(() => dao.watchAllFeed()).thenAnswer((_) => Stream.value([messageRow]));

      final result = await repository.watchFeed(null).first;

      expect(result, hasLength(1));
      expect(result.single.id, 'msg-1');
      verifyNever(() => dao.watchFeedForGroup(any()));
    });

    test('groupId != null reads from watchFeedForGroup', () async {
      when(
        () => dao.watchFeedForGroup('grp-1'),
      ).thenAnswer((_) => Stream.value([messageRow]));

      final result = await repository.watchFeed('grp-1').first;

      expect(result, hasLength(1));
      expect(result.single.id, 'msg-1');
      verifyNever(() => dao.watchAllFeed());
    });
  });
}
