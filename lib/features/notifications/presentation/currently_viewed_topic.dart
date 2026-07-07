import 'package:injectable/injectable.dart';

/// App-wide record of which (serverId, topic) live feed is currently on
/// screen, if any. [NotificationsCoordinator] checks this to suppress a
/// redundant popup notification for the topic the user is already looking
/// at (Notifications design spec, "Foreground suppress").
@lazySingleton
class CurrentlyViewedTopic {
  ({String serverId, String topic})? current;

  void set(String serverId, String topic) {
    current = (serverId: serverId, topic: topic);
  }

  /// Only clears if [serverId]/[topic] matches what's currently recorded —
  /// guards against a stale bloc's `close()` clearing a different topic
  /// that was opened afterward.
  void clear(String serverId, String topic) {
    final value = current;
    if (value != null && value.serverId == serverId && value.topic == topic) {
      current = null;
    }
  }
}
