import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ntfyd/features/notifications/data/notification_importance.dart';
import 'package:ntfyd/features/notifications/domain/entities/notification_channel_spec.dart';

/// Shows a system notification for a message that [NotificationPolicy]
/// (Task 1) has already decided should be shown, on the given channel.
class NotificationPresenter {
  NotificationPresenter(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  Future<void> show({
    required String serverId,
    required String messageId,
    required String topic,
    required String title,
    required String body,
    required NotificationChannelSpec channel,
  }) {
    final notificationId = '$serverId:$messageId'.hashCode;
    final payload = jsonEncode({'serverId': serverId, 'topic': topic});

    return _plugin.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          importance: importanceForPriorityLevel(channel.priorityLevel),
          priority: Priority.high,
        ),
      ),
      payload: payload,
    );
  }
}
