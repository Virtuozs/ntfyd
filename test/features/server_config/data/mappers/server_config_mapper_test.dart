import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/database/app_database.dart' as db;
import 'package:ntfyd/features/server_config/data/mappers/server_config_mapper.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';

void main() {
  group('ServerConfigMapper', () {
    group('toDomain', () {
      test('maps a row with authType=none and isDefault=true correctly', () {
        const row = db.ServerConfig(
          id: 'srv-1',
          baseUrl: 'https://ntfy.sh',
          displayName: 'ntfy.sh',
          authType: 'none',
          credentialRef: null,
          isDefault: 1,
          createdAt: 1749379200000, // 2025-06-08T16:00:00.000Z
        );

        final entity = ServerConfigMapper.toDomain(row);

        expect(entity.id, 'srv-1');
        expect(entity.baseUrl, 'https://ntfy.sh');
        expect(entity.displayName, 'ntfy.sh');
        expect(entity.authType, AuthType.none);
        expect(entity.credentialRef, isNull);
        expect(entity.isDefault, isTrue);
        expect(
          entity.createdAt,
          DateTime.fromMillisecondsSinceEpoch(1749379200000, isUtc: true),
        );
      });

      test('maps a row with authType=basic, credentialRef set, and '
          'isDefault=false correctly', () {
        const row = db.ServerConfig(
          id: 'srv-2',
          baseUrl: 'https://example.com',
          displayName: 'example.com',
          authType: 'basic',
          credentialRef: 'srv-2',
          isDefault: 0,
          createdAt: 1749465600000,
        );

        final entity = ServerConfigMapper.toDomain(row);

        expect(entity.authType, AuthType.basic);
        expect(entity.credentialRef, 'srv-2');
        expect(entity.isDefault, isFalse);
      });

      test('maps a row with authType=bearer correctly', () {
        const row = db.ServerConfig(
          id: 'srv-3',
          baseUrl: 'https://example.com',
          displayName: 'example.com',
          authType: 'bearer',
          credentialRef: 'srv-3',
          isDefault: 0,
          createdAt: 1749465600000,
        );

        final entity = ServerConfigMapper.toDomain(row);

        expect(entity.authType, AuthType.bearer);
      });
    });

    group('toCompanion', () {
      test(
        'maps a domain entity with authType=none and isDefault=true correctly',
        () {
          final entity = ServerConfig(
            id: 'srv-1',
            baseUrl: 'https://ntfy.sh',
            displayName: 'ntfy.sh',
            authType: AuthType.none,
            credentialRef: null,
            isDefault: true,
            createdAt: DateTime.fromMillisecondsSinceEpoch(
              1749379200000,
              isUtc: true,
            ),
          );

          final companion = ServerConfigMapper.toCompanion(entity);

          expect(companion.id, const Value('srv-1'));
          expect(companion.baseUrl, const Value('https://ntfy.sh'));
          expect(companion.displayName, const Value('ntfy.sh'));
          expect(companion.authType, const Value('none'));
          expect(companion.credentialRef, const Value(null));
          expect(companion.isDefault, const Value(1));
          expect(companion.createdAt, const Value(1749379200000));
        },
      );

      test(
        'maps a domain entity with authType=basic, credentialRef set, and isDefault=false correctly',
        () {
          final entity = ServerConfig(
            id: 'srv-2',
            baseUrl: 'https://example.com',
            displayName: 'example.com',
            authType: AuthType.basic,
            credentialRef: 'srv-2',
            isDefault: false,
            createdAt: DateTime.fromMillisecondsSinceEpoch(
              1749465600000,
              isUtc: true,
            ),
          );

          final companion = ServerConfigMapper.toCompanion(entity);

          expect(companion.authType, const Value('basic'));
          expect(companion.credentialRef, const Value('srv-2'));
          expect(companion.isDefault, const Value(0));
        },
      );

      test('maps a domain entity with authType=bearer correctly', () {
        final entity = ServerConfig(
          id: 'srv-3',
          baseUrl: 'https://example.com',
          displayName: 'example.com',
          authType: AuthType.bearer,
          credentialRef: 'srv-3',
          isDefault: false,
          createdAt: DateTime.fromMillisecondsSinceEpoch(
            1749465600000,
            isUtc: true,
          ),
        );

        final companion = ServerConfigMapper.toCompanion(entity);

        expect(companion.authType, const Value('bearer'));
      });
    });

    group('round-trip', () {
      test('toDomain(toCompanion(entity)) preserves all fields', () {
        final original = ServerConfig(
          id: 'srv-4',
          baseUrl: 'https://example.com',
          displayName: 'example.com',
          authType: AuthType.basic,
          credentialRef: 'srv-4',
          isDefault: true,
          createdAt: DateTime.fromMillisecondsSinceEpoch(
            1749465600000,
            isUtc: true,
          ),
        );

        final companion = ServerConfigMapper.toCompanion(original);
        final row = db.ServerConfig(
          id: companion.id.value,
          baseUrl: companion.baseUrl.value,
          displayName: companion.displayName.value,
          authType: companion.authType.value,
          credentialRef: companion.credentialRef.value,
          isDefault: companion.isDefault.value,
          createdAt: companion.createdAt.value,
        );
        final result = ServerConfigMapper.toDomain(row);

        expect(result, original);
      });
    });
  });
}
