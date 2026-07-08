import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:ntfyd/core/database/app_database.dart';
import 'package:ntfyd/core/database/daos/group_dao.dart';
import 'package:ntfyd/core/database/daos/message_dao.dart';
import 'package:ntfyd/core/database/daos/server_config_dao.dart';
import 'package:ntfyd/core/database/daos/setting_dao.dart';
import 'package:ntfyd/core/database/daos/subscription_dao.dart';
import 'package:ntfyd/core/secure_storage/flutter_secure_credential_vault.dart';
import 'package:ntfyd/core/secure_storage/secure_credential_vault.dart';

/// Core, cross-feature dependencies: database and secure storage.
@module
abstract class CoreModule {
  /// Singleton on-disk Drift database. Tests should bypass this module
  /// and construct AppDatabase(NativeDatabase.memory()) directly.
  @lazySingleton
  AppDatabase get appDatabase => AppDatabase();

  /// Drift auto-generates this getter on [AppDatabase]; exposing it as
  /// its own provider lets DAOs be injected directly into repositories.
  @lazySingleton
  ServerConfigDao serverConfigDao(AppDatabase db) => db.serverConfigDao;

  @lazySingleton
  SubscriptionDao subscriptionDao(AppDatabase db) => db.subscriptionDao;

  @lazySingleton
  MessageDao messageDao(AppDatabase db) => db.messageDao;

  @lazySingleton
  SettingDao settingDao(AppDatabase db) => db.settingDao;

  @lazySingleton
  GroupDao groupDao(AppDatabase db) => db.groupDao;

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @lazySingleton
  LocalAuthentication get localAuthentication => LocalAuthentication();

  @LazySingleton(as: SecureCredentialVault)
  FlutterSecureCredentialVault secureCredentialVault(
    FlutterSecureStorage storage,
  ) => FlutterSecureCredentialVault(storage);
}
