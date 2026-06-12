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
/// Sets `isDefault: true` if this is the first server being added,
/// `false` otherwise.
class AddServer implements UseCase<AddServerParams, void> {
  AddServer(
    this._repository,
    this._validateServerHealth, {
    String Function()? idGenerator,
    DateTime Function()? now,
  }) : _idGenerator = idGenerator ?? (() => const Uuid().v4()),
       _now = now ?? DateTime.now;

  final ServerConfigRepository _repository;
  final ValidateServerHealth _validateServerHealth;
  final String Function() _idGenerator;
  final DateTime Function() _now;

  @override
  Future<Result<void>> call(AddServerParams params) async {
    final existingResult = await _repository.getAll();
    if (!existingResult.isSuccess) {
      return Result.err(existingResult.failureOrThrow);
    }
    final isFirstServer = existingResult.valueOrThrow.isEmpty;

    final id = _idGenerator();
    final credentialRef = params.authType == AuthType.none ? null : id;

    final validateResult = ServerConfig.validate(
      id: id,
      baseUrl: params.baseUrl,
      displayName: params.displayName,
      authType: params.authType,
      credentialRef: credentialRef,
      isDefault: isFirstServer,
      createdAt: _now(),
    );
    if (!validateResult.isSuccess) {
      return Result.err(validateResult.failureOrThrow);
    }
    final config = validateResult.valueOrThrow;

    final healthResult = await _validateServerHealth.call(config.baseUrl);
    if (!healthResult.isSuccess) {
      return Result.err(healthResult.failureOrThrow);
    }

    return _repository.add(config, params.credential);
  }
}
