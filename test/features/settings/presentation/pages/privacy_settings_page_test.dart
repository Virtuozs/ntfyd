import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/di/injection_container.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_form_cubit.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_form_state.dart';
import 'package:ntfyd/features/server_config/presentation/pages/login_page.dart';
import 'package:ntfyd/features/settings/domain/entities/app_settings.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_cubit.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_state.dart';
import 'package:ntfyd/features/settings/presentation/pages/privacy_settings_page.dart';

class MockSettingsCubit extends Mock implements SettingsCubit {}

class MockServerFormCubit extends Mock implements ServerFormCubit {}

void main() {
  late MockSettingsCubit cubit;
  late StreamController<SettingsState> stateController;
  late MockServerFormCubit serverFormCubit;

  setUp(() {
    cubit = MockSettingsCubit();
    stateController = StreamController<SettingsState>.broadcast();
    serverFormCubit = MockServerFormCubit();

    when(() => cubit.stream).thenAnswer((_) => stateController.stream);
    when(() => cubit.close()).thenAnswer((_) async {});
    when(() => cubit.setHideLockScreenContent(any())).thenAnswer((_) async {});
    when(() => cubit.setAnalyticsOptOut(any())).thenAnswer((_) async {});
    when(() => cubit.clearAllData()).thenAnswer((_) async {});

    when(() => serverFormCubit.state).thenReturn(const ServerFormState.idle());
    when(() => serverFormCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => serverFormCubit.close()).thenAnswer((_) async {});
    getIt.registerFactory<ServerFormCubit>(() => serverFormCubit);
  });

  tearDown(() async {
    await stateController.close();
    await getIt.reset();
  });

  Future<void> pumpPage(WidgetTester tester, AppSettings settings) async {
    when(() => cubit.state).thenReturn(SettingsState.loaded(settings));
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SettingsCubit>.value(
          value: cubit,
          child: const PrivacySettingsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('"Clear all data" requires confirmation before calling clearAllData', (
    tester,
  ) async {
    await pumpPage(tester, const AppSettings());

    await tester.tap(find.text('Clear all data'));
    await tester.pumpAndSettle();
    verifyNever(() => cubit.clearAllData());

    await tester.tap(find.text('Clear all data').last);
    await tester.pumpAndSettle();

    verify(() => cubit.clearAllData()).called(1);
  });

  testWidgets('navigates to LoginPage when SettingsState.dataCleared is emitted', (
    tester,
  ) async {
    await pumpPage(tester, const AppSettings());

    stateController.add(const SettingsState.dataCleared());
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
  });
}
