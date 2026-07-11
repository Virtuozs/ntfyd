import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/di/injection_container.dart';
import 'package:ntfyd/features/feed/presentation/cubits/group_selector_cubit.dart';
import 'package:ntfyd/features/feed/presentation/cubits/group_selector_state.dart';
import 'package:ntfyd/features/feed/presentation/cubits/home_feed_cubit.dart';
import 'package:ntfyd/features/feed/presentation/cubits/home_feed_state.dart';
import 'package:ntfyd/features/feed/presentation/cubits/home_topic_summary.dart';
import 'package:ntfyd/features/feed/presentation/pages/home_page.dart';
import 'package:ntfyd/features/groups/domain/entities/group.dart';
import 'package:ntfyd/features/groups/presentation/widgets/topic_tags_sheet.dart';
import 'package:ntfyd/features/server_config/data/models/health_dto.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';
import 'package:ntfyd/features/server_config/domain/usecases/validate_server_health.dart';
import 'package:ntfyd/features/settings/domain/entities/app_settings.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_cubit.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_state.dart';
import 'package:ntfyd/features/settings/presentation/pages/settings_page.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';

class MockServerConfigRepository extends Mock
    implements ServerConfigRepository {}

class MockValidateServerHealth extends Mock implements ValidateServerHealth {}

class MockHomeFeedCubit extends Mock implements HomeFeedCubit {}

class MockGroupSelectorCubit extends Mock implements GroupSelectorCubit {}

class MockSettingsCubit extends Mock implements SettingsCubit {}

void main() {
  final server = ServerConfig(
    id: 'srv-1',
    baseUrl: 'https://ntfy.sh',
    displayName: 'ntfy.sh',
    authType: AuthType.none,
    isDefault: true,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  late MockServerConfigRepository serverConfigRepository;
  late MockValidateServerHealth validateServerHealth;
  late MockHomeFeedCubit homeFeedCubit;
  late MockGroupSelectorCubit groupSelectorCubit;
  late MockSettingsCubit settingsCubit;

  setUp(() {
    serverConfigRepository = MockServerConfigRepository();
    validateServerHealth = MockValidateServerHealth();
    homeFeedCubit = MockHomeFeedCubit();
    groupSelectorCubit = MockGroupSelectorCubit();
    settingsCubit = MockSettingsCubit();

    when(
      () => serverConfigRepository.getAll(),
    ).thenAnswer((_) async => Result.success([server]));
    when(
      () => validateServerHealth.call('https://ntfy.sh'),
    ).thenAnswer((_) async => const Result.success(HealthDto(healthy: true)));
    when(
      () => homeFeedCubit.state,
    ).thenReturn(const HomeFeedState.loaded(items: []));
    when(
      () => homeFeedCubit.stream,
    ).thenAnswer((_) => const Stream<HomeFeedState>.empty());
    when(
      () => homeFeedCubit.load(groupId: any(named: 'groupId')),
    ).thenReturn(null);
    when(() => homeFeedCubit.close()).thenAnswer((_) async {});
    when(() => groupSelectorCubit.state).thenReturn(const GroupSelectorState());
    when(
      () => groupSelectorCubit.stream,
    ).thenAnswer((_) => const Stream<GroupSelectorState>.empty());
    when(() => groupSelectorCubit.load()).thenReturn(null);
    when(() => groupSelectorCubit.close()).thenAnswer((_) async {});
    when(
      () => settingsCubit.state,
    ).thenReturn(const SettingsState.loaded(AppSettings()));
    when(
      () => settingsCubit.stream,
    ).thenAnswer((_) => const Stream<SettingsState>.empty());
    when(() => settingsCubit.load()).thenReturn(null);
    when(() => settingsCubit.close()).thenAnswer((_) async {});

    getIt
      ..reset()
      ..registerFactory<ServerConfigRepository>(() => serverConfigRepository)
      ..registerFactory<ValidateServerHealth>(() => validateServerHealth)
      ..registerFactory<HomeFeedCubit>(() => homeFeedCubit)
      ..registerFactory<GroupSelectorCubit>(() => groupSelectorCubit)
      ..registerFactory<SettingsCubit>(() => settingsCubit);
  });

  tearDown(() => getIt.reset());

  testWidgets('renders the ntfyd title, empty state, All chip, and a FAB', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();

    expect(find.text('ntfyd'), findsOneWidget);
    expect(find.text('No subscriptions yet'), findsOneWidget);
    expect(find.text('All'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    verify(() => homeFeedCubit.load()).called(1);
    verify(() => groupSelectorCubit.load()).called(1);
  });

  testWidgets('shows Connected once the default server health check succeeds', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();

    expect(find.text('Connected'), findsOneWidget);
  });

  testWidgets(
    'tapping the FAB reveals Subscribe Topic and Create Tag actions',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton).last);
      await tester.pumpAndSettle();

      expect(find.byTooltip('Subscribe to topic'), findsOneWidget);
      expect(find.byTooltip('Create Tag'), findsOneWidget);
    },
  );

  testWidgets('tapping the settings icon pushes SettingsPage', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsPage), findsOneWidget);
  });

  testWidgets('tapping Add to tag on a subscription opens TopicTagsSheet', (
    tester,
  ) async {
    final subscription = Subscription(
      id: 'sub-1',
      serverId: 'srv-1',
      topic: 'alerts',
      displayName: 'Alerts',
      createdAt: DateTime.utc(2026, 1, 1),
    );
    final summary = HomeTopicSummary(
      subscription: subscription,
      unreadCount: 0,
    );
    final group = Group(id: 'grp-1', name: 'Work');

    when(
      () => homeFeedCubit.state,
    ).thenReturn(HomeFeedState.loaded(items: [summary]));
    when(
      () => groupSelectorCubit.state,
    ).thenReturn(GroupSelectorState(groups: [group]));

    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add to tag'));
    await tester.pumpAndSettle();

    expect(find.byType(TopicTagsSheet), findsOneWidget);
  });
}
