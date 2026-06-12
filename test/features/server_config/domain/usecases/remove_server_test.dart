import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';
import 'package:ntfyd/features/server_config/domain/usecases/remove_server.dart';

class MockServerConfigRepository extends Mock
    implements ServerConfigRepository {}

void main() {
  late MockServerConfigRepository mockRepository;
  late RemoveServer useCase;

  final fixedNow = DateTime(2026, 6, 8);

  setUp(() {
    mockRepository = MockServerConfigRepository();
    useCase = RemoveServer(mockRepository);
  });

  ServerConfig buildConfig({required String id, required bool isDefault}) {
    return ServerConfig(
      id: id,
      baseUrl: 'https://example-$id.com',
      displayName: 'example-$id.com',
      authType: AuthType.none,
      credentialRef: null,
      isDefault: isDefault,
      createdAt: fixedNow,
    );
  }

  group('RemoveServer', () {
    test('removes a non-default server without reassigning default', () async {
      final defaultServer = buildConfig(id: 'srv-default', isDefault: true);
      final targetServer = buildConfig(id: 'srv-target', isDefault: false);

      when(
        () => mockRepository.getAll(),
      ).thenAnswer((_) async => Result.success([defaultServer, targetServer]));
      when(
        () => mockRepository.remove('srv-target'),
      ).thenAnswer((_) async => const Result.success(null));

      final result = await useCase.call('srv-target');

      expect(result.isSuccess, isTrue);
      verify(() => mockRepository.remove('srv-target')).called(1);
      verifyNever(() => mockRepository.setDefault(any()));
    });

    test('removes the default server and reassigns default to the first '
        'remaining server', () async {
      final targetServer = buildConfig(id: 'srv-default', isDefault: true);
      final remaining1 = buildConfig(id: 'srv-remaining-1', isDefault: false);
      final remaining2 = buildConfig(id: 'srv-remaining-2', isDefault: false);

      when(() => mockRepository.getAll()).thenAnswer(
        (_) async => Result.success([targetServer, remaining1, remaining2]),
      );
      when(
        () => mockRepository.remove('srv-default'),
      ).thenAnswer((_) async => const Result.success(null));
      when(
        () => mockRepository.setDefault('srv-remaining-1'),
      ).thenAnswer((_) async => const Result.success(null));

      final result = await useCase.call('srv-default');

      expect(result.isSuccess, isTrue);
      verify(() => mockRepository.remove('srv-default')).called(1);
      verify(() => mockRepository.setDefault('srv-remaining-1')).called(1);
    });

    test('removes the only (default) server without calling setDefault '
        'when no servers remain', () async {
      final targetServer = buildConfig(id: 'srv-only', isDefault: true);

      when(
        () => mockRepository.getAll(),
      ).thenAnswer((_) async => Result.success([targetServer]));
      when(
        () => mockRepository.remove('srv-only'),
      ).thenAnswer((_) async => const Result.success(null));

      final result = await useCase.call('srv-only');

      expect(result.isSuccess, isTrue);
      verify(() => mockRepository.remove('srv-only')).called(1);
      verifyNever(() => mockRepository.setDefault(any()));
    });

    test('propagates Failure from repository.getAll()', () async {
      when(() => mockRepository.getAll()).thenAnswer(
        (_) async => const Result.err(Failure.cache(message: 'db error')),
      );

      final result = await useCase.call('srv-1');

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<CacheFailure>());
      verifyNever(() => mockRepository.remove(any()));
    });

    test('propagates Failure from repository.remove()', () async {
      final targetServer = buildConfig(id: 'srv-target', isDefault: false);
      when(
        () => mockRepository.getAll(),
      ).thenAnswer((_) async => Result.success([targetServer]));
      when(
        () => mockRepository.remove('srv-target'),
      ).thenAnswer((_) async => const Result.err(Failure.notFound()));

      final result = await useCase.call('srv-target');

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<NotFoundFailure>());
      verifyNever(() => mockRepository.setDefault(any()));
    });
  });
}
