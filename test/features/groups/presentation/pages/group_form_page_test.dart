import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/di/injection_container.dart';
import 'package:ntfyd/features/groups/domain/entities/group.dart';
import 'package:ntfyd/features/groups/presentation/cubits/group_form_cubit.dart';
import 'package:ntfyd/features/groups/presentation/cubits/group_form_state.dart';
import 'package:ntfyd/features/groups/presentation/pages/group_form_page.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';

class MockServerConfigRepository extends Mock implements ServerConfigRepository {}

class MockSubscriptionRepository extends Mock implements SubscriptionRepository {}

class MockGroupFormCubit extends MockCubit<GroupFormState> implements GroupFormCubit {}

void main() {
  late MockServerConfigRepository serverConfigRepository;
  late MockSubscriptionRepository subscriptionRepository;
  late MockGroupFormCubit cubit;

  final server = ServerConfig(
    id: 'srv-1',
    baseUrl: 'https://ntfy.sh',
    displayName: 'ntfy.sh',
    authType: AuthType.none,
    isDefault: true,
    createdAt: DateTime.utc(2026, 1, 1),
  );
  final subscription = Subscription(
    id: 'sub-1',
    serverId: 'srv-1',
    topic: 'docker-alerts',
    displayName: 'docker-alerts',
    createdAt: DateTime.utc(2026, 1, 1),
  );

  setUp(() {
    serverConfigRepository = MockServerConfigRepository();
    subscriptionRepository = MockSubscriptionRepository();
    cubit = MockGroupFormCubit();

    when(() => serverConfigRepository.getAll()).thenAnswer(
      (_) async => Result.success([server]),
    );
    when(() => subscriptionRepository.watchAll()).thenAnswer(
      (_) => Stream.value([subscription]),
    );
    when(() => cubit.state).thenReturn(const GroupFormState.idle());
    when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
    when(
      () => cubit.submit(
        id: any(named: 'id'),
        name: any(named: 'name'),
        color: any(named: 'color'),
        members: any(named: 'members'),
        filter: any(named: 'filter'),
      ),
    ).thenAnswer((_) async {});

    getIt
      ..reset()
      ..registerFactory<ServerConfigRepository>(() => serverConfigRepository)
      ..registerFactory<SubscriptionRepository>(() => subscriptionRepository)
      ..registerFactory<GroupFormCubit>(() => cubit);
  });

  tearDown(() => getIt.reset());

  testWidgets('create mode shows an empty name field and the topic picker', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: GroupFormPage()));
    await tester.pumpAndSettle();

    expect(find.text('New Tag'), findsOneWidget);
    expect(find.text('docker-alerts'), findsOneWidget);
  });

  testWidgets('edit mode pre-fills the name field', (tester) async {
    const group = Group(id: 'grp-1', name: 'Homelab');

    await tester.pumpWidget(const MaterialApp(home: GroupFormPage(group: group)));
    await tester.pumpAndSettle();

    expect(find.text('Homelab'), findsOneWidget);
  });

  testWidgets('tapping Save calls cubit.submit with the entered name', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: GroupFormPage()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Homelab');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pump();

    verify(
      () => cubit.submit(
        id: null,
        name: 'Homelab',
        color: null,
        members: any(named: 'members'),
        filter: any(named: 'filter'),
      ),
    ).called(1);
  });

  testWidgets('pops the page once submission succeeds', (tester) async {
    final controller = StreamController<GroupFormState>();
    addTearDown(controller.close);
    whenListen(
      cubit,
      controller.stream,
      initialState: const GroupFormState.idle(),
    );

    // Push GroupFormPage onto a Navigator that already has a route to pop
    // back to (mirrors real usage: pushed from an existing screen), so
    // `Navigator.of(context).maybePop()` inside the page has somewhere to go.
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const GroupFormPage(),
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

    expect(find.byType(GroupFormPage), findsOneWidget);

    controller.add(const GroupFormState.success(group: Group(id: 'grp-1', name: 'Homelab')));
    await tester.pumpAndSettle();

    expect(find.byType(GroupFormPage), findsNothing);
  });
}
