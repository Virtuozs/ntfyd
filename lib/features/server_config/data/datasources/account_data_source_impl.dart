import 'package:ntfyd/core/network/ntfy_http_client.dart';
import 'package:ntfyd/core/secure_storage/server_credential.dart';
import 'package:ntfyd/features/server_config/data/datasources/account_data_source.dart';
import 'package:ntfyd/features/server_config/data/models/account_dto.dart';

/// Factory signature for constructing an [NtfyHttpClient] scoped to a single [baseUrl] + [ServerCredential] pair.
typedef NtfyAuthHttpClientFactory =
    NtfyHttpClient Function(String baseUrl, ServerCredential credential);

/// Dio-backed implementation of [AccountDataSource].
///
/// Calls `GET {baseUrl}/v1/account` with the given [ServerCredential]  attached via the `Authorization` header.
/// Constructs a new [NtfyHttpClient] per [getAccount] call (via [_clientFactory]) because each call may target a different server with different credentials.
///
/// Registered for DI via [ServerConfigModule.accountDataSource] rather than
/// a class-level `@LazySingleton` annotation: `injectable` cannot resolve
/// the bare `NtfyAuthHttpClientFactory` (`Function`-typed) constructor
/// param, even though it's optional, so the module provides this class
/// using its default (production) factory instead.
class AccountDataSourceImpl implements AccountDataSource {
  AccountDataSourceImpl({NtfyAuthHttpClientFactory? clientFactory})
    : _clientFactory =
          clientFactory ??
          ((baseUrl, credential) =>
              NtfyHttpClient(baseUrl: baseUrl, credential: credential));

  final NtfyAuthHttpClientFactory _clientFactory;

  @override
  Future<AccountDto> getAccount(String baseUrl, ServerCredential cred) async {
    final client = _clientFactory(baseUrl, cred);
    final response = await client.get<Map<String, dynamic>>('/v1/account');
    return AccountDto.fromJson(response.data!);
  }
}
