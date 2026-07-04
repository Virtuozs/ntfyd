import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/secure_storage/secure_credential_vault.dart';
import 'package:ntfyd/core/secure_storage/server_credential.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/server_config/data/datasources/account_data_source.dart';
import 'package:ntfyd/features/server_config/data/models/account_dto.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:ntfyd/features/subscription/domain/usecases/subscribe_to_topic.dart';

class MockServerConfigRepository extends Mock
    implements ServerConfigRepository {}

class MockSecureCredentialVault extends Mock implements SecureCredentialVault {}

class MockAccountDataSource extends Mock implements AccountDataSource {}

class MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

void main() {
  late MockServerConfigRepository serverConfigRepository;
  late MockSecureCredentialVault vault;
  late MockAccountDataSource accountDataSource;
  late MockSubscriptionRepository subscriptionRepository;
  late SubscribeToTopic useCase;

  const fixedId = 'sub-11111111-1111-1111-1111-111111111111';
  final fixedNow = DateTime.utc(2026, 6, 8);

  final anonServer = ServerConfig(
    id: 'srv-1',
    baseUrl: 'https://ntfy.sh',
    displayName: 'ntfy.sh',
    authType: AuthType.none,
    isDefault: true,
    createdAt: fixedNow,
  );

  final basicServer = ServerConfig(
    id: 'srv-2',
    baseUrl: 'https://example.com',
    displayName: 'example.com',
    authType: AuthType.basic,
    credentialRef: 'srv-2',
    isDefault: false,
    createdAt: fixedNow,
  );

  setUpAll(() {
    registerFallbackValue(
      Subscription(
        id: fixedId,
        serverId: 'srv-1',
        topic: 'alerts',
        displayName: 'alerts',
        createdAt: fixedNow,
      ),
    );
    registerFallbackValue(const ServerCredential.noAuth());
  });

  setUp(() {
    serverConfigRepository = MockServerConfigRepository();
    vault = MockSecureCredentialVault();
    accountDataSource = MockAccountDataSource();
    subscriptionRepository = MockSubscriptionRepository();

    SubscribeToTopicTestHooks.idGenerator = () => fixedId;
    SubscribeToTopicTestHooks.now = () => fixedNow;

    useCase = SubscribeToTopic(
      serverConfigRepository,
      vault,
      accountDataSource,
      subscriptionRepository,
    );
  });

  tearDown(() {
    SubscribeToTopicTestHooks.idGenerator = null;
    SubscribeToTopicTestHooks.now = null;
  });

  group('SubscribeToTopic', () {
    test(
      'persists subscription when account check succeeds (anonymous server)',
      () async {
        when(
          () => serverConfigRepository.getById('srv-1'),
        ).thenAnswer((_) async => Result.success(anonServer));
        when(
          () => accountDataSource.getAccount(
            'https://ntfy.sh',
            const ServerCredential.noAuth(),
          ),
        ).thenAnswer(
          (_) async => const AccountDto(username: '', role: 'anonymous'),
        );
        when(() => subscriptionRepository.subscribe(any())).thenAnswer(
          (invocation) async =>
              Result.success(invocation.positionalArguments[0] as Subscription),
        );

        final result = await useCase.call(
          const SubscribeToTopicParams(serverId: 'srv-1', topic: 'alerts'),
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrThrow.topic, 'alerts');
        expect(result.valueOrThrow.id, fixedId);
        verifyNever(() => vault.retrieve(any()));
      },
    );

    test('retrieves credential from vault when server has a credentialRef', () async {
      when(
        () => serverConfigRepository.getById('srv-2'),
      ).thenAnswer((_) async => Result.success(basicServer));
      when(() => vault.retrieve('srv-2')).thenAnswer(
        (_) async =>
            const ServerCredential.basicAuth(username: 'u', password: 'p'),
      );
      when(
        () => accountDataSource.getAccount(
          'https://example.com',
          const ServerCredential.basicAuth(username: 'u', password: 'p'),
        ),
      ).thenAnswer((_) async => const AccountDto(username: 'u', role: 'user'));
      when(() => subscriptionRepository.subscribe(any())).thenAnswer(
        (invocation) async =>
            Result.success(invocation.positionalArguments[0] as Subscription),
      );

      final result = await useCase.call(
        const SubscribeToTopicParams(serverId: 'srv-2', topic: 'alerts'),
      );

      expect(result.isSuccess, isTrue);
      verify(() => vault.retrieve('srv-2')).called(1);
    });

    test('returns AuthFailure on 401 without persisting', () async {
      when(
        () => serverConfigRepository.getById('srv-2'),
      ).thenAnswer((_) async => Result.success(basicServer));
      when(() => vault.retrieve('srv-2')).thenAnswer(
        (_) async =>
            const ServerCredential.basicAuth(username: 'u', password: 'wrong'),
      );
      when(() => accountDataSource.getAccount(any(), any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/v1/account'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/v1/account'),
            statusCode: 401,
          ),
        ),
      );

      final result = await useCase.call(
        const SubscribeToTopicParams(serverId: 'srv-2', topic: 'alerts'),
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<AuthFailure>());
      verifyNever(() => subscriptionRepository.subscribe(any()));
    });

    test('returns AuthFailure on 403 without persisting', () async {
      when(
        () => serverConfigRepository.getById('srv-2'),
      ).thenAnswer((_) async => Result.success(basicServer));
      when(() => vault.retrieve('srv-2')).thenAnswer(
        (_) async =>
            const ServerCredential.basicAuth(username: 'u', password: 'p'),
      );
      when(() => accountDataSource.getAccount(any(), any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/v1/account'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/v1/account'),
            statusCode: 403,
          ),
        ),
      );

      final result = await useCase.call(
        const SubscribeToTopicParams(serverId: 'srv-2', topic: 'alerts'),
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<AuthFailure>());
      verifyNever(() => subscriptionRepository.subscribe(any()));
    });

    test('returns NetworkFailure when server unreachable', () async {
      when(
        () => serverConfigRepository.getById('srv-1'),
      ).thenAnswer((_) async => Result.success(anonServer));
      when(() => accountDataSource.getAccount(any(), any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/v1/account'),
          type: DioExceptionType.connectionError,
          error: 'Connection refused',
        ),
      );

      final result = await useCase.call(
        const SubscribeToTopicParams(serverId: 'srv-1', topic: 'alerts'),
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<NetworkFailure>());
    });

    test(
      'returns ValidationFailure for empty topic without persisting',
      () async {
        when(
          () => serverConfigRepository.getById('srv-1'),
        ).thenAnswer((_) async => Result.success(anonServer));
        when(() => accountDataSource.getAccount(any(), any())).thenAnswer(
          (_) async => const AccountDto(username: '', role: 'anonymous'),
        );

        final result = await useCase.call(
          const SubscribeToTopicParams(serverId: 'srv-1', topic: ''),
        );

        expect(result.isSuccess, isFalse);
        expect(result.failureOrThrow, isA<ValidationFailure>());
        verifyNever(() => subscriptionRepository.subscribe(any()));
      },
    );
  });
}
