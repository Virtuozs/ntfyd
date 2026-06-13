import 'package:drift/drift.dart' show Value;
import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/database/app_database.dart' as db;
import 'package:ntfyd/core/database/daos/server_config_dao.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/secure_storage/secure_credential_vault.dart';
import 'package:ntfyd/core/secure_storage/server_credential.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/server_config/data/mappers/server_config_mapper.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';

/// Concrete [ServerConfigRepository] backed by [ServerConfigDao] for persistence and [SecureCredentialVault] (P1-5) for credentials.
///
/// `credentialRef == null` (set only for [AuthType.none] servers per [AddServer]) means the server has no vault entry andault calls are skipped for such servers.
@LazySingleton(as: ServerConfigRepository)
class ServerConfigRepositoryImpl implements ServerConfigRepository {
  ServerConfigRepositoryImpl(this._dao, this._vault);

  final ServerConfigDao _dao;
  final SecureCredentialVault _vault;

  @override
  Future<Result<List<ServerConfig>>> getAll() async {
    try {
      final rows = await _dao.watchAll().first;
      return Result.success(rows.map(ServerConfigMapper.toDomain).toList());
    } catch (e) {
      return Result.err(Failure.cache(message: 'Failed to load servers: $e'));
    }
  }

  @override
  Future<Result<ServerConfig>> getById(String id) async {
    try {
      final row = await _dao.findById(id);
      if (row == null) {
        return const Result.err(Failure.notFound());
      }
      return Result.success(ServerConfigMapper.toDomain(row));
    } catch (e) {
      return Result.err(Failure.cache(message: 'Failed to load server: $e'));
    }
  }

  @override
  Future<Result<void>> add(ServerConfig config, ServerCredential cred) async {
    try {
      final ref = config.credentialRef;
      if (ref != null) {
        await _vault.store(ref, cred);
      }
      await _dao.upsert(ServerConfigMapper.toCompanion(config));
      return const Result.success(null);
    } catch (e) {
      return Result.err(Failure.cache(message: 'Failed to add server: $e'));
    }
  }

  @override
  Future<Result<void>> editCredentials(String id, ServerCredential cred) async {
    try {
      final row = await _dao.findById(id);
      if (row == null) {
        return const Result.err(Failure.notFound());
      }
      final ref = row.credentialRef;
      if (ref == null) {
        return const Result.err(
          Failure.validation(
            field: 'credentialRef',
            message: 'Server has no credential slot (anonymous server)',
          ),
        );
      }
      await _vault.store(ref, cred);
      return const Result.success(null);
    } catch (e) {
      return Result.err(
        Failure.cache(message: 'Failed to edit credentials: $e'),
      );
    }
  }

  @override
  Future<Result<void>> setDefault(String id) async {
    try {
      await _dao.setDefault(id);
      return const Result.success(null);
    } catch (e) {
      return Result.err(
        Failure.cache(message: 'Failed to set default server: $e'),
      );
    }
  }

  @override
  Future<Result<void>> remove(String id) async {
    try {
      final row = await _dao.findById(id);
      if (row == null) {
        return const Result.err(Failure.notFound());
      }
      final ref = row.credentialRef;
      if (ref != null) {
        await _vault.delete(ref);
      }
      await _dao.deleteById(id);
      return const Result.success(null);
    } catch (e) {
      return Result.err(Failure.cache(message: 'Failed to remove server: $e'));
    }
  }
}
