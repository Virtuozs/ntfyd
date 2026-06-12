import 'package:ntfyd/core/database/app_database.dart';

/// Join result returned by [GroupDao.watchAll].
///
/// Plain Dart class — not a Freezed value object, since it's a
/// query-result aggregate, not a domain entity.
class GroupWithMembers {
  const GroupWithMembers({required this.group, required this.members});

  final Group group;
  final List<GroupMember> members;
}
