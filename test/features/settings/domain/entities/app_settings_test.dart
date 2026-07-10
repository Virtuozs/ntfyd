import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/features/settings/domain/entities/app_settings.dart';

void main() {
  group('AppSettings', () {
    test('default constructor uses documented defaults', () {
      const settings = AppSettings();

      expect(settings.themeMode, AppThemeMode.dark);
      expect(settings.quietHoursEnabled, isFalse);
      expect(settings.quietHoursStart, isNull);
      expect(settings.quietHoursEnd, isNull);
      expect(settings.retentionMaxAgeDays, isNull);
      expect(settings.retentionMaxRows, isNull);
      expect(settings.hideLockScreenContent, isFalse);
      expect(settings.analyticsOptOut, isFalse);
      expect(settings.biometricLock, isFalse);
    });

    test('copyWith overrides only the given field', () {
      const settings = AppSettings();

      final updated = settings.copyWith(themeMode: AppThemeMode.materialYou);

      expect(updated.themeMode, AppThemeMode.materialYou);
      expect(updated.biometricLock, isFalse);
    });

    test('default constructor defaults priorityThreshold to 1 (Min)', () {
      const settings = AppSettings();

      expect(settings.priorityThreshold, 1);
    });

    test('copyWith overrides priorityThreshold independently', () {
      const settings = AppSettings();

      final updated = settings.copyWith(priorityThreshold: 3);

      expect(updated.priorityThreshold, 3);
      expect(updated.themeMode, AppThemeMode.dark);
    });

    test('two instances with the same fields are equal', () {
      expect(
        const AppSettings(themeMode: AppThemeMode.white, biometricLock: true),
        const AppSettings(themeMode: AppThemeMode.white, biometricLock: true),
      );
    });
  });
}
