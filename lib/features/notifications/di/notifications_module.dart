import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/database/daos/message_dao.dart';
import 'package:ntfyd/core/database/daos/setting_dao.dart';
import 'package:ntfyd/core/database/daos/subscription_dao.dart';
import 'package:ntfyd/features/feed/domain/repositories/feed_repository.dart';
import 'package:ntfyd/features/notifications/data/background_delivery_service.dart';
import 'package:ntfyd/features/notifications/data/foreground_service_controller.dart';
import 'package:ntfyd/features/notifications/data/notification_channel_manager.dart';
import 'package:ntfyd/features/notifications/data/notification_presenter.dart';
import 'package:ntfyd/features/notifications/data/notifications_coordinator.dart';
import 'package:ntfyd/features/notifications/domain/services/notification_policy.dart';
import 'package:ntfyd/features/notifications/presentation/currently_viewed_topic.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';

@module
abstract class NotificationsModule {
  @lazySingleton
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin() =>
      FlutterLocalNotificationsPlugin();

  @lazySingleton
  NotificationPolicy notificationPolicy() => const NotificationPolicy();

  // Note: AndroidFlutterLocalNotificationsPlugin is nullable (null on
  // non-Android platforms), and injectable 3.0.x's generated GetItHelper
  // methods are bounded `<T extends Object>`, so a nullable type cannot be
  // registered as its own DI-resolvable singleton (it fails to compile:
  // `gh.lazySingleton<AndroidFlutterLocalNotificationsPlugin?>` doesn't
  // satisfy that bound). Resolving it inline here (still only evaluated
  // once, since this provider itself is a lazySingleton) avoids registering
  // the nullable type directly while keeping the same behavior.
  @lazySingleton
  NotificationChannelManager notificationChannelManager(
    FlutterLocalNotificationsPlugin plugin,
  ) => NotificationChannelManager(
    plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >(),
  );

  @lazySingleton
  NotificationPresenter notificationPresenter(
    FlutterLocalNotificationsPlugin plugin,
  ) => NotificationPresenter(plugin);

  @lazySingleton
  NotificationsCoordinator notificationsCoordinator(
    MessageDao messageDao,
    SubscriptionDao subscriptionDao,
    SettingDao settingDao,
    NotificationPresenter presenter,
    CurrentlyViewedTopic currentlyViewedTopic,
    NotificationPolicy policy,
  ) => NotificationsCoordinator(
    messageDao,
    subscriptionDao,
    settingDao,
    presenter,
    currentlyViewedTopic,
    policy,
  );

  @lazySingleton
  ForegroundServiceController foregroundServiceController() =>
      ForegroundServiceController();

  @lazySingleton
  BackgroundDeliveryService backgroundDeliveryService(
    SubscriptionRepository subscriptionRepository,
    FeedRepository feedRepository,
    ForegroundServiceController foregroundServiceController,
  ) => BackgroundDeliveryService(
    subscriptionRepository,
    feedRepository,
    foregroundServiceController,
  );
}
