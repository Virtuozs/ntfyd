import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';
import 'package:ntfyd/features/server_config/domain/usecases/set_default_server.dart';

class MockServerConfigRepository extends Mock
    implements ServerConfigRepository {}

void main() {
  late MockServerConfigRepository mockRepository;
  late SetDefaultServer useCase;

  setUp(() {
    mockRepository = MockServerConfigRepository();
    useCase = SetDefaultServer(mockRepository);
  });

  group('SetDefaultServer', () {
    test('calls repository.setDefault(id) and returns Success', () async {
      when(
        () => mockRepository.setDefault('srv-1'),
      ).thenAnswer((_) async => const Result.success(null));

      final result = await useCase.call('srv-1');

      expect(result.isSuccess, isTrue);
      verify(() => mockRepository.setDefault('srv-1')).called(1);
    });

    test('propagates Failure from repository.setDefault()', () async {
      when(
        () => mockRepository.setDefault('unknown-id'),
      ).thenAnswer((_) async => const Result.err(Failure.notFound()));

      final result = await useCase.call('unknown-id');

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<NotFoundFailure>());
    });
  });
}
