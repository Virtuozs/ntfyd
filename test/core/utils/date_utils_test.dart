import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/utils/date_utils.dart';

void main() {
  // Fixed reference "now" for deterministic tests.
  final now = DateTime(2026, 6, 12, 12, 0, 0); // Friday, June 12, 2026, noon

  group('relativeTime', () {
    test('30 seconds ago -> "just now"', () {
      final time = now.subtract(const Duration(seconds: 30));
      expect(relativeTime(time, now: now), equals('just now'));
    });

    test('59 seconds ago -> "just now"', () {
      final time = now.subtract(const Duration(seconds: 59));
      expect(relativeTime(time, now: now), equals('just now'));
    });

    test('5 minutes ago -> "5 min ago"', () {
      final time = now.subtract(const Duration(minutes: 5));
      expect(relativeTime(time, now: now), equals('5 min ago'));
    });

    test('1 minute ago -> "1 min ago"', () {
      final time = now.subtract(const Duration(minutes: 1));
      expect(relativeTime(time, now: now), equals('1 min ago'));
    });

    test('59 minutes ago -> "59 min ago"', () {
      final time = now.subtract(const Duration(minutes: 59));
      expect(relativeTime(time, now: now), equals('59 min ago'));
    });

    test('3 hours ago -> "3 h ago"', () {
      final time = now.subtract(const Duration(hours: 3));
      expect(relativeTime(time, now: now), equals('3 h ago'));
    });

    test('1 hour ago -> "1 h ago"', () {
      final time = now.subtract(const Duration(hours: 1));
      expect(relativeTime(time, now: now), equals('1 h ago'));
    });

    test('23 hours ago -> "23 h ago"', () {
      final time = now.subtract(const Duration(hours: 23));
      expect(relativeTime(time, now: now), equals('23 h ago'));
    });

    test('yesterday (24-48h ago, previous calendar day) -> "yesterday"', () {
      final time = now.subtract(const Duration(hours: 25));
      expect(relativeTime(time, now: now), equals('yesterday'));
    });

    test('2 days ago -> formatted date (not "yesterday")', () {
      final time = now.subtract(const Duration(days: 2));
      final result = relativeTime(time, now: now);
      expect(result, isNot(equals('yesterday')));
      expect(result, isNot(contains('ago')));
    });

    test('older date returns a non-empty formatted string', () {
      final time = DateTime(2026, 1, 1);
      final result = relativeTime(time, now: now);
      expect(result, isNotEmpty);
      expect(result, isNot(equals('just now')));
    });
  });
}
