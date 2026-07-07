import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ntfyd/features/notifications/data/notification_importance.dart';
import 'package:ntfyd/features/notifications/domain/entities/notification_channel_spec.dart';

/// Creates the 5 ntfy-priority notification channels once at app startup
/// (Android 8.0+ channels are immutable after creation — importance/sound
/// changes require the user to edit them in system settings from then on).
class NotificationChannelManager {
  NotificationChannelManager(this._androidPlugin);

  final AndroidFlutterLocalNotificationsPlugin? _androidPlugin;

  Future<void> createChannels() async {
    final plugin = _androidPlugin;
    if (plugin == null) return;

    for (final spec in NotificationChannelSpec.all) {
      await plugin.createNotificationChannel(
        AndroidNotificationChannel(
          spec.id,
          spec.name,
          importance: importanceForPriorityLevel(spec.priorityLevel),
        ),
      );
    }
  }
}
