import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/database/app_database.dart';

int _now() => DateTime.now().millisecondsSinceEpoch ~/ 1000;

AppDatabase _openDb() => AppDatabase(
  NativeDatabase.memory(setup: (db) => db.execute('PRAGMA foreign_keys = ON;')),
);

void main() {
  late AppDatabase db;

  setUp(() {
    db = _openDb();
  });

  tearDown(() async {
    await db.close();
  });

  group('clearAllTables', () {
    test('deletes every row from every data table', () async {
      await db.into(db.serverConfigs).insert(
        ServerConfigsCompanion.insert(
          id: 'srv-1',
          baseUrl: 'https://ntfy.sh',
          displayName: 'ntfy.sh',
          authType: 'none',
          createdAt: _now(),
        ),
      );
      await db.into(db.subscriptions).insert(
        SubscriptionsCompanion.insert(
          id: 'sub-1',
          serverId: 'srv-1',
          topic: 'alerts',
          displayName: 'alerts',
          createdAt: _now(),
        ),
      );
      await db.into(db.notificationMessages).insert(
        NotificationMessagesCompanion.insert(
          id: 'msg-1',
          serverId: 'srv-1',
          topic: 'alerts',
          time: _now(),
          event: 'message',
          receivedAt: _now(),
        ),
      );
      await db.into(db.groups).insert(
        GroupsCompanion.insert(id: 'grp-1', name: 'Homelab'),
      );
      await db.into(db.groupMembers).insert(
        GroupMembersCompanion.insert(
          groupId: 'grp-1',
          serverId: 'srv-1',
          topic: 'alerts',
        ),
      );
      await db.settingDao.updateAppSetting(
        const AppSettingsCompanion(themeMode: Value('white'), biometricLock: Value(1)),
      );

      await db.clearAllTables();

      expect(await db.select(db.serverConfigs).get(), isEmpty);
      expect(await db.select(db.subscriptions).get(), isEmpty);
      expect(await db.select(db.notificationMessages).get(), isEmpty);
      expect(await db.select(db.groups).get(), isEmpty);
      expect(await db.select(db.groupMembers).get(), isEmpty);
    });

    test('resets the appSettings row to defaults rather than deleting it', () async {
      await db.settingDao.updateAppSetting(
        const AppSettingsCompanion(themeMode: Value('white'), biometricLock: Value(1)),
      );

      await db.clearAllTables();

      final settings = await db.select(db.appSettings).getSingle();
      expect(settings.id, equals(1));
      expect(settings.themeMode, equals('dark'));
      expect(settings.biometricLock, equals(0));
      expect(settings.retentionMaxRows, equals(10000));
    });
  });
}
