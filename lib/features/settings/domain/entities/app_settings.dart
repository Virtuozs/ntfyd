import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

/// White = fixed light Material 3 (seed-based). Dark = the app's existing
/// hand-tuned default dark theme (also the fallback default). materialYou
/// = dynamic color from the system wallpaper (Android 12+), following
/// system light/dark, seed-color fallback where dynamic color isn't
/// available.
enum AppThemeMode { white, dark, materialYou }

/// Singleton app-wide preferences (Base-Plan §2.1 `AppSettings`). Mirrors
/// `lib/core/database/tables/app_settings_table.dart`'s row 1:1.
@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(AppThemeMode.dark) AppThemeMode themeMode,
    @Default(false) bool quietHoursEnabled,
    String? quietHoursStart, // "HH:mm" (24h)
    String? quietHoursEnd,
    @Default(1) int priorityThreshold, // 1 (Min) .. 5 (Urgent); floor for notification suppression
    int? retentionMaxAgeDays, // null = unlimited ("Forever")
    int? retentionMaxRows, // internal safety cap, not user-facing
    @Default(false) bool hideLockScreenContent,
    @Default(false) bool analyticsOptOut,
    @Default(false) bool biometricLock,
  }) = _AppSettings;
}
