import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/database/daos/group_dao.dart';
import 'package:ntfyd/core/database/value_objects/message_filter.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/feed/data/mappers/feed_mapper.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';
import 'package:ntfyd/features/groups/data/mappers/group_mapper.dart';
import 'package:ntfyd/features/groups/domain/entities/group.dart';
import 'package:ntfyd/features/groups/domain/repositories/group_repository.dart';

@LazySingleton(as: GroupRepository)
class GroupRepositoryImpl implements GroupRepository {
  GroupRepositoryImpl(this._dao);

  final GroupDao _dao;

  @override
  Stream<List<Group>> watchAll() {
    return _dao.watchAll().map(
      (rows) => rows.map(GroupMapper.toDomain).toList(),
    );
  }

  @override
  Future<Result<Group>> save(Group group) async {
    try {
      final (groupCompanion, memberCompanions) = GroupMapper.toCompanions(group);
      await _dao.upsert(groupCompanion, memberCompanions);
      return Result.success(group);
    } catch (e) {
      return Result.err(Failure.cache(message: 'Failed to save group: $e'));
    }
  }

  @override
  Future<Result<void>> delete(String groupId) async {
    try {
      await _dao.deleteGroup(groupId);
      return const Result.success(null);
    } catch (e) {
      return Result.err(Failure.cache(message: 'Failed to delete group: $e'));
    }
  }

  @override
  Stream<List<NotificationMessage>> watchFeed(
    String? groupId, {
    MessageFilter? filter,
  }) {
    final stream = groupId == null
        ? _dao.watchAllFeed(filter: filter)
        : _dao.watchFeedForGroup(groupId, filter: filter);
    return stream.map((rows) => rows.map(FeedMapper.toDomain).toList());
  }
}
