import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ntfyd/core/database/value_objects/message_filter.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/groups/domain/entities/group_membership.dart';

part 'group.freezed.dart';

/// A user-defined cross-server collection of topics (UI label: "Tag";
/// Base-Plan D8/FR9). [color] is a Flutter `Color`'s raw ARGB int
/// (`Color.toARGB32()`), matching `groups_table.dart`'s `IntColumn`.
@freezed
abstract class Group with _$Group {
  const factory Group({
    required String id,
    required String name,
    int? color,
    @Default({}) Set<GroupMembership> members,
    MessageFilter? filter,
    @Default(0) int sortOrder,
  }) = _Group;

  const Group._();

  /// Validates a candidate [Group], returning a [Result] containing either
  /// a valid [Group] or a [Failure.validation]. Mirrors
  /// `Subscription.validate`'s shape.
  static Result<Group> validate({
    required String id,
    required String name,
    int? color,
    Set<GroupMembership> members = const {},
    MessageFilter? filter,
    int sortOrder = 0,
  }) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return const Result.err(
        Failure.validation(field: 'name', message: 'name must not be empty'),
      );
    }

    return Result.success(
      Group(
        id: id,
        name: trimmedName,
        color: color,
        members: members,
        filter: filter,
        sortOrder: sortOrder,
      ),
    );
  }
}
