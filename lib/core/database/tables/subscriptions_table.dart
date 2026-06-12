import 'package:drift/drift.dart';

import 'package:ntfyd/core/database/tables/server_configs_table.dart';

class Subscriptions extends Table {
  TextColumn get id => text()();
  TextColumn get serverId =>
      text().references(ServerConfigs, #id, onDelete: KeyAction.cascade)();
  TextColumn get topic => text()();
  TextColumn get displayName => text()();
  IntColumn get priorityThreshold => integer().withDefault(const Constant(1))();
  IntColumn get muted => integer().withDefault(const Constant(0))();
  IntColumn get pinned => integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {serverId, topic},
  ];
}
