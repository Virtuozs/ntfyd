// test/features/notifications/domain/entities/notification_channel_spec_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/features/notifications/domain/entities/notification_channel_spec.dart';

void main() {
  group('NotificationChannelSpec.forPriority', () {
    test('returns the exact channel for priorities 1 through 5', () {
      for (var priority = 1; priority <= 5; priority++) {
        final spec = NotificationChannelSpec.forPriority(priority);
        expect(spec.priorityLevel, equals(priority));
      }
    });

    test('clamps out-of-range priorities to the nearest valid channel', () {
      expect(NotificationChannelSpec.forPriority(0).priorityLevel, equals(1));
      expect(NotificationChannelSpec.forPriority(9).priorityLevel, equals(5));
    });

    test('all channel ids are unique', () {
      final ids = NotificationChannelSpec.all.map((c) => c.id).toSet();
      expect(ids.length, equals(NotificationChannelSpec.all.length));
    });
  });
}
