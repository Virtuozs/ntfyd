import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ntfyd/features/settings/domain/entities/app_settings.dart';

part 'settings_state.freezed.dart';

@freezed
sealed class SettingsState with _$SettingsState {
  const factory SettingsState.loading() = SettingsLoading;

  const factory SettingsState.loaded(AppSettings settings) = SettingsLoaded;

  /// One-shot: emitted after a successful `clearAllData()`. The Privacy
  /// page listens for this to navigate back to first-run login.
  const factory SettingsState.dataCleared() = SettingsDataCleared;
}
