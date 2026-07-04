import 'package:drift/drift.dart';

import 'package:ntfyd/core/database/tables/groups_table.dart';

class GroupMembers extends Table {
  TextColumn get groupId =>
      text().references(Groups, #id, onDelete: KeyAction.cascade)();
  TextColumn get serverId => text()();
  TextColumn get topic => text()();

  @override
  Set<Column> get primaryKey => {groupId, serverId, topic};
}
