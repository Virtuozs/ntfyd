import 'package:ntfyd/core/secure_storage/server_credential.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';

/// Blank username AND password -> anonymous (NoAuth/none).
/// Otherwise -> Basic auth, using empty string for any unset field.
(AuthType, ServerCredential) credentialFromFields({
  String? user,
  String? password,
}) {
  final trimmedUser = user?.trim() ?? '';
  final trimmedPassword = password?.trim() ?? '';

  if (trimmedUser.isEmpty && trimmedPassword.isEmpty) {
    return (AuthType.none, const ServerCredential.noAuth());
  }

  return (
    AuthType.basic,
    ServerCredential.basicAuth(
      username: trimmedUser,
      password: trimmedPassword,
    ),
  );
}
