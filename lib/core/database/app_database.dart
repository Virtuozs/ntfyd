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
