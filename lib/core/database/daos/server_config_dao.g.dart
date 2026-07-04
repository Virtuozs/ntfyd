// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_config_dao.dart';

// ignore_for_file: type=lint
mixin _$ServerConfigDaoMixin on DatabaseAccessor<AppDatabase> {
  $ServerConfigsTable get serverConfigs => attachedDatabase.serverConfigs;
  ServerConfigDaoManager get managers => ServerConfigDaoManager(this);
}

class ServerConfigDaoManager {
  final _$ServerConfigDaoMixin _db;
  ServerConfigDaoManager(this._db);
  $$ServerConfigsTableTableManager get serverConfigs =>
      $$ServerConfigsTableTableManager(_db.attachedDatabase, _db.serverConfigs);
}
