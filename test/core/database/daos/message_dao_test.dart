import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
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
  int? expires,
  String event = 'message',
  int priority = 3,
  bool isRead = false,
  bool isPinned = false,
}) => NotificationMessagesCompanion.insert(
  id: id,
  serverId: serverId,
  topic: topic,
  time: time ?? _now(),
  expires: Value(expires),
  event: event,
  priority: Value(priority),
  isRead: Value(isRead ? 1 : 0),
  isPinned: Value(isPinned ? 1 : 0),
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

  group('insertOrReplace', () {
    test('same PK does not create duplicate row', () async {
      final msg = _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts');

      await db.messageDao.insertOrReplace(msg);
      await db.messageDao.insertOrReplace(msg);

      final all = await db.messageDao.watchByTopic('srv-1', 'alerts').first;
      expect(all.length, equals(1));
    });

    test('replaces existing row content on same PK', () async {
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts', isRead: false),
      );

      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts', isRead: true),
      );

      final all = await db.messageDao.watchByTopic('srv-1', 'alerts').first;
      expect(all.length, equals(1));
      expect(all.first.isRead, equals(1));
    });
  });

  group('watchInserted', () {
    test('emits when a new (serverId, id) is inserted', () async {
      final stream = db.messageDao.watchInserted();
      final emissions = <String>[];
      final sub = stream.listen((row) => emissions.add(row.id));

      await Future<void>.delayed(Duration.zero);
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts'),
      );
      await Future<void>.delayed(Duration.zero);

      expect(emissions, equals(['msg-1']));
      await sub.cancel();
    });

    test('does not emit when replacing an existing (serverId, id)', () async {
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts', isRead: false),
      );

      final stream = db.messageDao.watchInserted();
      final emissions = <String>[];
      final sub = stream.listen((row) => emissions.add(row.id));
      await Future<void>.delayed(Duration.zero);

      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts', isRead: true),
      );
      await Future<void>.delayed(Duration.zero);

      expect(emissions, isEmpty);
      await sub.cancel();
    });

    test('treats the same id on a different serverId as a new insert', () async {
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts'),
      );

      final stream = db.messageDao.watchInserted();
      final emissions = <String>[];
      final sub = stream.listen((row) => emissions.add(row.serverId));
      await Future<void>.delayed(Duration.zero);

      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-2', topic: 'alerts'),
      );
      await Future<void>.delayed(Duration.zero);

      expect(emissions, equals(['srv-2']));
      await sub.cancel();
    });
  });

  group('watchByTopic', () {
    test('emits updated list on insert', () async {
      final stream = db.messageDao.watchByTopic('srv-1', 'alerts');
      final emissions = <int>[];
      final sub = stream.listen((rows) => emissions.add(rows.length));

      await Future<void>.delayed(Duration.zero);
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts'),
      );
      await Future<void>.delayed(Duration.zero);

      expect(emissions, containsAllInOrder([0, 1]));
      await sub.cancel();
    });

    test('pinned messages sort before unpinned', () async {
      await db.messageDao.insertOrReplace(
        _msg(
          id: 'msg-1',
          serverId: 'srv-1',
          topic: 'alerts',
          time: 100,
          isPinned: false,
        ),
      );
      await db.messageDao.insertOrReplace(
        _msg(
          id: 'msg-2',
          serverId: 'srv-1',
          topic: 'alerts',
          time: 50, // older, but pinned
          isPinned: true,
        ),
      );

      final result = await db.messageDao.watchByTopic('srv-1', 'alerts').first;

      expect(result.first.id, equals('msg-2'));
      expect(result.last.id, equals('msg-1'));
    });

    test('orders by time DESC within same pin status', () async {
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts', time: 100),
      );
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-2', serverId: 'srv-1', topic: 'alerts', time: 200),
      );

      final result = await db.messageDao.watchByTopic('srv-1', 'alerts').first;

      expect(result.first.id, equals('msg-2'));
      expect(result.last.id, equals('msg-1'));
    });

    test('filters by priority when MessageFilter provided', () async {
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts', priority: 3),
      );
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-2', serverId: 'srv-1', topic: 'alerts', priority: 5),
      );
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-3', serverId: 'srv-1', topic: 'alerts', priority: 4),
      );

      final result = await db.messageDao
          .watchByTopic(
            'srv-1',
            'alerts',
            filter: const MessageFilter(priorities: {4, 5}),
          )
          .first;

      expect(result.length, equals(2));
      expect(result.map((e) => e.id), containsAll(['msg-2', 'msg-3']));
      expect(result.map((e) => e.id), isNot(contains('msg-1')));
    });

    test('only returns messages for the given (serverId, topic)', () async {
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts'),
      );
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-2', serverId: 'srv-1', topic: 'other-topic'),
      );
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-3', serverId: 'srv-2', topic: 'alerts'),
      );

      final result = await db.messageDao.watchByTopic('srv-1', 'alerts').first;

      expect(result.length, equals(1));
      expect(result.first.id, equals('msg-1'));
    });
  });

  group('markRead', () {
    test('sets isRead to true', () async {
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts', isRead: false),
      );

      await db.messageDao.markRead('srv-1', 'msg-1', true);

      final all = await db.messageDao.watchByTopic('srv-1', 'alerts').first;
      expect(all.first.isRead, equals(1));
    });

    test('sets isRead to false', () async {
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts', isRead: true),
      );

      await db.messageDao.markRead('srv-1', 'msg-1', false);

      final all = await db.messageDao.watchByTopic('srv-1', 'alerts').first;
      expect(all.first.isRead, equals(0));
    });
  });

  group('togglePin', () {
    test('flips isPinned from false to true', () async {
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts', isPinned: false),
      );

      await db.messageDao.togglePin('srv-1', 'msg-1');

      final all = await db.messageDao.watchByTopic('srv-1', 'alerts').first;
      expect(all.first.isPinned, equals(1));
    });

    test('flips isPinned from true to false', () async {
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts', isPinned: true),
      );

      await db.messageDao.togglePin('srv-1', 'msg-1');

      final all = await db.messageDao.watchByTopic('srv-1', 'alerts').first;
      expect(all.first.isPinned, equals(0));
    });
  });

  group('deleteById', () {
    test('removes the matching message', () async {
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts'),
      );

      await db.messageDao.deleteById('srv-1', 'msg-1');

      final all = await db.messageDao.watchByTopic('srv-1', 'alerts').first;
      expect(all, isEmpty);
    });
  });

  group('clearByTopic', () {
    test('removes all messages for (serverId, topic)', () async {
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts'),
      );
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-2', serverId: 'srv-1', topic: 'alerts'),
      );
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-3', serverId: 'srv-1', topic: 'other'),
      );

      await db.messageDao.clearByTopic('srv-1', 'alerts');

      final alerts = await db.messageDao.watchByTopic('srv-1', 'alerts').first;
      final other = await db.messageDao.watchByTopic('srv-1', 'other').first;
      expect(alerts, isEmpty);
      expect(other.length, equals(1));
    });
  });

  group('getLastId', () {
    test('returns id of message with max time', () async {
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts', time: 100),
      );
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-2', serverId: 'srv-1', topic: 'alerts', time: 300),
      );
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-3', serverId: 'srv-1', topic: 'alerts', time: 200),
      );

      final result = await db.messageDao.getLastId('srv-1', 'alerts');

      expect(result, equals('msg-2'));
    });

    test('returns null when no messages exist', () async {
      final result = await db.messageDao.getLastId('srv-1', 'alerts');

      expect(result, equals(null));
    });
  });

  group('purgeExpired', () {
    test('removes messages where expires < now', () async {
      final now = _now();
      await db.messageDao.insertOrReplace(
        _msg(
          id: 'msg-expired',
          serverId: 'srv-1',
          topic: 'alerts',
          expires: now - 1000, // past
        ),
      );
      await db.messageDao.insertOrReplace(
        _msg(
          id: 'msg-future',
          serverId: 'srv-1',
          topic: 'alerts',
          expires: now + 10000, // future
        ),
      );
      await db.messageDao.insertOrReplace(
        _msg(
          id: 'msg-no-expiry',
          serverId: 'srv-1',
          topic: 'alerts',
          expires: null,
        ),
      );

      await db.messageDao.purgeExpired();

      final all = await db.messageDao.watchByTopic('srv-1', 'alerts').first;
      expect(
        all.map((e) => e.id),
        containsAll(['msg-future', 'msg-no-expiry']),
      );
      expect(all.map((e) => e.id), isNot(contains('msg-expired')));
    });
  });

  group('purgeByRetention', () {
    test('maxAgeDays=0 deletes all rows regardless of age', () async {
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts'),
      );

      await db.messageDao.purgeByRetention(0, 100);

      final all = await db.messageDao.watchByTopic('srv-1', 'alerts').first;
      expect(all, isEmpty);
    });

    test('maxRows=0 deletes all rows regardless of count', () async {
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts'),
      );

      await db.messageDao.purgeByRetention(30, 0);

      final all = await db.messageDao.watchByTopic('srv-1', 'alerts').first;
      expect(all, isEmpty);
    });

    test('removes messages older than maxAgeDays', () async {
      final now = _now();
      const oneDaySeconds = 86400;
      await db.messageDao.insertOrReplace(
        _msg(
          id: 'msg-old',
          serverId: 'srv-1',
          topic: 'alerts',
          time: now - (10 * oneDaySeconds), // 10 days old
        ),
      );
      await db.messageDao.insertOrReplace(
        _msg(
          id: 'msg-recent',
          serverId: 'srv-1',
          topic: 'alerts',
          time: now - oneDaySeconds, // 1 day old
        ),
      );

      await db.messageDao.purgeByRetention(7, 1000);

      final all = await db.messageDao.watchByTopic('srv-1', 'alerts').first;
      expect(all.map((e) => e.id), contains('msg-recent'));
      expect(all.map((e) => e.id), isNot(contains('msg-old')));
    });

    test('keeps only maxRows most recent messages', () async {
      final now = _now();
      for (var i = 1; i <= 5; i++) {
        await db.messageDao.insertOrReplace(
          _msg(
            id: 'msg-$i',
            serverId: 'srv-1',
            topic: 'alerts',
            time: now - (5 - i),
          ),
        );
      }

      await db.messageDao.purgeByRetention(365, 2);

      final all = await db.messageDao.watchByTopic('srv-1', 'alerts').first;
      expect(all.length, equals(2));
      expect(all.map((e) => e.id), containsAll(['msg-5', 'msg-4']));
    });
  });

  group('watchUnreadCount', () {
    test('increments when unread message inserted', () async {
      final stream = db.messageDao.watchUnreadCount('srv-1', 'alerts');
      final emissions = <int>[];
      final sub = stream.listen(emissions.add);

      await Future<void>.delayed(Duration.zero);

      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts', isRead: false),
      );
      await Future<void>.delayed(Duration.zero);

      expect(emissions, containsAllInOrder([0, 1]));
      await sub.cancel();
    });

    test('decrements when message marked read', () async {
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts', isRead: false),
      );

      final stream = db.messageDao.watchUnreadCount('srv-1', 'alerts');
      final emissions = <int>[];
      final sub = stream.listen(emissions.add);
      await Future<void>.delayed(Duration.zero);

      await db.messageDao.markRead('srv-1', 'msg-1', true);
      await Future<void>.delayed(Duration.zero);

      expect(emissions, containsAllInOrder([1, 0]));
      await sub.cancel();
    });

    test('does not count read messages', () async {
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts', isRead: true),
      );

      final result = await db.messageDao
          .watchUnreadCount('srv-1', 'alerts')
          .first;

      expect(result, equals(0));
    });
  });

  group('watchLatestByTopic', () {
    test('emits null when no messages exist for the topic', () async {
      final result = await db.messageDao.watchLatestByTopic('srv-1', 'alerts').first;
      expect(result, equals(null));
    });

    test('emits the most recent message by time', () async {
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts', time: 100),
      );
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-2', serverId: 'srv-1', topic: 'alerts', time: 200),
      );

      final result = await db.messageDao.watchLatestByTopic('srv-1', 'alerts').first;
      expect(result?.id, 'msg-2');
    });

    test('pinned messages take priority over newer unpinned ones', () async {
      await db.messageDao.insertOrReplace(
        _msg(
          id: 'msg-1',
          serverId: 'srv-1',
          topic: 'alerts',
          time: 100,
          isPinned: true,
        ),
      );
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-2', serverId: 'srv-1', topic: 'alerts', time: 200),
      );

      final result = await db.messageDao.watchLatestByTopic('srv-1', 'alerts').first;
      expect(result?.id, 'msg-1');
    });
  });

  group('toggleRead', () {
    test('flips isRead from 0 to 1', () async {
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts', isRead: false),
      );

      await db.messageDao.toggleRead('srv-1', 'msg-1');

      final all = await db.messageDao.watchByTopic('srv-1', 'alerts').first;
      expect(all.first.isRead, equals(1));
    });

    test('flips isRead from 1 back to 0', () async {
      await db.messageDao.insertOrReplace(
        _msg(id: 'msg-1', serverId: 'srv-1', topic: 'alerts', isRead: true),
      );

      await db.messageDao.toggleRead('srv-1', 'msg-1');

      final all = await db.messageDao.watchByTopic('srv-1', 'alerts').first;
      expect(all.first.isRead, equals(0));
    });
  });
}
