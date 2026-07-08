import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:ntfyd/core/database/daos/group_dao.dart';
import 'package:ntfyd/core/database/daos/message_dao.dart';
import 'package:ntfyd/core/database/daos/server_config_dao.dart';
import 'package:ntfyd/core/database/daos/setting_dao.dart';
import 'package:ntfyd/core/database/daos/subscription_dao.dart';
import 'package:ntfyd/core/database/tables/app_settings_table.dart';
import 'package:ntfyd/core/database/tables/group_members_table.dart';
import 'package:ntfyd/core/database/tables/groups_table.dart';
import 'package:ntfyd/core/database/tables/notification_messages_table.dart';
import 'package:ntfyd/core/database/tables/server_configs_table.dart';
import 'package:ntfyd/core/database/tables/subscriptions_table.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    ServerConfigs,
    Subscriptions,
    NotificationMessages,
    Groups,
    GroupMembers,
    AppSettings,
  ],
  daos: [ServerConfigDao, SubscriptionDao, MessageDao, GroupDao, SettingDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  /// Destructive reset (Privacy ▸ Clear all data, FR16): wipes every
  /// server, subscription, message, group, and group membership, then
  /// resets the singleton `AppSettings` row back to its defaults (not
  /// deleted — `SettingDao` assumes the row always exists). Children
  /// deleted before parents to respect FK constraints.
  Future<void> clearAllTables() async {
    await transaction(() async {
      await delete(notificationMessages).go();
      await delete(groupMembers).go();
      await delete(groups).go();
      await delete(subscriptions).go();
      await delete(serverConfigs).go();
      await settingDao.updateAppSetting(
        const AppSettingsCompanion(
          themeMode: Value('dark'),
          quietHoursEnabled: Value(0),
          quietHoursStart: Value(null),
          quietHoursEnd: Value(null),
          retentionMaxAgeDays: Value(null),
          retentionMaxRows: Value(10000),
          hideLockScreenContent: Value(0),
          analyticsOptOut: Value(0),
          biometricLock: Value(0),
        ),
      );
    });
  }

  /// Opens (or creates) the on-disk SQLite database in the app's documents directory.
  /// Lazy so the platform path lookup happens off the main isolate.
  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'ntfyd.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
