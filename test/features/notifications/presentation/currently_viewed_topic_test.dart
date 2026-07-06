import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/features/notifications/presentation/currently_viewed_topic.dart';

void main() {
  late CurrentlyViewedTopic tracker;

  setUp(() {
    tracker = CurrentlyViewedTopic();
  });

  test('starts with no topic being viewed', () {
    expect(tracker.current, isNull);
  });

  test('set() records the (serverId, topic) pair', () {
    tracker.set('srv-1', 'alerts');
    expect(tracker.current, equals((serverId: 'srv-1', topic: 'alerts')));
  });

  test('clear() with a matching pair resets to null', () {
    tracker.set('srv-1', 'alerts');
    tracker.clear('srv-1', 'alerts');
    expect(tracker.current, isNull);
  });

  test('clear() with a non-matching pair leaves the current value untouched', () {
    tracker.set('srv-1', 'alerts');
    tracker.clear('srv-2', 'other');
    expect(tracker.current, equals((serverId: 'srv-1', topic: 'alerts')));
  });
}
