import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/secure_storage/server_credential.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';
import 'package:ntfyd/features/server_config/domain/usecases/edit_credentials.dart';

class MockServerConfigRepository extends Mock
    implements ServerConfigRepository {}

void main() {
  late MockServerConfigRepository mockRepository;
  late EditCredentials useCase;

  setUpAll(() {
    registerFallbackValue(const ServerCredential.noAuth());
  });

  setUp(() {
    mockRepository = MockServerConfigRepository();
    useCase = EditCredentials(mockRepository);
  });

  group('EditCredentials', () {
    test('calls repository.editCredentials(id, credential) and returns '
        'Success', () async {
      const credential = ServerCredential.basicAuth(
        username: 'user',
        password: 'newpass',
      );
      when(
        () => mockRepository.editCredentials('srv-1', credential),
      ).thenAnswer((_) async => const Result.success(null));

      final result = await useCase.call(
        const EditCredentialsParams(serverId: 'srv-1', credential: credential),
      );

      expect(result.isSuccess, isTrue);
      verify(
        () => mockRepository.editCredentials('srv-1', credential),
      ).called(1);
    });

    test('propagates Failure from repository.editCredentials()', () async {
      const credential = ServerCredential.noAuth();
      when(
        () => mockRepository.editCredentials('unknown-id', credential),
      ).thenAnswer((_) async => const Result.err(Failure.notFound()));

      final result = await useCase.call(
        const EditCredentialsParams(
          serverId: 'unknown-id',
          credential: credential,
        ),
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<NotFoundFailure>());
    });
  });
}
