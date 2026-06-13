import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/shared/theme/app_theme.dart';
import 'package:ntfyd/shared/theme/design_tokens.dart';

void main() {
  group('AppTheme.defaultDark', () {
    late ThemeData theme;
    late ColorScheme scheme;

    setUp(() {
      theme = AppTheme.defaultDark();
      scheme = theme.colorScheme;
    });

    test('should_return_dark_brightness', () {
      expect(scheme.brightness, Brightness.dark);
    });

    test('should_use_design_background_color', () {
      expect(scheme.surface, DefaultPalette.background);
    });

    test('should_use_design_primary_color', () {
      expect(scheme.primary, DefaultPalette.primary);
    });

    test('should_use_design_onPrimary_color', () {
      expect(scheme.onPrimary, DefaultPalette.onPrimary);
    });

    test('should_set_input_fill_color_to_card_surface', () {
      expect(theme.inputDecorationTheme.fillColor, DefaultPalette.cardSurface);
      expect(theme.inputDecorationTheme.filled, isTrue);
    });

    test('should_use_design_onSurface_text_color', () {
      expect(scheme.onSurface, DefaultPalette.onSurface);
    });

    test('should_use_design_onSurfaceVariant_text_color', () {
      expect(scheme.onSurfaceVariant, DefaultPalette.onSurfaceVariant);
    });

    test('should_be_material3', () {
      expect(theme.useMaterial3, isTrue);
    });

    test('seed_based_light_and_dark_remain_unaffected', () {
      // Sanity check: existing methods still produce a different scheme
      // (seed #2196F3), proving defaultDark() didn't mutate shared state.
      final seedDark = AppTheme.dark();
      expect(seedDark.colorScheme.primary, isNot(DefaultPalette.primary));
    });
  });
}
