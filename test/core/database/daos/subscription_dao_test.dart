import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/database/app_database.dart';

AppDatabase _openDb() => AppDatabase(
  NativeDatabase.memory(setup: (db) => db.execute('PRAGMA foreign_keys = ON;')),
);

int _now() => DateTime.now().millisecondsSinceEpoch ~/ 1000;

ServerConfigsCompanion _server(String id) => ServerConfigsCompanion.insert(
  id: id,
  baseUrl: 'https://$id.example.com',
  displayName: id,
  authType: 'none',
  createdAt: _now(),
);

SubscriptionsCompanion _sub(
  String id,
  String serverId,
  String topic, {
  bool pinned = false,
  bool muted = false,
}) => SubscriptionsCompanion.insert(
  id: id,
  serverId: serverId,
  topic: topic,
  displayName: topic,
  pinned: Value(pinned ? 1 : 0),
  muted: Value(muted ? 1 : 0),
  createdAt: _now(),
);

void main() {
  late AppDatabase db;

  setUp(() async {
    db = _openDb();
    await db.serverConfigDao.upsert(_server('srv-1'));
    await db.serverConfigDao.upsert(_server('srv-2'));
  });

  tearDown(() async {
    await db.close();
  });

  group('watchByServer', () {
    test('emits only subscriptions for the given server', () async {
      await db.subscriptionDao.upsert(_sub('sub-1', 'srv-1', 'alerts'));
      await db.subscriptionDao.upsert(_sub('sub-2', 'srv-2', 'alerts'));

      final result = await db.subscriptionDao.watchByServer('srv-1').first;

      expect(result.length, equals(1));
      expect(result.first.serverId, equals('srv-1'));
    });
  });

  group('findByTopic', () {
    test('returns matching subscription', () async {
      await db.subscriptionDao.upsert(_sub('sub-1', 'srv-1', 'alerts'));

      final result = await db.subscriptionDao.findByTopic('srv-1', 'alerts');

      expect(result, isNot(equals(null)));
      expect(result!.id, equals('sub-1'));
    });

    test('returns null when no match', () async {
      final result = await db.subscriptionDao.findByTopic('srv-1', 'ghost');

      expect(result, equals(null));
    });
  });

  group('upsert', () {
    test('inserts a new subscription', () async {
      await db.subscriptionDao.upsert(_sub('sub-1', 'srv-1', 'alerts'));

      final result = await db.subscriptionDao.findByTopic('srv-1', 'alerts');
      expect(result, isNot(equals(null)));
    });
  });

  group('deleteByTopic', () {
    test('removes the subscription', () async {
      await db.subscriptionDao.upsert(_sub('sub-1', 'srv-1', 'alerts'));

      await db.subscriptionDao.deleteByTopic('srv-1', 'alerts');

      final result = await db.subscriptionDao.findByTopic('srv-1', 'alerts');
      expect(result, equals(null));
    });
  });

  group('togglePin', () {
    test('flips pinned from false to true', () async {
      await db.subscriptionDao.upsert(_sub('sub-1', 'srv-1', 'alerts'));

      await db.subscriptionDao.togglePin('sub-1');

      final result = await db.subscriptionDao.findByTopic('srv-1', 'alerts');
      expect(result!.pinned, equals(1));
    });

    test('flips pinned from true to false', () async {
      await db.subscriptionDao.upsert(
        _sub('sub-1', 'srv-1', 'alerts', pinned: true),
      );

      await db.subscriptionDao.togglePin('sub-1');

      final result = await db.subscriptionDao.findByTopic('srv-1', 'alerts');
      expect(result!.pinned, equals(0));
    });
  });

  group('toggleMute', () {
    test('flips muted from false to true', () async {
      await db.subscriptionDao.upsert(_sub('sub-1', 'srv-1', 'alerts'));

      await db.subscriptionDao.toggleMute('sub-1');

      final result = await db.subscriptionDao.findByTopic('srv-1', 'alerts');
      expect(result!.muted, equals(1));
    });

    test('flips muted from true to false', () async {
      await db.subscriptionDao.upsert(
        _sub('sub-1', 'srv-1', 'alerts', muted: true),
      );

      await db.subscriptionDao.toggleMute('sub-1');

      final result = await db.subscriptionDao.findByTopic('srv-1', 'alerts');
      expect(result!.muted, equals(0));
    });
  });

  group('updatePriorityThreshold', () {
    test('updates priorityThreshold for the given id', () async {
      await db.subscriptionDao.upsert(_sub('sub-1', 'srv-1', 'alerts'));

      await db.subscriptionDao.updatePriorityThreshold('sub-1', 4);

      final result = await db.subscriptionDao.findByTopic('srv-1', 'alerts');
      expect(result!.priorityThreshold, equals(4));
    });
  });
}
