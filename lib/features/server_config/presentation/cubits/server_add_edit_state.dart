import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ntfyd/core/error/failures.dart';

part 'server_add_edit_state.freezed.dart';

@freezed
sealed class ServerAddEditState with _$ServerAddEditState {
  const factory ServerAddEditState.idle() = ServerAddEditIdle;
  const factory ServerAddEditState.validating() = ServerAddEditValidating;
  const factory ServerAddEditState.success() = ServerAddEditSuccess;
  const factory ServerAddEditState.error({required Failure failure}) =
      ServerAddEditError;
}
