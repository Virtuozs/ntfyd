import 'package:ntfyd/core/database/value_objects/message_filter.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/feed/domain/entities/feed_connection_state.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';

abstract class FeedRepository {
  Stream<List<NotificationMessage>> watchMessages(
    String serverId,
    String topic, {
    MessageFilter? filter,
  });

  Stream<int> watchUnreadCount(String serverId, String topic);

  Stream<NotificationMessage?> watchLatestMessage(String serverId, String topic);

  Stream<FeedConnectionState> watchConnectionState(String serverId, String topic);

  /// Opens a screen-scoped WS session for (serverId, topic) if one isn't
  /// already open (idempotent), then performs a catch-up history fetch.
  Future<Result<void>> connect(String serverId, String topic);

  /// Tears down the WS session for (serverId, topic), if any.
  Future<Result<void>> disconnect(String serverId, String topic);

  /// Manual pull-to-refresh: fetches cached history since the last known
  /// message id (or all history if none is cached yet) without touching
  /// the WS session.
  Future<Result<void>> refreshHistory(String serverId, String topic);

  Future<Result<void>> toggleRead(String serverId, String id);

  Future<Result<void>> togglePin(String serverId, String id);
}
