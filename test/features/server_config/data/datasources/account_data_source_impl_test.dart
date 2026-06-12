import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/network/ntfy_http_client.dart';
import 'package:ntfyd/core/secure_storage/server_credential.dart';
import 'package:ntfyd/features/server_config/data/datasources/account_data_source_impl.dart';

class _MockAdapter implements HttpClientAdapter {
  late Future<ResponseBody> Function(RequestOptions) handler;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => handler(options);
}

ResponseBody _jsonResponse(int statusCode, Map<String, dynamic> json) {
  final bytes = Stream<Uint8List>.fromIterable([
    Uint8List.fromList(utf8.encode(jsonEncode(json))),
  ]);
  return ResponseBody(
    bytes,
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

void main() {
  late _MockAdapter adapter;
  late Dio dio;

  setUp(() {
    adapter = _MockAdapter();
    dio = Dio(BaseOptions(validateStatus: (s) => s != null && s < 400))
      ..httpClientAdapter = adapter;
  });

  group('AccountDataSourceImpl', () {
    test('getAccount parses 200 response into AccountDto', () async {
      adapter.handler = (options) async {
        expect(options.path, '/v1/account');
        expect(options.headers['Authorization'], 'Basic dXNlcjpwYXNz');
        return _jsonResponse(200, {'username': 'user', 'role': 'user'});
      };

      final source = AccountDataSourceImpl(
        clientFactory: (baseUrl, cred) =>
            NtfyHttpClient(baseUrl: baseUrl, credential: cred, dio: dio),
      );

      final dto = await source.getAccount(
        'https://example.com',
        const ServerCredential.basicAuth(username: 'user', password: 'pass'),
      );

      expect(dto.username, 'user');
      expect(dto.role, 'user');
    });

    test('getAccount throws DioException on 401', () async {
      adapter.handler = (_) async =>
          _jsonResponse(401, {'code': 40101, 'error': 'unauthorized'});

      final source = AccountDataSourceImpl(
        clientFactory: (baseUrl, cred) =>
            NtfyHttpClient(baseUrl: baseUrl, credential: cred, dio: dio),
      );

      expect(
        () => source.getAccount(
          'https://example.com',
          const ServerCredential.basicAuth(username: 'bad', password: 'creds'),
        ),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'statusCode',
            401,
          ),
        ),
      );
    });

    test('getAccount throws DioException on 403', () async {
      adapter.handler = (_) async =>
          _jsonResponse(403, {'code': 40301, 'error': 'forbidden'});

      final source = AccountDataSourceImpl(
        clientFactory: (baseUrl, cred) =>
            NtfyHttpClient(baseUrl: baseUrl, credential: cred, dio: dio),
      );

      expect(
        () => source.getAccount(
          'https://example.com',
          const ServerCredential.bearerToken(token: 'tk_invalid'),
        ),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'statusCode',
            403,
          ),
        ),
      );
    });

    test('getAccount sends Bearer auth header for bearer tokens', () async {
      adapter.handler = (options) async {
        expect(options.headers['Authorization'], 'Bearer tk_abc123');
        return _jsonResponse(200, {'username': 'phil', 'role': 'admin'});
      };

      final source = AccountDataSourceImpl(
        clientFactory: (baseUrl, cred) =>
            NtfyHttpClient(baseUrl: baseUrl, credential: cred, dio: dio),
      );

      final dto = await source.getAccount(
        'https://example.com',
        const ServerCredential.bearerToken(token: 'tk_abc123'),
      );

      expect(dto.role, 'admin');
    });

    test('getAccount sends no Authorization header for anonymous', () async {
      adapter.handler = (options) async {
        expect(options.headers.containsKey('Authorization'), false);
        return _jsonResponse(200, {'username': '', 'role': 'anonymous'});
      };

      final source = AccountDataSourceImpl(
        clientFactory: (baseUrl, cred) =>
            NtfyHttpClient(baseUrl: baseUrl, credential: cred, dio: dio),
      );

      final dto = await source.getAccount(
        'https://example.com',
        const ServerCredential.noAuth(),
      );

      expect(dto.role, 'anonymous');
    });
  });
}
