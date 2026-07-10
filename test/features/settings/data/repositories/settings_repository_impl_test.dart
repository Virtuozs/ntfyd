// test/features/settings/data/repositories/settings_repository_impl_test.dart
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/database/app_database.dart' as db;
import 'package:ntfyd/core/database/daos/message_dao.dart';
import 'package:ntfyd/core/database/daos/setting_dao.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/secure_storage/secure_credential_vault.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:ntfyd/features/settings/domain/entities/app_settings.dart';

class MockSettingDao extends Mock implements SettingDao {}

class MockMessageDao extends Mock implements MessageDao {}

class MockAppDatabase extends Mock implements db.AppDatabase {}

class MockSecureCredentialVault extends Mock implements SecureCredentialVault {}

void main() {
  late MockSettingDao settingDao;
  late MockMessageDao messageDao;
  late MockAppDatabase appDatabase;
  late MockSecureCredentialVault vault;
  late SettingsRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(const db.AppSettingsCompanion());
  });

  setUp(() {
    settingDao = MockSettingDao();
    messageDao = MockMessageDao();
    appDatabase = MockAppDatabase();
    vault = MockSecureCredentialVault();
    repository = SettingsRepositoryImpl(settingDao, messageDao, appDatabase, vault);
  });

  group('watch', () {
    test('maps every dao row to a domain AppSettings', () async {
      final row = db.AppSetting(
        id: 1,
        themeMode: 'white',
        quietHoursEnabled: 0,
        priorityThreshold: 1,
        hideLockScreenContent: 0,
        analyticsOptOut: 0,
        biometricLock: 0,
      );
      when(() => settingDao.watch()).thenAnswer((_) => Stream.value(row));

      final result = await repository.watch().first;

      expect(result.themeMode, AppThemeMode.white);
    });
  });

  group('update', () {
    test('writes via settingDao and returns Success(settings)', () async {
      when(() => settingDao.updateAppSetting(any())).thenAnswer((_) async {});
      const settings = AppSettings(themeMode: AppThemeMode.materialYou);

      final result = await repository.update(settings);

      expect(result.isSuccess, isTrue);
      expect(result.valueOrThrow, settings);
      verify(() => settingDao.updateAppSetting(any())).called(1);
    });

    test('returns Failure.cache when settingDao throws', () async {
      when(() => settingDao.updateAppSetting(any())).thenThrow(Exception('db error'));

      final result = await repository.update(const AppSettings());

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<CacheFailure>());
    });
  });

  group('clearCache', () {
    test('calls messageDao.purgeByRetention(0, 0) unconditionally', () async {
      when(() => messageDao.purgeByRetention(0, 0)).thenAnswer((_) async {});

      final result = await repository.clearCache();

      expect(result.isSuccess, isTrue);
      verify(() => messageDao.purgeByRetention(0, 0)).called(1);
    });

    test('returns Failure.cache when messageDao throws', () async {
      when(() => messageDao.purgeByRetention(0, 0)).thenThrow(Exception('db error'));

      final result = await repository.clearCache();

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<CacheFailure>());
    });
  });

  group('clearAllData', () {
    test('clears all tables then deletes credentials, in that order', () async {
      when(() => appDatabase.clearAllTables()).thenAnswer((_) async {});
      when(() => vault.deleteAll()).thenAnswer((_) async {});

      final result = await repository.clearAllData();

      expect(result.isSuccess, isTrue);
      verifyInOrder([
        () => appDatabase.clearAllTables(),
        () => vault.deleteAll(),
      ]);
    });

    test('returns Failure.cache when clearAllTables throws', () async {
      when(() => appDatabase.clearAllTables()).thenThrow(Exception('db error'));

      final result = await repository.clearAllData();

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<CacheFailure>());
      verifyNever(() => vault.deleteAll());
    });
  });
}
