import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/secure_storage/server_credential.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';

/// Input parameters for [EditCredentials].
class EditCredentialsParams {
  const EditCredentialsParams({
    required this.serverId,
    required this.credential,
  });

  final String serverId;
  final ServerCredential credential;
}

/// Overwrites the stored credential for the server identified by
/// [EditCredentialsParams.serverId].
@injectable
class EditCredentials implements UseCase<EditCredentialsParams, void> {
  EditCredentials(this._repository);

  final ServerConfigRepository _repository;
  @override
  Future<Result<void>> call(EditCredentialsParams params) {
    return _repository.editCredentials(params.serverId, params.credential);
  }
}
