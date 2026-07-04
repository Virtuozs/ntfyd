import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';

void main() {
  group('ServerConfig.validate', () {
    final createdAt = DateTime(2026, 6, 8);

    test('accepts baseUrl with http:// scheme', () {
      const baseUrl = 'http://192.168.1.50';

      final result = ServerConfig.validate(
        id: 'srv-1',
        baseUrl: baseUrl,
        authType: AuthType.none,
        isDefault: true,
        createdAt: createdAt,
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrThrow.baseUrl, 'http://192.168.1.50');
    });

    test('accepts baseUrl with https:// scheme', () {
      const baseUrl = 'https://ntfy.sh';

      final result = ServerConfig.validate(
        id: 'srv-1',
        baseUrl: baseUrl,
        authType: AuthType.none,
        isDefault: true,
        createdAt: createdAt,
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrThrow.baseUrl, 'https://ntfy.sh');
    });

    test('rejects baseUrl with ftp:// scheme', () {
      const baseUrl = 'ftp://example.com';

      final result = ServerConfig.validate(
        id: 'srv-1',
        baseUrl: baseUrl,
        authType: AuthType.none,
        isDefault: true,
        createdAt: createdAt,
      );

      expect(result.isSuccess, isFalse);
      final failure = result.failureOrThrow;
      expect(failure, isA<ValidationFailure>());
      expect((failure as ValidationFailure).field, 'baseUrl');
    });

    test('rejects baseUrl with no scheme', () {
      const baseUrl = 'example.com';

      final result = ServerConfig.validate(
        id: 'srv-1',
        baseUrl: baseUrl,
        authType: AuthType.none,
        isDefault: true,
        createdAt: createdAt,
      );

      expect(result.isSuccess, isFalse);
      final failure = result.failureOrThrow as ValidationFailure;
      expect(failure.field, 'baseUrl');
    });

    test('rejects empty baseUrl', () {
      const baseUrl = '';

      final result = ServerConfig.validate(
        id: 'srv-1',
        baseUrl: baseUrl,
        authType: AuthType.none,
        isDefault: true,
        createdAt: createdAt,
      );

      expect(result.isSuccess, isFalse);
      final failure = result.failureOrThrow as ValidationFailure;
      expect(failure.field, 'baseUrl');
    });

    test('normalizes trailing slash from baseUrl', () {
      const baseUrl = 'https://example.com/';

      final result = ServerConfig.validate(
        id: 'srv-1',
        baseUrl: baseUrl,
        authType: AuthType.none,
        isDefault: true,
        createdAt: createdAt,
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrThrow.baseUrl, 'https://example.com');
    });

    test('defaults displayName to host when displayName is null', () {
      const baseUrl = 'https://ntfy.sh';

      final result = ServerConfig.validate(
        id: 'srv-1',
        baseUrl: baseUrl,
        displayName: null,
        authType: AuthType.none,
        isDefault: true,
        createdAt: createdAt,
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrThrow.displayName, 'ntfy.sh');
    });

    test('defaults displayName to host when displayName is empty string', () {
      const baseUrl = 'https://ntfy.sh';

      final result = ServerConfig.validate(
        id: 'srv-1',
        baseUrl: baseUrl,
        displayName: '',
        authType: AuthType.none,
        isDefault: true,
        createdAt: createdAt,
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrThrow.displayName, 'ntfy.sh');
    });

    test(
      'defaults displayName to host when displayName is whitespace-only',
      () {
        const baseUrl = 'https://ntfy.sh';

        final result = ServerConfig.validate(
          id: 'srv-1',
          baseUrl: baseUrl,
          displayName: '   ',
          authType: AuthType.none,
          isDefault: true,
          createdAt: createdAt,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrThrow.displayName, 'ntfy.sh');
      },
    );

    test(
      'defaults displayName to host:port when baseUrl has a non-default port',
      () {
        const baseUrl = 'https://192.168.1.50:8443';

        final result = ServerConfig.validate(
          id: 'srv-1',
          baseUrl: baseUrl,
          displayName: null,
          authType: AuthType.none,
          isDefault: true,
          createdAt: createdAt,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrThrow.displayName, '192.168.1.50:8443');
      },
    );

    test('uses explicit non-empty displayName as-is without host fallback', () {
      const baseUrl = 'https://192.168.1.50:8443';

      final result = ServerConfig.validate(
        id: 'srv-1',
        baseUrl: baseUrl,
        displayName: 'Homelab',
        authType: AuthType.none,
        isDefault: true,
        createdAt: createdAt,
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrThrow.displayName, 'Homelab');
    });

    test(
      'authType=basic with null credentialRef returns ValidationFailure',
      () {
        const baseUrl = 'https://ntfy.sh';

        final result = ServerConfig.validate(
          id: 'srv-1',
          baseUrl: baseUrl,
          authType: AuthType.basic,
          credentialRef: null,
          isDefault: true,
          createdAt: createdAt,
        );

        expect(result.isSuccess, isFalse);
        final failure = result.failureOrThrow as ValidationFailure;
        expect(failure.field, 'credentialRef');
      },
    );

    test(
      'authType=basic with empty credentialRef returns ValidationFailure',
      () {
        const baseUrl = 'https://ntfy.sh';

        final result = ServerConfig.validate(
          id: 'srv-1',
          baseUrl: baseUrl,
          authType: AuthType.basic,
          credentialRef: '',
          isDefault: true,
          createdAt: createdAt,
        );

        expect(result.isSuccess, isFalse);
        final failure = result.failureOrThrow as ValidationFailure;
        expect(failure.field, 'credentialRef');
      },
    );

    test('authType=none with null credentialRef succeeds', () {
      const baseUrl = 'https://ntfy.sh';

      final result = ServerConfig.validate(
        id: 'srv-1',
        baseUrl: baseUrl,
        authType: AuthType.none,
        credentialRef: null,
        isDefault: true,
        createdAt: createdAt,
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrThrow.credentialRef, isNull);
    });

    test(
      'valid input produces a ServerConfig with all fields set correctly',
      () {
        const baseUrl = 'https://ntfy.sh/';
        const id = 'srv-1';
        const displayName = 'My ntfy.sh';

        final result = ServerConfig.validate(
          id: id,
          baseUrl: baseUrl,
          displayName: displayName,
          authType: AuthType.bearer,
          credentialRef: 'cred-ref-1',
          isDefault: true,
          createdAt: createdAt,
        );

        expect(result.isSuccess, isTrue);
        final config = result.valueOrThrow;
        expect(config.id, id);
        expect(config.baseUrl, 'https://ntfy.sh');
        expect(config.displayName, displayName);
        expect(config.authType, AuthType.bearer);
        expect(config.credentialRef, 'cred-ref-1');
        expect(config.isDefault, isTrue);
        expect(config.createdAt, createdAt);
      },
    );
  });

  group('ServerConfig.normalizeBaseUrlInput', () {
    test('empty string defaults to https://ntfy.sh', () {
      final result = ServerConfig.normalizeBaseUrlInput('');

      expect(result, 'https://ntfy.sh');
    });

    test('whitespace-only string defaults to https://ntfy.sh', () {
      final result = ServerConfig.normalizeBaseUrlInput('   ');

      expect(result, 'https://ntfy.sh');
    });

    test('input without scheme is prefixed with https://', () {
      final result = ServerConfig.normalizeBaseUrlInput('example.com');

      expect(result, 'https://example.com');
    });

    test('input with http:// scheme is returned unchanged', () {
      final result = ServerConfig.normalizeBaseUrlInput('http://example.com');

      expect(result, 'http://example.com');
    });

    test('input with https:// scheme and trailing slash is unchanged', () {
      final result = ServerConfig.normalizeBaseUrlInput('https://example.com/');

      expect(result, 'https://example.com/');
    });
  });

  group('ServerConfig equality and copyWith (Freezed)', () {
    final createdAt = DateTime(2026, 6, 8);

    ServerConfig buildConfig({bool isDefault = false}) {
      return ServerConfig(
        id: 'srv-1',
        baseUrl: 'https://ntfy.sh',
        displayName: 'ntfy.sh',
        authType: AuthType.none,
        credentialRef: null,
        isDefault: isDefault,
        createdAt: createdAt,
      );
    }

    test('two ServerConfig instances with identical fields are equal', () {
      final a = buildConfig();
      final b = buildConfig();

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('copyWith(isDefault: true) produces a new instance with only that '
        'field changed', () {
      final original = buildConfig(isDefault: false);

      // act
      final updated = original.copyWith(isDefault: true);

      // assert
      expect(updated.isDefault, isTrue);
      expect(updated.id, original.id);
      expect(updated.baseUrl, original.baseUrl);
      expect(updated.displayName, original.displayName);
      expect(updated.authType, original.authType);
      expect(updated.credentialRef, original.credentialRef);
      expect(updated.createdAt, original.createdAt);
    });

    test('copyWith does not mutate the original instance', () {
      final original = buildConfig(isDefault: false);

      final updated = original.copyWith(isDefault: true);

      expect(original.isDefault, isFalse);
      expect(updated, isNot(same(original)));
    });
  });
}
