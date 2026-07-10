import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';

part 'server_manager_state.freezed.dart';

@freezed
sealed class ServerManagerState with _$ServerManagerState {
  const factory ServerManagerState.loading() = ServerManagerLoading;

  const factory ServerManagerState.loaded(List<ServerConfig> servers) =
      ServerManagerLoaded;

  const factory ServerManagerState.error({required Failure failure}) =
      ServerManagerError;
}
