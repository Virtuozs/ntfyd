import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:ntfyd/features/subscription/domain/usecases/subscribe_to_topic.dart';
import 'package:ntfyd/features/subscription/domain/usecases/toggle_mute.dart';
import 'package:ntfyd/features/subscription/domain/usecases/toggle_pin.dart';
import 'package:ntfyd/features/subscription/domain/usecases/unsubscribe_from_topic.dart';
import 'package:ntfyd/features/subscription/domain/usecases/update_priority_threshold.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_bloc.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_event.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_state.dart';

class MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

class MockSubscribeToTopic extends Mock implements SubscribeToTopic {}

class MockUnsubscribeFromTopic extends Mock implements UnsubscribeFromTopic {}

class MockTogglePin extends Mock implements TogglePin {}

class MockToggleMute extends Mock implements ToggleMute {}

class MockUpdatePriorityThreshold extends Mock
    implements UpdatePriorityThreshold {}

void main() {
  late MockSubscriptionRepository repository;
  late MockSubscribeToTopic subscribeToTopic;
  late MockUnsubscribeFromTopic unsubscribeFromTopic;
  late MockTogglePin togglePin;
  late MockToggleMute toggleMute;
  late MockUpdatePriorityThreshold updatePriorityThreshold;

  final now = DateTime.utc(2026, 1, 1);
  final sub1 = Subscription(
    id: 'sub-1',
    serverId: 'srv-1',
    topic: 'alerts',
    displayName: 'alerts',
    createdAt: now,
  );
  final sub2 = Subscription(
    id: 'sub-2',
    serverId: 'srv-1',
    topic: 'minecraft',
    displayName: 'minecraft',
    createdAt: now,
  );

  setUpAll(() {
    registerFallbackValue(
      const SubscribeToTopicParams(serverId: 'srv-1', topic: 'alerts'),
    );
    registerFallbackValue(
      const UnsubscribeFromTopicParams(serverId: 'srv-1', topic: 'alerts'),
    );
    registerFallbackValue(
      const UpdatePriorityThresholdParams(
        subscriptionId: 'sub-1',
        threshold: 3,
      ),
    );
  });

  setUp(() {
    repository = MockSubscriptionRepository();
    subscribeToTopic = MockSubscribeToTopic();
    unsubscribeFromTopic = MockUnsubscribeFromTopic();
    togglePin = MockTogglePin();
    toggleMute = MockToggleMute();
    updatePriorityThreshold = MockUpdatePriorityThreshold();
  });

  SubscriptionBloc buildBloc() => SubscriptionBloc(
    repository,
    subscribeToTopic,
    unsubscribeFromTopic,
    togglePin,
    toggleMute,
    updatePriorityThreshold,
  );

  group('SubscriptionBloc', () {
    blocTest<SubscriptionBloc, SubscriptionState>(
      'Load emits [loading, loaded([sub1, sub2])]',
      build: () {
        when(
          () => repository.watchByServer('srv-1'),
        ).thenAnswer((_) => Stream.value([sub1, sub2]));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const SubscriptionEvent.load(serverId: 'srv-1')),
      expect: () => [
        const SubscriptionState.loading(),
        SubscriptionState.loaded(subscriptions: [sub1, sub2]),
      ],
    );

    blocTest<SubscriptionBloc, SubscriptionState>(
      'a successful Subscribe surfaces the new row via the active '
      'watchByServer stream (Option A: repository stream is single source)',
      build: () {
        final controller = StreamController<List<Subscription>>();
        addTearDown(controller.close);
        when(
          () => repository.watchByServer('srv-1'),
        ).thenAnswer((_) => controller.stream);
        when(
          () => subscribeToTopic.call(any()),
        ).thenAnswer((_) async => Result.success(sub1));
        controller.add(const []);
        controller.add([sub1]);
        return buildBloc();
      },
      act: (bloc) async {
        bloc.add(const SubscriptionEvent.load(serverId: 'srv-1'));
        await Future<void>.delayed(Duration.zero);
        bloc.add(
          const SubscriptionEvent.subscribe(
            serverId: 'srv-1',
            topic: 'alerts',
          ),
        );
      },
      expect: () => [
        const SubscriptionState.loading(),
        const SubscriptionState.loaded(subscriptions: []),
        SubscriptionState.loaded(subscriptions: [sub1]),
      ],
    );

    blocTest<SubscriptionBloc, SubscriptionState>(
      'Subscribe on AuthFailure emits authError',
      build: () {
        when(
          () => subscribeToTopic.call(any()),
        ).thenAnswer(
          (_) async => const Result.err(Failure.auth(statusCode: 401)),
        );
        return buildBloc();
      },
      seed: () => const SubscriptionState.loaded(subscriptions: []),
      act: (bloc) => bloc.add(
        const SubscriptionEvent.subscribe(serverId: 'srv-1', topic: 'alerts'),
      ),
      expect: () => [
        const SubscriptionState.authError(
          failure: Failure.auth(statusCode: 401),
        ),
      ],
    );

    blocTest<SubscriptionBloc, SubscriptionState>(
      'TogglePin failure emits error state',
      build: () {
        when(() => togglePin.call('sub-1')).thenAnswer(
          (_) async => const Result.err(Failure.cache(message: 'db error')),
        );
        return buildBloc();
      },
      seed: () => const SubscriptionState.loaded(subscriptions: []),
      act: (bloc) => bloc.add(const SubscriptionEvent.togglePin(id: 'sub-1')),
      expect: () => [isA<SubscriptionError>()],
    );

    blocTest<SubscriptionBloc, SubscriptionState>(
      'ToggleMute failure emits error state',
      build: () {
        when(() => toggleMute.call('sub-1')).thenAnswer(
          (_) async => const Result.err(Failure.cache(message: 'db error')),
        );
        return buildBloc();
      },
      seed: () => const SubscriptionState.loaded(subscriptions: []),
      act: (bloc) => bloc.add(const SubscriptionEvent.toggleMute(id: 'sub-1')),
      expect: () => [isA<SubscriptionError>()],
    );

    blocTest<SubscriptionBloc, SubscriptionState>(
      'UpdateThreshold failure emits error state',
      build: () {
        when(
          () => updatePriorityThreshold.call(
            const UpdatePriorityThresholdParams(
              subscriptionId: 'sub-1',
              threshold: 4,
            ),
          ),
        ).thenAnswer(
          (_) async => const Result.err(Failure.cache(message: 'db error')),
        );
        return buildBloc();
      },
      seed: () => const SubscriptionState.loaded(subscriptions: []),
      act: (bloc) => bloc.add(
        const SubscriptionEvent.updateThreshold(id: 'sub-1', threshold: 4),
      ),
      expect: () => [isA<SubscriptionError>()],
    );

    blocTest<SubscriptionBloc, SubscriptionState>(
      'Unsubscribe failure emits error state',
      build: () {
        when(
          () => unsubscribeFromTopic.call(
            const UnsubscribeFromTopicParams(
              serverId: 'srv-1',
              topic: 'alerts',
            ),
          ),
        ).thenAnswer(
          (_) async => const Result.err(Failure.cache(message: 'db error')),
        );
        return buildBloc();
      },
      seed: () => const SubscriptionState.loaded(subscriptions: []),
      act: (bloc) => bloc.add(
        const SubscriptionEvent.unsubscribe(serverId: 'srv-1', topic: 'alerts'),
      ),
      expect: () => [isA<SubscriptionError>()],
    );

    test('SubscriptionState.when() is exhaustive (sanity check)', () {
      const state = SubscriptionState.loaded(subscriptions: []);
      expect(
        state.when(
          loading: () => 0,
          loaded: (_) => 1,
          authError: (_) => 2,
          error: (_) => 3,
        ),
        1,
      );
    });
  });
}
