import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ntfyd/core/network/ntfy_http_client.dart';
import 'package:ntfyd/core/secure_storage/server_credential.dart';
import 'package:ntfyd/features/feed/data/models/message_dto.dart';

typedef NtfyPollHttpClientFactory =
    NtfyHttpClient Function(String baseUrl, ServerCredential credential);

/// Fetches cached history for catch-up (`since=<id>`) or a full refresh
/// (`since=all`) via `GET /{topic}/json?poll=1&since=...`. The response
/// body is newline-delimited JSON (one object per line); each non-blank
/// line is parsed into a [MessageDto].
class FeedPollDataSource {
  FeedPollDataSource({NtfyPollHttpClientFactory? clientFactory})
    : _clientFactory =
          clientFactory ??
          ((baseUrl, credential) =>
              NtfyHttpClient(baseUrl: baseUrl, credential: credential));

  final NtfyPollHttpClientFactory _clientFactory;

  Future<List<MessageDto>> fetchHistory({
    required String baseUrl,
    required String topic,
    required ServerCredential credential,
    required String since,
  }) async {
    final client = _clientFactory(baseUrl, credential);
    final response = await client.get<String>(
      '/$topic/json',
      queryParameters: {'poll': '1', 'since': since},
      options: Options(responseType: ResponseType.plain),
    );

    final body = response.data ?? '';
    return body
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .map(
          (line) =>
              MessageDto.fromJson(jsonDecode(line) as Map<String, dynamic>),
        )
        .toList();
  }
}
