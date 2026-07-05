import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/features/feed/domain/entities/attachment.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';
import 'package:ntfyd/features/feed/domain/entities/ntfy_action.dart';

void main() {
  final fixedTime = DateTime.utc(2026, 7, 5, 12);
  final fixedReceivedAt = DateTime.utc(2026, 7, 5, 12, 0, 1);

  group('NotificationMessage', () {
    test('holds required fields and applies defaults', () {
      final message = NotificationMessage(
        id: 'msg-1',
        serverId: 'srv-1',
        topic: 'alerts',
        time: fixedTime,
        event: 'message',
        receivedAt: fixedReceivedAt,
      );

      expect(message.priority, 3);
      expect(message.tags, isEmpty);
      expect(message.actions, isEmpty);
      expect(message.isMarkdown, isTrue);
      expect(message.read, isFalse);
      expect(message.pinned, isFalse);
      expect(message.expires, isNull);
      expect(message.attachment, isNull);
    });

    test('holds optional rich fields when provided', () {
      final message = NotificationMessage(
        id: 'msg-1',
        serverId: 'srv-1',
        topic: 'alerts',
        time: fixedTime,
        expires: fixedTime.add(const Duration(hours: 3)),
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
        read: true,
        pinned: true,
        receivedAt: fixedReceivedAt,
      );

      expect(message.title, 'Backup failed');
      expect(message.priority, 5);
      expect(message.tags, ['warning', 'skull']);
      expect(message.attachment?.name, 'log.txt');
      expect(message.actions, hasLength(1));
      expect(message.read, isTrue);
      expect(message.pinned, isTrue);
    });

    test('two identical messages are equal (Freezed equality)', () {
      final a = NotificationMessage(
        id: 'msg-1',
        serverId: 'srv-1',
        topic: 'alerts',
        time: fixedTime,
        event: 'message',
        receivedAt: fixedReceivedAt,
      );
      final b = NotificationMessage(
        id: 'msg-1',
        serverId: 'srv-1',
        topic: 'alerts',
        time: fixedTime,
        event: 'message',
        receivedAt: fixedReceivedAt,
      );

      expect(a, equals(b));
    });

    test('copyWith(pinned: true) produces a new, unequal instance', () {
      final message = NotificationMessage(
        id: 'msg-1',
        serverId: 'srv-1',
        topic: 'alerts',
        time: fixedTime,
        event: 'message',
        receivedAt: fixedReceivedAt,
      );

      final pinned = message.copyWith(pinned: true);

      expect(pinned.pinned, isTrue);
      expect(pinned, isNot(equals(message)));
    });
  });
}
