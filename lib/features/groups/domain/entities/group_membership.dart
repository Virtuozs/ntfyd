import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_membership.freezed.dart';

/// A single (serverId, topic) a [Group] includes. Named distinctly from
/// Drift's generated `GroupMember` row class (same simple name, different
/// type) to avoid a collision when both are in scope.
@freezed
abstract class GroupMembership with _$GroupMembership {
  const factory GroupMembership({
    required String serverId,
    required String topic,
  }) = _GroupMembership;
}
