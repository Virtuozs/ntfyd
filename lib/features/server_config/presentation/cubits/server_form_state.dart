import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ntfyd/core/error/failures.dart';

part 'server_form_state.freezed.dart';

@freezed
sealed class ServerFormState with _$ServerFormState {
  const factory ServerFormState.idle() = ServerFormIdle;
  const factory ServerFormState.validating() = ServerFormValidating;
  const factory ServerFormState.success() = ServerFormSuccess;
  const factory ServerFormState.error({required Failure failure}) =
      ServerFormError;
}
