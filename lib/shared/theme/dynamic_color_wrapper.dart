import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:ntfyd/core/app_lock/app_lock_guard.dart';
import 'package:ntfyd/core/app_lock/app_lock_service.dart';
import 'package:ntfyd/features/settings/domain/entities/app_settings.dart';
import 'package:ntfyd/shared/startup/startup_gate.dart';
import 'package:ntfyd/shared/theme/app_theme.dart';
import 'package:ntfyd/shared/theme/app_theme_controller.dart';

/// Root theming widget. Three [AppThemeMode]s:
/// - [AppThemeMode.white]: fixed light Material 3 ([AppTheme.light]).
/// - [AppThemeMode.dark]: the app's hand-tuned default dark theme
///   ([AppTheme.defaultDark]) — also the fallback default.
/// - [AppThemeMode.materialYou]: dynamic color from the system wallpaper,
///   following system light/dark, seed-color fallback where unavailable.
///
/// Also mounts [AppLockGuard] via [MaterialApp.builder] so the lock overlay
/// renders inside the app's `Localizations`/`Theme`/`Directionality`
/// ancestry rather than above it.
class DynamicColorWrapper extends StatelessWidget {
  const DynamicColorWrapper({
    super.key,
    required this.controller,
    required this.navigatorKey,
    required this.biometricLock,
    required this.hideLockScreenContent,
    required this.appLockService,
  });

  final AppThemeController controller;
  final GlobalKey<NavigatorState> navigatorKey;
  final bool biometricLock;
  final bool hideLockScreenContent;
  final AppLockService appLockService;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: controller,
      builder: (context, mode, _) {
        switch (mode) {
          case AppThemeMode.white:
            final theme = AppTheme.light();
            return MaterialApp(
              title: 'ntfyd',
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              theme: theme,
              darkTheme: theme,
              themeMode: ThemeMode.light,
              home: _buildHome(),
              builder: (context, child) => AppLockGuard(
                biometricLock: biometricLock,
                hideLockScreenContent: hideLockScreenContent,
                appLockService: appLockService,
                child: child!,
              ),
            );
          case AppThemeMode.dark:
            final theme = AppTheme.defaultDark();
            return MaterialApp(
              title: 'ntfyd',
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              theme: theme,
              darkTheme: theme,
              themeMode: ThemeMode.dark,
              home: _buildHome(),
              builder: (context, child) => AppLockGuard(
                biometricLock: biometricLock,
                hideLockScreenContent: hideLockScreenContent,
                appLockService: appLockService,
                child: child!,
              ),
            );
          case AppThemeMode.materialYou:
            return DynamicColorBuilder(
              builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
                return MaterialApp(
                  title: 'ntfyd',
                  debugShowCheckedModeBanner: false,
                  navigatorKey: navigatorKey,
                  theme: AppTheme.light(dynamicScheme: lightDynamic),
                  darkTheme: AppTheme.dark(dynamicScheme: darkDynamic),
                  themeMode: ThemeMode.system,
                  home: _buildHome(),
                  builder: (context, child) => AppLockGuard(
                    biometricLock: biometricLock,
                    hideLockScreenContent: hideLockScreenContent,
                    appLockService: appLockService,
                    child: child!,
                  ),
                );
              },
            );
        }
      },
    );
  }

  Widget _buildHome() {
    return const StartupGate();
  }
}
