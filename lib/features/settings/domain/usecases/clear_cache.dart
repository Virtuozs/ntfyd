import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/settings/domain/repositories/settings_repository.dart';

@injectable
class ClearCache implements UseCase<NoParams, void> {
  ClearCache(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Result<void>> call(NoParams params) => _repository.clearCache();
}
