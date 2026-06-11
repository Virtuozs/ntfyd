import 'package:drift/drift.dart';

import 'package:ntfyd/core/database/tables/app_settings_table.dart';
import 'package:ntfyd/core/database/tables/group_members_table.dart';
import 'package:ntfyd/core/database/tables/groups_table.dart';
import 'package:ntfyd/core/database/tables/notification_messages_table.dart';
import 'package:ntfyd/core/database/tables/server_configs_table.dart';
import 'package:ntfyd/core/database/tables/subscriptions_table.dart';

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
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;
}
