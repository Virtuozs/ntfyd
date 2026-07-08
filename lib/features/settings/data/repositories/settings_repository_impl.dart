// lib/features/settings/data/repositories/settings_repository_impl.dart
import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/database/app_database.dart';
import 'package:ntfyd/core/database/daos/message_dao.dart';
import 'package:ntfyd/core/database/daos/setting_dao.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/secure_storage/secure_credential_vault.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/settings/data/mappers/settings_mapper.dart';
import 'package:ntfyd/features/settings/domain/entities/app_settings.dart';
import 'package:ntfyd/features/settings/domain/repositories/settings_repository.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(
    this._settingDao,
    this._messageDao,
    this._appDatabase,
    this._vault,
  );

  final SettingDao _settingDao;
  final MessageDao _messageDao;
  final AppDatabase _appDatabase;
  final SecureCredentialVault _vault;

  @override
  Stream<AppSettings> watch() => _settingDao.watch().map(SettingsMapper.toDomain);

  @override
  Future<Result<AppSettings>> update(AppSettings settings) async {
    try {
      await _settingDao.updateAppSetting(SettingsMapper.toCompanion(settings));
      return Result.success(settings);
    } catch (e) {
      return Result.err(Failure.cache(message: 'Failed to update settings: $e'));
    }
  }

  @override
  Future<Result<void>> clearCache() async {
    try {
      await _messageDao.purgeByRetention(0, 0);
      return const Result.success(null);
    } catch (e) {
      return Result.err(Failure.cache(message: 'Failed to clear cache: $e'));
    }
  }

  @override
  Future<Result<void>> clearAllData() async {
    try {
      await _appDatabase.clearAllTables();
      await _vault.deleteAll();
      return const Result.success(null);
    } catch (e) {
      return Result.err(Failure.cache(message: 'Failed to clear all data: $e'));
    }
  }
}
