import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ntfyd/core/secure_storage/secure_credential_vault.dart';
import 'package:ntfyd/core/secure_storage/server_credential.dart';

const _basicPrefix = 'basic:';
const _bearerPrefix = 'bearer:';

class FlutterSecureCredentialVault implements SecureCredentialVault {
  FlutterSecureCredentialVault(this._storage);

  final FlutterSecureStorage _storage;

  static const _keyPrefix = 'ntfyd_cred_';
  @override
  Future<void> delete(String ref) async {
    await _storage.delete(key: _storageKey(ref));
  }

  @override
  Future<void> deleteAll() async {
    final all = await _storage.readAll();
    for (final key in all.keys) {
      if (key.startsWith(_keyPrefix)) {
        await _storage.delete(key: key);
      }
    }
  }

  @override
  Future<ServerCredential?> retrieve(String ref) async {
    final raw = await _storage.read(key: _storageKey(ref));
    if (raw == null) return const ServerCredential.noAuth();

    if (raw.startsWith(_basicPrefix)) {
      final encoded = raw.substring(_basicPrefix.length);
      final parts = _decodeBasic(encoded);
      if (parts == null) return const ServerCredential.noAuth();
      return ServerCredential.basicAuth(
        username: parts.username,
        password: parts.password,
      );
    }

    if (raw.startsWith(_bearerPrefix)) {
      final token = raw.substring(_bearerPrefix.length);
      return ServerCredential.bearerToken(token: token);
    }

    // Malformed / unknown format for fail safe.
    return const ServerCredential.noAuth();
  }

  @override
  Future<void> store(String ref, ServerCredential cred) async {
    final key = _storageKey(ref);
    await cred.when(
      noAuth: () => _storage.delete(key: key),
      basicAuth: (username, password) {
        final encoded = _encodeBasic(username, password);
        return _storage.write(key: key, value: '$_basicPrefix$encoded');
      },
      bearerToken: (token) =>
          _storage.write(key: key, value: '$_bearerPrefix$token'),
    );
  }

  String _storageKey(String ref) => '$_keyPrefix$ref';

  String _encodeBasic(String username, String password) =>
      base64.encode(utf8.encode('$username:$password'));

  ({String username, String password})? _decodeBasic(String encoded) {
    try {
      final decoded = utf8.decode(base64.decode(encoded));
      final colonIndex = decoded.indexOf(':');
      if (colonIndex < 0) return null;
      return (
        username: decoded.substring(0, colonIndex),
        password: decoded.substring(colonIndex + 1),
      );
    } catch (_) {
      return null;
    }
  }
}
