// test/features/notifications/domain/services/notification_policy_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/features/notifications/domain/services/notification_policy.dart';

void main() {
  const policy = NotificationPolicy();
  final noon = DateTime(2026, 1, 1, 12, 0);

  group('mute and threshold', () {
    test('suppresses when the subscription is muted', () {
      final decision = policy.evaluate(
        messagePriority: 5,
        serverId: 'srv-1',
        topic: 'alerts',
        subscriptionMuted: true,
        priorityThreshold: 1,
        quietHoursEnabled: false,
        quietHoursStart: null,
        quietHoursEnd: null,
        now: noon,
        currentlyViewedTopic: null,
      );
      expect(decision.shouldShow, isFalse);
    });

    test('suppresses when message priority is below the threshold', () {
      final decision = policy.evaluate(
        messagePriority: 2,
        serverId: 'srv-1',
        topic: 'alerts',
        subscriptionMuted: false,
        priorityThreshold: 3,
        quietHoursEnabled: false,
        quietHoursStart: null,
        quietHoursEnd: null,
        now: noon,
        currentlyViewedTopic: null,
      );
      expect(decision.shouldShow, isFalse);
    });

    test('shows when priority meets the threshold and nothing else suppresses', () {
      final decision = policy.evaluate(
        messagePriority: 3,
        serverId: 'srv-1',
        topic: 'alerts',
        subscriptionMuted: false,
        priorityThreshold: 3,
        quietHoursEnabled: false,
        quietHoursStart: null,
        quietHoursEnd: null,
        now: noon,
        currentlyViewedTopic: null,
      );
      expect(decision.shouldShow, isTrue);
      expect(decision.channel.priorityLevel, equals(3));
    });
  });

  group('quiet hours', () {
    test('suppresses within a same-day quiet-hours window', () {
      final decision = policy.evaluate(
        messagePriority: 3,
        serverId: 'srv-1',
        topic: 'alerts',
        subscriptionMuted: false,
        priorityThreshold: 1,
        quietHoursEnabled: true,
        quietHoursStart: '09:00',
        quietHoursEnd: '17:00',
        now: DateTime(2026, 1, 1, 12, 0),
        currentlyViewedTopic: null,
      );
      expect(decision.shouldShow, isFalse);
    });

    test('does not suppress outside a same-day quiet-hours window', () {
      final decision = policy.evaluate(
        messagePriority: 3,
        serverId: 'srv-1',
        topic: 'alerts',
        subscriptionMuted: false,
        priorityThreshold: 1,
        quietHoursEnabled: true,
        quietHoursStart: '09:00',
        quietHoursEnd: '17:00',
        now: DateTime(2026, 1, 1, 20, 0),
        currentlyViewedTopic: null,
      );
      expect(decision.shouldShow, isTrue);
    });

    test('handles an overnight window that wraps past midnight', () {
      final decisionInside = policy.evaluate(
        messagePriority: 3,
        serverId: 'srv-1',
        topic: 'alerts',
        subscriptionMuted: false,
        priorityThreshold: 1,
        quietHoursEnabled: true,
        quietHoursStart: '22:00',
        quietHoursEnd: '07:00',
        now: DateTime(2026, 1, 1, 23, 30),
        currentlyViewedTopic: null,
      );
      final decisionAfterMidnight = policy.evaluate(
        messagePriority: 3,
        serverId: 'srv-1',
        topic: 'alerts',
        subscriptionMuted: false,
        priorityThreshold: 1,
        quietHoursEnabled: true,
        quietHoursStart: '22:00',
        quietHoursEnd: '07:00',
        now: DateTime(2026, 1, 1, 3, 0),
        currentlyViewedTopic: null,
      );
      final decisionOutside = policy.evaluate(
        messagePriority: 3,
        serverId: 'srv-1',
        topic: 'alerts',
        subscriptionMuted: false,
        priorityThreshold: 1,
        quietHoursEnabled: true,
        quietHoursStart: '22:00',
        quietHoursEnd: '07:00',
        now: DateTime(2026, 1, 1, 12, 0),
        currentlyViewedTopic: null,
      );

      expect(decisionInside.shouldShow, isFalse);
      expect(decisionAfterMidnight.shouldShow, isFalse);
      expect(decisionOutside.shouldShow, isTrue);
    });

    test('priority 5 (urgent) bypasses quiet hours', () {
      final decision = policy.evaluate(
        messagePriority: 5,
        serverId: 'srv-1',
        topic: 'alerts',
        subscriptionMuted: false,
        priorityThreshold: 1,
        quietHoursEnabled: true,
        quietHoursStart: '09:00',
        quietHoursEnd: '17:00',
        now: DateTime(2026, 1, 1, 12, 0),
        currentlyViewedTopic: null,
      );
      expect(decision.shouldShow, isTrue);
    });
  });

  group('currently-viewed topic', () {
    test('suppresses when the message is for the topic on screen', () {
      final decision = policy.evaluate(
        messagePriority: 3,
        serverId: 'srv-1',
        topic: 'alerts',
        subscriptionMuted: false,
        priorityThreshold: 1,
        quietHoursEnabled: false,
        quietHoursStart: null,
        quietHoursEnd: null,
        now: noon,
        currentlyViewedTopic: (serverId: 'srv-1', topic: 'alerts'),
      );
      expect(decision.shouldShow, isFalse);
    });

    test('does not suppress when a different topic is on screen', () {
      final decision = policy.evaluate(
        messagePriority: 3,
        serverId: 'srv-1',
        topic: 'alerts',
        subscriptionMuted: false,
        priorityThreshold: 1,
        quietHoursEnabled: false,
        quietHoursStart: null,
        quietHoursEnd: null,
        now: noon,
        currentlyViewedTopic: (serverId: 'srv-1', topic: 'other'),
      );
      expect(decision.shouldShow, isTrue);
    });
  });
}
