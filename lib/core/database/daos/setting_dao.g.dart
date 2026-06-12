// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_dao.dart';

// ignore_for_file: type=lint
mixin _$SettingDaoMixin on DatabaseAccessor<AppDatabase> {
  $AppSettingsTable get appSettings => attachedDatabase.appSettings;
  SettingDaoManager get managers => SettingDaoManager(this);
}

class SettingDaoManager {
  final _$SettingDaoMixin _db;
  SettingDaoManager(this._db);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db.attachedDatabase, _db.appSettings);
}
