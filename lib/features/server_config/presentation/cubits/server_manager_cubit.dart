import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/server_config/domain/usecases/list_servers.dart';
import 'package:ntfyd/features/server_config/domain/usecases/remove_server.dart';
import 'package:ntfyd/features/server_config/domain/usecases/set_default_server.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_manager_state.dart';

@injectable
class ServerManagerCubit extends Cubit<ServerManagerState> {
  ServerManagerCubit(
    this._listServers,
    this._removeServer,
    this._setDefaultServer,
  ) : super(const ServerManagerState.loading());

  final ListServers _listServers;
  final RemoveServer _removeServer;
  final SetDefaultServer _setDefaultServer;

  Future<void> load() async {
    emit(const ServerManagerState.loading());
    final result = await _listServers.call(const NoParams());
    if (result.isSuccess) {
      emit(ServerManagerState.loaded(result.valueOrThrow));
    } else {
      emit(ServerManagerState.error(failure: result.failureOrThrow));
    }
  }

  Future<void> remove(String id) async {
    final result = await _removeServer.call(id);
    if (result.isSuccess) {
      await load();
    } else {
      emit(ServerManagerState.error(failure: result.failureOrThrow));
    }
  }

  Future<void> setDefault(String id) async {
    final result = await _setDefaultServer.call(id);
    if (result.isSuccess) {
      await load();
    } else {
      emit(ServerManagerState.error(failure: result.failureOrThrow));
    }
  }
}
