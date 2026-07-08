import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/app_lock/app_lock_service.dart';
import 'package:ntfyd/di/injection_container.dart';
import 'package:ntfyd/features/settings/domain/entities/app_settings.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_cubit.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_state.dart';
import 'package:ntfyd/features/settings/presentation/pages/biometrics_settings_page.dart';

class MockSettingsCubit extends Mock implements SettingsCubit {}

class MockAppLockService extends Mock implements AppLockService {}

void main() {
  late MockSettingsCubit cubit;
  late MockAppLockService appLockService;

  setUp(() {
    cubit = MockSettingsCubit();
    appLockService = MockAppLockService();
    when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => cubit.close()).thenAnswer((_) async {});
    when(() => cubit.setBiometricLock(any())).thenAnswer((_) async {});

    getIt.registerFactory<AppLockService>(() => appLockService);
  });

  tearDown(() async {
    await getIt.reset();
  });

  Future<void> pumpPage(WidgetTester tester, {required bool biometricLock}) async {
    when(() => cubit.state).thenReturn(
      SettingsState.loaded(AppSettings(biometricLock: biometricLock)),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SettingsCubit>.value(
          value: cubit,
          child: const BiometricsSettingsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('switch reflects current biometricLock and toggling calls the cubit', (
    tester,
  ) async {
    when(() => appLockService.isAvailable()).thenAnswer((_) async => true);
    await pumpPage(tester, biometricLock: false);

    final switchFinder = find.byType(SwitchListTile);
    expect(tester.widget<SwitchListTile>(switchFinder).value, isFalse);

    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    verify(() => cubit.setBiometricLock(true)).called(1);
  });

  testWidgets('switch is disabled and shows a warning when biometrics unavailable', (
    tester,
  ) async {
    when(() => appLockService.isAvailable()).thenAnswer((_) async => false);
    await pumpPage(tester, biometricLock: false);

    expect(tester.widget<SwitchListTile>(find.byType(SwitchListTile)).onChanged, isNull);
    expect(find.textContaining('No biometric'), findsOneWidget);
  });
}
