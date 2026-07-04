import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:ntfyd/features/subscription/domain/usecases/update_priority_threshold.dart';

class MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

void main() {
  late MockSubscriptionRepository repository;
  late UpdatePriorityThreshold useCase;

  setUp(() {
    repository = MockSubscriptionRepository();
    useCase = UpdatePriorityThreshold(repository);
  });

  group('UpdatePriorityThreshold', () {
    test('delegates to repository.updatePriorityThreshold', () async {
      when(
        () => repository.updatePriorityThreshold('sub-1', 4),
      ).thenAnswer((_) async => const Result.success(null));

      final result = await useCase.call(
        const UpdatePriorityThresholdParams(
          subscriptionId: 'sub-1',
          threshold: 4,
        ),
      );

      expect(result.isSuccess, isTrue);
      verify(() => repository.updatePriorityThreshold('sub-1', 4)).called(1);
    });

    test('propagates Failure from repository', () async {
      when(() => repository.updatePriorityThreshold('sub-1', 4)).thenAnswer(
        (_) async => const Result.err(Failure.cache(message: 'db error')),
      );

      final result = await useCase.call(
        const UpdatePriorityThresholdParams(
          subscriptionId: 'sub-1',
          threshold: 4,
        ),
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<CacheFailure>());
    });
  });
}
