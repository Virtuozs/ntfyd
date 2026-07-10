import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/domain/usecases/add_server.dart';
import 'package:ntfyd/features/server_config/domain/usecases/edit_credentials.dart';
import 'package:ntfyd/features/server_config/presentation/credential_from_fields.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_add_edit_state.dart';

@injectable
class ServerAddEditCubit extends Cubit<ServerAddEditState> {
  ServerAddEditCubit(this._addServer, this._editCredentials)
      : super(const ServerAddEditState.idle());

  final AddServer _addServer;
  final EditCredentials _editCredentials;

  Future<void> addServer({
    required String url,
    String? user,
    String? password,
  }) async {
    if (state is ServerAddEditValidating) return;
    emit(const ServerAddEditState.validating());

    final normalizedUrl = ServerConfig.normalizeBaseUrlInput(url);
    final (authType, credential) =
        credentialFromFields(user: user, password: password);

    final result = await _addServer.call(
      AddServerParams(
        baseUrl: normalizedUrl,
        authType: authType,
        credential: credential,
      ),
    );

    if (result.isSuccess) {
      emit(const ServerAddEditState.success());
    } else {
      emit(ServerAddEditState.error(failure: result.failureOrThrow));
    }
  }

  Future<void> editCredentials({
    required String serverId,
    String? user,
    String? password,
  }) async {
    if (state is ServerAddEditValidating) return;
    emit(const ServerAddEditState.validating());

    final (_, credential) = credentialFromFields(user: user, password: password);

    final result = await _editCredentials.call(
      EditCredentialsParams(serverId: serverId, credential: credential),
    );

    if (result.isSuccess) {
      emit(const ServerAddEditState.success());
    } else {
      emit(ServerAddEditState.error(failure: result.failureOrThrow));
    }
  }
}
