import 'package:drift/drift.dart';

class NotificationMessages extends Table {
  TextColumn get id => text()();
  TextColumn get serverId => text()();
  TextColumn get topic => text()();
  IntColumn get time => integer()();
  IntColumn get expires => integer().nullable()();
  TextColumn get event => text()();
  TextColumn get title => text().nullable()();
  TextColumn get body => text().nullable()();
  IntColumn get priority => integer().withDefault(const Constant(3))();
  TextColumn get tags => text().nullable()(); // JSON array string
  TextColumn get click => text().nullable()();
  TextColumn get icon => text().nullable()();
  TextColumn get attachment => text().nullable()(); // JSON object string
  TextColumn get actions => text().nullable()(); // JSON array string
  IntColumn get isMarkdown => integer().withDefault(const Constant(0))();
  IntColumn get isRead => integer().withDefault(const Constant(0))();
  IntColumn get isPinned => integer().withDefault(const Constant(0))();
  IntColumn get receivedAt => integer()();

  @override
  Set<Column> get primaryKey => {serverId, id};
}
