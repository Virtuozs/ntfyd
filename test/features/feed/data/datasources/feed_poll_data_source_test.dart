import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/network/ntfy_http_client.dart';
import 'package:ntfyd/core/secure_storage/server_credential.dart';
import 'package:ntfyd/features/feed/data/datasources/feed_poll_data_source.dart';

class MockNtfyHttpClient extends Mock implements NtfyHttpClient {}

void main() {
  late MockNtfyHttpClient mockHttpClient;
  late String? requestedBaseUrl;
  late ServerCredential? requestedCredential;
  late FeedPollDataSource dataSource;

  setUp(() {
    mockHttpClient = MockNtfyHttpClient();
    requestedBaseUrl = null;
    requestedCredential = null;
    dataSource = FeedPollDataSource(
      clientFactory: (baseUrl, credential) {
        requestedBaseUrl = baseUrl;
        requestedCredential = credential;
        return mockHttpClient;
      },
    );
  });

  group('FeedPollDataSource.fetchHistory', () {
    test('parses newline-delimited JSON into a list of MessageDtos', () async {
      when(
        () => mockHttpClient.get<String>(
          '/alerts/json',
          queryParameters: {'poll': '1', 'since': 'msg-0'},
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response<String>(
          requestOptions: RequestOptions(path: '/alerts/json'),
          statusCode: 200,
          data:
              '{"id":"msg-1","time":100,"event":"message","topic":"alerts"}\n'
              '{"id":"msg-2","time":200,"event":"message","topic":"alerts"}\n',
        ),
      );

      final result = await dataSource.fetchHistory(
        baseUrl: 'https://ntfy.sh',
        topic: 'alerts',
        credential: const ServerCredential.noAuth(),
        since: 'msg-0',
      );

      expect(result, hasLength(2));
      expect(result[0].id, 'msg-1');
      expect(result[1].id, 'msg-2');
      expect(requestedBaseUrl, 'https://ntfy.sh');
      expect(requestedCredential, const ServerCredential.noAuth());
    });

    test('ignores blank lines around parseable lines', () async {
      when(
        () => mockHttpClient.get<String>(
          '/alerts/json',
          queryParameters: {'poll': '1', 'since': 'all'},
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response<String>(
          requestOptions: RequestOptions(path: '/alerts/json'),
          statusCode: 200,
          data:
              '\n{"id":"msg-1","time":100,"event":"keepalive","topic":"alerts"}\n\n',
        ),
      );

      final result = await dataSource.fetchHistory(
        baseUrl: 'https://ntfy.sh',
        topic: 'alerts',
        credential: const ServerCredential.noAuth(),
        since: 'all',
      );

      expect(result, hasLength(1));
      expect(result.first.event, 'keepalive');
    });

    test('returns an empty list for an empty response body', () async {
      when(
        () => mockHttpClient.get<String>(
          '/alerts/json',
          queryParameters: {'poll': '1', 'since': 'all'},
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response<String>(
          requestOptions: RequestOptions(path: '/alerts/json'),
          statusCode: 200,
          data: '',
        ),
      );

      final result = await dataSource.fetchHistory(
        baseUrl: 'https://ntfy.sh',
        topic: 'alerts',
        credential: const ServerCredential.noAuth(),
        since: 'all',
      );

      expect(result, isEmpty);
    });
  });
}
