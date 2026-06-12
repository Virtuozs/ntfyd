import 'package:drift/drift.dart';
import 'package:ntfyd/core/database/app_database.dart';
import 'package:ntfyd/core/database/tables/server_configs_table.dart';

part 'server_config_dao.g.dart';

@DriftAccessor(tables: [ServerConfigs])
class ServerConfigDao extends DatabaseAccessor<AppDatabase>
    with _$ServerConfigDaoMixin {
  ServerConfigDao(super.db);

  Stream<List<ServerConfig>> watchAll() {
    return select(serverConfigs).watch();
  }

  Future<ServerConfig?> findById(String id) {
    return (select(
      serverConfigs,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> upsert(ServerConfigsCompanion row) {
    return into(serverConfigs).insertOnConflictUpdate(row);
  }

  Future<void> deleteById(String id) {
    return (delete(serverConfigs)..where((t) => t.id.equals(id))).go();
  }

  Future<void> setDefault(String id) {
    return transaction(() async {
      await update(
        serverConfigs,
      ).write(const ServerConfigsCompanion(isDefault: Value(0)));

      await (update(serverConfigs)..where((t) => t.id.equals(id))).write(
        const ServerConfigsCompanion(isDefault: Value(1)),
      );
    });
  }
}
