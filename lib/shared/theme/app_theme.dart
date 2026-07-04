import 'package:flutter/material.dart';
import 'package:ntfyd/shared/theme/design_tokens.dart';

/// Seed color for Material You fallback.
const Color _seedColor = Color(0xFF2196F3); // ntfy blue

abstract final class AppTheme {
  /// Light theme => Material 3, seed-based.
  /// Used only when Material You is enabled (dynamic or seed-fallback).
  static ThemeData light({ColorScheme? dynamicScheme}) {
    final scheme =
        dynamicScheme ??
        ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.light,
        );
    return _buildTheme(scheme);
  }

  /// Dark theme => Material 3, seed-based.
  /// Used only when Material You is enabled (dynamic or seed-fallback).
  static ThemeData dark({ColorScheme? dynamicScheme}) {
    final scheme =
        dynamicScheme ??
        ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.dark,
        );
    return _buildTheme(scheme);
  }

  /// Fixed dark theme matching the app's default (Material You disabled design, hand-built from [DefaultPalette].
  ///
  /// This is the app's default appearance. It is dark-only by design —
  /// when Material You is OFF, both `theme` and `darkTheme` on
  /// [MaterialApp] should be set to this, so `ThemeMode.system` has no
  /// visible light-mode variant to switch to.
  static ThemeData defaultDark() {
    const scheme = ColorScheme.dark(
      primary: DefaultPalette.primary,
      onPrimary: DefaultPalette.onPrimary,
      surface: DefaultPalette.background,
      onSurface: DefaultPalette.onSurface,
      onSurfaceVariant: DefaultPalette.onSurfaceVariant,
      surfaceContainerHigh: DefaultPalette.cardSurface,
      surfaceContainer: DefaultPalette.cardSurface,
      surfaceContainerLow: DefaultPalette.background,
      surfaceContainerLowest: DefaultPalette.background,
      surfaceContainerHighest: DefaultPalette.cardSurface,
      outlineVariant: DefaultPalette.cardSurface,
    );

    final theme = _buildTheme(scheme);

    return theme.copyWith(
      scaffoldBackgroundColor: DefaultPalette.background,
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        filled: true,
        fillColor: DefaultPalette.cardSurface,
      ),
    );
  }

  static ThemeData _buildTheme(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: scheme.outlineVariant, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
