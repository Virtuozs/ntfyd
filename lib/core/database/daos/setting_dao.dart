import 'package:drift/drift.dart';
import 'package:ntfyd/core/database/app_database.dart';
import 'package:ntfyd/core/database/tables/app_settings_table.dart';

part 'setting_dao.g.dart';

@DriftAccessor(tables: [AppSettings])
class SettingDao extends DatabaseAccessor<AppDatabase> with _$SettingDaoMixin {
  SettingDao(super.db);

  Stream<AppSetting> watch() async* {
    await _ensureRowExists();

    yield* (select(appSettings)..where((t) => t.id.equals(1))).watchSingle();
  }

  Future<void> updateAppSetting(AppSettingsCompanion row) async {
    await _ensureRowExists();

    await (update(appSettings)..where((t) => t.id.equals(1))).write(row);
  }

  Future<void> _ensureRowExists() async {
    final existing = await (select(
      appSettings,
    )..where((t) => t.id.equals(1))).getSingleOrNull();

    if (existing == null) {
      await into(appSettings).insertOnConflictUpdate(
        const AppSettingsCompanion(
          id: Value(1),
          themeMode: Value('system'),
          dynamicColor: Value(1),
          quietHoursEnabled: Value(0),
          hideLockScreenContent: Value(0),
          analyticsOptOut: Value(0),
          biometricLock: Value(0),
        ),
      );
    }
  }
}
