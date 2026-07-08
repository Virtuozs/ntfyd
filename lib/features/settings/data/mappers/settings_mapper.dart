import 'package:drift/drift.dart' show Value;
import 'package:ntfyd/core/database/app_database.dart' as db;
import 'package:ntfyd/features/settings/domain/entities/app_settings.dart';

/// Maps between the Drift `AppSettings` singleton row and the domain
/// [AppSettings] entity. An unrecognized/legacy `themeMode` string falls
/// back to [AppThemeMode.dark] rather than throwing, per the
/// "default fallback is dark" requirement.
class SettingsMapper {
  static AppSettings toDomain(db.AppSetting row) {
    return AppSettings(
      themeMode: _themeModeFromString(row.themeMode),
      quietHoursEnabled: row.quietHoursEnabled == 1,
      quietHoursStart: row.quietHoursStart,
      quietHoursEnd: row.quietHoursEnd,
      retentionMaxAgeDays: row.retentionMaxAgeDays,
      retentionMaxRows: row.retentionMaxRows,
      hideLockScreenContent: row.hideLockScreenContent == 1,
      analyticsOptOut: row.analyticsOptOut == 1,
      biometricLock: row.biometricLock == 1,
    );
  }

  static db.AppSettingsCompanion toCompanion(AppSettings settings) {
    return db.AppSettingsCompanion(
      themeMode: Value(_themeModeToString(settings.themeMode)),
      quietHoursEnabled: Value(settings.quietHoursEnabled ? 1 : 0),
      quietHoursStart: Value(settings.quietHoursStart),
      quietHoursEnd: Value(settings.quietHoursEnd),
      retentionMaxAgeDays: Value(settings.retentionMaxAgeDays),
      retentionMaxRows: Value(settings.retentionMaxRows),
      hideLockScreenContent: Value(settings.hideLockScreenContent ? 1 : 0),
      analyticsOptOut: Value(settings.analyticsOptOut ? 1 : 0),
      biometricLock: Value(settings.biometricLock ? 1 : 0),
    );
  }

  static AppThemeMode _themeModeFromString(String value) {
    return switch (value) {
      'white' => AppThemeMode.white,
      'materialYou' => AppThemeMode.materialYou,
      _ => AppThemeMode.dark,
    };
  }

  static String _themeModeToString(AppThemeMode mode) {
    return switch (mode) {
      AppThemeMode.white => 'white',
      AppThemeMode.dark => 'dark',
      AppThemeMode.materialYou => 'materialYou',
    };
  }
}
