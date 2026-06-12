import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/database/app_database.dart' as db;
import 'package:ntfyd/core/database/daos/server_config_dao.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/secure_storage/secure_credential_vault.dart';
import 'package:ntfyd/core/secure_storage/server_credential.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/server_config/data/repositories/server_config_repository_impl.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';

class MockServerConfigDao extends Mock implements ServerConfigDao {}

class MockSecureCredentialVault extends Mock implements SecureCredentialVault {}

void main() {
  late MockServerConfigDao dao;
  late MockSecureCredentialVault vault;
  late ServerConfigRepositoryImpl repository;

  final now = DateTime.utc(2026, 1, 1);

  final anonRow = db.ServerConfig(
    id: 'srv-1',
    baseUrl: 'https://ntfy.sh',
    displayName: 'ntfy.sh',
    authType: 'none',
    credentialRef: null,
    isDefault: 1,
    createdAt: now.millisecondsSinceEpoch,
  );

  final basicRow = db.ServerConfig(
    id: 'srv-2',
    baseUrl: 'https://example.com',
    displayName: 'example.com',
    authType: 'basic',
    credentialRef: 'srv-2',
    isDefault: 0,
    createdAt: now.millisecondsSinceEpoch,
  );

  final anonConfig = ServerConfig(
    id: 'srv-1',
    baseUrl: 'https://ntfy.sh',
    displayName: 'ntfy.sh',
    authType: AuthType.none,
    credentialRef: null,
    isDefault: true,
    createdAt: now,
  );

  final basicConfig = ServerConfig(
    id: 'srv-2',
    baseUrl: 'https://example.com',
    displayName: 'example.com',
    authType: AuthType.basic,
    credentialRef: 'srv-2',
    isDefault: false,
    createdAt: now,
  );

  setUpAll(() {
    registerFallbackValue(const db.ServerConfigsCompanion());
    registerFallbackValue(const ServerCredential.noAuth());
  });

  setUp(() {
    dao = MockServerConfigDao();
    vault = MockSecureCredentialVault();
    repository = ServerConfigRepositoryImpl(dao, vault);
  });

  group('getAll', () {
    test('returns mapped list on success', () async {
      when(
        () => dao.watchAll(),
      ).thenAnswer((_) => Stream.value([anonRow, basicRow]));

      final result = await repository.getAll();

      expect(result.isSuccess, true);
      expect(result.valueOrThrow, [anonConfig, basicConfig]);
    });

    test('returns empty list when no rows', () async {
      when(() => dao.watchAll()).thenAnswer((_) => Stream.value(const []));

      final result = await repository.getAll();

      expect(result.isSuccess, true);
      expect(result.valueOrThrow, isEmpty);
    });

    test('returns Failure.cache when dao throws', () async {
      when(
        () => dao.watchAll(),
      ).thenAnswer((_) => Stream.error(Exception('db error')));

      final result = await repository.getAll();

      expect(result.isSuccess, false);
      expect(result.failureOrThrow, isA<CacheFailure>());
    });
  });

  group('getById', () {
    test('returns mapped entity when row found', () async {
      when(() => dao.findById('srv-2')).thenAnswer((_) async => basicRow);

      final result = await repository.getById('srv-2');

      expect(result.isSuccess, true);
      expect(result.valueOrThrow, basicConfig);
    });

    test('returns Failure.notFound when row absent', () async {
      when(() => dao.findById('missing')).thenAnswer((_) async => null);

      final result = await repository.getById('missing');

      expect(result.isSuccess, false);
      expect(result.failureOrThrow, isA<NotFoundFailure>());
    });

    test('returns Failure.cache when dao throws', () async {
      when(() => dao.findById('srv-1')).thenThrow(Exception('db error'));

      final result = await repository.getById('srv-1');

      expect(result.isSuccess, false);
      expect(result.failureOrThrow, isA<CacheFailure>());
    });
  });

  group('add', () {
    test(
      'stores credential then upserts row when credentialRef != null',
      () async {
        when(() => vault.store(any(), any())).thenAnswer((_) async {});
        when(() => dao.upsert(any())).thenAnswer((_) async {});

        const cred = ServerCredential.basicAuth(username: 'u', password: 'p');
        final result = await repository.add(basicConfig, cred);

        expect(result.isSuccess, true);
        verify(() => vault.store('srv-2', cred)).called(1);
        verify(() => dao.upsert(any())).called(1);
      },
    );

    test('skips vault.store when credentialRef == null', () async {
      when(() => dao.upsert(any())).thenAnswer((_) async {});

      final result = await repository.add(
        anonConfig,
        const ServerCredential.noAuth(),
      );

      expect(result.isSuccess, true);
      verifyNever(() => vault.store(any(), any()));
      verify(() => dao.upsert(any())).called(1);
    });

    test('upserts companion with correct field mapping', () async {
      when(() => dao.upsert(any())).thenAnswer((_) async {});

      await repository.add(anonConfig, const ServerCredential.noAuth());

      final captured =
          verify(() => dao.upsert(captureAny())).captured.single
              as db.ServerConfigsCompanion;
      expect(captured.id.value, 'srv-1');
      expect(captured.baseUrl.value, 'https://ntfy.sh');
      expect(captured.authType.value, 'none');
      expect(captured.isDefault.value, 1);
    });

    test('returns Failure.cache when vault.store throws', () async {
      when(() => vault.store(any(), any())).thenThrow(Exception('vault error'));

      final result = await repository.add(
        basicConfig,
        const ServerCredential.basicAuth(username: 'u', password: 'p'),
      );

      expect(result.isSuccess, false);
      expect(result.failureOrThrow, isA<CacheFailure>());
      verifyNever(() => dao.upsert(any()));
    });

    test('returns Failure.cache when dao.upsert throws', () async {
      when(() => dao.upsert(any())).thenThrow(Exception('db error'));

      final result = await repository.add(
        anonConfig,
        const ServerCredential.noAuth(),
      );

      expect(result.isSuccess, false);
      expect(result.failureOrThrow, isA<CacheFailure>());
    });
  });

  group('editCredentials', () {
    test('stores new credential when server has credentialRef', () async {
      when(() => dao.findById('srv-2')).thenAnswer((_) async => basicRow);
      when(() => vault.store(any(), any())).thenAnswer((_) async {});

      const newCred = ServerCredential.bearerToken(token: 'tk_new');
      final result = await repository.editCredentials('srv-2', newCred);

      expect(result.isSuccess, true);
      verify(() => vault.store('srv-2', newCred)).called(1);
    });

    test(
      'returns Failure.validation when server is anonymous (credentialRef == null)',
      () async {
        when(() => dao.findById('srv-1')).thenAnswer((_) async => anonRow);

        final result = await repository.editCredentials(
          'srv-1',
          const ServerCredential.basicAuth(username: 'u', password: 'p'),
        );

        expect(result.isSuccess, false);
        expect(result.failureOrThrow, isA<ValidationFailure>());
        verifyNever(() => vault.store(any(), any()));
      },
    );

    test('returns Failure.notFound when server does not exist', () async {
      when(() => dao.findById('missing')).thenAnswer((_) async => null);

      final result = await repository.editCredentials(
        'missing',
        const ServerCredential.bearerToken(token: 'tk_x'),
      );

      expect(result.isSuccess, false);
      expect(result.failureOrThrow, isA<NotFoundFailure>());
    });

    test('returns Failure.cache when vault.store throws', () async {
      when(() => dao.findById('srv-2')).thenAnswer((_) async => basicRow);
      when(() => vault.store(any(), any())).thenThrow(Exception('vault error'));

      final result = await repository.editCredentials(
        'srv-2',
        const ServerCredential.bearerToken(token: 'tk_x'),
      );

      expect(result.isSuccess, false);
      expect(result.failureOrThrow, isA<CacheFailure>());
    });
  });

  group('setDefault', () {
    test('delegates to dao.setDefault', () async {
      when(() => dao.setDefault('srv-2')).thenAnswer((_) async {});

      final result = await repository.setDefault('srv-2');

      expect(result.isSuccess, true);
      verify(() => dao.setDefault('srv-2')).called(1);
    });

    test('returns Failure.cache when dao throws', () async {
      when(() => dao.setDefault('srv-2')).thenThrow(Exception('db error'));

      final result = await repository.setDefault('srv-2');

      expect(result.isSuccess, false);
      expect(result.failureOrThrow, isA<CacheFailure>());
    });
  });

  group('remove', () {
    test('deletes vault entry and row when credentialRef != null', () async {
      when(() => dao.findById('srv-2')).thenAnswer((_) async => basicRow);
      when(() => vault.delete(any())).thenAnswer((_) async {});
      when(() => dao.deleteById(any())).thenAnswer((_) async {});

      final result = await repository.remove('srv-2');

      expect(result.isSuccess, true);
      verify(() => vault.delete('srv-2')).called(1);
      verify(() => dao.deleteById('srv-2')).called(1);
    });

    test('skips vault.delete when credentialRef == null', () async {
      when(() => dao.findById('srv-1')).thenAnswer((_) async => anonRow);
      when(() => dao.deleteById(any())).thenAnswer((_) async {});

      final result = await repository.remove('srv-1');

      expect(result.isSuccess, true);
      verifyNever(() => vault.delete(any()));
      verify(() => dao.deleteById('srv-1')).called(1);
    });

    test('returns Failure.notFound when server does not exist', () async {
      when(() => dao.findById('missing')).thenAnswer((_) async => null);

      final result = await repository.remove('missing');

      expect(result.isSuccess, false);
      expect(result.failureOrThrow, isA<NotFoundFailure>());
      verifyNever(() => dao.deleteById(any()));
    });

    test('returns Failure.cache when dao.deleteById throws', () async {
      when(() => dao.findById('srv-1')).thenAnswer((_) async => anonRow);
      when(() => dao.deleteById(any())).thenThrow(Exception('db error'));

      final result = await repository.remove('srv-1');

      expect(result.isSuccess, false);
      expect(result.failureOrThrow, isA<CacheFailure>());
    });
  });
}
