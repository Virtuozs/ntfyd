import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/secure_storage/server_credential.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/server_config/data/datasources/health_data_source.dart';
import 'package:ntfyd/features/server_config/data/models/health_dto.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';
import 'package:ntfyd/features/server_config/domain/usecases/add_server.dart';
import 'package:ntfyd/features/server_config/domain/usecases/validate_server_health.dart';

class MockServerConfigRepository extends Mock
    implements ServerConfigRepository {}

class MockHealthDataSource extends Mock implements HealthDataSource {}

void main() {
  late MockServerConfigRepository mockRepository;
  late MockHealthDataSource mockHealthDataSource;
  late ValidateServerHealth validateServerHealth;
  late AddServer useCase;

  const fixedId = '11111111-1111-1111-1111-111111111111';
  final fixedNow = DateTime(2026, 6, 8);

  setUpAll(() {
    registerFallbackValue(
      ServerConfig(
        id: fixedId,
        baseUrl: 'https://ntfy.sh',
        displayName: 'ntfy.sh',
        authType: AuthType.none,
        credentialRef: null,
        isDefault: true,
        createdAt: fixedNow,
      ),
    );
    registerFallbackValue(const ServerCredential.noAuth());
  });

  setUp(() {
    mockRepository = MockServerConfigRepository();
    mockHealthDataSource = MockHealthDataSource();
    validateServerHealth = ValidateServerHealth(mockHealthDataSource);

    AddServerTestHooks.idGenerator = () => fixedId;
    AddServerTestHooks.now = () => fixedNow;

    useCase = AddServer(mockRepository, validateServerHealth);
  });

  tearDown(() {
    AddServerTestHooks.idGenerator = null;
    AddServerTestHooks.now = null;
  });

  group('AddServer', () {
    test(
      'sets isDefault=true and calls repository.add when no servers exist',
      () async {
        when(
          () => mockRepository.getAll(),
        ).thenAnswer((_) async => const Result.success([]));
        when(
          () => mockHealthDataSource.checkHealth(any()),
        ).thenAnswer((_) async => const HealthDto(healthy: true));
        when(
          () => mockRepository.add(any(), any()),
        ).thenAnswer((_) async => const Result.success(null));

        const params = AddServerParams(
          baseUrl: 'https://ntfy.sh',
          authType: AuthType.none,
          credential: ServerCredential.noAuth(),
        );

        final result = await useCase.call(params);

        expect(result.isSuccess, isTrue);
        final captured = verify(
          () => mockRepository.add(captureAny(), captureAny()),
        ).captured;
        final addedConfig = captured[0] as ServerConfig;
        final addedCred = captured[1] as ServerCredential;

        expect(addedConfig.isDefault, isTrue);
        expect(addedConfig.id, fixedId);
        expect(addedConfig.baseUrl, 'https://ntfy.sh');
        expect(addedConfig.displayName, 'ntfy.sh');
        expect(addedConfig.authType, AuthType.none);
        expect(addedConfig.credentialRef, isNull);
        expect(addedConfig.createdAt, fixedNow);
        expect(addedCred, const ServerCredential.noAuth());
      },
    );

    test(
      'sets isDefault=false and calls repository.add when servers already exist',
      () async {
        final existing = ServerConfig(
          id: 'existing-id',
          baseUrl: 'https://existing.example.com',
          displayName: 'existing.example.com',
          authType: AuthType.none,
          credentialRef: null,
          isDefault: true,
          createdAt: fixedNow,
        );
        when(
          () => mockRepository.getAll(),
        ).thenAnswer((_) async => Result.success([existing]));
        when(
          () => mockHealthDataSource.checkHealth(any()),
        ).thenAnswer((_) async => const HealthDto(healthy: true));
        when(
          () => mockRepository.add(any(), any()),
        ).thenAnswer((_) async => const Result.success(null));

        const params = AddServerParams(
          baseUrl: 'https://ntfy.sh',
          authType: AuthType.none,
          credential: ServerCredential.noAuth(),
        );

        final result = await useCase.call(params);

        expect(result.isSuccess, isTrue);
        final captured = verify(
          () => mockRepository.add(captureAny(), captureAny()),
        ).captured;
        final addedConfig = captured[0] as ServerConfig;

        expect(addedConfig.isDefault, isFalse);
      },
    );

    test(
      'returns ValidationFailure for invalid baseUrl without calling health check or repository.add',
      () async {
        when(
          () => mockRepository.getAll(),
        ).thenAnswer((_) async => const Result.success([]));

        const params = AddServerParams(
          baseUrl: 'ftp://example.com',
          authType: AuthType.none,
          credential: ServerCredential.noAuth(),
        );

        final result = await useCase.call(params);

        // assert
        expect(result.isSuccess, isFalse);
        expect(result.failureOrThrow, isA<ValidationFailure>());
        verifyNever(() => mockHealthDataSource.checkHealth(any()));
        verifyNever(() => mockRepository.add(any(), any()));
      },
    );

    test(
      'returns NetworkFailure when health check fails and does not call repository.add',
      () async {
        when(
          () => mockRepository.getAll(),
        ).thenAnswer((_) async => const Result.success([]));
        when(() => mockHealthDataSource.checkHealth(any())).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/v1/health'),
            type: DioExceptionType.connectionError,
            error: 'Connection refused',
          ),
        );

        const params = AddServerParams(
          baseUrl: 'https://unreachable.example.com',
          authType: AuthType.none,
          credential: ServerCredential.noAuth(),
        );

        final result = await useCase.call(params);

        expect(result.isSuccess, isFalse);
        expect(result.failureOrThrow, isA<NetworkFailure>());
        verifyNever(() => mockRepository.add(any(), any()));
      },
    );

    test(
      'sets credentialRef equal to generated id when authType is basic',
      () async {
        when(
          () => mockRepository.getAll(),
        ).thenAnswer((_) async => const Result.success([]));
        when(
          () => mockHealthDataSource.checkHealth(any()),
        ).thenAnswer((_) async => const HealthDto(healthy: true));
        when(
          () => mockRepository.add(any(), any()),
        ).thenAnswer((_) async => const Result.success(null));

        const params = AddServerParams(
          baseUrl: 'https://selfhosted.example.com',
          authType: AuthType.basic,
          credential: ServerCredential.basicAuth(
            username: 'user',
            password: 'pass',
          ),
        );

        final result = await useCase.call(params);

        expect(result.isSuccess, isTrue);
        final captured = verify(
          () => mockRepository.add(captureAny(), captureAny()),
        ).captured;
        final addedConfig = captured[0] as ServerConfig;

        expect(addedConfig.credentialRef, fixedId);
      },
    );
  });
}
