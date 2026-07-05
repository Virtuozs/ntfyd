import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/feed/domain/repositories/feed_repository.dart';
import 'package:ntfyd/features/feed/domain/usecases/disconnect_feed.dart';

class MockFeedRepository extends Mock implements FeedRepository {}

void main() {
  late MockFeedRepository repository;
  late DisconnectFeed useCase;

  setUp(() {
    repository = MockFeedRepository();
    useCase = DisconnectFeed(repository);
  });

  group('DisconnectFeed', () {
    test('delegates to repository.disconnect', () async {
      when(
        () => repository.disconnect('srv-1', 'alerts'),
      ).thenAnswer((_) async => const Result.success(null));

      final result = await useCase.call(
        const DisconnectFeedParams(serverId: 'srv-1', topic: 'alerts'),
      );

      expect(result.isSuccess, isTrue);
      verify(() => repository.disconnect('srv-1', 'alerts')).called(1);
    });

    test('propagates Failure from repository', () async {
      when(() => repository.disconnect('srv-1', 'alerts')).thenAnswer(
        (_) async => const Result.err(Failure.cache(message: 'db error')),
      );

      final result = await useCase.call(
        const DisconnectFeedParams(serverId: 'srv-1', topic: 'alerts'),
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<CacheFailure>());
    });
  });
}
