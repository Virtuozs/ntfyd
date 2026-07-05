import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_event.freezed.dart';

@freezed
sealed class FeedEvent with _$FeedEvent {
  const factory FeedEvent.load({
    required String serverId,
    required String topic,
  }) = FeedLoad;

  const factory FeedEvent.refresh() = FeedRefresh;

  const factory FeedEvent.toggleRead({required String id}) = FeedToggleRead;

  const factory FeedEvent.togglePin({required String id}) = FeedTogglePin;
}
