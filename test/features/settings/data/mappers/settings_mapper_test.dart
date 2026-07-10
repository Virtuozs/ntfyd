import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/database/app_database.dart' as db;
import 'package:ntfyd/features/settings/data/mappers/settings_mapper.dart';
import 'package:ntfyd/features/settings/domain/entities/app_settings.dart';

void main() {
  group('SettingsMapper.toDomain', () {
    test('maps every field, decoding themeMode and bool columns', () {
      final row = db.AppSetting(
        id: 1,
        themeMode: 'white',
        quietHoursEnabled: 1,
        quietHoursStart: '22:00',
        quietHoursEnd: '07:00',
        priorityThreshold: 2,
        retentionMaxAgeDays: 30,
        retentionMaxRows: 10000,
        hideLockScreenContent: 1,
        analyticsOptOut: 1,
        biometricLock: 1,
      );

      final settings = SettingsMapper.toDomain(row);

      expect(settings.themeMode, AppThemeMode.white);
      expect(settings.quietHoursEnabled, isTrue);
      expect(settings.quietHoursStart, '22:00');
      expect(settings.quietHoursEnd, '07:00');
      expect(settings.priorityThreshold, 2);
      expect(settings.retentionMaxAgeDays, 30);
      expect(settings.retentionMaxRows, 10000);
      expect(settings.hideLockScreenContent, isTrue);
      expect(settings.analyticsOptOut, isTrue);
      expect(settings.biometricLock, isTrue);
    });

    test('maps materialYou and false bool columns', () {
      final row = db.AppSetting(
        id: 1,
        themeMode: 'materialYou',
        quietHoursEnabled: 0,
        priorityThreshold: 1,
        hideLockScreenContent: 0,
        analyticsOptOut: 0,
        biometricLock: 0,
      );

      final settings = SettingsMapper.toDomain(row);

      expect(settings.themeMode, AppThemeMode.materialYou);
      expect(settings.quietHoursEnabled, isFalse);
      expect(settings.biometricLock, isFalse);
    });

    test('falls back to AppThemeMode.dark for an unrecognized string', () {
      final row = db.AppSetting(
        id: 1,
        themeMode: 'system', // stale value from before this design
        quietHoursEnabled: 0,
        priorityThreshold: 1,
        hideLockScreenContent: 0,
        analyticsOptOut: 0,
        biometricLock: 0,
      );

      final settings = SettingsMapper.toDomain(row);

      expect(settings.themeMode, AppThemeMode.dark);
    });
  });

  group('SettingsMapper.toCompanion', () {
    test('encodes themeMode and bool fields', () {
      const settings = AppSettings(
        themeMode: AppThemeMode.white,
        quietHoursEnabled: true,
        quietHoursStart: '22:00',
        quietHoursEnd: '07:00',
        retentionMaxAgeDays: 7,
        retentionMaxRows: 10000,
        hideLockScreenContent: true,
        analyticsOptOut: true,
        biometricLock: true,
      );

      final companion = SettingsMapper.toCompanion(settings);

      expect(companion.themeMode, const Value('white'));
      expect(companion.quietHoursEnabled, const Value(1));
      expect(companion.quietHoursStart, const Value('22:00'));
      expect(companion.quietHoursEnd, const Value('07:00'));
      expect(companion.retentionMaxAgeDays, const Value(7));
      expect(companion.retentionMaxRows, const Value(10000));
      expect(companion.hideLockScreenContent, const Value(1));
      expect(companion.analyticsOptOut, const Value(1));
      expect(companion.biometricLock, const Value(1));
    });

    test('encodes materialYou and false bool fields', () {
      const settings = AppSettings(themeMode: AppThemeMode.materialYou);

      final companion = SettingsMapper.toCompanion(settings);

      expect(companion.themeMode, const Value('materialYou'));
      expect(companion.quietHoursEnabled, const Value(0));
      expect(companion.biometricLock, const Value(0));
    });

    test('encodes null quiet-hours/retention fields as explicit null Values', () {
      const settings = AppSettings();

      final companion = SettingsMapper.toCompanion(settings);

      expect(companion.quietHoursStart, const Value(null));
      expect(companion.quietHoursEnd, const Value(null));
      expect(companion.retentionMaxAgeDays, const Value(null));
      expect(companion.retentionMaxRows, const Value(null));
    });

    test('encodes priorityThreshold', () {
      const settings = AppSettings(priorityThreshold: 5);

      final companion = SettingsMapper.toCompanion(settings);

      expect(companion.priorityThreshold, const Value(5));
    });
  });
}
