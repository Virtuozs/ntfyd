import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';

/// Removes the server identified by [String] (the server id) and its vault entry.
///
/// If the removed server was the default, reassigns `isDefault` to the
/// first remaining server (if any).
class RemoveServer implements UseCase<String, void> {
  RemoveServer(this._repository);

  final ServerConfigRepository _repository;

  @override
  Future<Result<void>> call(String serverId) async {
    final allResult = await _repository.getAll();
    if (!allResult.isSuccess) {
      return Result.err(allResult.failureOrThrow);
    }
    final servers = allResult.valueOrThrow;

    final target = servers.where((s) => s.id == serverId).firstOrNull;
    final wasDefault = target?.isDefault ?? false;

    // 2. Remove the target server + its vault entry.
    final removeResult = await _repository.remove(serverId);
    if (!removeResult.isSuccess) {
      return Result.err(removeResult.failureOrThrow);
    }

    // 3. Reassign default if needed.
    if (wasDefault) {
      final remaining = servers.where((s) => s.id != serverId).toList();
      if (remaining.isNotEmpty) {
        return _repository.setDefault(remaining.first.id);
      }
    }

    return const Result.success(null);
  }
}
