import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/di/injection_container.dart';
import 'package:ntfyd/features/server_config/presentation/pages/server_manager_page.dart';
import 'package:ntfyd/features/settings/domain/entities/app_settings.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_cubit.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_state.dart';
import 'package:ntfyd/features/settings/presentation/pages/settings_page.dart';

class MockSettingsCubit extends Mock implements SettingsCubit {}

void main() {
  late MockSettingsCubit cubit;

  setUp(() {
    cubit = MockSettingsCubit();
    when(() => cubit.state).thenReturn(
      const SettingsState.loaded(AppSettings()),
    );
    when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => cubit.close()).thenAnswer((_) async {});
    when(() => cubit.load()).thenReturn(null);

    getIt.registerFactory<SettingsCubit>(() => cubit);
  });

  tearDown(() async {
    await getIt.reset();
  });

  Future<void> pumpPage(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SettingsPage()),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows all 6 settings rows', (tester) async {
    await pumpPage(tester);

    expect(find.text('Server URL'), findsOneWidget);
    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('Biometrics'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Cache & Sync'), findsOneWidget);
    expect(find.text('Privacy'), findsOneWidget);
  });

  testWidgets('tapping Server URL pushes ServerManagerPage', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.text('Server URL'));
    await tester.pumpAndSettle();

    expect(find.byType(ServerManagerPage), findsOneWidget);
  });
}
