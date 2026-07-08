// test/features/settings/presentation/pages/cache_sync_settings_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/features/settings/domain/entities/app_settings.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_cubit.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_state.dart';
import 'package:ntfyd/features/settings/presentation/pages/cache_sync_settings_page.dart';

class MockSettingsCubit extends Mock implements SettingsCubit {}

void main() {
  late MockSettingsCubit cubit;

  setUp(() {
    cubit = MockSettingsCubit();
    when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => cubit.close()).thenAnswer((_) async {});
    when(() => cubit.setRetentionMaxAgeDays(any())).thenAnswer((_) async {});
    when(() => cubit.clearCache()).thenAnswer((_) async {});
  });

  Future<void> pumpPage(WidgetTester tester, AppSettings settings) async {
    when(() => cubit.state).thenReturn(SettingsState.loaded(settings));
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SettingsCubit>.value(
          value: cubit,
          child: const CacheSyncSettingsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('selecting "30 days" calls setRetentionMaxAgeDays(30)', (
    tester,
  ) async {
    await pumpPage(tester, const AppSettings(retentionMaxAgeDays: 7));

    await tester.tap(find.text('30 days'));
    await tester.pumpAndSettle();

    verify(() => cubit.setRetentionMaxAgeDays(30)).called(1);
  });

  testWidgets('selecting "Forever" calls setRetentionMaxAgeDays(null)', (
    tester,
  ) async {
    await pumpPage(tester, const AppSettings(retentionMaxAgeDays: 7));

    await tester.tap(find.text('Forever'));
    await tester.pumpAndSettle();

    verify(() => cubit.setRetentionMaxAgeDays(null)).called(1);
  });

  testWidgets('"Clear cache now" requires confirmation before calling clearCache', (
    tester,
  ) async {
    await pumpPage(tester, const AppSettings());

    await tester.tap(find.text('Clear cache now'));
    await tester.pumpAndSettle();
    verifyNever(() => cubit.clearCache());

    await tester.tap(find.text('Clear cache').last);
    await tester.pumpAndSettle();

    verify(() => cubit.clearCache()).called(1);
  });
}
