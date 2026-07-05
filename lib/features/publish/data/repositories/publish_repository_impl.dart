import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ntfyd/core/error/exception_mapper.dart';
import 'package:ntfyd/core/network/ntfy_http_client.dart';
import 'package:ntfyd/core/secure_storage/secure_credential_vault.dart';
import 'package:ntfyd/core/secure_storage/server_credential.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/publish/domain/entities/publish_draft.dart';
import 'package:ntfyd/features/publish/domain/repositories/publish_repository.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';
import 'package:path/path.dart' as p;

typedef NtfyPublishHttpClientFactory =
    NtfyHttpClient Function(String baseUrl, ServerCredential credential);

/// Publishes a [PublishDraft] to `POST/PUT /{topic}` (api_spec.md §2).
///
/// Registered for DI via `PublishModule.publishRepository` rather than a
/// class-level `@LazySingleton` annotation: `injectable` cannot resolve
/// the bare `NtfyPublishHttpClientFactory` (`Function`-typed) constructor
/// param, even though it's optional (same constraint as
/// `AccountDataSourceImpl`/`FeedRepositoryImpl`).
class PublishRepositoryImpl implements PublishRepository {
  PublishRepositoryImpl(
    this._serverConfigRepository,
    this._vault, {
    NtfyPublishHttpClientFactory? clientFactory,
  }) : _clientFactory =
           clientFactory ??
           ((baseUrl, credential) =>
               NtfyHttpClient(baseUrl: baseUrl, credential: credential));

  final ServerConfigRepository _serverConfigRepository;
  final SecureCredentialVault _vault;
  final NtfyPublishHttpClientFactory _clientFactory;

  @override
  Future<Result<void>> publish(String serverId, PublishDraft draft) async {
    final serverResult = await _serverConfigRepository.getById(serverId);
    if (!serverResult.isSuccess) {
      return Result.err(serverResult.failureOrThrow);
    }
    final server = serverResult.valueOrThrow;

    final credentialRef = server.credentialRef;
    final credential = credentialRef == null
        ? const ServerCredential.noAuth()
        : (await _vault.retrieve(credentialRef)) ??
              const ServerCredential.noAuth();

    final client = _clientFactory(server.baseUrl, credential);
    final headers = _headersFor(draft);

    try {
      if (draft.attachmentPath != null) {
        final bytes = await File(draft.attachmentPath!).readAsBytes();
        await client.put<void>(
          '/${draft.topic}',
          data: bytes,
          options: Options(headers: headers),
        );
      } else {
        await client.post<void>(
          '/${draft.topic}',
          data: draft.body,
          options: Options(headers: headers),
        );
      }
      return const Result.success(null);
    } catch (e) {
      return Result.err(ExceptionMapper.map(e));
    }
  }

  Map<String, String> _headersFor(PublishDraft draft) {
    final headers = <String, String>{};

    if (draft.attachmentPath != null) {
      headers['X-Filename'] = p.basename(draft.attachmentPath!);
      if (draft.body.trim().isNotEmpty) {
        headers['X-Message'] = draft.body;
      }
    }
    if (draft.title != null && draft.title!.isNotEmpty) {
      headers['X-Title'] = draft.title!;
    }
    headers['X-Priority'] = draft.priority.toString();
    if (draft.tags.isNotEmpty) {
      headers['X-Tags'] = draft.tags.join(',');
    }
    if (draft.markdown) {
      headers['X-Markdown'] = 'true';
    }
    if (draft.delay != null && draft.delay!.isNotEmpty) {
      headers['X-Delay'] = draft.delay!;
    }

    return headers;
  }
}
