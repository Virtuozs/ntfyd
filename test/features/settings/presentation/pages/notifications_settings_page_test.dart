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
    when(() => cubit.setPriorityThreshold(any())).thenAnswer((_) async {});
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

  testWidgets('priority dropdown shows the current threshold', (tester) async {
    await pumpPage(tester, const AppSettings(priorityThreshold: 3));

    expect(find.text('Default priority'), findsOneWidget);
  });

  testWidgets('selecting a priority option calls setPriorityThreshold', (tester) async {
    when(() => cubit.setPriorityThreshold(any())).thenAnswer((_) async {});
    await pumpPage(tester, const AppSettings(priorityThreshold: 3));

    await tester.tap(find.byType(DropdownButton<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Urgent priority').last);
    await tester.pumpAndSettle();

    verify(() => cubit.setPriorityThreshold(5)).called(1);
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

  testWidgets(
    'turning quiet hours on from null start/end fills in 22:00/07:00',
    (tester) async {
      await pumpPage(tester, const AppSettings());

      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();

      verify(
        () => cubit.setQuietHours(enabled: true, start: '22:00', end: '07:00'),
      ).called(1);
    },
  );

  testWidgets('Start/End rows are disabled while quiet hours is off', (tester) async {
    await pumpPage(tester, const AppSettings());

    final startTile = tester.widget<ListTile>(find.widgetWithText(ListTile, 'Start'));
    final endTile = tester.widget<ListTile>(find.widgetWithText(ListTile, 'End'));

    expect(startTile.enabled, isFalse);
    expect(endTile.enabled, isFalse);
  });
}
