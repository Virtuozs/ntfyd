// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/error/exception_mapper.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/network/ntfy_http_client.dart';
import 'package:ntfyd/core/secure_storage/server_credential.dart';

class _MockAdapter implements HttpClientAdapter {
  late Future<ResponseBody> Function(RequestOptions) handler;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) => handler(options);
}

void main(){
  late _MockAdapter mockAdapter;

  ResponseBody _ok(String json) => ResponseBody.fromString(
    json, 
    200,
    headers: {
      Headers.contentTypeHeader: ['application/json'],
  });

  ResponseBody _error(int statusCode) => ResponseBody.fromString(
    '{"error": "test error"}',
    statusCode,
    headers: {
      Headers.contentTypeHeader: ['application/json'],
  });

  setUp(() {
    mockAdapter = _MockAdapter();
  });

  group('NtfyHttpClient => authentication header', () {
    test('No Auth attaches no Authorization header', () async {
      String? capturedAuthHeader;
      mockAdapter.handler = (options) async {
        capturedAuthHeader = options.headers['Authorization'] as String?;
        return _ok('{"healthy": true}');
      };

      final client = NtfyHttpClient(
        baseUrl: 'https://ntfy.sh',
        credential: const ServerCredential.noAuth(),
        dio: Dio()..httpClientAdapter = mockAdapter,
      );

      await client.get('/v1/health');
      
      expect(capturedAuthHeader, isNull);
    });

    test('BasicAuth attaches correct Base64 Authorization header', () async {
      String? capturedAuthHeader;
      mockAdapter.handler = (options) async {
        capturedAuthHeader = options.headers['Authorization'] as String?;
        return _ok('{"healthy": true}');
      };
      
      final client = NtfyHttpClient(
        baseUrl: 'https://nfty.sh',
        credential: const ServerCredential.basicAuth(
          username: 'jane',
          password: 'doe',),
        dio: Dio()..httpClientAdapter = mockAdapter
      );

      await client.get('/v1/health');

      expect(capturedAuthHeader, 'Basic amFuZTpkb2U=');
    });

    test('Bearer token attaches correct Bearer Authorization Header', () async {
      String? capturedAuthHeader;
      mockAdapter.handler = (options) async {
        capturedAuthHeader = options.headers['Authorization'] as String?;
        return _ok('{"healthy": true}');
      };

      final client = NtfyHttpClient(
        baseUrl: 'https://ntfy.sh',
        credential: const ServerCredential.bearerToken(
          token: 'tk_xyz213',
        ),
        dio: Dio()..httpClientAdapter = mockAdapter,
      );

      await client.get('/v1/health');

      expect(capturedAuthHeader, 'Bearer tk_xyz213');
    });

    test('Authorization header value is never a query parameters', () async {
      // NFR3: secrets must never appear in URLs (they appear in server logs). We verify the query string has no auth data.
      Uri? capturedUri;
      mockAdapter.handler = (options) async {
        capturedUri = options.uri;
        return _ok('{"health": true}');
      };

      final client = NtfyHttpClient(
        baseUrl: 'https://ntfy.sh',
        credential: const ServerCredential.basicAuth(
          username: 'jane',
          password: 'doe',
        ),
        dio: Dio()..httpClientAdapter = mockAdapter,
      );

      await client.get('/v1/health');

      final queryString = capturedUri?.query ?? '';
      expect(queryString.contains('jane'), isFalse);
      expect(queryString.contains('doe'), isFalse);
    });
  });

  group('NtfyHttpClient => Successful responses', () {
    test('GET returns response with status 200', () async {
      mockAdapter.handler = (_) async => _ok('{"healthy": true}');

      final client = NtfyHttpClient(
        baseUrl: 'https://ntfy.sh',
        dio: Dio()..httpClientAdapter = mockAdapter,
      );

      final response = await client.get('/v1/health');

      expect(response.statusCode, 200);
    });

    test('POST retrurn response with status 200', () async {
      mockAdapter.handler = (_) async => ResponseBody.fromString(
        '{"id":"abc123","time":1683000000,"event":"message","topic":"mytopic"}',
        200,
        headers: {
          Headers.contentTypeHeader: ['application/json'],
        },
      );

      final client = NtfyHttpClient(
        baseUrl: 'https://ntfy.sh',
        dio: Dio()..httpClientAdapter = mockAdapter,
      );

      final response = await client.post<Map<String, dynamic>>(
        '/mytopic',
        data: 'Hello world',
        options: Options(
          contentType: 'text/plain',
          responseType: ResponseType.json,
        ),
      );

      expect(response.statusCode, 200);

    });
  });

  group('NtfyHttpClient => error propagation', () {
    test('401 response throws DioException', () async {
      mockAdapter.handler = (_) async => _error(401);

      final client = NtfyHttpClient(
        baseUrl: 'https://ntfy.sh',
        dio: Dio()..httpClientAdapter = mockAdapter,
      );

      // We expect a DioException, not a raw 401 Response.
      // Repositories depend on this — they catch DioException
      // and call ExceptionMapper.map() on it.
      await expectLater(
        () => client.get('/v1/account'),
        throwsA(isA<DioException>()),
      );
    });

    test('500 response throws DioException', () async {
      mockAdapter.handler = (_) async => _error(500);

      final client = NtfyHttpClient(
        baseUrl: 'https://ntfy.sh',
        dio: Dio()..httpClientAdapter = mockAdapter,
      );

      await expectLater(
        () => client.get('/v1/health'),
        throwsA(isA<DioException>()),
      );
    });

    test('DioException from 401 maps to AuthFailure via ExceptionMapper', () async {
      // ARRANGE
      mockAdapter.handler = (_) async => _error(401);

      final client = NtfyHttpClient(
        baseUrl: 'https://ntfy.sh',
        dio: Dio()..httpClientAdapter = mockAdapter,
      );

      // This is how a repository will use NtfyHttpClient in practice:
      // catch the DioException and map it.
      Failure? mappedFailure;
      try {
        await client.get('/v1/account');
      } on DioException catch (e) {
        mappedFailure = ExceptionMapper.map(e);
      }

      expect(mappedFailure, isA<AuthFailure>());
      expect((mappedFailure as AuthFailure).statusCode, 401);
    });

    test('DioException from 429 maps to RateLimitFailure via ExceptionMapper',
        () async {
      mockAdapter.handler = (_) async => _error(429);

      final client = NtfyHttpClient(
        baseUrl: 'https://ntfy.sh',
        dio: Dio()..httpClientAdapter = mockAdapter,
      );

      Failure? mappedFailure;
      try {
        await client.get('/mytopic');
      } on DioException catch (e) {
        mappedFailure = ExceptionMapper.map(e);
      }

      expect(mappedFailure, isA<RateLimitFailure>());
    });
  });

  group('NtfyInterceptor => secrets never logged', () {
    test('logged request path does not contain credential value', () async {
      final loggedMessages = <String>[];

      mockAdapter.handler = (_) async => _ok('{"healthy": true}');

      final client = NtfyHttpClient(
        baseUrl: 'https://ntfy.sh',
        credential: const ServerCredential.basicAuth(
          username: 'alice',
          password: 's3cr3t',
        ),
        dio: Dio()..httpClientAdapter = mockAdapter,
        onLog: (message) => loggedMessages.add(message),
      );

      await client.get('/v1/health');

      // None of the log output should contain the raw password
      final allLogs = loggedMessages.join(' ');
      expect(allLogs.contains('s3cr3t'), isFalse);
      expect(allLogs.contains('YWxpY2U6czNjcjN0'), isFalse); // base64 too
    });
  });
}