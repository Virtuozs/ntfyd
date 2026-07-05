import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/network/ntfy_http_client.dart';
import 'package:ntfyd/core/secure_storage/secure_credential_vault.dart';
import 'package:ntfyd/core/secure_storage/server_credential.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/publish/data/repositories/publish_repository_impl.dart';
import 'package:ntfyd/features/publish/domain/entities/publish_draft.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';

class MockServerConfigRepository extends Mock
    implements ServerConfigRepository {}

class MockSecureCredentialVault extends Mock implements SecureCredentialVault {}

class MockNtfyHttpClient extends Mock implements NtfyHttpClient {}

void main() {
  late MockServerConfigRepository serverConfigRepository;
  late MockSecureCredentialVault vault;
  late MockNtfyHttpClient client;
  late PublishRepositoryImpl repository;

  final anonServer = ServerConfig(
    id: 'srv-1',
    baseUrl: 'https://ntfy.sh',
    displayName: 'ntfy.sh',
    authType: AuthType.none,
    isDefault: true,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  final authedServer = ServerConfig(
    id: 'srv-2',
    baseUrl: 'https://example.com',
    displayName: 'example.com',
    authType: AuthType.basic,
    credentialRef: 'srv-2',
    isDefault: false,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  setUp(() {
    serverConfigRepository = MockServerConfigRepository();
    vault = MockSecureCredentialVault();
    client = MockNtfyHttpClient();

    repository = PublishRepositoryImpl(
      serverConfigRepository,
      vault,
      clientFactory: (_, _) => client,
    );
  });

  group('publish (no attachment)', () {
    test(
      'POSTs the body with title/priority/tags/markdown/delay headers',
      () async {
        when(
          () => serverConfigRepository.getById('srv-1'),
        ).thenAnswer((_) async => Result.success(anonServer));
        when(
          () => client.post<void>(
            '/alerts',
            data: 'Backup failed',
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async =>
              Response<void>(requestOptions: RequestOptions(path: '/alerts')),
        );

        final draft = PublishDraft.validate(
          topic: 'alerts',
          body: 'Backup failed',
          title: 'NAS',
          priority: 5,
          tags: const ['warning'],
          markdown: true,
          delay: '30m',
        ).valueOrThrow;

        final result = await repository.publish('srv-1', draft);

        expect(result.isSuccess, isTrue);
        final captured = verify(
          () => client.post<void>(
            '/alerts',
            data: 'Backup failed',
            options: captureAny(named: 'options'),
          ),
        ).captured;
        final options = captured.single as Options;
        expect(options.headers?['X-Title'], 'NAS');
        expect(options.headers?['X-Priority'], '5');
        expect(options.headers?['X-Tags'], 'warning');
        expect(options.headers?['X-Markdown'], 'true');
        expect(options.headers?['X-Delay'], '30m');
      },
    );

    test(
      'retrieves credential from vault when the server has a credentialRef',
      () async {
        when(
          () => serverConfigRepository.getById('srv-2'),
        ).thenAnswer((_) async => Result.success(authedServer));
        when(() => vault.retrieve('srv-2')).thenAnswer(
          (_) async =>
              const ServerCredential.basicAuth(username: 'u', password: 'p'),
        );
        when(
          () => client.post<void>(
            any(),
            data: any<String>(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async =>
              Response<void>(requestOptions: RequestOptions(path: '/alerts')),
        );

        final draft = PublishDraft.validate(
          topic: 'alerts',
          body: 'hi',
        ).valueOrThrow;

        await repository.publish('srv-2', draft);

        verify(() => vault.retrieve('srv-2')).called(1);
      },
    );

    test('returns the mapped Failure when the HTTP call throws', () async {
      when(
        () => serverConfigRepository.getById('srv-1'),
      ).thenAnswer((_) async => Result.success(anonServer));
      when(
        () => client.post<void>(
          any(),
          data: any<String>(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/alerts'),
          type: DioExceptionType.connectionError,
        ),
      );

      final draft = PublishDraft.validate(
        topic: 'alerts',
        body: 'hi',
      ).valueOrThrow;

      final result = await repository.publish('srv-1', draft);

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<NetworkFailure>());
    });
  });

  group('publish (with attachment)', () {
    test('PUTs the file bytes with X-Filename and X-Message headers', () async {
      final tempFile =
          File(
            '${Directory.systemTemp.path}/publish_repository_impl_test_'
            '${DateTime.now().microsecondsSinceEpoch}.txt',
          )..writeAsBytesSync([1, 2, 3]);
      addTearDown(() => tempFile.deleteSync());

      when(
        () => serverConfigRepository.getById('srv-1'),
      ).thenAnswer((_) async => Result.success(anonServer));
      when(
        () => client.put<void>(
          '/alerts',
          data: any<List<int>>(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async =>
            Response<void>(requestOptions: RequestOptions(path: '/alerts')),
      );

      final draft = PublishDraft.validate(
        topic: 'alerts',
        body: 'see attached',
        attachmentPath: tempFile.path,
      ).valueOrThrow;

      final result = await repository.publish('srv-1', draft);

      expect(result.isSuccess, isTrue);
      final captured = verify(
        () => client.put<void>(
          '/alerts',
          data: captureAny<List<int>>(named: 'data'),
          options: captureAny(named: 'options'),
        ),
      ).captured;
      expect(captured[0], [1, 2, 3]);
      final options = captured[1] as Options;
      expect(options.headers?['X-Filename'], tempFile.uri.pathSegments.last);
      expect(options.headers?['X-Message'], 'see attached');
    });
  });
}
