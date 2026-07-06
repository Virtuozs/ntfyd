import 'dart:async';

import 'package:ntfyd/core/database/app_database.dart' as db;
import 'package:ntfyd/core/database/daos/message_dao.dart';
import 'package:ntfyd/core/database/daos/setting_dao.dart';
import 'package:ntfyd/core/database/daos/subscription_dao.dart';
import 'package:ntfyd/features/notifications/data/notification_presenter.dart';
import 'package:ntfyd/features/notifications/domain/services/notification_policy.dart';
import 'package:ntfyd/features/notifications/presentation/currently_viewed_topic.dart';

/// Bridges [MessageDao.watchInserted] to [NotificationPresenter]: for every
/// genuinely new message, looks up its subscription's mute/threshold and
/// the app's quiet-hours settings, runs [NotificationPolicy], and shows a
/// notification when the policy says to.
class NotificationsCoordinator {
  NotificationsCoordinator(
    this._messageDao,
    this._subscriptionDao,
    this._settingDao,
    this._presenter,
    this._currentlyViewedTopic,
    this._policy,
  );

  final MessageDao _messageDao;
  final SubscriptionDao _subscriptionDao;
  final SettingDao _settingDao;
  final NotificationPresenter _presenter;
  final CurrentlyViewedTopic _currentlyViewedTopic;
  final NotificationPolicy _policy;

  StreamSubscription<db.NotificationMessage>? _subscription;

  void start() {
    _subscription = _messageDao.watchInserted().listen(_handleInserted);
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  Future<void> _handleInserted(db.NotificationMessage row) async {
    final subscription = await _subscriptionDao.findByTopic(
      row.serverId,
      row.topic,
    );
    if (subscription == null) return;

    final settings = await _settingDao.watch().first;

    final decision = _policy.evaluate(
      messagePriority: row.priority,
      serverId: row.serverId,
      topic: row.topic,
      subscriptionMuted: subscription.muted == 1,
      priorityThreshold: subscription.priorityThreshold,
      quietHoursEnabled: settings.quietHoursEnabled == 1,
      quietHoursStart: settings.quietHoursStart,
      quietHoursEnd: settings.quietHoursEnd,
      now: DateTime.now(),
      currentlyViewedTopic: _currentlyViewedTopic.current,
    );

    if (!decision.shouldShow) return;

    await _presenter.show(
      serverId: row.serverId,
      messageId: row.id,
      topic: row.topic,
      title: row.title ?? row.topic,
      body: row.body ?? '',
      channel: decision.channel,
    );
  }
}
