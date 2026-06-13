import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/network/ntfy_http_client.dart';
import 'package:ntfyd/features/server_config/data/datasources/health_data_source.dart';
import 'package:ntfyd/features/server_config/data/models/health_dto.dart';

/// Constructs an [NtfyHttpClient] scoped to a single [baseUrl], with no
/// stored credentials. Injectable-friendly wrapper around a factory
/// function (bare function types can't be DI-registered directly).
@lazySingleton
class NtfyHttpClientFactory {
  NtfyHttpClient call(String baseUrl) => NtfyHttpClient(baseUrl: baseUrl);
}

/// Dio-backed implementation of [HealthDataSource].
///
/// Calls `GET {baseUrl}/v1/health`. No authentication is sent — per D14,
/// the Connect flow validates reachability only.
/// Constructs a new [NtfyHttpClient] per [checkHealth] call (via [_clientFactory]) because each call may target a different server.
@LazySingleton(as: HealthDataSource)
class HealthDataSourceImpl implements HealthDataSource {
  HealthDataSourceImpl(this._clientFactory);

  final NtfyHttpClientFactory _clientFactory;

  @override
  Future<HealthDto> checkHealth(String baseUrl) async {
    final client = _clientFactory(baseUrl);
    final response = await client.get<Map<String, dynamic>>('/v1/health');
    return HealthDto.fromJson(response.data!);
  }
}
