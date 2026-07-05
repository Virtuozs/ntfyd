import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/publish/domain/entities/publish_draft.dart';
import 'package:ntfyd/features/publish/domain/usecases/publish_message.dart';
import 'package:ntfyd/features/publish/presentation/cubits/publish_cubit.dart';
import 'package:ntfyd/features/publish/presentation/cubits/publish_state.dart';

class MockPublishMessage extends Mock implements PublishMessage {}

void main() {
  late MockPublishMessage publishMessage;

  final draft = PublishDraft.validate(
    topic: 'alerts',
    body: 'hi',
  ).valueOrThrow;

  setUpAll(() {
    registerFallbackValue(
      PublishMessageParams(serverId: 'srv-1', draft: draft),
    );
  });

  setUp(() {
    publishMessage = MockPublishMessage();
  });

  PublishCubit buildCubit() => PublishCubit(publishMessage);

  blocTest<PublishCubit, PublishState>(
    'emits submitting then success on a successful publish',
    build: () {
      when(
        () => publishMessage.call(any()),
      ).thenAnswer((_) async => const Result.success(null));
      return buildCubit();
    },
    act: (cubit) => cubit.submit('srv-1', draft),
    expect: () => [
      const PublishState.submitting(),
      const PublishState.success(),
    ],
  );

  blocTest<PublishCubit, PublishState>(
    'emits submitting then error on failure',
    build: () {
      when(() => publishMessage.call(any())).thenAnswer(
        (_) async => const Result.err(Failure.network(message: 'offline')),
      );
      return buildCubit();
    },
    act: (cubit) => cubit.submit('srv-1', draft),
    expect: () => [const PublishState.submitting(), isA<PublishError>()],
  );

  blocTest<PublishCubit, PublishState>(
    'reset() returns to idle',
    build: () {
      when(
        () => publishMessage.call(any()),
      ).thenAnswer((_) async => const Result.success(null));
      return buildCubit();
    },
    act: (cubit) async {
      await cubit.submit('srv-1', draft);
      cubit.reset();
    },
    expect: () => [
      const PublishState.submitting(),
      const PublishState.success(),
      const PublishState.idle(),
    ],
  );
}
