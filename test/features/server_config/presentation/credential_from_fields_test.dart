import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/secure_storage/server_credential.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';
import 'package:ntfyd/features/server_config/presentation/credential_from_fields.dart';

void main() {
  group('credentialFromFields', () {
    test('blank user and password -> AuthType.none / NoAuth', () {
      final (authType, credential) = credentialFromFields(
        user: '',
        password: '',
      );
      expect(authType, AuthType.none);
      expect(credential, const ServerCredential.noAuth());
    });

    test('null user and password -> AuthType.none / NoAuth', () {
      final (authType, credential) = credentialFromFields();
      expect(authType, AuthType.none);
      expect(credential, const ServerCredential.noAuth());
    });

    test('non-blank user/password -> AuthType.basic / BasicAuth', () {
      final (authType, credential) = credentialFromFields(
        user: 'alice',
        password: 'secret',
      );
      expect(authType, AuthType.basic);
      expect(
        credential,
        const ServerCredential.basicAuth(username: 'alice', password: 'secret'),
      );
    });

    test('whitespace-only user/password trims to blank -> none', () {
      final (authType, credential) = credentialFromFields(
        user: '  ',
        password: '  ',
      );
      expect(authType, AuthType.none);
      expect(credential, const ServerCredential.noAuth());
    });

    test('user set but password blank -> basic auth with empty password', () {
      final (authType, credential) = credentialFromFields(
        user: 'alice',
        password: '',
      );
      expect(authType, AuthType.basic);
      expect(
        credential,
        const ServerCredential.basicAuth(username: 'alice', password: ''),
      );
    });
  });
}
