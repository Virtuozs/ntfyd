import 'package:drift/drift.dart';

class Groups extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get icon => text().nullable()();
  IntColumn get color => integer().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  TextColumn get filterPriorities => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
