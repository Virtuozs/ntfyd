import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart' show isNull;
import 'package:ntfyd/core/database/app_database.dart';
import 'package:ntfyd/core/database/value_objects/message_filter.dart';

AppDatabase _openDb() => AppDatabase(
  NativeDatabase.memory(setup: (db) => db.execute('PRAGMA foreign_keys = ON;')),
);

int _now() => DateTime.now().millisecondsSinceEpoch ~/ 1000;

NotificationMessagesCompanion _msg({
  required String id,
  required String serverId,
  required String topic,
  int? time,
  int priority = 3,
}) => NotificationMessagesCompanion.insert(
  id: id,
  serverId: serverId,
  topic: topic,
  time: time ?? _now(),
  event: 'message',
  priority: Value(priority),
  receivedAt: _now(),
);

void main() {
  late AppDatabase db;

  setUp(() {
    db = _openDb();
  });

  tearDown(() async {
    await db.close();
  });

  group('upsert + watchAll', () {
    test('inserts group with members', () async {
      await db.groupDao
          .upsert(GroupsCompanion.insert(id: 'grp-1', name: 'Homelab'), [
            GroupMembersCompanion.insert(
              groupId: 'grp-1',
              serverId: 'srv-1',
              topic: 'alerts',
            ),
            GroupMembersCompanion.insert(
              groupId: 'grp-1',
              serverId: 'srv-2',
              topic: 'cron',
            ),
          ]);

      final all = await db.groupDao.watchAll().first;
      expect(all.length, equals(1));
      expect(all.first.group.name, equals('Homelab'));
      expect(all.first.members.length, equals(2));
    });

    test('upsert replaces members in a single transaction', () async {
      await db.groupDao
          .upsert(GroupsCompanion.insert(id: 'grp-1', name: 'Homelab'), [
            GroupMembersCompanion.insert(
              groupId: 'grp-1',
              serverId: 'srv-1',
              topic: 'alerts',
            ),
          ]);

      await db.groupDao
          .upsert(GroupsCompanion.insert(id: 'grp-1', name: 'Homelab'), [
            GroupMembersCompanion.insert(
              groupId: 'grp-1',
              serverId: 'srv-2',
              topic: 'cron',
            ),
          ]);

      final all = await db.groupDao.watchAll().first;
      expect(all.first.members.length, equals(1));
      expect(all.first.members.first.serverId, equals('srv-2'));
    });
  });

  group('deleteGroup', () {
    test('cascades to group_members', () async {
      await db.groupDao
          .upsert(GroupsCompanion.insert(id: 'grp-1', name: 'Homelab'), [
            GroupMembersCompanion.insert(
              groupId: 'grp-1',
              serverId: 'srv-1',
              topic: 'alerts',
            ),
          ]);

      await db.groupDao.deleteGroup('grp-1');

      final all = await db.groupDao.watchAll().first;
      expect(all, isEmpty);
    });
  });

  group('watchFeedForGroup', () {
    test('returns messages from all member topics', () async {
      await db.groupDao
          .upsert(GroupsCompanion.insert(id: 'grp-1', name: 'Homelab'), [
            GroupMembersCompanion.insert(
              groupId: 'grp-1',
              serverId: 'srv-1',
              topic: 'alerts',
            ),
            GroupMembersCompanion.insert(
              groupId: 'grp-1',
              serverId: 'srv-2',
              topic: 'cron',
            ),
          ]);
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts'),
      );
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-2', serverId: 'srv-2', topic: 'cron'),
      );
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-3', serverId: 'srv-1', topic: 'unrelated'),
      );

      final result = await db.groupDao.watchFeedForGroup('grp-1').first;

      expect(result.length, equals(2));
      expect(result.map((e) => e.id), containsAll(['msg-1', 'msg-2']));
      expect(result.map((e) => e.id), isNot(contains('msg-3')));
    });

    test('returns empty stream when group has 0 members', () async {
      await db.groupDao.upsert(
        GroupsCompanion.insert(id: 'grp-1', name: 'Empty'),
        [],
      );
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts'),
      );

      final result = await db.groupDao.watchFeedForGroup('grp-1').first;

      expect(result, isEmpty);
    });

    test('applies MessageFilter to merged feed', () async {
      await db.groupDao
          .upsert(GroupsCompanion.insert(id: 'grp-1', name: 'Homelab'), [
            GroupMembersCompanion.insert(
              groupId: 'grp-1',
              serverId: 'srv-1',
              topic: 'alerts',
            ),
          ]);
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts', priority: 3),
      );
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-2', serverId: 'srv-1', topic: 'alerts', priority: 5),
      );

      final result = await db.groupDao
          .watchFeedForGroup(
            'grp-1',
            filter: const MessageFilter(priorities: {5}),
          )
          .first;

      expect(result.length, equals(1));
      expect(result.first.id, equals('msg-2'));
    });
  });

  group('watchAllFeed', () {
    test('returns messages from all topics across all servers', () async {
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts'),
      );
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-2', serverId: 'srv-2', topic: 'cron'),
      );

      final result = await db.groupDao.watchAllFeed().first;

      expect(result.length, equals(2));
      expect(result.map((e) => e.id), containsAll(['msg-1', 'msg-2']));
    });

    test('applies MessageFilter to all feed', () async {
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts', priority: 1),
      );
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-2', serverId: 'srv-2', topic: 'cron', priority: 5),
      );

      final result = await db.groupDao
          .watchAllFeed(filter: const MessageFilter(priorities: {5}))
          .first;

      expect(result.length, equals(1));
      expect(result.first.id, equals('msg-2'));
    });
  });

  group('filterPriorities column', () {
    test('upsert persists and round-trips filterPriorities', () async {
      await db.groupDao.upsert(
        GroupsCompanion.insert(
          id: 'grp-1',
          name: 'Homelab',
          filterPriorities: const Value('3,4,5'),
        ),
        const [],
      );

      final groups = await db.groupDao.watchAll().first;

      expect(groups, hasLength(1));
      expect(groups.single.group.filterPriorities, '3,4,5');
    });

    test('upsert leaves filterPriorities null when omitted', () async {
      await db.groupDao.upsert(
        GroupsCompanion.insert(id: 'grp-1', name: 'Homelab'),
        const [],
      );

      final groups = await db.groupDao.watchAll().first;

      expect(groups.single.group.filterPriorities, isNull);
    });
  });
}
