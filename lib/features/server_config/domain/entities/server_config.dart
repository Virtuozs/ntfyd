import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';

part 'server_config.freezed.dart';

@freezed
abstract class ServerConfig with _$ServerConfig {
  const factory ServerConfig({
    required String id,
    required String baseUrl,
    required String displayName,
    required AuthType authType,
    String? credentialRef,
    required bool isDefault,
    required DateTime createdAt,
  }) = _ServerConfig;

  const ServerConfig._();

  /// Validates and normalizes input, returning a [Result] containing
  /// either a valid [ServerConfig] or a [Failure.validation].
  static Result<ServerConfig> validate({
    required String id,
    required String baseUrl,
    String? displayName,
    required AuthType authType,
    String? credentialRef,
    required bool isDefault,
    required DateTime createdAt,
  }) {
    final uri = Uri.tryParse(baseUrl);
    final scheme = uri?.scheme ?? '';

    if (scheme != 'http' && scheme != 'https') {
      return const Result.err(
        Failure.validation(
          field: 'baseUrl',
          message: 'baseUrl must start with http:// or https://',
        ),
      );
    }

    if (authType != AuthType.none &&
        (credentialRef == null || credentialRef.isEmpty)) {
      return const Result.err(
        Failure.validation(
          field: 'credentialRef',
          message: 'credentialRef is required when authType is not none',
        ),
      );
    }

    var normalizedBaseUrl = baseUrl;
    if (normalizedBaseUrl.endsWith('/')) {
      normalizedBaseUrl = normalizedBaseUrl.substring(
        0,
        normalizedBaseUrl.length - 1,
      );
    }

    // displayName fallback: null/empty/whitespace-only -> host (or
    // host:port if a non-default port was explicitly specified).
    var resolvedDisplayName = displayName?.trim() ?? '';
    if (resolvedDisplayName.isEmpty) {
      final normalizedUri = Uri.parse(normalizedBaseUrl);
      resolvedDisplayName = normalizedUri.hasPort
          ? '${normalizedUri.host}:${normalizedUri.port}'
          : normalizedUri.host;
    } else {
      resolvedDisplayName = displayName!;
    }

    return Result.success(
      ServerConfig(
        id: id,
        baseUrl: normalizedBaseUrl,
        displayName: resolvedDisplayName,
        authType: authType,
        credentialRef: credentialRef,
        isDefault: isDefault,
        createdAt: createdAt,
      ),
    );
  }

  /// Normalizes raw user input for the server URL field before
  /// validation. Blank input defaults to 'https://ntfy.sh'.
  static String normalizeBaseUrlInput(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return 'https://ntfy.sh';
    if (!trimmed.contains('://')) return 'https://$trimmed';
    return trimmed;
  }
}
