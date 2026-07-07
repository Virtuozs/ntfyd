import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';
import 'package:ntfyd/features/groups/presentation/blocs/group_feed_bloc.dart';
import 'package:ntfyd/features/groups/presentation/blocs/group_feed_event.dart';
import 'package:ntfyd/features/groups/presentation/blocs/group_feed_state.dart';
import 'package:ntfyd/features/groups/presentation/pages/group_feed_page.dart';

class MockGroupFeedBloc extends MockBloc<GroupFeedEvent, GroupFeedState>
    implements GroupFeedBloc {}

void main() {
  late MockGroupFeedBloc bloc;

  final now = DateTime.utc(2026, 1, 1);
  final message = NotificationMessage(
    id: 'msg-1',
    serverId: 'srv-1',
    topic: 'docker-alerts',
    time: now,
    event: 'message',
    title: 'Container restarted',
    receivedAt: now,
  );

  setUp(() {
    bloc = MockGroupFeedBloc();
  });

  Future<void> pumpPage(WidgetTester tester) {
    return tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<GroupFeedBloc>.value(
          value: bloc,
          child: const GroupFeedPage(groupId: 'grp-1', title: 'Homelab'),
        ),
      ),
    );
  }

  testWidgets('shows the title and each message with its topic as sourceLabel', (
    tester,
  ) async {
    whenListen(
      bloc,
      const Stream<GroupFeedState>.empty(),
      initialState: GroupFeedState.loaded(messages: [message]),
    );

    await pumpPage(tester);

    expect(find.text('Homelab'), findsOneWidget);
    expect(find.text('Container restarted'), findsOneWidget);
    expect(find.textContaining('docker-alerts ·'), findsOneWidget);
  });

  testWidgets('shows empty state when there are no messages', (tester) async {
    whenListen(
      bloc,
      const Stream<GroupFeedState>.empty(),
      initialState: const GroupFeedState.loaded(messages: []),
    );

    await pumpPage(tester);

    expect(find.text('No messages yet'), findsOneWidget);
  });
}
