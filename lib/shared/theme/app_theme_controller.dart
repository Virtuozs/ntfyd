import 'package:flutter/foundation.dart';
import 'package:ntfyd/features/settings/domain/entities/app_settings.dart';

/// Drives which theme [DynamicColorWrapper] renders. Fed from
/// `SettingsCubit`'s `themeMode` in `main.dart` — this stays a plain
/// `ValueNotifier` so `DynamicColorWrapper` doesn't need to know
/// settings/Bloc exist.
class AppThemeController extends ValueNotifier<AppThemeMode> {
  AppThemeController({AppThemeMode initial = AppThemeMode.dark}) : super(initial);
}
