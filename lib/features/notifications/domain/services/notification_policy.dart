// lib/features/notifications/domain/services/notification_policy.dart
import 'package:ntfyd/features/notifications/domain/entities/notification_channel_spec.dart';
import 'package:ntfyd/features/notifications/domain/entities/notification_decision.dart';

/// Pure decision of whether an incoming message should raise a system
/// notification. No framework/plugin imports — testable with plain values.
class NotificationPolicy {
  const NotificationPolicy();

  NotificationDecision evaluate({
    required int messagePriority,
    required String serverId,
    required String topic,
    required bool subscriptionMuted,
    required int priorityThreshold,
    required bool quietHoursEnabled,
    required String? quietHoursStart,
    required String? quietHoursEnd,
    required DateTime now,
    required ({String serverId, String topic})? currentlyViewedTopic,
  }) {
    final channel = NotificationChannelSpec.forPriority(messagePriority);

    final isViewingThisTopic = currentlyViewedTopic != null &&
        currentlyViewedTopic.serverId == serverId &&
        currentlyViewedTopic.topic == topic;

    final isSuppressed = isViewingThisTopic ||
        subscriptionMuted ||
        messagePriority < priorityThreshold ||
        (messagePriority < 5 &&
            quietHoursEnabled &&
            _isWithinQuietHours(now, quietHoursStart, quietHoursEnd));

    return NotificationDecision(shouldShow: !isSuppressed, channel: channel);
  }

  bool _isWithinQuietHours(DateTime now, String? start, String? end) {
    final startMinutes = _parseHHmm(start);
    final endMinutes = _parseHHmm(end);
    if (startMinutes == null || endMinutes == null) return false;

    final nowMinutes = now.hour * 60 + now.minute;

    if (startMinutes == endMinutes) return true; // 24h window
    if (startMinutes < endMinutes) {
      return nowMinutes >= startMinutes && nowMinutes < endMinutes;
    }
    // Overnight window, e.g. 22:00 -> 07:00.
    return nowMinutes >= startMinutes || nowMinutes < endMinutes;
  }

  int? _parseHHmm(String? value) {
    if (value == null) return null;
    final parts = value.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return h * 60 + m;
  }
}
