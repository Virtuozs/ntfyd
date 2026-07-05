import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ntfyd/core/error/failures.dart';

part 'publish_state.freezed.dart';

@freezed
sealed class PublishState with _$PublishState {
  const factory PublishState.idle() = PublishIdle;

  const factory PublishState.submitting() = PublishSubmitting;

  const factory PublishState.success() = PublishSuccess;

  const factory PublishState.error({required Failure failure}) = PublishError;
}
