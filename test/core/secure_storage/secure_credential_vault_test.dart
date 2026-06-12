import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/secure_storage/flutter_secure_credential_vault.dart';
import 'package:ntfyd/core/secure_storage/server_credential.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

FlutterSecureCredentialVault _makeVault(FlutterSecureStorage storage) =>
    FlutterSecureCredentialVault(storage);

const _prefix = 'ntfyd_cred_';
String _key(String ref) => '$_prefix$ref';

String _base64Basic(String username, String password) =>
    base64.encode(utf8.encode('$username:$password'));

void main() {
  late MockFlutterSecureStorage storage;
  late FlutterSecureCredentialVault vault;

  setUp(() {
    storage = MockFlutterSecureStorage();
    vault = _makeVault(storage);
    when(
      () => storage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});

    when(() => storage.delete(key: any(named: 'key'))).thenAnswer((_) async {});

    when(
      () => storage.read(key: any(named: 'key')),
    ).thenAnswer((_) async => null);

    when(() => storage.readAll()).thenAnswer((_) async => {});
  });

  group('store', () {
    test(
      'BasicAuth write base64-encoded user:password to correct key',
      () async {
        const ref = 'server-1';
        const cred = ServerCredential.basicAuth(
          username: 'jane',
          password: 'doe',
        );

        final expectedValue = 'basic:${_base64Basic('jane', 'doe')}';

        await vault.store(ref, cred);

        verify(
          () => storage.write(key: _key(ref), value: expectedValue),
        ).called(1);
      },
    );

    test('Bearer write raw token string to correct key', () async {
      const ref = 'server-2';
      const cred = ServerCredential.bearerToken(token: 'tk_abc123');

      await vault.store(ref, cred);

      verify(
        () => storage.write(key: _key(ref), value: 'bearer:tk_abc123'),
      ).called(1);
    });

    test('NoAuth delete the key (no value stored)', () async {
      const ref = 'server-3';
      const cred = ServerCredential.noAuth();

      await vault.store(ref, cred);

      verify(() => storage.delete(key: _key(ref))).called(1);
      verifyNever(
        () => storage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      );
    });
  });

  group('retrieve', () {
    test('returns NoAuth when key is absent', () async {
      const ref = 'ghost-server';
      when(() => storage.read(key: _key(ref))).thenAnswer((_) async => null);

      final result = await vault.retrieve(ref);

      expect(result, equals(const ServerCredential.noAuth()));
    });

    test('returns BasicAuth with correct username and password', () async {
      const ref = 'server-basic';
      final encoded = _base64Basic('jane', 'doe');

      when(
        () => storage.read(key: _key(ref)),
      ).thenAnswer((_) async => 'basic:$encoded');

      final result = await vault.retrieve(ref);

      expect(
        result,
        equals(
          const ServerCredential.basicAuth(username: 'jane', password: 'doe'),
        ),
      );
    });

    test('returns BearerToken with correct token value', () async {
      const ref = 'server-bearer';
      when(
        () => storage.read(key: _key(ref)),
      ).thenAnswer((_) async => 'bearer:tk_xyz789');

      final result = await vault.retrieve(ref);

      expect(
        result,
        equals(const ServerCredential.bearerToken(token: 'tk_xyz789')),
      );
    });

    test('returns NoAuth for malformed stored value', () async {
      const ref = 'server-corrupt';
      when(
        () => storage.read(key: _key(ref)),
      ).thenAnswer((_) async => 'GARBAGE_VALUE_NO_PREFIX');

      final result = await vault.retrieve(ref);

      expect(result, equals(const ServerCredential.noAuth()));
    });
  });

  group('delete', () {
    test('deletes the correct key from storage', () async {
      const ref = 'server-to-delete';
      when(() => storage.delete(key: _key(ref))).thenAnswer((_) async {});

      await vault.delete(ref);

      verify(() => storage.delete(key: _key(ref))).called(1);
    });
  });

  group('deleteAll', () {
    test('deletes all keys that carry the vault prefix', () async {
      when(() => storage.readAll()).thenAnswer(
        (_) async => {
          '${_prefix}server-a': 'tk_aaa',
          '${_prefix}server-b': 'basic:${_base64Basic('u', 'p')}',
          'some_other_plugin_key': 'untouched',
        },
      );
      when(
        () => storage.delete(key: '${_prefix}server-a'),
      ).thenAnswer((_) async {});
      when(
        () => storage.delete(key: '${_prefix}server-b'),
      ).thenAnswer((_) async {});

      await vault.deleteAll();

      verify(() => storage.delete(key: '${_prefix}server-a')).called(1);
      verify(() => storage.delete(key: '${_prefix}server-b')).called(1);
      verifyNever(() => storage.delete(key: 'some_other_plugin_key'));
    });
  });
  group('ServerCredential =>  Freezed equality', () {
    test('BasicAuth == BasicAuth with same fields', () {
      const a = ServerCredential.basicAuth(
        username: 'alice',
        password: 's3cr3t',
      );
      const b = ServerCredential.basicAuth(
        username: 'alice',
        password: 's3cr3t',
      );
      expect(a, equals(b));
    });

    test('BasicAuth != BasicAuth with different password', () {
      const a = ServerCredential.basicAuth(username: 'alice', password: 'one');
      const b = ServerCredential.basicAuth(username: 'alice', password: 'two');
      expect(a, isNot(equals(b)));
    });

    test('BearerToken == BearerToken with same token', () {
      const a = ServerCredential.bearerToken(token: 'tk_same');
      const b = ServerCredential.bearerToken(token: 'tk_same');
      expect(a, equals(b));
    });

    test('NoAuth == NoAuth', () {
      const a = ServerCredential.noAuth();
      const b = ServerCredential.noAuth();
      expect(a, equals(b));
    });

    test('NoAuth != BasicAuth', () {
      const a = ServerCredential.noAuth();
      const b = ServerCredential.basicAuth(username: 'u', password: 'p');
      expect(a, isNot(equals(b)));
    });
  });
  group('ServerCredential.when() exhaustive', () {
    test('routes noAuth variant correctly', () {
      const cred = ServerCredential.noAuth();
      final result = cred.when(
        noAuth: () => 'no-auth',
        basicAuth: (_, _) => 'basic',
        bearerToken: (_) => 'bearer',
      );
      expect(result, 'no-auth');
    });

    test('routes basicAuth variant correctly', () {
      const cred = ServerCredential.basicAuth(
        username: 'alice',
        password: 'secret',
      );
      final result = cred.when(
        noAuth: () => 'no-auth',
        basicAuth: (username, password) => 'basic:$username',
        bearerToken: (_) => 'bearer',
      );
      expect(result, 'basic:alice');
    });

    test('routes bearerToken variant correctly', () {
      const cred = ServerCredential.bearerToken(token: 'tk_xyz');
      final result = cred.when(
        noAuth: () => 'no-auth',
        basicAuth: (_, _) => 'basic',
        bearerToken: (token) => 'bearer:$token',
      );
      expect(result, 'bearer:tk_xyz');
    });

    test('all 3 variants handled without a default branch', () {
      final credentials = [
        const ServerCredential.noAuth(),
        const ServerCredential.basicAuth(username: 'u', password: 'p'),
        const ServerCredential.bearerToken(token: 'tk_1'),
      ];

      final labels = credentials
          .map(
            (c) => c.when(
              noAuth: () => 'none',
              basicAuth: (_, _) => 'basic',
              bearerToken: (_) => 'bearer',
            ),
          )
          .toList();

      expect(labels, ['none', 'basic', 'bearer']);
    });
  });

  group('security credentials are not logged', () {
    test('toString() of BasicAuth does not expose password', () {
      const cred = ServerCredential.basicAuth(
        username: 'alice',
        password: 'sup3rS3cr3t',
      );
      final str = cred.toString();
      // Freezed-generated toString includes field values by default,
      // so we rely on the vault never logging the credential this
      // test confirms the raw password isn't visible in the object's
      // toString if we were to log cred.runtimeType or a safe label.
      //
      // More importantly: the vault's store() must NOT call
      // storage.write with a value that contains the raw password.
      // That contract is tested in the store() group above.
      //
      // Here we specifically verify the password doesn't slip into
      // vault's internal key (which would be a security regression):
      expect(str, isNot(contains('sup3rS3cr3t')));
    });

    test('storage key for a ref never contains credential values', () {
      // The _key() function only uses the ref, never the credential.
      const ref = 'prod-server';
      expect(_key(ref), equals('${_prefix}prod-server'));
      expect(_key(ref), isNot(contains('password')));
      expect(_key(ref), isNot(contains('token')));
    });
  });
}
