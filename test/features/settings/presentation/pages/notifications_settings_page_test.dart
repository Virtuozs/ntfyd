import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/features/settings/domain/entities/app_settings.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_cubit.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_state.dart';
import 'package:ntfyd/features/settings/presentation/pages/notifications_settings_page.dart';

class MockSettingsCubit extends Mock implements SettingsCubit {}

void main() {
  late MockSettingsCubit cubit;

  setUp(() {
    cubit = MockSettingsCubit();
    when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => cubit.close()).thenAnswer((_) async {});
    when(() => cubit.setQuietHours(
      enabled: any(named: 'enabled'),
      start: any(named: 'start'),
      end: any(named: 'end'),
    )).thenAnswer((_) async {});
  });

  Future<void> pumpPage(WidgetTester tester, AppSettings settings) async {
    when(() => cubit.state).thenReturn(SettingsState.loaded(settings));
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SettingsCubit>.value(
          value: cubit,
          child: const NotificationsSettingsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows all 5 priority channels', (tester) async {
    await pumpPage(tester, const AppSettings());

    expect(find.text('Min priority'), findsOneWidget);
    expect(find.text('Low priority'), findsOneWidget);
    expect(find.text('Default priority'), findsOneWidget);
    expect(find.text('High priority'), findsOneWidget);
    expect(find.text('Urgent priority'), findsOneWidget);
  });

  testWidgets('toggling quiet hours off calls setQuietHours(enabled: false)', (
    tester,
  ) async {
    await pumpPage(
      tester,
      const AppSettings(
        quietHoursEnabled: true,
        quietHoursStart: '22:00',
        quietHoursEnd: '07:00',
      ),
    );

    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    verify(
      () => cubit.setQuietHours(enabled: false, start: '22:00', end: '07:00'),
    ).called(1);
  });
}
