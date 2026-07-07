import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';

part 'group_feed_state.freezed.dart';

@freezed
sealed class GroupFeedState with _$GroupFeedState {
  const factory GroupFeedState.loading() = GroupFeedLoading;
  const factory GroupFeedState.error({required Failure failure}) = GroupFeedError;
  const factory GroupFeedState.loaded({
    required List<NotificationMessage> messages,
  }) = GroupFeedLoaded;
}
