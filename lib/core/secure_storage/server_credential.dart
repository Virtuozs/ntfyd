import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_credential.freezed.dart';

@freezed
sealed class ServerCredential with _$ServerCredential {
  const factory ServerCredential.noAuth() = NoAuth;

  const factory ServerCredential.basicAuth({
    required String username,
    required String password,
  }) = BasicAuth;

  const factory ServerCredential.bearerToken({
    required String token,
  }) = BearerToken;
}