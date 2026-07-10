import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/settings/domain/entities/app_settings.dart';
import 'package:ntfyd/features/settings/domain/repositories/settings_repository.dart';
import 'package:ntfyd/features/settings/domain/usecases/clear_all_data.dart';
import 'package:ntfyd/features/settings/domain/usecases/clear_cache.dart';
import 'package:ntfyd/features/settings/domain/usecases/update_settings.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_cubit.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_state.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

class MockUpdateSettings extends Mock implements UpdateSettings {}

class MockClearCache extends Mock implements ClearCache {}

class MockClearAllData extends Mock implements ClearAllData {}

void main() {
  late MockSettingsRepository repository;
  late MockUpdateSettings updateSettings;
  late MockClearCache clearCache;
  late MockClearAllData clearAllData;
  late StreamController<AppSettings> settingsController;

  const loaded = AppSettings(themeMode: AppThemeMode.white);

  setUpAll(() {
    registerFallbackValue(const UpdateSettingsParams(settings: AppSettings()));
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    repository = MockSettingsRepository();
    updateSettings = MockUpdateSettings();
    clearCache = MockClearCache();
    clearAllData = MockClearAllData();
    settingsController = StreamController<AppSettings>.broadcast();

    when(() => repository.watch()).thenAnswer((_) => settingsController.stream);
  });

  tearDown(() async {
    await settingsController.close();
  });

  SettingsCubit buildCubit() =>
      SettingsCubit(repository, updateSettings, clearCache, clearAllData);

  blocTest<SettingsCubit, SettingsState>(
    'starts in loading state',
    build: buildCubit,
    verify: (cubit) => expect(cubit.state, const SettingsState.loading()),
  );

  blocTest<SettingsCubit, SettingsState>(
    'load() emits loaded(settings) from the repository stream',
    build: buildCubit,
    act: (cubit) async {
      cubit.load();
      await Future<void>.delayed(Duration.zero);
      settingsController.add(loaded);
    },
    expect: () => [const SettingsState.loaded(loaded)],
  );

  blocTest<SettingsCubit, SettingsState>(
    'setThemeMode calls UpdateSettings with the copied settings',
    build: buildCubit,
    seed: () => const SettingsState.loaded(loaded),
    act: (cubit) async {
      when(() => updateSettings.call(any())).thenAnswer(
        (_) async => const Result.success(loaded),
      );
      await cubit.setThemeMode(AppThemeMode.materialYou);
    },
    verify: (_) {
      verify(
        () => updateSettings.call(
          const UpdateSettingsParams(
            settings: AppSettings(themeMode: AppThemeMode.materialYou),
          ),
        ),
      ).called(1);
    },
  );

  blocTest<SettingsCubit, SettingsState>(
    'setThemeMode is a no-op while still loading',
    build: buildCubit,
    act: (cubit) => cubit.setThemeMode(AppThemeMode.white),
    verify: (_) => verifyNever(() => updateSettings.call(any())),
  );

  blocTest<SettingsCubit, SettingsState>(
    'setPriorityThreshold calls UpdateSettings with the copied settings',
    build: buildCubit,
    seed: () => const SettingsState.loaded(loaded),
    act: (cubit) async {
      when(() => updateSettings.call(any())).thenAnswer(
        (_) async => const Result.success(loaded),
      );
      await cubit.setPriorityThreshold(4);
    },
    verify: (_) {
      verify(
        () => updateSettings.call(
          UpdateSettingsParams(settings: loaded.copyWith(priorityThreshold: 4)),
        ),
      ).called(1);
    },
  );

  blocTest<SettingsCubit, SettingsState>(
    'clearCache delegates to the ClearCache use case',
    build: buildCubit,
    act: (cubit) async {
      when(() => clearCache.call(const NoParams())).thenAnswer(
        (_) async => const Result.success(null),
      );
      await cubit.clearCache();
    },
    verify: (_) => verify(() => clearCache.call(const NoParams())).called(1),
  );

  blocTest<SettingsCubit, SettingsState>(
    'clearAllData emits dataCleared and it is not overwritten by a late stream event',
    build: buildCubit,
    act: (cubit) async {
      cubit.load();
      await Future<void>.delayed(Duration.zero);
      when(() => clearAllData.call(const NoParams())).thenAnswer(
        (_) async => const Result.success(null),
      );
      await cubit.clearAllData();
      // Simulate the reactive stream still firing after clearAllData().
      settingsController.add(const AppSettings());
      await Future<void>.delayed(Duration.zero);
    },
    expect: () => [const SettingsState.dataCleared()],
  );
}
