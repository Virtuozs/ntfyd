import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/network/backoff_strategy.dart';

void main() {
  group('BackoffStrategy => backoff calculation', () {
    const strategy = BackoffStrategy(
      initial: Duration(seconds: 1),
      max: Duration(seconds: 60),
      jitter: 0.0,
    );

    test('attempt 0 returns exactly the initial duration', () {
      final result = strategy.next(0);

      expect(result, const Duration(seconds: 1));
    });

    test('attempt 1 return double the initial duration', () {
      final result = strategy.next(1);

      expect(result, const Duration(seconds: 2));
    });

    test('attempt 2 returns 4x the initial duration', () {
      final result = strategy.next(2);

      expect(result, const Duration(seconds: 4));
    });

    test('duration is capped at max regardless of attempt', () {
      final result = strategy.next(10);

      expect(result, const Duration(seconds: 60));
    });

    test('duration never exceeds max even after many attempt', () {
      final result = strategy.next(50);

      expect(result, const Duration(seconds: 60));
    });
  });

  group('BackoffStrategy => Jitter', () {
    test('jitter duration stay within 20% of the base duration', () {
      const strategy = BackoffStrategy(
        initial: Duration(seconds: 1),
        max: Duration(seconds: 60),
        jitter: 0.2,
      );

      for (var i = 0; i < 200; i++) {
        final result = strategy.next(0);
        final ms = result.inMilliseconds;

        expect(
          ms,
          inInclusiveRange(800, 1200),
          reason:
              'attempt 0 with 20% jitter must stay within 800–1200ms, got ${ms}ms',
        );
      }
    });

    test('jitter 0.0 producess no randomness', () {
      const strategy = BackoffStrategy(
        initial: Duration(seconds: 1),
        max: Duration(seconds: 60),
        jitter: 0.0,
      );

      final first = strategy.next(0);
      for (var i = 0; i < 10; i++) {
        expect(strategy.next(0), equals(first));
      }
    });
  });

  group('BackoffStrategy => Object Equality', () {
    test('two strategies with identical fields are equal', () {
      const a = BackoffStrategy(
        initial: Duration(seconds: 1),
        max: Duration(seconds: 60),
        jitter: 0.0,
      );
      const b = BackoffStrategy(
        initial: Duration(seconds: 1),
        max: Duration(seconds: 60),
        jitter: 0.0,
      );

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('two strategies with different initial are not equal', () {
      const a = BackoffStrategy(
        initial: Duration(seconds: 1),
        max: Duration(seconds: 60),
        jitter: 0.0,
      );
      const b = BackoffStrategy(
        initial: Duration(seconds: 2),
        max: Duration(seconds: 60),
        jitter: 0.0,
      );

      expect(a, isNot(b));
    });

    test('two strategies with different max are not equal', () {
      const a = BackoffStrategy(
        initial: Duration(seconds: 1),
        max: Duration(seconds: 30),
        jitter: 0.0,
      );
      const b = BackoffStrategy(
        initial: Duration(seconds: 1),
        max: Duration(seconds: 60),
        jitter: 0.0,
      );

      expect(a, isNot(b));
    });

    test('two strategies with different jitter are not equal', () {
      const a = BackoffStrategy(
        initial: Duration(seconds: 1),
        max: Duration(seconds: 60),
        jitter: 0.0,
      );
      const b = BackoffStrategy(
        initial: Duration(seconds: 1),
        max: Duration(seconds: 60),
        jitter: 0.2,
      );

      expect(a, isNot(b));
    });

    test('copyWith produces updated instance', () {
      const original = BackoffStrategy(
        initial: Duration(seconds: 1),
        max: Duration(seconds: 60),
        jitter: 0.2,
      );

      final copy = original.copyWith(max: const Duration(seconds: 120));

      expect(copy.max, const Duration(seconds: 120));
      expect(copy.initial, const Duration(seconds: 1));
      expect(copy, isNot(same(original)));
    });

    test('copyWith produces the same instance when no arguments provided', () {
      const original = BackoffStrategy(
        initial: Duration(seconds: 1),
        max: Duration(seconds: 60),
        jitter: 0.2,
      );

      final copy = original.copyWith();

      expect(copy, equals(original));
      expect(identical(original, copy), isFalse);
    });
  });
}
