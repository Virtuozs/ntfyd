import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/database/app_database.dart' as db;
import 'package:ntfyd/core/database/daos/message_dao.dart';
import 'package:ntfyd/core/database/daos/setting_dao.dart';
import 'package:ntfyd/core/database/daos/subscription_dao.dart';
import 'package:ntfyd/features/notifications/data/notification_presenter.dart';
import 'package:ntfyd/features/notifications/data/notifications_coordinator.dart';
import 'package:ntfyd/features/notifications/domain/entities/notification_channel_spec.dart';
import 'package:ntfyd/features/notifications/domain/services/notification_policy.dart';
import 'package:ntfyd/features/notifications/presentation/currently_viewed_topic.dart';

class MockMessageDao extends Mock implements MessageDao {}

class MockSubscriptionDao extends Mock implements SubscriptionDao {}

class MockSettingDao extends Mock implements SettingDao {}

class MockNotificationPresenter extends Mock implements NotificationPresenter {}

db.NotificationMessage _row({
  required String id,
  required String serverId,
  required String topic,
  int priority = 3,
}) => db.NotificationMessage(
  id: id,
  serverId: serverId,
  topic: topic,
  time: 100,
  event: 'message',
  title: 'Title',
  body: 'Body',
  priority: priority,
  isMarkdown: 0,
  isRead: 0,
  isPinned: 0,
  receivedAt: 100,
);

db.Subscription _subscriptionRow({
  bool muted = false,
  int priorityThreshold = 1,
}) => db.Subscription(
  id: 'sub-1',
  serverId: 'srv-1',
  topic: 'alerts',
  displayName: 'alerts',
  priorityThreshold: priorityThreshold,
  muted: muted ? 1 : 0,
  pinned: 0,
  createdAt: 0,
);

db.AppSetting _settingsRow({bool quietHoursEnabled = false}) => db.AppSetting(
  id: 1,
  themeMode: 'dark',
  quietHoursEnabled: quietHoursEnabled ? 1 : 0,
  hideLockScreenContent: 0,
  analyticsOptOut: 0,
  biometricLock: 0,
);

void main() {
  late MockMessageDao messageDao;
  late MockSubscriptionDao subscriptionDao;
  late MockSettingDao settingDao;
  late MockNotificationPresenter presenter;
  late CurrentlyViewedTopic currentlyViewedTopic;
  late StreamController<db.NotificationMessage> insertedController;
  late NotificationsCoordinator coordinator;

  setUpAll(() {
    registerFallbackValue(NotificationChannelSpec.forPriority(3));
  });

  setUp(() {
    messageDao = MockMessageDao();
    subscriptionDao = MockSubscriptionDao();
    settingDao = MockSettingDao();
    presenter = MockNotificationPresenter();
    currentlyViewedTopic = CurrentlyViewedTopic();
    insertedController = StreamController<db.NotificationMessage>.broadcast();

    when(() => messageDao.watchInserted()).thenAnswer((_) => insertedController.stream);
    when(
      () => settingDao.watch(),
    ).thenAnswer((_) => Stream.value(_settingsRow()));
    when(() => presenter.show(
      serverId: any(named: 'serverId'),
      messageId: any(named: 'messageId'),
      topic: any(named: 'topic'),
      title: any(named: 'title'),
      body: any(named: 'body'),
      channel: any(named: 'channel'),
    )).thenAnswer((_) async {});

    coordinator = NotificationsCoordinator(
      messageDao,
      subscriptionDao,
      settingDao,
      presenter,
      currentlyViewedTopic,
      const NotificationPolicy(),
    );
  });

  tearDown(() async {
    await insertedController.close();
  });

  test('shows a notification for a new message that is not suppressed', () async {
    when(
      () => subscriptionDao.findByTopic('srv-1', 'alerts'),
    ).thenAnswer((_) async => _subscriptionRow());

    coordinator.start();
    insertedController.add(_row(id: 'msg-1', serverId: 'srv-1', topic: 'alerts'));
    await Future<void>.delayed(Duration.zero);
    await coordinator.stop();

    verify(() => presenter.show(
      serverId: 'srv-1',
      messageId: 'msg-1',
      topic: 'alerts',
      title: 'Title',
      body: 'Body',
      channel: any(named: 'channel'),
    )).called(1);
  });

  test('does not show a notification when the subscription is muted', () async {
    when(
      () => subscriptionDao.findByTopic('srv-1', 'alerts'),
    ).thenAnswer((_) async => _subscriptionRow(muted: true));

    coordinator.start();
    insertedController.add(_row(id: 'msg-1', serverId: 'srv-1', topic: 'alerts'));
    await Future<void>.delayed(Duration.zero);
    await coordinator.stop();

    verifyNever(() => presenter.show(
      serverId: any(named: 'serverId'),
      messageId: any(named: 'messageId'),
      topic: any(named: 'topic'),
      title: any(named: 'title'),
      body: any(named: 'body'),
      channel: any(named: 'channel'),
    ));
  });

  test('does not show a notification when there is no matching subscription', () async {
    when(
      () => subscriptionDao.findByTopic('srv-1', 'alerts'),
    ).thenAnswer((_) async => null);

    coordinator.start();
    insertedController.add(_row(id: 'msg-1', serverId: 'srv-1', topic: 'alerts'));
    await Future<void>.delayed(Duration.zero);
    await coordinator.stop();

    verifyNever(() => presenter.show(
      serverId: any(named: 'serverId'),
      messageId: any(named: 'messageId'),
      topic: any(named: 'topic'),
      title: any(named: 'title'),
      body: any(named: 'body'),
      channel: any(named: 'channel'),
    ));
  });

  test('does not show a notification for the topic currently being viewed', () async {
    when(
      () => subscriptionDao.findByTopic('srv-1', 'alerts'),
    ).thenAnswer((_) async => _subscriptionRow());
    currentlyViewedTopic.set('srv-1', 'alerts');

    coordinator.start();
    insertedController.add(_row(id: 'msg-1', serverId: 'srv-1', topic: 'alerts'));
    await Future<void>.delayed(Duration.zero);
    await coordinator.stop();

    verifyNever(() => presenter.show(
      serverId: any(named: 'serverId'),
      messageId: any(named: 'messageId'),
      topic: any(named: 'topic'),
      title: any(named: 'title'),
      body: any(named: 'body'),
      channel: any(named: 'channel'),
    ));
  });
}
