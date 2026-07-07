import 'package:ntfyd/core/database/value_objects/message_filter.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';
import 'package:ntfyd/features/groups/domain/entities/group.dart';

abstract class GroupRepository {
  Stream<List<Group>> watchAll();

  Future<Result<Group>> save(Group group);

  Future<Result<void>> delete(String groupId);

  /// The merged feed across a group's members. `groupId == null` is the
  /// built-in "All" view (every message across every subscription).
  Stream<List<NotificationMessage>> watchFeed(
    String? groupId, {
    MessageFilter? filter,
  });
}
