import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';

part 'home_topic_summary.freezed.dart';

/// Per-subscription projection driving one Home card: the subscription
/// itself plus its latest message (for the preview line) and unread
/// count. Presentation-layer only — not a domain entity.
@freezed
abstract class HomeTopicSummary with _$HomeTopicSummary {
  const factory HomeTopicSummary({
    required Subscription subscription,
    NotificationMessage? latestMessage,
    required int unreadCount,
  }) = _HomeTopicSummary;
}
