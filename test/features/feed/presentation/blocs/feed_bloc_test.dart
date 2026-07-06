import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/feed/domain/entities/feed_connection_state.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';
import 'package:ntfyd/features/feed/domain/repositories/feed_repository.dart';
import 'package:ntfyd/features/feed/domain/usecases/connect_feed.dart';
import 'package:ntfyd/features/feed/domain/usecases/disconnect_feed.dart';
import 'package:ntfyd/features/feed/domain/usecases/refresh_feed_history.dart';
import 'package:ntfyd/features/feed/domain/usecases/toggle_message_pin.dart';
import 'package:ntfyd/features/feed/domain/usecases/toggle_message_read.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_bloc.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_event.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_state.dart';
import 'package:ntfyd/features/notifications/presentation/currently_viewed_topic.dart';

class MockFeedRepository extends Mock implements FeedRepository {}

class MockConnectFeed extends Mock implements ConnectFeed {}

class MockDisconnectFeed extends Mock implements DisconnectFeed {}

class MockRefreshFeedHistory extends Mock implements RefreshFeedHistory {}

class MockToggleMessageRead extends Mock implements ToggleMessageRead {}

class MockToggleMessagePin extends Mock implements ToggleMessagePin {}

void main() {
  late MockFeedRepository repository;
  late MockConnectFeed connectFeed;
  late MockDisconnectFeed disconnectFeed;
  late MockRefreshFeedHistory refreshFeedHistory;
  late MockToggleMessageRead toggleMessageRead;
  late MockToggleMessagePin toggleMessagePin;
  late CurrentlyViewedTopic currentlyViewedTopic;

  late StreamController<List<NotificationMessage>> messagesController;
  late StreamController<FeedConnectionState> connectionController;

  final now = DateTime.utc(2026, 1, 1);
  final message = NotificationMessage(
    id: 'msg-1',
    serverId: 'srv-1',
    topic: 'alerts',
    time: now,
    event: 'message',
    receivedAt: now,
  );

  setUpAll(() {
    registerFallbackValue(
      const ConnectFeedParams(serverId: 'srv-1', topic: 'alerts'),
    );
    registerFallbackValue(
      const DisconnectFeedParams(serverId: 'srv-1', topic: 'alerts'),
    );
    registerFallbackValue(
      const RefreshFeedHistoryParams(serverId: 'srv-1', topic: 'alerts'),
    );
    registerFallbackValue(
      const ToggleMessageReadParams(serverId: 'srv-1', id: 'msg-1'),
    );
    registerFallbackValue(
      const ToggleMessagePinParams(serverId: 'srv-1', id: 'msg-1'),
    );
  });

  setUp(() {
    repository = MockFeedRepository();
    connectFeed = MockConnectFeed();
    disconnectFeed = MockDisconnectFeed();
    refreshFeedHistory = MockRefreshFeedHistory();
    toggleMessageRead = MockToggleMessageRead();
    toggleMessagePin = MockToggleMessagePin();
    currentlyViewedTopic = CurrentlyViewedTopic();

    messagesController =
        StreamController<List<NotificationMessage>>.broadcast();
    connectionController = StreamController<FeedConnectionState>.broadcast();

    when(
      () => repository.watchMessages('srv-1', 'alerts'),
    ).thenAnswer((_) => messagesController.stream);
    when(
      () => repository.watchConnectionState('srv-1', 'alerts'),
    ).thenAnswer((_) => connectionController.stream);
    // bloc_test's testBloc() always calls bloc.close() after act(), and
    // FeedBloc.close() calls DisconnectFeed whenever a FeedLoad has set
    // _serverId/_topic — stub a default success here so every test's
    // implicit teardown close() has a matching stub, regardless of
    // whether that test's own build() cares about disconnect.
    when(
      () => disconnectFeed.call(any()),
    ).thenAnswer((_) async => const Result.success(null));
  });

  tearDown(() async {
    await messagesController.close();
    await connectionController.close();
  });

  FeedBloc buildBloc() => FeedBloc(
    repository,
    connectFeed,
    disconnectFeed,
    refreshFeedHistory,
    toggleMessageRead,
    toggleMessagePin,
    currentlyViewedTopic,
  );

  group('FeedLoad', () {
    blocTest<FeedBloc, FeedState>(
      'emits loading then error when ConnectFeed fails',
      build: () {
        when(() => connectFeed.call(any())).thenAnswer(
          (_) async => const Result.err(Failure.network(message: 'offline')),
        );
        return buildBloc();
      },
      act: (bloc) =>
          bloc.add(const FeedEvent.load(serverId: 'srv-1', topic: 'alerts')),
      expect: () => [const FeedState.loading(), isA<FeedError>()],
    );

    blocTest<FeedBloc, FeedState>(
      'emits loading then loaded once messages/connection streams emit',
      build: () {
        when(
          () => connectFeed.call(any()),
        ).thenAnswer((_) async => const Result.success(null));
        return buildBloc();
      },
      act: (bloc) async {
        bloc.add(const FeedEvent.load(serverId: 'srv-1', topic: 'alerts'));
        await Future<void>.delayed(Duration.zero);
        messagesController.add([message]);
        connectionController.add(FeedConnectionState.live);
      },
      expect: () => [
        const FeedState.loading(),
        FeedState.loaded(
          messages: [message],
          connectionState: FeedConnectionState.live,
        ),
      ],
    );
  });

  group('FeedRefresh', () {
    blocTest<FeedBloc, FeedState>(
      'calls RefreshFeedHistory with the loaded serverId/topic',
      build: () {
        when(
          () => connectFeed.call(any()),
        ).thenAnswer((_) async => const Result.success(null));
        when(
          () => refreshFeedHistory.call(any()),
        ).thenAnswer((_) async => const Result.success(null));
        return buildBloc();
      },
      act: (bloc) async {
        bloc.add(const FeedEvent.load(serverId: 'srv-1', topic: 'alerts'));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const FeedEvent.refresh());
        await Future<void>.delayed(Duration.zero);
      },
      verify: (_) {
        verify(
          () => refreshFeedHistory.call(
            const RefreshFeedHistoryParams(
              serverId: 'srv-1',
              topic: 'alerts',
            ),
          ),
        ).called(1);
      },
    );

    blocTest<FeedBloc, FeedState>(
      'restores the previous FeedLoaded state after a failed refresh, '
      'transiently surfacing the error',
      build: () {
        when(
          () => connectFeed.call(any()),
        ).thenAnswer((_) async => const Result.success(null));
        when(() => refreshFeedHistory.call(any())).thenAnswer(
          (_) async =>
              const Result.err(Failure.network(message: 'refresh failed')),
        );
        return buildBloc();
      },
      act: (bloc) async {
        bloc.add(const FeedEvent.load(serverId: 'srv-1', topic: 'alerts'));
        await Future<void>.delayed(Duration.zero);
        messagesController.add([message]);
        connectionController.add(FeedConnectionState.live);
        await Future<void>.delayed(Duration.zero);
        bloc.add(const FeedEvent.refresh());
        await Future<void>.delayed(Duration.zero);
      },
      expect: () => [
        const FeedState.loading(),
        FeedState.loaded(
          messages: [message],
          connectionState: FeedConnectionState.live,
        ),
        isA<FeedError>(),
        FeedState.loaded(
          messages: [message],
          connectionState: FeedConnectionState.live,
        ),
      ],
    );

    blocTest<FeedBloc, FeedState>(
      'stays in error when refresh fails before the initial load completes',
      build: () {
        when(
          () => connectFeed.call(any()),
        ).thenAnswer((_) async => const Result.success(null));
        when(() => refreshFeedHistory.call(any())).thenAnswer(
          (_) async =>
              const Result.err(Failure.network(message: 'refresh failed')),
        );
        return buildBloc();
      },
      act: (bloc) async {
        bloc.add(const FeedEvent.load(serverId: 'srv-1', topic: 'alerts'));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const FeedEvent.refresh());
        await Future<void>.delayed(Duration.zero);
      },
      expect: () => [const FeedState.loading(), isA<FeedError>()],
    );
  });

  group('FeedToggleRead / FeedTogglePin', () {
    blocTest<FeedBloc, FeedState>(
      'FeedToggleRead calls ToggleMessageRead with the loaded serverId',
      build: () {
        when(
          () => connectFeed.call(any()),
        ).thenAnswer((_) async => const Result.success(null));
        when(
          () => toggleMessageRead.call(any()),
        ).thenAnswer((_) async => const Result.success(null));
        return buildBloc();
      },
      act: (bloc) async {
        bloc.add(const FeedEvent.load(serverId: 'srv-1', topic: 'alerts'));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const FeedEvent.toggleRead(id: 'msg-1'));
        await Future<void>.delayed(Duration.zero);
      },
      verify: (_) {
        verify(
          () => toggleMessageRead.call(
            const ToggleMessageReadParams(serverId: 'srv-1', id: 'msg-1'),
          ),
        ).called(1);
      },
    );

    blocTest<FeedBloc, FeedState>(
      'FeedTogglePin calls ToggleMessagePin with the loaded serverId',
      build: () {
        when(
          () => connectFeed.call(any()),
        ).thenAnswer((_) async => const Result.success(null));
        when(
          () => toggleMessagePin.call(any()),
        ).thenAnswer((_) async => const Result.success(null));
        return buildBloc();
      },
      act: (bloc) async {
        bloc.add(const FeedEvent.load(serverId: 'srv-1', topic: 'alerts'));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const FeedEvent.togglePin(id: 'msg-1'));
        await Future<void>.delayed(Duration.zero);
      },
      verify: (_) {
        verify(
          () => toggleMessagePin.call(
            const ToggleMessagePinParams(serverId: 'srv-1', id: 'msg-1'),
          ),
        ).called(1);
      },
    );
  });

  group('close', () {
    test('disconnects the loaded serverId/topic on close', () async {
      when(
        () => connectFeed.call(any()),
      ).thenAnswer((_) async => const Result.success(null));
      when(
        () => disconnectFeed.call(any()),
      ).thenAnswer((_) async => const Result.success(null));

      final bloc = buildBloc();
      bloc.add(const FeedEvent.load(serverId: 'srv-1', topic: 'alerts'));
      await Future<void>.delayed(Duration.zero);

      await bloc.close();

      verify(
        () => disconnectFeed.call(
          const DisconnectFeedParams(serverId: 'srv-1', topic: 'alerts'),
        ),
      ).called(1);
    });

    test('does not call DisconnectFeed when never loaded', () async {
      final bloc = buildBloc();

      await bloc.close();

      verifyNever(() => disconnectFeed.call(any()));
    });
  });

  group('CurrentlyViewedTopic wiring', () {
    // Plain `test()` (not `blocTest`) — `blocTest`'s harness always calls
    // `bloc.close()` internally before running `verify`, which would clear
    // `currentlyViewedTopic` before this assertion could see it set. Manual
    // control over `close()` timing (as in the `close` group above) is
    // needed to observe both pre-close and post-close state.
    test('records the topic as currently viewed on load', () async {
      when(
        () => connectFeed.call(any()),
      ).thenAnswer((_) async => const Result.success(null));

      final bloc = buildBloc();
      bloc.add(const FeedEvent.load(serverId: 'srv-1', topic: 'alerts'));
      await Future<void>.delayed(Duration.zero);

      expect(
        currentlyViewedTopic.current,
        equals((serverId: 'srv-1', topic: 'alerts')),
      );

      await bloc.close();
    });

    test('clears the currently-viewed topic on close', () async {
      when(
        () => connectFeed.call(any()),
      ).thenAnswer((_) async => const Result.success(null));

      final bloc = buildBloc();
      bloc.add(const FeedEvent.load(serverId: 'srv-1', topic: 'alerts'));
      await Future<void>.delayed(Duration.zero);

      await bloc.close();

      expect(currentlyViewedTopic.current, isNull);
    });
  });
}
