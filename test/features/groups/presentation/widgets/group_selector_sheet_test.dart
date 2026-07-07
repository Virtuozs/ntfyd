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
import 'package:ntfyd/features/groups/presentation/cubits/group_form_cubit.dart';
import 'package:ntfyd/features/groups/presentation/cubits/group_form_state.dart';
import 'package:ntfyd/features/groups/presentation/pages/group_form_page.dart';
import 'package:ntfyd/features/groups/presentation/widgets/group_selector_sheet.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';

class MockGroupSelectorCubit extends MockCubit<GroupSelectorState>
    implements GroupSelectorCubit {}

class MockGroupFormCubit extends MockCubit<GroupFormState> implements GroupFormCubit {}

class MockServerConfigRepository extends Mock implements ServerConfigRepository {}

class MockSubscriptionRepository extends Mock implements SubscriptionRepository {}

void main() {
  late MockGroupSelectorCubit cubit;
  late MockGroupFormCubit groupFormCubit;
  late MockServerConfigRepository serverConfigRepository;
  late MockSubscriptionRepository subscriptionRepository;

  final homelab = Group(id: 'grp-1', name: 'Homelab', color: 0xFF0000FF);

  setUp(() {
    cubit = MockGroupSelectorCubit();
    groupFormCubit = MockGroupFormCubit();
    serverConfigRepository = MockServerConfigRepository();
    subscriptionRepository = MockSubscriptionRepository();

    when(() => groupFormCubit.state).thenReturn(const GroupFormState.idle());
    when(() => groupFormCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => serverConfigRepository.getAll()).thenAnswer(
      (_) async => const Result.success([]),
    );
    when(() => subscriptionRepository.watchAll()).thenAnswer(
      (_) => Stream.value(const []),
    );

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
            child: const GroupSelectorSheet(),
          ),
        ),
      ),
    );
  }

  testWidgets('shows All plus each group, and a New Tag entry', (tester) async {
    when(() => cubit.state).thenReturn(GroupSelectorState(groups: [homelab]));

    await pumpSheet(tester);

    expect(find.text('All'), findsOneWidget);
    expect(find.text('Homelab'), findsOneWidget);
    expect(find.text('New Tag'), findsOneWidget);
  });

  testWidgets('tapping All selects null and closes the sheet', (tester) async {
    when(() => cubit.state).thenReturn(GroupSelectorState(groups: [homelab]));

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                builder: (_) => BlocProvider<GroupSelectorCubit>.value(
                  value: cubit,
                  child: const GroupSelectorSheet(),
                ),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();

    verify(() => cubit.select(null)).called(1);
    expect(find.byType(GroupSelectorSheet), findsNothing);
  });

  testWidgets('tapping New Tag opens GroupFormPage', (tester) async {
    when(() => cubit.state).thenReturn(const GroupSelectorState());

    await pumpSheet(tester);

    await tester.tap(find.text('New Tag'));
    await tester.pumpAndSettle();

    expect(find.byType(GroupFormPage), findsOneWidget);
  });
}
