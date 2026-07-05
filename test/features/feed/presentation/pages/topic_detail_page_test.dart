import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/features/feed/domain/entities/feed_connection_state.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_bloc.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_event.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_state.dart';
import 'package:ntfyd/features/feed/presentation/pages/topic_detail_page.dart';
import 'package:ntfyd/features/publish/presentation/cubits/publish_cubit.dart';
import 'package:ntfyd/features/publish/presentation/cubits/publish_state.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';

class MockFeedBloc extends MockBloc<FeedEvent, FeedState>
    implements FeedBloc {}

class MockPublishCubit extends MockCubit<PublishState>
    implements PublishCubit {}

void main() {
  late MockFeedBloc bloc;
  late MockPublishCubit publishCubit;

  final subscription = Subscription(
    id: 'sub-1',
    serverId: 'srv-1',
    topic: 'security',
    displayName: 'security',
    createdAt: DateTime.utc(2026, 1, 1),
  );

  final message = NotificationMessage(
    id: 'msg-1',
    serverId: 'srv-1',
    topic: 'security',
    time: DateTime.now(),
    event: 'message',
    title: 'Login detected',
    receivedAt: DateTime.now(),
  );

  setUpAll(() {
    registerFallbackValue(const FeedEvent.refresh());
  });

  setUp(() {
    bloc = MockFeedBloc();
    publishCubit = MockPublishCubit();
    whenListen(
      publishCubit,
      const Stream<PublishState>.empty(),
      initialState: const PublishState.idle(),
    );
  });

  Future<void> pumpPage(WidgetTester tester) {
    return tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<FeedBloc>.value(value: bloc),
            BlocProvider<PublishCubit>.value(value: publishCubit),
          ],
          child: TopicDetailPage(subscription: subscription),
        ),
      ),
    );
  }

  testWidgets('renders topic as the title and shows a loading spinner', (
    tester,
  ) async {
    whenListen(
      bloc,
      const Stream<FeedState>.empty(),
      initialState: const FeedState.loading(),
    );

    await pumpPage(tester);

    expect(find.text('security'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows "No messages yet" when loaded with an empty list', (
    tester,
  ) async {
    whenListen(
      bloc,
      const Stream<FeedState>.empty(),
      initialState: const FeedState.loaded(
        messages: [],
        connectionState: FeedConnectionState.live,
      ),
    );

    await pumpPage(tester);

    expect(find.text('No messages yet'), findsOneWidget);
    expect(find.text('Live'), findsOneWidget);
  });

  testWidgets(
    'renders a MessageCard per message and dispatches FeedTogglePin on tap',
    (tester) async {
      whenListen(
        bloc,
        const Stream<FeedState>.empty(),
        initialState: FeedState.loaded(
          messages: [message],
          connectionState: FeedConnectionState.live,
        ),
      );

      await pumpPage(tester);

      expect(find.text('Login detected'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.push_pin));

      verify(() => bloc.add(const FeedEvent.togglePin(id: 'msg-1'))).called(1);
    },
  );

  testWidgets('shows an error message when the state is FeedError', (
    tester,
  ) async {
    whenListen(
      bloc,
      const Stream<FeedState>.empty(),
      initialState: const FeedState.error(
        failure: Failure.network(message: 'offline'),
      ),
    );

    await pumpPage(tester);

    expect(find.textContaining('Something went wrong'), findsOneWidget);
  });

  testWidgets(
    'shows a snackbar and restores the list when a refresh fails',
    (tester) async {
      final loaded = FeedState.loaded(
        messages: [message],
        connectionState: FeedConnectionState.live,
      );
      const error = FeedState.error(
        failure: Failure.network(message: 'refresh failed'),
      );

      whenListen(
        bloc,
        Stream<FeedState>.fromIterable([error, loaded]),
        initialState: loaded,
      );

      await pumpPage(tester);
      await tester.pump();
      await tester.pump();

      expect(
        find.text('Refresh failed. Showing cached messages.'),
        findsOneWidget,
      );
      // The builder settles back on the restored FeedLoaded content rather
      // than the full-screen error message.
      expect(find.text('Login detected'), findsOneWidget);
      expect(find.textContaining('Something went wrong'), findsNothing);
    },
  );

  testWidgets('renders the composer bar', (tester) async {
    whenListen(
      bloc,
      const Stream<FeedState>.empty(),
      initialState: const FeedState.loaded(
        messages: [],
        connectionState: FeedConnectionState.live,
      ),
    );

    await pumpPage(tester);

    expect(find.text('Send'), findsOneWidget);
  });
}
