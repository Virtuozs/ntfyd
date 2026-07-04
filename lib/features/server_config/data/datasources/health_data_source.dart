import 'package:dio/dio.dart';

import 'package:ntfyd/features/server_config/data/models/health_dto.dart';

/// Checks reachability of an ntfy server via `GET /v1/health`.
/// Simple Stub => Full implementation (Dio-backed) will be implemented later.
abstract class HealthDataSource {
  /// Throws a [DioException] on network/HTTP errors; [ValidateServerHealth]
  /// is responsible for mapping these to typed [Failure]s via [ExceptionMapper].
  Future<HealthDto> checkHealth(String baseUrl);
}
