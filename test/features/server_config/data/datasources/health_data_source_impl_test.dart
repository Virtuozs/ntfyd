import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/network/ntfy_http_client.dart';
import 'package:ntfyd/features/server_config/data/datasources/health_data_source_impl.dart';
import 'package:ntfyd/features/server_config/data/models/health_dto.dart';

class MockNtfyHttpClient extends Mock implements NtfyHttpClient {}

class FakeNtfyHttpClientFactory implements NtfyHttpClientFactory {
  FakeNtfyHttpClientFactory(this._client, this._onCall);

  final NtfyHttpClient _client;
  final void Function(String baseUrl) _onCall;

  @override
  NtfyHttpClient call(String baseUrl) {
    _onCall(baseUrl);
    return _client;
  }
}

void main() {
  late MockNtfyHttpClient mockHttpClient;
  late HealthDataSourceImpl dataSource;
  late String? requestedBaseUrl;

  setUp(() {
    mockHttpClient = MockNtfyHttpClient();
    requestedBaseUrl = null;
    dataSource = HealthDataSourceImpl(
      FakeNtfyHttpClientFactory(mockHttpClient, (baseUrl) {
        requestedBaseUrl = baseUrl;
      }),
    );
  });

  group('HealthDataSourceImpl', () {
    test(
      'returns HealthDto(healthy: true) on 200 with {"healthy": true}',
      () async {
        when(
          () => mockHttpClient.get<Map<String, dynamic>>('/v1/health'),
        ).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(
            requestOptions: RequestOptions(path: '/v1/health'),
            statusCode: 200,
            data: {'healthy': true},
          ),
        );

        final result = await dataSource.checkHealth('https://ntfy.sh');

        expect(result, const HealthDto(healthy: true));
        expect(requestedBaseUrl, 'https://ntfy.sh');
      },
    );

    test(
      'returns HealthDto(healthy: false) on 200 with {"healthy": false}',
      () async {
        when(
          () => mockHttpClient.get<Map<String, dynamic>>('/v1/health'),
        ).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(
            requestOptions: RequestOptions(path: '/v1/health'),
            statusCode: 200,
            data: {'healthy': false},
          ),
        );

        final result = await dataSource.checkHealth('https://example.com');

        expect(result, const HealthDto(healthy: false));
        expect(requestedBaseUrl, 'https://example.com');
      },
    );

    test('propagates DioException on connection error', () async {
      when(
        () => mockHttpClient.get<Map<String, dynamic>>('/v1/health'),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/v1/health'),
          type: DioExceptionType.connectionError,
        ),
      );

      expect(
        () => dataSource.checkHealth('https://unreachable.example'),
        throwsA(isA<DioException>()),
      );
    });

    test(
      'propagates DioException on 500 response (validateStatus rejects it)',
      () async {
        when(
          () => mockHttpClient.get<Map<String, dynamic>>('/v1/health'),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/v1/health'),
            type: DioExceptionType.badResponse,
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: '/v1/health'),
              statusCode: 500,
            ),
          ),
        );

        expect(
          () => dataSource.checkHealth('https://example.com'),
          throwsA(isA<DioException>()),
        );
      },
    );
  });
}
