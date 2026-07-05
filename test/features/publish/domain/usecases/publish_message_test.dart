import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/publish/domain/entities/publish_draft.dart';
import 'package:ntfyd/features/publish/domain/repositories/publish_repository.dart';
import 'package:ntfyd/features/publish/domain/usecases/publish_message.dart';

class MockPublishRepository extends Mock implements PublishRepository {}

void main() {
  late MockPublishRepository repository;
  late PublishMessage useCase;

  final draft = PublishDraft.validate(
    topic: 'alerts',
    body: 'hello',
  ).valueOrThrow;

  setUpAll(() {
    registerFallbackValue(draft);
  });

  setUp(() {
    repository = MockPublishRepository();
    useCase = PublishMessage(repository);
  });

  group('PublishMessage', () {
    test('delegates to repository.publish', () async {
      when(
        () => repository.publish('srv-1', draft),
      ).thenAnswer((_) async => const Result.success(null));

      final result = await useCase.call(
        PublishMessageParams(serverId: 'srv-1', draft: draft),
      );

      expect(result.isSuccess, isTrue);
      verify(() => repository.publish('srv-1', draft)).called(1);
    });

    test('propagates Failure from repository', () async {
      when(() => repository.publish('srv-1', draft)).thenAnswer(
        (_) async => const Result.err(Failure.network(message: 'offline')),
      );

      final result = await useCase.call(
        PublishMessageParams(serverId: 'srv-1', draft: draft),
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<NetworkFailure>());
    });
  });
}
