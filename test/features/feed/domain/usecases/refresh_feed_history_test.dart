import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/feed/domain/repositories/feed_repository.dart';
import 'package:ntfyd/features/feed/domain/usecases/refresh_feed_history.dart';

class MockFeedRepository extends Mock implements FeedRepository {}

void main() {
  late MockFeedRepository repository;
  late RefreshFeedHistory useCase;

  setUp(() {
    repository = MockFeedRepository();
    useCase = RefreshFeedHistory(repository);
  });

  group('RefreshFeedHistory', () {
    test('delegates to repository.refreshHistory', () async {
      when(
        () => repository.refreshHistory('srv-1', 'alerts'),
      ).thenAnswer((_) async => const Result.success(null));

      final result = await useCase.call(
        const RefreshFeedHistoryParams(serverId: 'srv-1', topic: 'alerts'),
      );

      expect(result.isSuccess, isTrue);
      verify(() => repository.refreshHistory('srv-1', 'alerts')).called(1);
    });

    test('propagates Failure from repository', () async {
      when(() => repository.refreshHistory('srv-1', 'alerts')).thenAnswer(
        (_) async => const Result.err(Failure.network(message: 'offline')),
      );

      final result = await useCase.call(
        const RefreshFeedHistoryParams(serverId: 'srv-1', topic: 'alerts'),
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<NetworkFailure>());
    });
  });
}
