import 'package:ntfyd/core/secure_storage/server_credential.dart';
import 'package:ntfyd/features/server_config/data/models/account_dto.dart';

/// Validates credentials via `GET /v1/account
/// Used for first-subscribe credential validation: a 401/403 here means the stored credentials are invalid for this server.
abstract class AccountDataSource {
  /// Throws on network/HTTP errors (mapped to [Failure] by callers via
  /// [ExceptionMapper]). Returns the parsed account on 200.
  Future<AccountDto> getAccount(String baseUrl, ServerCredential cred);
}
