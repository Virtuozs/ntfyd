import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/database/app_database.dart' as db;
import 'package:ntfyd/features/feed/data/mappers/feed_mapper.dart';
import 'package:ntfyd/features/feed/data/models/message_dto.dart';
import 'package:ntfyd/features/feed/domain/entities/attachment.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';
import 'package:ntfyd/features/feed/domain/entities/ntfy_action.dart';

db.NotificationMessage _rowFromCompanion(db.NotificationMessagesCompanion companion) {
  return db.NotificationMessage(
    id: companion.id.value,
    serverId: companion.serverId.value,
    topic: companion.topic.value,
    time: companion.time.value,
    expires: companion.expires.value,
    event: companion.event.value,
    title: companion.title.value,
    body: companion.body.value,
    priority: companion.priority.value,
    tags: companion.tags.value,
    click: companion.click.value,
    icon: companion.icon.value,
    attachment: companion.attachment.value,
    actions: companion.actions.value,
    isMarkdown: companion.isMarkdown.value,
    isRead: companion.isRead.value,
    isPinned: companion.isPinned.value,
    receivedAt: companion.receivedAt.value,
  );
}

void main() {
  final receivedAt = DateTime.utc(2026, 7, 5, 12, 0, 1);

  group('FeedMapper.fromDto', () {
    test('returns null for non-message events', () {
      for (final event in ['open', 'keepalive', 'message_delete', 'message_clear']) {
        final dto = MessageDto(
          id: 'msg-1',
          time: 1751700000,
          event: event,
          topic: 'alerts',
        );

        expect(
          FeedMapper.fromDto(dto, serverId: 'srv-1', receivedAt: receivedAt),
          isNull,
          reason: 'event=$event should not map to a NotificationMessage',
        );
      }
    });

    test('maps a full message DTO', () {
      const dto = MessageDto(
        id: 'msg-1',
        time: 1751700000,
        expires: 1751710000,
        event: 'message',
        topic: 'alerts',
        message: 'Backup failed',
        title: 'NAS',
        tags: ['warning', 'skull'],
        priority: 5,
        click: 'https://example.com',
        icon: 'https://example.com/icon.png',
        actions: [
          {'action': 'copy', 'label': 'Copy', 'value': 'x'},
        ],
        attachment: {
          'name': 'log.txt',
          'url': 'https://ntfy.sh/file/abc.txt',
        },
      );

      final message =
          FeedMapper.fromDto(dto, serverId: 'srv-1', receivedAt: receivedAt)!;

      expect(message.id, 'msg-1');
      expect(message.serverId, 'srv-1');
      expect(message.topic, 'alerts');
      expect(
        message.time,
        DateTime.fromMillisecondsSinceEpoch(1751700000 * 1000, isUtc: true),
      );
      expect(
        message.expires,
        DateTime.fromMillisecondsSinceEpoch(1751710000 * 1000, isUtc: true),
      );
      expect(message.body, 'Backup failed');
      expect(message.title, 'NAS');
      expect(message.tags, ['warning', 'skull']);
      expect(message.priority, 5);
      expect(message.click, 'https://example.com');
      expect(message.icon, 'https://example.com/icon.png');
      expect(message.attachment?.name, 'log.txt');
      expect(message.actions, [const NtfyAction.copy(label: 'Copy', value: 'x')]);
      expect(message.isMarkdown, isTrue);
      expect(message.read, isFalse);
      expect(message.pinned, isFalse);
      expect(message.receivedAt, receivedAt);
    });

    test('defaults priority to 3 and tags/actions to empty when absent', () {
      const dto = MessageDto(
        id: 'msg-1',
        time: 1751700000,
        event: 'message',
        topic: 'alerts',
      );

      final message =
          FeedMapper.fromDto(dto, serverId: 'srv-1', receivedAt: receivedAt)!;

      expect(message.priority, 3);
      expect(message.tags, isEmpty);
      expect(message.actions, isEmpty);
      expect(message.attachment, isNull);
    });
  });

  group('FeedMapper.toCompanion / toDomain round trip', () {
    test('round-trips a message with tags, attachment, and actions', () {
      final message = NotificationMessage(
        id: 'msg-1',
        serverId: 'srv-1',
        topic: 'alerts',
        time: DateTime.utc(2026, 7, 5, 12),
        expires: DateTime.utc(2026, 7, 5, 15),
        event: 'message',
        title: 'Backup failed',
        body: 'NAS disk usage 94%',
        priority: 5,
        tags: const ['warning', 'skull'],
        click: 'https://example.com',
        icon: 'https://example.com/icon.png',
        attachment: const Attachment(
          name: 'log.txt',
          url: 'https://ntfy.sh/file/abc.txt',
        ),
        actions: const [NtfyAction.copy(label: 'Copy', value: 'x')],
        pinned: true,
        receivedAt: receivedAt,
      );

      final row = _rowFromCompanion(FeedMapper.toCompanion(message));

      expect(FeedMapper.toDomain(row), equals(message));
    });

    test('round-trips a message with no optional fields', () {
      final message = NotificationMessage(
        id: 'msg-1',
        serverId: 'srv-1',
        topic: 'alerts',
        time: DateTime.utc(2026, 7, 5, 12),
        event: 'message',
        receivedAt: receivedAt,
      );

      final row = _rowFromCompanion(FeedMapper.toCompanion(message));

      expect(FeedMapper.toDomain(row), equals(message));
    });
  });
}
