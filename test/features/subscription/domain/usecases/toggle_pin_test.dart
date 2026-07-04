import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:ntfyd/features/subscription/domain/usecases/toggle_pin.dart';

class MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

void main() {
  late MockSubscriptionRepository repository;
  late TogglePin useCase;

  setUp(() {
    repository = MockSubscriptionRepository();
    useCase = TogglePin(repository);
  });

  group('TogglePin', () {
    test('delegates to repository.togglePin', () async {
      when(
        () => repository.togglePin('sub-1'),
      ).thenAnswer((_) async => const Result.success(null));

      final result = await useCase.call('sub-1');

      expect(result.isSuccess, isTrue);
      verify(() => repository.togglePin('sub-1')).called(1);
    });

    test('propagates Failure from repository', () async {
      when(() => repository.togglePin('sub-1')).thenAnswer(
        (_) async => const Result.err(Failure.cache(message: 'db error')),
      );

      final result = await useCase.call('sub-1');

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<CacheFailure>());
    });
  });
}
