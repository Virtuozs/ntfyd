import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_feed_event.freezed.dart';

@freezed
sealed class GroupFeedEvent with _$GroupFeedEvent {
  const factory GroupFeedEvent.load({String? groupId}) = GroupFeedLoad;
  const factory GroupFeedEvent.toggleRead({
    required String serverId,
    required String id,
  }) = GroupFeedToggleRead;
  const factory GroupFeedEvent.togglePin({
    required String serverId,
    required String id,
  }) = GroupFeedTogglePin;
}
