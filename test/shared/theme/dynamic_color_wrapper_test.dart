import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/shared/theme/design_tokens.dart';
import 'package:ntfyd/shared/theme/dynamic_color_wrapper.dart';
import 'package:ntfyd/shared/theme/material_you_controller.dart';

void main() {
  group('DynamicColorWrapper', () {
    testWidgets('should_use_defaultDark_when_materialYou_disabled', (
      tester,
    ) async {
      final controller = MaterialYouController(); // defaults to false

      await tester.pumpWidget(DynamicColorWrapper(controller: controller));
      await tester.pumpAndSettle();

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));

      expect(app.theme!.colorScheme.surface, DefaultPalette.background);
      expect(app.theme!.colorScheme.primary, DefaultPalette.primary);
      // theme and darkTheme should be identical (dark-only by design)
      expect(
        app.darkTheme!.colorScheme.surface,
        app.theme!.colorScheme.surface,
      );
      expect(
        app.darkTheme!.colorScheme.primary,
        app.theme!.colorScheme.primary,
      );
    });

    testWidgets('should_use_dynamic_or_seed_theme_when_materialYou_enabled', (
      tester,
    ) async {
      final controller = MaterialYouController(initial: true);

      await tester.pumpWidget(DynamicColorWrapper(controller: controller));
      await tester.pumpAndSettle();

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));

      // Should NOT be the fixed default palette.
      expect(app.theme!.colorScheme.surface, isNot(DefaultPalette.background));
      expect(app.theme!.colorScheme.primary, isNot(DefaultPalette.primary));

      // DynamicColorBuilder should be present in the tree.
      expect(find.byType(DynamicColorBuilder), findsOneWidget);
    });

    testWidgets('should_rebuild_on_controller_toggle', (tester) async {
      final controller = MaterialYouController(); // false

      await tester.pumpWidget(DynamicColorWrapper(controller: controller));
      await tester.pumpAndSettle();

      var app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.theme!.colorScheme.primary, DefaultPalette.primary);

      controller.value = true;
      await tester.pumpAndSettle();

      app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.theme!.colorScheme.primary, isNot(DefaultPalette.primary));
    });

    testWidgets('should_keep_themeMode_system_in_both_states', (tester) async {
      final controller = MaterialYouController();

      await tester.pumpWidget(DynamicColorWrapper(controller: controller));
      await tester.pumpAndSettle();
      var app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.themeMode, ThemeMode.system);

      controller.value = true;
      await tester.pumpAndSettle();
      app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.themeMode, ThemeMode.system);
    });

    testWidgets('should_not_build_DynamicColorBuilder_when_disabled', (
      tester,
    ) async {
      final controller = MaterialYouController(); // false

      await tester.pumpWidget(DynamicColorWrapper(controller: controller));
      await tester.pumpAndSettle();

      expect(find.byType(DynamicColorBuilder), findsNothing);
    });
  });
}
