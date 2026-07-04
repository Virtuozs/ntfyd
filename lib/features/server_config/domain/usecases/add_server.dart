import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/secure_storage/server_credential.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';
import 'package:ntfyd/features/server_config/domain/usecases/validate_server_health.dart';
import 'package:uuid/uuid.dart';

class AddServerParams {
  const AddServerParams({
    required this.baseUrl,
    this.displayName,
    required this.authType,
    required this.credential,
  });

  /// Raw or normalized base URL (caller is expected to have already run
  /// [ServerConfig.normalizeBaseUrlInput] on raw user input).
  final String baseUrl;

  /// Optional display name; falls back to host per [ServerConfig.validate].
  final String? displayName;

  final AuthType authType;

  /// The credential to store in the secure vault. For [AuthType.none]
  /// this should be [ServerCredential.noAuth].
  final ServerCredential credential;
}

/// Adds a new server: validates health (D14), then persists the
/// [ServerConfig] + [ServerCredential] via [ServerConfigRepository].
///
/// If a [ServerConfig] with the same [AddServerParams.baseUrl] already
/// exists (e.g. the user re-enters the same server on the login screen
/// after a restart), this updates that existing entry's credentials in
/// place rather than inserting a duplicate row — avoids violating the
/// `server_configs.base_url` unique constraint.
@injectable
class AddServer implements UseCase<AddServerParams, void> {
  AddServer(this._repository, this._validateServerHealth);

  final ServerConfigRepository _repository;
  final ValidateServerHealth _validateServerHealth;

  String Function() get _idGenerator =>
      AddServerTestHooks.idGenerator ?? (() => const Uuid().v4());

  DateTime Function() get _now => AddServerTestHooks.now ?? DateTime.now;

  @override
  Future<Result<void>> call(AddServerParams params) async {
    final existingResult = await _repository.getAll();
    if (!existingResult.isSuccess) {
      return Result.err(existingResult.failureOrThrow);
    }
    final existingServers = existingResult.valueOrThrow;
    final isFirstServer = existingServers.isEmpty;

    final existing = existingServers.cast<ServerConfig?>().firstWhere(
          (s) => s!.baseUrl == params.baseUrl,
      orElse: () => null,
    );

    final id = existing?.id ?? _idGenerator();
    final credentialRef = params.authType == AuthType.none ? null : id;

    final validateResult = ServerConfig.validate(
      id: id,
      baseUrl: params.baseUrl,
      displayName: params.displayName,
      authType: params.authType,
      credentialRef: credentialRef,
      isDefault: existing?.isDefault ?? isFirstServer,
      createdAt: existing?.createdAt ?? _now(),
    );
    if (!validateResult.isSuccess) {
      return Result.err(validateResult.failureOrThrow);
    }
    final config = validateResult.valueOrThrow;

    final healthResult = await _validateServerHealth.call(config.baseUrl);
    if (!healthResult.isSuccess) {
      return Result.err(healthResult.failureOrThrow);
    }

    if (existing != null &&
        existing.credentialRef != null &&
        credentialRef == null) {
      await _repository.editCredentials(
        id,
        const ServerCredential.noAuth(),
      );
    }

    return _repository.add(config, params.credential);
  }
}

/// Test-only seams for [AddServer]'s ID generation and clock.
///
/// Not part of the public domain API. Tests MUST reset both fields to
/// `null` in `tearDown` to avoid leaking state across tests.
class AddServerTestHooks {
  static String Function()? idGenerator;
  static DateTime Function()? now;
}