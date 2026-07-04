import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/database/app_database.dart';

AppDatabase _openDb() => AppDatabase(
  NativeDatabase.memory(
    setup: (db) {
      db.execute('PRAGMA foreign_keys = ON;');
    },
  ),
);

int _now() => DateTime.now().millisecondsSinceEpoch ~/ 1000;

void main() {
  late AppDatabase db;

  setUp(() {
    db = _openDb();
  });

  tearDown(() async {
    await db.close();
  });

  group('server_configs', () {
    test('insert then retrieve by id succeeds', () async {
      // Arrange
      final row = ServerConfigsCompanion.insert(
        id: 'srv-1',
        baseUrl: 'https://ntfy.sh',
        displayName: 'ntfy.sh',
        authType: 'none',
        createdAt: _now(),
      );

      // Act
      await db.into(db.serverConfigs).insert(row);
      final result = await (db.select(
        db.serverConfigs,
      )..where((t) => t.id.equals('srv-1'))).getSingle();

      // Assert
      expect(result.id, equals('srv-1'));
      expect(result.baseUrl, equals('https://ntfy.sh'));
      expect(result.authType, equals('none'));
      expect(result.isDefault, equals(0));
    });

    test('insert duplicate base_url throws constraint violation', () async {
      // Arrange
      final row1 = ServerConfigsCompanion.insert(
        id: 'srv-1',
        baseUrl: 'https://ntfy.sh',
        displayName: 'first',
        authType: 'none',
        createdAt: _now(),
      );
      final row2 = ServerConfigsCompanion.insert(
        id: 'srv-2',
        baseUrl: 'https://ntfy.sh', // same base_url
        displayName: 'second',
        authType: 'none',
        createdAt: _now(),
      );

      // Act
      await db.into(db.serverConfigs).insert(row1);

      // Assert
      expect(() => db.into(db.serverConfigs).insert(row2), throwsA(anything));
    });

    test('isDefault defaults to 0', () async {
      // Arrange
      final row = ServerConfigsCompanion.insert(
        id: 'srv-1',
        baseUrl: 'https://ntfy.sh',
        displayName: 'ntfy.sh',
        authType: 'none',
        createdAt: _now(),
      );

      // Act
      await db.into(db.serverConfigs).insert(row);
      final result = await (db.select(
        db.serverConfigs,
      )..where((t) => t.id.equals('srv-1'))).getSingle();

      // Assert
      expect(result.isDefault, equals(0));
    });
  });

  group('subscriptions', () {
    /// Inserts a server_config prerequisite.
    Future<void> insertServer(String id) async {
      await db
          .into(db.serverConfigs)
          .insert(
            ServerConfigsCompanion.insert(
              id: id,
              baseUrl: 'https://ntfy.sh/$id',
              displayName: id,
              authType: 'none',
              createdAt: _now(),
            ),
          );
    }

    test('insert then retrieve succeeds', () async {
      // Arrange
      await insertServer('srv-1');
      final row = SubscriptionsCompanion.insert(
        id: 'sub-1',
        serverId: 'srv-1',
        topic: 'alerts',
        displayName: 'Alerts',
        createdAt: _now(),
      );

      // Act
      await db.into(db.subscriptions).insert(row);
      final result = await (db.select(
        db.subscriptions,
      )..where((t) => t.id.equals('sub-1'))).getSingle();

      // Assert
      expect(result.topic, equals('alerts'));
      expect(result.muted, equals(0));
      expect(result.pinned, equals(0));
      expect(result.priorityThreshold, equals(1));
    });

    test(
      'insert same (server_id, topic) twice throws constraint violation',
      () async {
        // Arrange
        await insertServer('srv-1');
        final row1 = SubscriptionsCompanion.insert(
          id: 'sub-1',
          serverId: 'srv-1',
          topic: 'alerts',
          displayName: 'Alerts',
          createdAt: _now(),
        );
        final row2 = SubscriptionsCompanion.insert(
          id: 'sub-2', // different id
          serverId: 'srv-1',
          topic: 'alerts', // same (server_id, topic)
          displayName: 'Alerts Dup',
          createdAt: _now(),
        );

        // Act
        await db.into(db.subscriptions).insert(row1);

        // Assert
        expect(() => db.into(db.subscriptions).insert(row2), throwsA(anything));
      },
    );

    test('same topic on different servers is allowed', () async {
      // Arrange
      await insertServer('srv-1');
      await insertServer('srv-2');

      // Act & Assert — no exception
      await db
          .into(db.subscriptions)
          .insert(
            SubscriptionsCompanion.insert(
              id: 'sub-1',
              serverId: 'srv-1',
              topic: 'alerts',
              displayName: 'Alerts',
              createdAt: _now(),
            ),
          );
      await db
          .into(db.subscriptions)
          .insert(
            SubscriptionsCompanion.insert(
              id: 'sub-2',
              serverId: 'srv-2',
              topic: 'alerts', // same topic, different server
              displayName: 'Alerts',
              createdAt: _now(),
            ),
          );

      final all = await db.select(db.subscriptions).get();
      expect(all.length, equals(2));
    });
  });

  group('notification_messages', () {
    test('insert then retrieve by (server_id, id) succeeds', () async {
      // Arrange
      final row = NotificationMessagesCompanion.insert(
        id: 'msg-1',
        serverId: 'srv-1',
        topic: 'alerts',
        time: _now(),
        event: 'message',
        receivedAt: _now(),
      );

      // Act
      await db.into(db.notificationMessages).insert(row);
      final result =
          await (db.select(db.notificationMessages)..where(
                (t) => t.serverId.equals('srv-1') & t.id.equals('msg-1'),
              ))
              .getSingle();

      // Assert
      expect(result.id, equals('msg-1'));
      expect(result.serverId, equals('srv-1'));
      expect(result.priority, equals(3));
      expect(result.isRead, equals(0));
      expect(result.isPinned, equals(0));
      expect(result.isMarkdown, equals(0));
    });

    test('composite PK (server_id, id) prevents duplicate', () async {
      // Arrange
      final row = NotificationMessagesCompanion.insert(
        id: 'msg-1',
        serverId: 'srv-1',
        topic: 'alerts',
        time: _now(),
        event: 'message',
        receivedAt: _now(),
      );

      // Act
      await db.into(db.notificationMessages).insert(row);

      // Assert
      expect(
        () => db.into(db.notificationMessages).insert(row),
        throwsA(anything),
      );
    });

    test('same id on different servers is allowed', () async {
      // Arrange & Act — no exception
      await db
          .into(db.notificationMessages)
          .insert(
            NotificationMessagesCompanion.insert(
              id: 'msg-1',
              serverId: 'srv-1',
              topic: 'alerts',
              time: _now(),
              event: 'message',
              receivedAt: _now(),
            ),
          );
      await db
          .into(db.notificationMessages)
          .insert(
            NotificationMessagesCompanion.insert(
              id: 'msg-1', // same id, different server
              serverId: 'srv-2',
              topic: 'alerts',
              time: _now(),
              event: 'message',
              receivedAt: _now(),
            ),
          );

      final all = await db.select(db.notificationMessages).get();
      expect(all.length, equals(2));
    });
  });

  group('groups and group_members', () {
    test('insert group then retrieve succeeds', () async {
      // Arrange
      final row = GroupsCompanion.insert(id: 'grp-1', name: 'Homelab');

      // Act
      await db.into(db.groups).insert(row);
      final result = await (db.select(
        db.groups,
      )..where((t) => t.id.equals('grp-1'))).getSingle();

      // Assert
      expect(result.name, equals('Homelab'));
      expect(result.sortOrder, equals(0));
    });

    test('insert group member then query members succeeds', () async {
      // Arrange
      await db
          .into(db.groups)
          .insert(GroupsCompanion.insert(id: 'grp-1', name: 'Homelab'));
      final member = GroupMembersCompanion.insert(
        groupId: 'grp-1',
        serverId: 'srv-1',
        topic: 'alerts',
      );

      // Act
      await db.into(db.groupMembers).insert(member);
      final members = await (db.select(
        db.groupMembers,
      )..where((t) => t.groupId.equals('grp-1'))).get();

      // Assert
      expect(members.length, equals(1));
      expect(members.first.serverId, equals('srv-1'));
      expect(members.first.topic, equals('alerts'));
    });

    test('deleting group cascades to group_members', () async {
      // Arrange
      await db
          .into(db.groups)
          .insert(GroupsCompanion.insert(id: 'grp-1', name: 'Homelab'));

      await db
          .into(db.groupMembers)
          .insert(
            GroupMembersCompanion.insert(
              groupId: 'grp-1',
              serverId: 'srv-1',
              topic: 'alerts',
            ),
          );

      // Act
      await (db.delete(db.groups)..where((t) => t.id.equals('grp-1'))).go();

      // Assert
      final members = await db.select(db.groupMembers).get();
      expect(members, isEmpty);
    });

    test('duplicate group_member PK throws constraint violation', () async {
      // Arrange
      await db
          .into(db.groups)
          .insert(GroupsCompanion.insert(id: 'grp-1', name: 'Homelab'));
      final member = GroupMembersCompanion.insert(
        groupId: 'grp-1',
        serverId: 'srv-1',
        topic: 'alerts',
      );

      // Act
      await db.into(db.groupMembers).insert(member);

      // Assert
      expect(() => db.into(db.groupMembers).insert(member), throwsA(anything));
    });
  });

  group('app_settings', () {
    AppSettingsCompanion defaultSettings() => const AppSettingsCompanion(
      id: Value(1),
      themeMode: Value('system'),
      dynamicColor: Value(1),
      quietHoursEnabled: Value(0),
      hideLockScreenContent: Value(0),
      analyticsOptOut: Value(0),
      biometricLock: Value(0),
    );
    test('upsert inserts first row with id=1', () async {
      // Act
      await db.into(db.appSettings).insertOnConflictUpdate(defaultSettings());
      final all = await db.select(db.appSettings).get();

      // Assert
      expect(all.length, equals(1));
      expect(all.first.id, equals(1));
      expect(all.first.themeMode, equals('system'));
      expect(all.first.dynamicColor, equals(1));
      expect(all.first.biometricLock, equals(0));
    });

    test(
      'second upsert updates existing row, does not create new row',
      () async {
        await db
            .into(db.appSettings)
            .insertOnConflictUpdate(defaultSettings());
        // Arrange
        await db
            .into(db.appSettings)
            .insertOnConflictUpdate(
              defaultSettings().copyWith(themeMode: const Value('dark')),
            );

        final all = await db.select(db.appSettings).get();

        // Assert — still only one row
        expect(all.length, equals(1));
        expect(all.first.themeMode, equals('dark'));
      },
    );

    test('default values are correct', () async {
      // Arrange & Act
      await db.into(db.appSettings).insertOnConflictUpdate(defaultSettings());
      final row = await db.select(db.appSettings).getSingle();

      // Assert
      expect(row.themeMode, equals('system'));
      expect(row.dynamicColor, equals(1));
      expect(row.quietHoursEnabled, equals(0));
      expect(row.hideLockScreenContent, equals(0));
      expect(row.analyticsOptOut, equals(0));
      expect(row.biometricLock, equals(0));
      expect(row.quietHoursStart, equals(null));
      expect(row.quietHoursEnd, equals(null));
      expect(row.retentionMaxAgeDays, equals(null));
      expect(row.retentionMaxRows, equals(null));
    });
  });
}
