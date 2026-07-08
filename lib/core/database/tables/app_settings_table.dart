import 'package:drift/drift.dart';

class AppSettings extends Table {
  // Singleton row — always id=1.
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get themeMode => text().withDefault(const Constant('dark'))();
  IntColumn get quietHoursEnabled => integer().withDefault(const Constant(0))();
  TextColumn get quietHoursStart => text().nullable()();
  TextColumn get quietHoursEnd => text().nullable()();
  IntColumn get retentionMaxAgeDays => integer().nullable()();
  IntColumn get retentionMaxRows => integer().nullable()();
  IntColumn get hideLockScreenContent =>
      integer().withDefault(const Constant(0))();
  IntColumn get analyticsOptOut => integer().withDefault(const Constant(0))();
  IntColumn get biometricLock => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
