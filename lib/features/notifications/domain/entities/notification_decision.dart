// lib/features/notifications/domain/entities/notification_decision.dart
import 'package:ntfyd/features/notifications/domain/entities/notification_channel_spec.dart';

class NotificationDecision {
  const NotificationDecision({required this.shouldShow, required this.channel});

  final bool shouldShow;
  final NotificationChannelSpec channel;
}
