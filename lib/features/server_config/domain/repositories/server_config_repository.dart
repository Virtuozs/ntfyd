import 'package:ntfyd/core/secure_storage/server_credential.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';

abstract class ServerConfigRepository {
  Future<Result<List<ServerConfig>>> getAll();
  Future<Result<ServerConfig>> getById(String id);
  Future<Result<void>> add(ServerConfig config, ServerCredential cred);
  Future<Result<void>> editCredentials(String id, ServerCredential cred);
  Future<Result<void>> setDefault(String id);
  Future<Result<void>> remove(String id);
}
