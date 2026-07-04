import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/secure_storage/server_credential.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/domain/usecases/add_server.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_form_state.dart';

/// Drives the first-run login facade (D14: health-only validation on
/// Connect; credential validation deferred to first subscribe).
@injectable
class ServerFormCubit extends Cubit<ServerFormState> {
  ServerFormCubit(this._addServer) : super(const ServerFormState.idle());

  final AddServer _addServer;

  /// Normalizes [url], derives an [AuthType]/[ServerCredential] from
  /// [user]/[password] (blank → anonymous, otherwise → Basic auth), and
  /// delegates to [AddServer] (which performs health validation per D14).
  ///
  /// No-op if a connect attempt is already in progress.
  Future<void> connect({
    required String url,
    String? user,
    String? password,
  }) async {
    if (state is ServerFormValidating) return;

    emit(const ServerFormState.validating());

    final normalizedUrl = ServerConfig.normalizeBaseUrlInput(url);
    final (authType, credential) = _buildCredential(user, password);

    final result = await _addServer.call(
      AddServerParams(
        baseUrl: normalizedUrl,
        authType: authType,
        credential: credential,
      ),
    );

    switch (result) {
      case Success<void>():
        emit(ServerFormState.success(baseUrl: normalizedUrl));
      case Err<void>(failure: final failure):
        emit(ServerFormState.error(failure: failure));
    }
  }

  /// Blank username AND password → anonymous (NoAuth/none).
  /// Otherwise → Basic auth, using empty string for any unset field.
  (AuthType, ServerCredential) _buildCredential(
      String? user,
      String? password,
      ) {
    final trimmedUser = user?.trim() ?? '';
    final trimmedPassword = password?.trim() ?? '';

    if (trimmedUser.isEmpty && trimmedPassword.isEmpty) {
      return (AuthType.none, const ServerCredential.noAuth());
    }

    return (
    AuthType.basic,
    ServerCredential.basicAuth(
      username: trimmedUser,
      password: trimmedPassword,
    ),
    );
  }
}