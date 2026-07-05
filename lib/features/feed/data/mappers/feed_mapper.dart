import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:ntfyd/core/database/app_database.dart' as db;
import 'package:ntfyd/features/feed/data/models/message_dto.dart';
import 'package:ntfyd/features/feed/domain/entities/attachment.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';
import 'package:ntfyd/features/feed/domain/entities/ntfy_action.dart';

/// Maps between the ntfy wire format ([MessageDto]), the domain
/// [NotificationMessage] entity, and the Drift [db.NotificationMessage] row.
///
/// Only `event == "message"` frames become domain entities via [fromDto] —
/// `open`, `keepalive`, `message_delete`, `message_clear` are handled
/// directly by `FeedRepositoryImpl`, never mapped here.
class FeedMapper {
  static NotificationMessage? fromDto(
    MessageDto dto, {
    required String serverId,
    required DateTime receivedAt,
  }) {
    if (dto.event != 'message') return null;

    return NotificationMessage(
      id: dto.id,
      serverId: serverId,
      topic: dto.topic,
      time: _fromUnixSeconds(dto.time.toInt()),
      expires: dto.expires == null ? null : _fromUnixSeconds(dto.expires!.toInt()),
      event: dto.event,
      title: dto.title,
      body: dto.message,
      priority: dto.priority ?? 3,
      tags: dto.tags ?? const [],
      click: dto.click,
      icon: dto.icon,
      attachment: attachmentFromJson(dto.attachment),
      actions: actionsFromJson(dto.actions),
      receivedAt: receivedAt,
    );
  }

  static db.NotificationMessagesCompanion toCompanion(NotificationMessage msg) {
    return db.NotificationMessagesCompanion.insert(
      id: msg.id,
      serverId: msg.serverId,
      topic: msg.topic,
      time: _toUnixSeconds(msg.time),
      expires: Value(msg.expires == null ? null : _toUnixSeconds(msg.expires!)),
      event: msg.event,
      title: Value(msg.title),
      body: Value(msg.body),
      priority: Value(msg.priority),
      tags: Value(jsonEncode(msg.tags)),
      click: Value(msg.click),
      icon: Value(msg.icon),
      attachment: Value(
        msg.attachment == null ? null : jsonEncode(attachmentToJson(msg.attachment!)),
      ),
      actions: Value(jsonEncode(msg.actions.map(actionToJson).toList())),
      isMarkdown: Value(msg.isMarkdown ? 1 : 0),
      isRead: Value(msg.read ? 1 : 0),
      isPinned: Value(msg.pinned ? 1 : 0),
      receivedAt: _toUnixSeconds(msg.receivedAt),
    );
  }

  static NotificationMessage toDomain(db.NotificationMessage row) {
    return NotificationMessage(
      id: row.id,
      serverId: row.serverId,
      topic: row.topic,
      time: _fromUnixSeconds(row.time),
      expires: row.expires == null ? null : _fromUnixSeconds(row.expires!),
      event: row.event,
      title: row.title,
      body: row.body,
      priority: row.priority,
      tags: row.tags == null ? const [] : (jsonDecode(row.tags!) as List).cast<String>(),
      click: row.click,
      icon: row.icon,
      attachment: row.attachment == null
          ? null
          : attachmentFromJson(jsonDecode(row.attachment!) as Map<String, dynamic>),
      actions: row.actions == null
          ? const []
          : actionsFromJson(
              (jsonDecode(row.actions!) as List).cast<Map<String, dynamic>>(),
            ),
      isMarkdown: row.isMarkdown == 1,
      read: row.isRead == 1,
      pinned: row.isPinned == 1,
      receivedAt: _fromUnixSeconds(row.receivedAt),
    );
  }

  static Attachment? attachmentFromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return Attachment(
      name: json['name'] as String,
      url: json['url'] as String,
      type: json['type'] as String?,
      size: json['size'] as int?,
      expires: json['expires'] as int?,
    );
  }

  static Map<String, dynamic> attachmentToJson(Attachment attachment) => {
    'name': attachment.name,
    'url': attachment.url,
    if (attachment.type != null) 'type': attachment.type,
    if (attachment.size != null) 'size': attachment.size,
    if (attachment.expires != null) 'expires': attachment.expires,
  };

  static List<NtfyAction> actionsFromJson(List<Map<String, dynamic>>? json) {
    if (json == null) return const [];
    return json.map(_actionFromJson).whereType<NtfyAction>().toList();
  }

  static NtfyAction? _actionFromJson(Map<String, dynamic> json) {
    switch (json['action'] as String?) {
      case 'view':
        return NtfyAction.view(
          label: json['label'] as String,
          url: json['url'] as String,
          clear: json['clear'] as bool? ?? false,
        );
      case 'http':
        return NtfyAction.http(
          label: json['label'] as String,
          url: json['url'] as String,
          method: json['method'] as String? ?? 'POST',
          headers: (json['headers'] as Map?)?.cast<String, String>() ?? const {},
          body: json['body'] as String?,
          clear: json['clear'] as bool? ?? false,
        );
      case 'broadcast':
        return NtfyAction.broadcast(
          label: json['label'] as String,
          intent: json['intent'] as String? ?? 'io.heckel.ntfy.USER_ACTION',
          extras: (json['extras'] as Map?)?.cast<String, String>() ?? const {},
          clear: json['clear'] as bool? ?? false,
        );
      case 'copy':
        return NtfyAction.copy(
          label: json['label'] as String,
          value: json['value'] as String,
          clear: json['clear'] as bool? ?? false,
        );
      default:
        return null;
    }
  }

  static Map<String, dynamic> actionToJson(NtfyAction action) => action.when(
    view: (label, url, clear) => {
      'action': 'view',
      'label': label,
      'url': url,
      'clear': clear,
    },
    http: (label, url, method, headers, body, clear) => {
      'action': 'http',
      'label': label,
      'url': url,
      'method': method,
      'headers': headers,
      'body': ?body,
      'clear': clear,
    },
    broadcast: (label, intent, extras, clear) => {
      'action': 'broadcast',
      'label': label,
      'intent': intent,
      'extras': extras,
      'clear': clear,
    },
    copy: (label, value, clear) => {
      'action': 'copy',
      'label': label,
      'value': value,
      'clear': clear,
    },
  );

  static DateTime _fromUnixSeconds(int seconds) =>
      DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);

  static int _toUnixSeconds(DateTime time) =>
      time.toUtc().millisecondsSinceEpoch ~/ 1000;
}
