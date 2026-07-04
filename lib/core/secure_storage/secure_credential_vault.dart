import 'package:ntfyd/core/secure_storage/server_credential.dart';

abstract class SecureCredentialVault {
  /// Persists [cred] under [ref].
  /// A [NoAuth] credential removes any existing entry for [ref].
  Future<void> store(String ref, ServerCredential cred);

  /// Returns the [ServerCredential] stored under [ref], or [NoAuth] if absent.
  Future<ServerCredential?> retrieve(String ref);

  Future<void> delete(String ref);

  Future<void> deleteAll();
}
