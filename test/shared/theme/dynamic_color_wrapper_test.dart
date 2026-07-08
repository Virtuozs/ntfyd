import 'dart:async';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/app_lock/app_lock_service.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/di/injection_container.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_form_cubit.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_form_state.dart';
import 'package:ntfyd/features/settings/domain/entities/app_settings.dart';
import 'package:ntfyd/shared/theme/app_theme_controller.dart';
import 'package:ntfyd/shared/theme/design_tokens.dart';
import 'package:ntfyd/shared/theme/dynamic_color_wrapper.dart';

class MockServerFormCubit extends Mock implements ServerFormCubit {}

class MockAppLockService extends Mock implements AppLockService {}

void main() {
  late MockServerFormCubit mockServerFormCubit;
  late GlobalKey<NavigatorState> navigatorKey;
  late MockAppLockService mockAppLockService;

  setUp(() {
    navigatorKey = GlobalKey<NavigatorState>();
    mockServerFormCubit = MockServerFormCubit();
    when(
      () => mockServerFormCubit.state,
    ).thenReturn(const ServerFormState.idle());
    when(
      () => mockServerFormCubit.stream,
    ).thenAnswer((_) => const Stream.empty());
    when(() => mockServerFormCubit.close()).thenAnswer((_) async {});

    getIt.registerFactory<ServerFormCubit>(() => mockServerFormCubit);

    mockAppLockService = MockAppLockService();
    when(() => mockAppLockService.isAvailable()).thenAnswer((_) async => true);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('DynamicColorWrapper', () {
    testWidgets('should_use_defaultDark_theme_for_AppThemeMode_dark', (
      tester,
    ) async {
      final controller = AppThemeController(); // defaults to dark

      await tester.pumpWidget(
        DynamicColorWrapper(
          controller: controller,
          navigatorKey: navigatorKey,
          biometricLock: false,
          appLockService: mockAppLockService,
        ),
      );
      await tester.pumpAndSettle();

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));

      expect(app.theme!.colorScheme.surface, DefaultPalette.background);
      expect(app.theme!.colorScheme.primary, DefaultPalette.primary);
      expect(app.darkTheme!.colorScheme.surface, app.theme!.colorScheme.surface);
      expect(app.themeMode, ThemeMode.dark);
    });

    testWidgets('should_use_light_theme_for_AppThemeMode_white', (
      tester,
    ) async {
      final controller = AppThemeController(initial: AppThemeMode.white);

      await tester.pumpWidget(
        DynamicColorWrapper(
          controller: controller,
          navigatorKey: navigatorKey,
          biometricLock: false,
          appLockService: mockAppLockService,
        ),
      );
      await tester.pumpAndSettle();

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));

      expect(app.theme!.colorScheme.brightness, Brightness.light);
      expect(app.darkTheme!.colorScheme.brightness, Brightness.light);
      expect(app.themeMode, ThemeMode.light);
      expect(find.byType(DynamicColorBuilder), findsNothing);
    });

    testWidgets('should_use_dynamic_or_seed_theme_for_AppThemeMode_materialYou', (
      tester,
    ) async {
      final controller = AppThemeController(initial: AppThemeMode.materialYou);

      await tester.pumpWidget(
        DynamicColorWrapper(
          controller: controller,
          navigatorKey: navigatorKey,
          biometricLock: false,
          appLockService: mockAppLockService,
        ),
      );
      await tester.pumpAndSettle();

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));

      expect(app.theme!.colorScheme.surface, isNot(DefaultPalette.background));
      expect(app.theme!.colorScheme.primary, isNot(DefaultPalette.primary));
      expect(app.themeMode, ThemeMode.system);
      expect(find.byType(DynamicColorBuilder), findsOneWidget);
    });

    testWidgets('should_rebuild_on_controller_change', (tester) async {
      final controller = AppThemeController(); // dark

      await tester.pumpWidget(
        DynamicColorWrapper(
          controller: controller,
          navigatorKey: navigatorKey,
          biometricLock: false,
          appLockService: mockAppLockService,
        ),
      );
      await tester.pumpAndSettle();

      var app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.theme!.colorScheme.primary, DefaultPalette.primary);

      controller.value = AppThemeMode.materialYou;
      await tester.pumpAndSettle();

      app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.theme!.colorScheme.primary, isNot(DefaultPalette.primary));
    });

    testWidgets(
      'shows the lock overlay on resume without throwing when biometricLock is true',
      (tester) async {
        // Arrange — regression test for AppLockGuard being mounted above
        // MaterialApp instead of via MaterialApp.builder. In the broken
        // tree shape, the overlay's Theme.of/Material lookups throw
        // because there is no MaterialApp ancestor.
        final controller = AppThemeController(); // dark
        final authCompleter = Completer<Result<bool>>();
        when(
          () => mockAppLockService.authenticate(any()),
        ).thenAnswer((_) => authCompleter.future);

        await tester.pumpWidget(
          DynamicColorWrapper(
            controller: controller,
            navigatorKey: navigatorKey,
            biometricLock: true,
            appLockService: mockAppLockService,
          ),
        );
        await tester.pumpAndSettle();

        // Act
        WidgetsBinding.instance.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        );
        await tester.pump();

        // Assert
        expect(find.byKey(const Key('lock_overlay')), findsOneWidget);
        expect(tester.takeException(), isNull);

        authCompleter.complete(const Result.success(true));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );
  });
}
