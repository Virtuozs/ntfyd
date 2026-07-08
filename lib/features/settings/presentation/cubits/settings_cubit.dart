import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/settings/domain/entities/app_settings.dart';
import 'package:ntfyd/features/settings/domain/repositories/settings_repository.dart';
import 'package:ntfyd/features/settings/domain/usecases/clear_all_data.dart';
import 'package:ntfyd/features/settings/domain/usecases/clear_cache.dart';
import 'package:ntfyd/features/settings/domain/usecases/update_settings.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_state.dart';

/// Single cubit backing every Settings sub-page. Setters are
/// fire-and-forget: [SettingsRepository.watch]'s active subscription
/// re-delivers the persisted row, so no setter manually emits.
@injectable
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(
    this._repository,
    this._updateSettings,
    this._clearCache,
    this._clearAllData,
  ) : super(const SettingsState.loading());

  final SettingsRepository _repository;
  final UpdateSettings _updateSettings;
  final ClearCache _clearCache;
  final ClearAllData _clearAllData;

  StreamSubscription<AppSettings>? _subscription;

  void load() {
    unawaited(_subscription?.cancel());
    _subscription = _repository.watch().listen(
      (settings) => emit(SettingsState.loaded(settings)),
    );
  }

  Future<void> _update(AppSettings Function(AppSettings current) transform) async {
    final current = state;
    if (current is! SettingsLoaded) return;
    await _updateSettings.call(
      UpdateSettingsParams(settings: transform(current.settings)),
    );
  }

  Future<void> setThemeMode(AppThemeMode mode) =>
      _update((s) => s.copyWith(themeMode: mode));

  Future<void> setQuietHours({
    required bool enabled,
    String? start,
    String? end,
  }) => _update(
    (s) => s.copyWith(
      quietHoursEnabled: enabled,
      quietHoursStart: start,
      quietHoursEnd: end,
    ),
  );

  Future<void> setRetentionMaxAgeDays(int? days) =>
      _update((s) => s.copyWith(retentionMaxAgeDays: days));

  Future<void> setHideLockScreenContent(bool value) =>
      _update((s) => s.copyWith(hideLockScreenContent: value));

  Future<void> setAnalyticsOptOut(bool value) =>
      _update((s) => s.copyWith(analyticsOptOut: value));

  Future<void> setBiometricLock(bool value) =>
      _update((s) => s.copyWith(biometricLock: value));

  Future<void> clearCache() async {
    await _clearCache.call(const NoParams());
  }

  Future<void> clearAllData() async {
    await _clearAllData.call(const NoParams());
    await _subscription?.cancel();
    _subscription = null;
    emit(const SettingsState.dataCleared());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
