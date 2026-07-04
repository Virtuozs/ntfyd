import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';

void main() {
  final fixedNow = DateTime.utc(2026, 6, 8);

  group('Subscription.validate', () {
    test('returns ValidationFailure when topic is empty', () {
      final result = Subscription.validate(
        id: 'sub-1',
        serverId: 'srv-1',
        topic: '',
        displayName: 'Alerts',
        createdAt: fixedNow,
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<ValidationFailure>());
      expect((result.failureOrThrow as ValidationFailure).field, 'topic');
    });

    test('returns ValidationFailure when priorityThreshold is below 1', () {
      final result = Subscription.validate(
        id: 'sub-1',
        serverId: 'srv-1',
        topic: 'alerts',
        priorityThreshold: 0,
        createdAt: fixedNow,
      );

      expect(result.isSuccess, isFalse);
      expect(
        (result.failureOrThrow as ValidationFailure).field,
        'priorityThreshold',
      );
    });

    test('returns ValidationFailure when priorityThreshold is above 5', () {
      final result = Subscription.validate(
        id: 'sub-1',
        serverId: 'srv-1',
        topic: 'alerts',
        priorityThreshold: 6,
        createdAt: fixedNow,
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<ValidationFailure>());
    });

    test('pinned and muted default to false, priorityThreshold defaults to 1', () {
      final result = Subscription.validate(
        id: 'sub-1',
        serverId: 'srv-1',
        topic: 'alerts',
        createdAt: fixedNow,
      );

      expect(result.isSuccess, isTrue);
      final sub = result.valueOrThrow;
      expect(sub.pinned, isFalse);
      expect(sub.muted, isFalse);
      expect(sub.priorityThreshold, 1);
    });

    test('falls back displayName to topic when displayName is null/blank', () {
      final result = Subscription.validate(
        id: 'sub-1',
        serverId: 'srv-1',
        topic: 'alerts',
        displayName: '   ',
        createdAt: fixedNow,
      );

      expect(result.valueOrThrow.displayName, 'alerts');
    });

    test('two Subscriptions with identical fields are equal (Freezed equality)', () {
      final a = Subscription.validate(
        id: 'sub-1',
        serverId: 'srv-1',
        topic: 'alerts',
        createdAt: fixedNow,
      ).valueOrThrow;
      final b = Subscription.validate(
        id: 'sub-1',
        serverId: 'srv-1',
        topic: 'alerts',
        createdAt: fixedNow,
      ).valueOrThrow;

      expect(a, equals(b));
    });

    test('copyWith(pinned: true) produces a new, unequal instance', () {
      final sub = Subscription.validate(
        id: 'sub-1',
        serverId: 'srv-1',
        topic: 'alerts',
        createdAt: fixedNow,
      ).valueOrThrow;

      final pinned = sub.copyWith(pinned: true);

      expect(pinned.pinned, isTrue);
      expect(pinned, isNot(equals(sub)));
    });
  });
}
