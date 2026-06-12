import 'package:drift/drift.dart';

class ServerConfigs extends Table {
  TextColumn get id => text()();
  TextColumn get baseUrl => text().unique()();
  TextColumn get displayName => text()();
  TextColumn get authType => text()(); // 'none' | 'basic' | 'bearer'
  TextColumn get credentialRef => text().nullable()();
  IntColumn get isDefault => integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
