import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';
import 'package:ntfyd/features/feed/domain/repositories/feed_repository.dart';
import 'package:ntfyd/features/feed/presentation/cubits/home_feed_cubit.dart';
import 'package:ntfyd/features/feed/presentation/cubits/home_feed_state.dart';
import 'package:ntfyd/features/feed/presentation/cubits/home_topic_summary.dart';
import 'package:ntfyd/features/groups/domain/entities/group.dart';
import 'package:ntfyd/features/groups/domain/entities/group_membership.dart';
import 'package:ntfyd/features/groups/domain/repositories/group_repository.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';

class MockSubscriptionRepository extends Mock implements SubscriptionRepository {}

class MockFeedRepository extends Mock implements FeedRepository {}

class MockGroupRepository extends Mock implements GroupRepository {}

void main() {
  late MockSubscriptionRepository subscriptionRepository;
  late MockFeedRepository feedRepository;
  late MockGroupRepository groupRepository;

  late StreamController<List<Subscription>> subscriptionsController;
  late StreamController<List<Group>> groupsController;
  late StreamController<NotificationMessage?> latestDockerController;
  late StreamController<int> unreadDockerController;
  late StreamController<NotificationMessage?> latestMinecraftController;
  late StreamController<int> unreadMinecraftController;

  final now = DateTime.utc(2026, 1, 1);
  final dockerSub = Subscription(
    id: 'sub-1',
    serverId: 'srv-1',
    topic: 'docker-alerts',
    displayName: 'docker-alerts',
    createdAt: now,
  );
  final minecraftSub = Subscription(
    id: 'sub-2',
    serverId: 'srv-2',
    topic: 'minecraft-server',
    displayName: 'minecraft-server',
    createdAt: now,
  );

  setUp(() {
    subscriptionRepository = MockSubscriptionRepository();
    feedRepository = MockFeedRepository();
    groupRepository = MockGroupRepository();

    subscriptionsController = StreamController<List<Subscription>>.broadcast();
    groupsController = StreamController<List<Group>>.broadcast();
    latestDockerController = StreamController<NotificationMessage?>.broadcast();
    unreadDockerController = StreamController<int>.broadcast();
    latestMinecraftController = StreamController<NotificationMessage?>.broadcast();
    unreadMinecraftController = StreamController<int>.broadcast();

    when(() => subscriptionRepository.watchAll()).thenAnswer((_) => subscriptionsController.stream);
    when(() => groupRepository.watchAll()).thenAnswer((_) => groupsController.stream);
    when(
      () => feedRepository.watchLatestMessage('srv-1', 'docker-alerts'),
    ).thenAnswer((_) => latestDockerController.stream);
    when(
      () => feedRepository.watchUnreadCount('srv-1', 'docker-alerts'),
    ).thenAnswer((_) => unreadDockerController.stream);
    when(
      () => feedRepository.watchLatestMessage('srv-2', 'minecraft-server'),
    ).thenAnswer((_) => latestMinecraftController.stream);
    when(
      () => feedRepository.watchUnreadCount('srv-2', 'minecraft-server'),
    ).thenAnswer((_) => unreadMinecraftController.stream);
  });

  tearDown(() async {
    await subscriptionsController.close();
    await groupsController.close();
    await latestDockerController.close();
    await unreadDockerController.close();
    await latestMinecraftController.close();
    await unreadMinecraftController.close();
  });

  HomeFeedCubit buildCubit() =>
      HomeFeedCubit(subscriptionRepository, feedRepository, groupRepository);

  blocTest<HomeFeedCubit, HomeFeedState>(
    'load() with no groupId watches every subscription across every server',
    build: buildCubit,
    act: (cubit) async {
      cubit.load();
      await Future<void>.delayed(Duration.zero);
      subscriptionsController.add([]);
    },
    expect: () => [
      const HomeFeedState.loading(),
      const HomeFeedState.loaded(items: []),
    ],
  );

  blocTest<HomeFeedCubit, HomeFeedState>(
    'load() with no groupId combines latest message and unread count per subscription',
    build: buildCubit,
    act: (cubit) async {
      cubit.load();
      await Future<void>.delayed(Duration.zero);
      subscriptionsController.add([dockerSub, minecraftSub]);
      await Future<void>.delayed(Duration.zero);
      latestDockerController.add(null);
      unreadDockerController.add(12);
      latestMinecraftController.add(null);
      unreadMinecraftController.add(2);
    },
    expect: () => [
      const HomeFeedState.loading(),
      HomeFeedState.loaded(
        items: [
          HomeTopicSummary(subscription: dockerSub, unreadCount: 12),
          HomeTopicSummary(subscription: minecraftSub, unreadCount: 2),
        ],
      ),
    ],
  );

  blocTest<HomeFeedCubit, HomeFeedState>(
    'load(groupId: ...) filters subscriptions to the group\'s members',
    build: buildCubit,
    act: (cubit) async {
      cubit.load(groupId: 'grp-1');
      await Future<void>.delayed(Duration.zero);
      groupsController.add([
        Group(
          id: 'grp-1',
          name: 'Homelab',
          members: {const GroupMembership(serverId: 'srv-1', topic: 'docker-alerts')},
        ),
      ]);
      await Future<void>.delayed(Duration.zero);
      subscriptionsController.add([dockerSub, minecraftSub]);
      await Future<void>.delayed(Duration.zero);
      latestDockerController.add(null);
      unreadDockerController.add(12);
    },
    expect: () => [
      const HomeFeedState.loading(),
      HomeFeedState.loaded(
        items: [HomeTopicSummary(subscription: dockerSub, unreadCount: 12)],
      ),
    ],
  );
}
