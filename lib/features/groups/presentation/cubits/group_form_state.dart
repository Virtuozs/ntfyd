import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/features/groups/domain/entities/group.dart';

part 'group_form_state.freezed.dart';

@freezed
sealed class GroupFormState with _$GroupFormState {
  const factory GroupFormState.idle() = GroupFormIdle;
  const factory GroupFormState.submitting() = GroupFormSubmitting;
  const factory GroupFormState.success({required Group group}) = GroupFormSuccess;
  const factory GroupFormState.error({required Failure failure}) = GroupFormError;
}
