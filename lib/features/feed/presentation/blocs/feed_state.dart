import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/features/feed/domain/entities/feed_connection_state.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';

part 'feed_state.freezed.dart';

@freezed
sealed class FeedState with _$FeedState {
  const factory FeedState.loading() = FeedLoading;

  const factory FeedState.loaded({
    required List<NotificationMessage> messages,
    required FeedConnectionState connectionState,
  }) = FeedLoaded;

  const factory FeedState.error({required Failure failure}) = FeedError;
}
