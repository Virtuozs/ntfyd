import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/features/feed/domain/entities/attachment.dart';
import 'package:ntfyd/features/feed/domain/entities/feed_connection_state.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';
import 'package:ntfyd/features/feed/domain/entities/ntfy_action.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_bloc.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_event.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_state.dart';
import 'package:ntfyd/features/feed/presentation/pages/message_detail_page.dart';

class MockFeedBloc extends MockBloc<FeedEvent, FeedState>
    implements FeedBloc {}

void main() {
  late MockFeedBloc bloc;

  final message = NotificationMessage(
    id: 'msg-1',
    serverId: 'srv-1',
    topic: 'security',
    time: DateTime.utc(2026, 7, 5, 12),
    event: 'message',
    title: 'Login detected',
    body: 'root via ssh',
    priority: 5,
    tags: const ['warning', 'skull'],
    attachment: const Attachment(
      name: 'log.txt',
      url: 'https://ntfy.sh/file/log.txt',
    ),
    actions: const [NtfyAction.copy(label: 'Copy IP', value: '1.2.3.4')],
    receivedAt: DateTime.utc(2026, 7, 5, 12, 0, 1),
  );

  setUpAll(() {
    registerFallbackValue(const FeedEvent.refresh());
  });

  setUp(() {
    bloc = MockFeedBloc();
    whenListen(
      bloc,
      const Stream<FeedState>.empty(),
      initialState: FeedState.loaded(
        messages: [message],
        connectionState: FeedConnectionState.live,
      ),
    );
  });

  Future<void> pumpPage(WidgetTester tester) {
    return tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<FeedBloc>.value(
          value: bloc,
          child: MessageDetailPage(message: message),
        ),
      ),
    );
  }

  testWidgets('renders title, priority chip, and tag chips', (tester) async {
    await pumpPage(tester);

    expect(find.text('Login detected'), findsOneWidget);
    expect(find.text('Priority 5'), findsOneWidget);
    expect(find.text('warning'), findsOneWidget);
    expect(find.text('skull'), findsOneWidget);
  });

  testWidgets('renders the attachment filename', (tester) async {
    await pumpPage(tester);

    expect(find.text('log.txt'), findsOneWidget);
    expect(find.byIcon(Icons.attach_file), findsOneWidget);
  });

  testWidgets('renders a disabled action button', (tester) async {
    await pumpPage(tester);

    final buttonFinder = find.widgetWithText(OutlinedButton, 'Copy IP');
    expect(buttonFinder, findsOneWidget);
    expect(tester.widget<OutlinedButton>(buttonFinder).onPressed, isNull);
  });

  testWidgets('tapping the pin icon dispatches FeedTogglePin', (
    tester,
  ) async {
    await pumpPage(tester);

    await tester.tap(find.byIcon(Icons.push_pin));

    verify(() => bloc.add(const FeedEvent.togglePin(id: 'msg-1'))).called(1);
  });

  testWidgets('tapping the check icon dispatches FeedToggleRead', (
    tester,
  ) async {
    await pumpPage(tester);

    await tester.tap(find.byIcon(Icons.check));

    verify(() => bloc.add(const FeedEvent.toggleRead(id: 'msg-1'))).called(1);
  });

  testWidgets(
    'reflects a pin toggle from bloc state, not just the constructor '
    'snapshot',
    (tester) async {
      final pinnedMessage = message.copyWith(pinned: true);

      whenListen(
        bloc,
        Stream<FeedState>.fromIterable([
          FeedState.loaded(
            messages: [pinnedMessage],
            connectionState: FeedConnectionState.live,
          ),
        ]),
        initialState: FeedState.loaded(
          messages: [message],
          connectionState: FeedConnectionState.live,
        ),
      );

      await pumpPage(tester);
      await tester.pump();

      final theme = Theme.of(tester.element(find.byType(MessageDetailPage)));
      final icon = tester.widget<Icon>(find.byIcon(Icons.push_pin));
      expect(icon.color, theme.colorScheme.error);
    },
  );
}
