import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/error/exception_mapper.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/server_config/data/datasources/health_data_source.dart';
import 'package:ntfyd/features/server_config/data/models/health_dto.dart';

/// Validates that a server is reachable via `GET /v1/health` (D14:
/// health-only validation on Connect; credential validation is deferred to first subscribe).
@injectable
class ValidateServerHealth implements UseCase<String, HealthDto> {
  ValidateServerHealth(this._healthDataSource);

  final HealthDataSource _healthDataSource;

  /// [params] is the server's baseUrl.
  @override
  Future<Result<HealthDto>> call(String params) async {
    try {
      final dto = await _healthDataSource.checkHealth(params);
      return Result.success(dto);
    } catch (e) {
      return Result.err(ExceptionMapper.map(e));
    }
  }
}
