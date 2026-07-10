import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';

/// Returns all configured servers.
@injectable
class ListServers implements UseCase<NoParams, List<ServerConfig>> {
  ListServers(this._repository);

  final ServerConfigRepository _repository;

  @override
  Future<Result<List<ServerConfig>>> call(NoParams params) {
    return _repository.getAll();
  }
}
