import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/feed/domain/repositories/feed_repository.dart';
import 'package:ntfyd/features/feed/domain/usecases/toggle_message_pin.dart';

class MockFeedRepository extends Mock implements FeedRepository {}

void main() {
  late MockFeedRepository repository;
  late ToggleMessagePin useCase;

  setUp(() {
    repository = MockFeedRepository();
    useCase = ToggleMessagePin(repository);
  });

  group('ToggleMessagePin', () {
    test('delegates to repository.togglePin', () async {
      when(
        () => repository.togglePin('srv-1', 'msg-1'),
      ).thenAnswer((_) async => const Result.success(null));

      final result = await useCase.call(
        const ToggleMessagePinParams(serverId: 'srv-1', id: 'msg-1'),
      );

      expect(result.isSuccess, isTrue);
      verify(() => repository.togglePin('srv-1', 'msg-1')).called(1);
    });

    test('propagates Failure from repository', () async {
      when(() => repository.togglePin('srv-1', 'msg-1')).thenAnswer(
        (_) async => const Result.err(Failure.cache(message: 'db error')),
      );

      final result = await useCase.call(
        const ToggleMessagePinParams(serverId: 'srv-1', id: 'msg-1'),
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<CacheFailure>());
    });
  });
}
