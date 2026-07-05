import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/features/feed/domain/entities/attachment.dart';

void main() {
  group('Attachment', () {
    test('holds all fields', () {
      const attachment = Attachment(
        name: 'backup.zip',
        url: 'https://ntfy.sh/file/abc123.zip',
        type: 'application/zip',
        size: 2048,
        expires: 1751000000,
      );

      expect(attachment.name, 'backup.zip');
      expect(attachment.url, 'https://ntfy.sh/file/abc123.zip');
      expect(attachment.type, 'application/zip');
      expect(attachment.size, 2048);
      expect(attachment.expires, 1751000000);
    });

    test('type/size/expires are optional', () {
      const attachment = Attachment(
        name: 'backup.zip',
        url: 'https://ntfy.sh/file/abc123.zip',
      );

      expect(attachment.type, isNull);
      expect(attachment.size, isNull);
      expect(attachment.expires, isNull);
    });

    test('two Attachments with identical fields are equal (Freezed equality)', () {
      const a = Attachment(name: 'f.zip', url: 'https://x/f.zip');
      const b = Attachment(name: 'f.zip', url: 'https://x/f.zip');

      expect(a, equals(b));
    });
  });
}
