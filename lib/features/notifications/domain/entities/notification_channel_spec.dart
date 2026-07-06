// lib/features/notifications/domain/entities/notification_channel_spec.dart

/// One Android notification channel per ntfy priority level (1-5), created
/// once at app startup (Task 6) and referenced by [NotificationPolicy]
/// decisions. Pure data — no platform/plugin types, so domain stays
/// framework-free per the dependency rule.
class NotificationChannelSpec {
  const NotificationChannelSpec({
    required this.id,
    required this.name,
    required this.priorityLevel,
  });

  final String id;
  final String name;
  final int priorityLevel;

  static const List<NotificationChannelSpec> all = [
    NotificationChannelSpec(id: 'ntfy_priority_1', name: 'Min priority', priorityLevel: 1),
    NotificationChannelSpec(id: 'ntfy_priority_2', name: 'Low priority', priorityLevel: 2),
    NotificationChannelSpec(id: 'ntfy_priority_3', name: 'Default priority', priorityLevel: 3),
    NotificationChannelSpec(id: 'ntfy_priority_4', name: 'High priority', priorityLevel: 4),
    NotificationChannelSpec(id: 'ntfy_priority_5', name: 'Urgent priority', priorityLevel: 5),
  ];

  static NotificationChannelSpec forPriority(int priority) {
    final clamped = priority.clamp(1, 5);
    return all.firstWhere((c) => c.priorityLevel == clamped);
  }
}
