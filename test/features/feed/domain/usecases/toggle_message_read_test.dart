import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/feed/domain/repositories/feed_repository.dart';
import 'package:ntfyd/features/feed/domain/usecases/toggle_message_read.dart';

class MockFeedRepository extends Mock implements FeedRepository {}

void main() {
  late MockFeedRepository repository;
  late ToggleMessageRead useCase;

  setUp(() {
    repository = MockFeedRepository();
    useCase = ToggleMessageRead(repository);
  });

  group('ToggleMessageRead', () {
    test('delegates to repository.toggleRead', () async {
      when(
        () => repository.toggleRead('srv-1', 'msg-1'),
      ).thenAnswer((_) async => const Result.success(null));

      final result = await useCase.call(
        const ToggleMessageReadParams(serverId: 'srv-1', id: 'msg-1'),
      );

      expect(result.isSuccess, isTrue);
      verify(() => repository.toggleRead('srv-1', 'msg-1')).called(1);
    });

    test('propagates Failure from repository', () async {
      when(() => repository.toggleRead('srv-1', 'msg-1')).thenAnswer(
        (_) async => const Result.err(Failure.cache(message: 'db error')),
      );

      final result = await useCase.call(
        const ToggleMessageReadParams(serverId: 'srv-1', id: 'msg-1'),
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<CacheFailure>());
    });
  });
}
