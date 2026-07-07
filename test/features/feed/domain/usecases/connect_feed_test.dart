import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/feed/domain/entities/connection_owner.dart';
import 'package:ntfyd/features/feed/domain/repositories/feed_repository.dart';
import 'package:ntfyd/features/feed/domain/usecases/connect_feed.dart';

class MockFeedRepository extends Mock implements FeedRepository {}

void main() {
  late MockFeedRepository repository;
  late ConnectFeed useCase;

  setUp(() {
    repository = MockFeedRepository();
    useCase = ConnectFeed(repository);
  });

  group('ConnectFeed', () {
    test('delegates to repository.connect', () async {
      when(
        () => repository.connect('srv-1', 'alerts', owner: ConnectionOwner.screen),
      ).thenAnswer((_) async => const Result.success(null));

      final result = await useCase.call(
        const ConnectFeedParams(serverId: 'srv-1', topic: 'alerts'),
      );

      expect(result.isSuccess, isTrue);
      verify(() => repository.connect('srv-1', 'alerts', owner: ConnectionOwner.screen)).called(1);
    });

    test('propagates Failure from repository', () async {
      when(() => repository.connect('srv-1', 'alerts', owner: ConnectionOwner.screen)).thenAnswer(
        (_) async => const Result.err(Failure.network(message: 'offline')),
      );

      final result = await useCase.call(
        const ConnectFeedParams(serverId: 'srv-1', topic: 'alerts'),
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<NetworkFailure>());
    });
  });
}
