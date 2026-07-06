import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Shared priority-level -> platform-Importance mapping, used by both
/// [NotificationChannelManager] (channel creation) and [NotificationPresenter]
/// (per-notification details) so the two stay in sync.
Importance importanceForPriorityLevel(int priorityLevel) => switch (priorityLevel) {
  1 => Importance.min,
  2 => Importance.low,
  4 => Importance.high,
  5 => Importance.max,
  _ => Importance.defaultImportance,
};
