import 'package:drift/drift.dart' show Value;
import 'package:ntfyd/core/database/app_database.dart' as db;

import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';

/// Maps between the Drift-generated [db.ServerConfig] row and the domain [ServerConfig] entity.
///
/// [AuthType] round-trips via its enum [Enum.name] (`'none'`, `'basic'`,  `'bearer'`), matching the `auth_type` column's CHECK constraint.
/// [ServerConfig.isDefault] maps to/from `0`/`1`. [ServerConfig.createdAt] maps to/from epoch milliseconds, treated as UTC.
class ServerConfigMapper {
  /// Converts a Drift row to a domain entity.
  static ServerConfig toDomain(db.ServerConfig row) {
    return ServerConfig(
      id: row.id,
      baseUrl: row.baseUrl,
      displayName: row.displayName,
      authType: AuthType.values.byName(row.authType),
      credentialRef: row.credentialRef,
      isDefault: row.isDefault == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        row.createdAt,
        isUtc: true,
      ),
    );
  }

  /// Converts a domain entity to a Drift companion suitable for insert/update.
  static db.ServerConfigsCompanion toCompanion(ServerConfig entity) {
    return db.ServerConfigsCompanion.insert(
      id: entity.id,
      baseUrl: entity.baseUrl,
      displayName: entity.displayName,
      authType: entity.authType.name,
      credentialRef: Value(entity.credentialRef),
      isDefault: Value(entity.isDefault ? 1 : 0),
      createdAt: entity.createdAt.toUtc().millisecondsSinceEpoch,
    );
  }
}
