import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/features/feed/presentation/cubits/home_topic_summary.dart';

part 'home_feed_state.freezed.dart';

@freezed
sealed class HomeFeedState with _$HomeFeedState {
  const factory HomeFeedState.loading() = HomeFeedLoading;

  const factory HomeFeedState.loaded({required List<HomeTopicSummary> items}) =
      HomeFeedLoaded;

  const factory HomeFeedState.error({required Failure failure}) =
      HomeFeedError;
}
