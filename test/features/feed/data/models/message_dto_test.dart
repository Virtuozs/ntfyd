import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/features/feed/data/models/message_dto.dart';

void main() {
  group('MessageDto', () {
    test('fromJson parses a full message frame', () {
      final dto = MessageDto.fromJson({
        'id': 'msg-1',
        'time': 1751700000,
        'expires': 1751710000,
        'event': 'message',
        'topic': 'alerts',
        'message': 'Backup failed',
        'title': 'NAS',
        'tags': ['warning', 'skull'],
        'priority': 5,
        'click': 'https://example.com',
        'icon': 'https://example.com/icon.png',
        'actions': [
          {'action': 'copy', 'label': 'Copy', 'value': 'x'},
        ],
        'attachment': {'name': 'log.txt', 'url': 'https://ntfy.sh/file/abc.txt'},
      });

      expect(dto.id, 'msg-1');
      expect(dto.time, 1751700000);
      expect(dto.expires, 1751710000);
      expect(dto.event, 'message');
      expect(dto.topic, 'alerts');
      expect(dto.message, 'Backup failed');
      expect(dto.title, 'NAS');
      expect(dto.tags, ['warning', 'skull']);
      expect(dto.priority, 5);
      expect(dto.click, 'https://example.com');
      expect(dto.icon, 'https://example.com/icon.png');
      expect(dto.actions, hasLength(1));
      expect(dto.actions?.first['label'], 'Copy');
      expect(dto.attachment?['name'], 'log.txt');
    });

    test('fromJson tolerates a minimal control frame', () {
      final dto = MessageDto.fromJson({
        'id': 'msg-2',
        'time': 1751700000,
        'event': 'keepalive',
        'topic': 'alerts',
      });

      expect(dto.event, 'keepalive');
      expect(dto.message, isNull);
      expect(dto.tags, isNull);
      expect(dto.actions, isNull);
      expect(dto.attachment, isNull);
    });
  });
}
