import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/di/injection_container.dart';
import 'package:ntfyd/features/feed/presentation/cubits/group_selector_cubit.dart';
import 'package:ntfyd/features/feed/presentation/cubits/group_selector_state.dart';
import 'package:ntfyd/features/groups/domain/entities/group.dart';
import 'package:ntfyd/features/groups/domain/entities/group_membership.dart';
import 'package:ntfyd/features/groups/presentation/cubits/group_form_cubit.dart';
import 'package:ntfyd/features/groups/presentation/cubits/group_form_state.dart';
import 'package:ntfyd/features/groups/presentation/pages/group_form_page.dart';
import 'package:ntfyd/features/groups/presentation/widgets/topic_tags_sheet.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';

class MockGroupSelectorCubit extends MockCubit<GroupSelectorState>
    implements GroupSelectorCubit {}

class MockGroupFormCubit extends MockCubit<GroupFormState>
    implements GroupFormCubit {}

class MockServerConfigRepository extends Mock
    implements ServerConfigRepository {}

class MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

void main() {
  late MockGroupSelectorCubit cubit;
  late MockGroupFormCubit groupFormCubit;
  late MockServerConfigRepository serverConfigRepository;
  late MockSubscriptionRepository subscriptionRepository;

  final subscription = Subscription(
    id: 'sub-1',
    serverId: 'srv-1',
    topic: 'alerts',
    displayName: 'alerts',
    createdAt: DateTime.utc(2026, 1, 1),
  );
  const membership = GroupMembership(serverId: 'srv-1', topic: 'alerts');
  final homelab = Group(id: 'grp-1', name: 'Homelab', color: 0xFF0000FF);
  final work = Group(id: 'grp-2', name: 'Work', members: {membership});

  setUpAll(() {
    registerFallbackValue(homelab);
    registerFallbackValue(membership);
  });

  setUp(() {
    cubit = MockGroupSelectorCubit();
    groupFormCubit = MockGroupFormCubit();
    serverConfigRepository = MockServerConfigRepository();
    subscriptionRepository = MockSubscriptionRepository();

    when(() => groupFormCubit.state).thenReturn(const GroupFormState.idle());
    when(() => groupFormCubit.stream).thenAnswer((_) => const Stream.empty());
    when(
      () => serverConfigRepository.getAll(),
    ).thenAnswer((_) async => const Result.success([]));
    when(
      () => subscriptionRepository.watchAll(),
    ).thenAnswer((_) => Stream.value(const []));
    when(() => cubit.toggleMembership(any(), any())).thenAnswer((_) async {});

    getIt
      ..reset()
      ..registerFactory<GroupFormCubit>(() => groupFormCubit)
      ..registerFactory<ServerConfigRepository>(() => serverConfigRepository)
      ..registerFactory<SubscriptionRepository>(() => subscriptionRepository);
  });

  tearDown(() => getIt.reset());

  Future<void> pumpSheet(WidgetTester tester) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<GroupSelectorCubit>.value(
            value: cubit,
            child: TopicTagsSheet(subscription: subscription),
          ),
        ),
      ),
    );
  }

  testWidgets('shows a checkbox per group, checked when already a member', (
    tester,
  ) async {
    when(
      () => cubit.state,
    ).thenReturn(GroupSelectorState(groups: [homelab, work]));

    await pumpSheet(tester);

    final homelabTile = tester.widget<CheckboxListTile>(
      find.widgetWithText(CheckboxListTile, 'Homelab'),
    );
    final workTile = tester.widget<CheckboxListTile>(
      find.widgetWithText(CheckboxListTile, 'Work'),
    );
    expect(homelabTile.value, isFalse);
    expect(workTile.value, isTrue);
  });

  testWidgets(
    'tapping an unchecked group calls toggleMembership and keeps the sheet open',
    (tester) async {
      when(() => cubit.state).thenReturn(GroupSelectorState(groups: [homelab]));

      await pumpSheet(tester);
      await tester.tap(find.widgetWithText(CheckboxListTile, 'Homelab'));
      await tester.pumpAndSettle();

      verify(() => cubit.toggleMembership(homelab, membership)).called(1);
      expect(find.byType(TopicTagsSheet), findsOneWidget);
    },
  );

  testWidgets('tapping New Tag pops the sheet and opens GroupFormPage', (
    tester,
  ) async {
    when(() => cubit.state).thenReturn(const GroupSelectorState());

    await pumpSheet(tester);
    await tester.tap(find.text('New Tag'));
    await tester.pumpAndSettle();

    expect(find.byType(GroupFormPage), findsOneWidget);
  });
}
