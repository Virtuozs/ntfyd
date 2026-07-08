import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/features/settings/domain/entities/app_settings.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_cubit.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_state.dart';
import 'package:ntfyd/features/settings/presentation/pages/theme_settings_page.dart';

class MockSettingsCubit extends Mock implements SettingsCubit {}

void main() {
  late MockSettingsCubit cubit;

  setUpAll(() {
    registerFallbackValue(AppThemeMode.white);
  });

  setUp(() {
    cubit = MockSettingsCubit();
    when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => cubit.close()).thenAnswer((_) async {});
    when(() => cubit.setThemeMode(any())).thenAnswer((_) async {});
  });

  Future<void> pumpPage(WidgetTester tester, AppSettings settings) async {
    when(() => cubit.state).thenReturn(SettingsState.loaded(settings));
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SettingsCubit>.value(
          value: cubit,
          child: const ThemeSettingsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('exactly one radio tile is selected, matching current themeMode', (
    tester,
  ) async {
    await pumpPage(tester, const AppSettings(themeMode: AppThemeMode.white));

    final tiles = tester.widgetList<RadioListTile<AppThemeMode>>(
      find.byType(RadioListTile<AppThemeMode>),
    );
    expect(tiles.length, 3);
    expect(
      tiles.where((t) => t.value == t.groupValue).single.value,
      AppThemeMode.white,
    );
  });

  testWidgets('tapping "Material You" calls setThemeMode(materialYou)', (
    tester,
  ) async {
    await pumpPage(tester, const AppSettings());

    await tester.tap(find.text('Material You'));
    await tester.pumpAndSettle();

    verify(() => cubit.setThemeMode(AppThemeMode.materialYou)).called(1);
  });
}
