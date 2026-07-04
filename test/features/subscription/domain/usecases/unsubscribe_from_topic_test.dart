import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/database/daos/message_dao.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:ntfyd/features/subscription/domain/usecases/unsubscribe_from_topic.dart';

class MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

class MockMessageDao extends Mock implements MessageDao {}

void main() {
  late MockSubscriptionRepository repository;
  late MockMessageDao messageDao;
  late UnsubscribeFromTopic useCase;

  setUp(() {
    repository = MockSubscriptionRepository();
    messageDao = MockMessageDao();
    useCase = UnsubscribeFromTopic(repository, messageDao);
  });

  group('UnsubscribeFromTopic', () {
    test('clears messages then unsubscribes', () async {
      when(
        () => messageDao.clearByTopic('srv-1', 'alerts'),
      ).thenAnswer((_) async {});
      when(
        () => repository.unsubscribe('srv-1', 'alerts'),
      ).thenAnswer((_) async => const Result.success(null));

      final result = await useCase.call(
        const UnsubscribeFromTopicParams(serverId: 'srv-1', topic: 'alerts'),
      );

      expect(result.isSuccess, isTrue);
      verifyInOrder([
        () => messageDao.clearByTopic('srv-1', 'alerts'),
        () => repository.unsubscribe('srv-1', 'alerts'),
      ]);
    });

    test('propagates Failure from repository.unsubscribe', () async {
      when(
        () => messageDao.clearByTopic('srv-1', 'alerts'),
      ).thenAnswer((_) async {});
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
