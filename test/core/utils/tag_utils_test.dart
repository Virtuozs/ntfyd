import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/utils/tag_utils.dart';

void main() {
  group('tagsFromCsv', () {
    test('parses comma-separated tags', () {
      expect(tagsFromCsv('warning,skull'), equals(['warning', 'skull']));
    });

    test('trims whitespace around tags', () {
      expect(
        tagsFromCsv('warning, skull , fire'),
        equals(['warning', 'skull', 'fire']),
      );
    });

    test('filters out empty segments', () {
      expect(tagsFromCsv('warning,,skull'), equals(['warning', 'skull']));
    });

    test('returns empty list for null input', () {
      expect(tagsFromCsv(null), isEmpty);
    });

    test('returns empty list for empty string', () {
      expect(tagsFromCsv(''), isEmpty);
    });

    test('returns empty list for whitespace-only string', () {
      expect(tagsFromCsv('   '), isEmpty);
    });

    test('single tag with no commas', () {
      expect(tagsFromCsv('warning'), equals(['warning']));
    });
  });

  group('tagsToCsv', () {
    test('joins tags with commas', () {
      expect(tagsToCsv(['warning', 'skull']), equals('warning,skull'));
    });

    test('empty list returns empty string', () {
      expect(tagsToCsv([]), equals(''));
    });

    test('single tag returns that tag with no comma', () {
      expect(tagsToCsv(['warning']), equals('warning'));
    });
  });

  group('round-trip', () {
    test('tagsFromCsv(tagsToCsv(tags)) == tags', () {
      const tags = ['warning', 'skull', 'fire'];
      expect(tagsFromCsv(tagsToCsv(tags)), equals(tags));
    });
  });
}
