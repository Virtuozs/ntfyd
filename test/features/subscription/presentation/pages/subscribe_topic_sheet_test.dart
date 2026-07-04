import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/presentation/pages/server_manager_page.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_bloc.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_event.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_state.dart';
import 'package:ntfyd/features/subscription/presentation/pages/subscribe_topic_sheet.dart';

class MockSubscriptionBloc
    extends MockBloc<SubscriptionEvent, SubscriptionState>
    implements SubscriptionBloc {}

void main() {
  late MockSubscriptionBloc bloc;

  final servers = [
    ServerConfig(
      id: 'srv-1',
      baseUrl: 'https://ntfy.sh',
      displayName: 'ntfy.sh',
      authType: AuthType.none,
      isDefault: true,
      createdAt: DateTime.utc(2026, 1, 1),
    ),
    ServerConfig(
      id: 'srv-2',
      baseUrl: 'https://home.example.com',
      displayName: 'Homelab',
      authType: AuthType.basic,
      credentialRef: 'srv-2',
      isDefault: false,
      createdAt: DateTime.utc(2026, 1, 1),
    ),
  ];

  setUpAll(() {
    registerFallbackValue(const SubscriptionEvent.load(serverId: 'srv-1'));
  });

  setUp(() {
    bloc = MockSubscriptionBloc();
    whenListen(
      bloc,
      const Stream<SubscriptionState>.empty(),
      initialState: const SubscriptionState.loaded(subscriptions: []),
    );
  });

  Future<void> pumpSheet(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<SubscriptionBloc>.value(
            value: bloc,
            child: SubscribeTopicSheet(servers: servers),
          ),
        ),
      ),
    );
  }

  testWidgets('renders server picker with server names', (tester) async {
    await pumpSheet(tester);

    expect(find.text('ntfy.sh'), findsOneWidget);
    expect(find.byType(DropdownButtonFormField<ServerConfig>), findsOneWidget);
  });

  testWidgets('tapping Subscribe dispatches Subscribe event', (tester) async {
    await pumpSheet(tester);

    await tester.enterText(find.byType(TextField).at(0), 'alerts');
    await tester.tap(find.widgetWithText(FilledButton, 'Subscribe'));
    await tester.pump();

    verify(
      () => bloc.add(
        const SubscriptionEvent.subscribe(serverId: 'srv-1', topic: 'alerts'),
      ),
    ).called(1);
  });

  testWidgets('dispatches load for the initially selected server on open', (
    tester,
  ) async {
    await pumpSheet(tester);

    verify(
      () => bloc.add(const SubscriptionEvent.load(serverId: 'srv-1')),
    ).called(1);
  });

  testWidgets(
    'shows confirmation and pops the sheet once the subscribed topic '
    'appears in a loaded state, but not on the initial loaded emission',
    (tester) async {
      final controller = StreamController<SubscriptionState>();
      addTearDown(controller.close);
      whenListen(
        bloc,
        controller.stream,
        initialState: const SubscriptionState.loading(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    builder: (_) => BlocProvider<SubscriptionBloc>.value(
                      value: bloc,
                      child: SubscribeTopicSheet(servers: servers),
                    ),
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.byType(SubscribeTopicSheet), findsOneWidget);

      // Simulate the real load's initial emission from watchByServer.
      // This must NOT be mistaken for a successful submission.
      controller.add(const SubscriptionState.loaded(subscriptions: []));
      await tester.pump();

      expect(find.text('Subscribed to alerts'), findsNothing);
      expect(find.byType(SubscribeTopicSheet), findsOneWidget);

      await tester.enterText(find.byType(TextField).at(0), 'alerts');
      await tester.tap(find.widgetWithText(FilledButton, 'Subscribe'));
      await tester.pump();

      // Simulate the DB write becoming visible on the watchByServer stream.
      controller.add(
        SubscriptionState.loaded(
          subscriptions: [
            Subscription(
              id: 'sub-1',
              serverId: 'srv-1',
              topic: 'alerts',
              displayName: 'alerts',
              createdAt: DateTime.utc(2026, 1, 1),
            ),
          ],
        ),
      );
      await tester.pump();

      expect(find.text('Subscribed to alerts'), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.byType(SubscribeTopicSheet), findsNothing);
    },
  );

  testWidgets('authError state shows Edit Credentials button', (
    tester,
  ) async {
    whenListen(
      bloc,
      const Stream<SubscriptionState>.empty(),
      initialState: const SubscriptionState.authError(
        failure: Failure.auth(statusCode: 401),
      ),
    );

    await pumpSheet(tester);

    expect(find.text('Invalid credentials'), findsOneWidget);
    expect(
      find.widgetWithText(OutlinedButton, 'Edit Credentials'),
      findsOneWidget,
    );

    await tester.tap(find.widgetWithText(OutlinedButton, 'Edit Credentials'));
    await tester.pumpAndSettle();

    expect(find.byType(ServerManagerPage), findsOneWidget);
  });
}
