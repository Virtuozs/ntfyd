import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';

/// Marks the server identified by [String] (the server id) as the
/// default, clearing `isDefault` on all other servers.
@injectable
class SetDefaultServer implements UseCase<String, void> {
  SetDefaultServer(this._repository);

  final ServerConfigRepository _repository;

  @override
  Future<Result<void>> call(String params) {
    return _repository.setDefault(params);
  }
}
