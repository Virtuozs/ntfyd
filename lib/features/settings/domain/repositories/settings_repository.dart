import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/settings/domain/entities/app_settings.dart';

abstract class SettingsRepository {
  Stream<AppSettings> watch();

  Future<Result<AppSettings>> update(AppSettings settings);

  /// Deletes all stored messages now, regardless of the configured
  /// retention policy. Subscriptions, groups, servers, and settings are
  /// kept.
  Future<Result<void>> clearCache();

  /// Destructive reset: wipes every server, subscription, message, and
  /// group, resets settings to defaults, and deletes stored credentials.
  Future<Result<void>> clearAllData();
}
