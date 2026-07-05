import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ntfyd/features/feed/domain/entities/attachment.dart';
import 'package:ntfyd/features/feed/domain/entities/ntfy_action.dart';

part 'notification_message.freezed.dart';

/// A single ntfy message, already filtered to `event == "message"` by the
/// data layer ([FeedMapper]) — `open`/`keepalive` never become instances of
/// this type, and `message_delete`/`message_clear` are mutations handled
/// directly against [MessageDao], not represented here.
@freezed
abstract class NotificationMessage with _$NotificationMessage {
  const factory NotificationMessage({
    required String id,
    required String serverId,
    required String topic,
    required DateTime time,
    DateTime? expires,
    required String event,
    String? title,
    String? body,
    @Default(3) int priority,
    @Default([]) List<String> tags,
    String? click,
    String? icon,
    Attachment? attachment,
    @Default([]) List<NtfyAction> actions,
    @Default(true) bool isMarkdown,
    @Default(false) bool read,
    @Default(false) bool pinned,
    required DateTime receivedAt,
  }) = _NotificationMessage;
}
