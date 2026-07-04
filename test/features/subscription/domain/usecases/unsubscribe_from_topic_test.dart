import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:ntfyd/features/subscription/domain/usecases/unsubscribe_from_topic.dart';

class MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

void main() {
  late MockSubscriptionRepository repository;
  late UnsubscribeFromTopic useCase;

  setUp(() {
    repository = MockSubscriptionRepository();
    useCase = UnsubscribeFromTopic(repository);
  });

  group('UnsubscribeFromTopic', () {
    test(
      'delegates to repository.unsubscribe and returns its result',
      () async {
        when(
          () => repository.unsubscribe('srv-1', 'alerts'),
        ).thenAnswer((_) async => const Result.success(null));

        final result = await useCase.call(
          const UnsubscribeFromTopicParams(serverId: 'srv-1', topic: 'alerts'),
        );

        expect(result.isSuccess, isTrue);
        verify(() => repository.unsubscribe('srv-1', 'alerts')).called(1);
      },
    );

    test('propagates Failure from repository.unsubscribe', () async {
      when(() => repository.unsubscribe('srv-1', 'alerts')).thenAnswer(
        (_) async => const Result.err(Failure.cache(message: 'db error')),
      );

      final result = await useCase.call(
        const UnsubscribeFromTopicParams(serverId: 'srv-1', topic: 'alerts'),
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<CacheFailure>());
    });
  });
}
