import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';
import 'package:ntfyd/features/server_config/domain/usecases/list_servers.dart';

class MockServerConfigRepository extends Mock
    implements ServerConfigRepository {}

void main() {
  late MockServerConfigRepository mockRepository;
  late ListServers useCase;

  setUp(() {
    mockRepository = MockServerConfigRepository();
    useCase = ListServers(mockRepository);
  });

  final config = ServerConfig(
    id: 'srv-1',
    baseUrl: 'https://ntfy.sh',
    displayName: 'ntfy.sh',
    authType: AuthType.none,
    credentialRef: null,
    isDefault: true,
    createdAt: DateTime(2026, 6, 8),
  );

  group('ListServers', () {
    test('returns Success with all servers from repository.getAll()', () async {
      when(
        () => mockRepository.getAll(),
      ).thenAnswer((_) async => Result.success([config]));

      final result = await useCase.call(const NoParams());

      expect(result.isSuccess, isTrue);
      expect(result.valueOrThrow, [config]);
      verify(() => mockRepository.getAll()).called(1);
    });

    test('propagates Failure from repository.getAll()', () async {
      when(() => mockRepository.getAll()).thenAnswer(
        (_) async => const Result.err(Failure.cache(message: 'db error')),
      );

      final result = await useCase.call(const NoParams());

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<CacheFailure>());
    });
  });
}
