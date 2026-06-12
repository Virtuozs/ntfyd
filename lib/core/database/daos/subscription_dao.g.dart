// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_dao.dart';

// ignore_for_file: type=lint
mixin _$SubscriptionDaoMixin on DatabaseAccessor<AppDatabase> {
  $ServerConfigsTable get serverConfigs => attachedDatabase.serverConfigs;
  $SubscriptionsTable get subscriptions => attachedDatabase.subscriptions;
  SubscriptionDaoManager get managers => SubscriptionDaoManager(this);
}

class SubscriptionDaoManager {
  final _$SubscriptionDaoMixin _db;
  SubscriptionDaoManager(this._db);
  $$ServerConfigsTableTableManager get serverConfigs =>
      $$ServerConfigsTableTableManager(_db.attachedDatabase, _db.serverConfigs);
  $$SubscriptionsTableTableManager get subscriptions =>
      $$SubscriptionsTableTableManager(_db.attachedDatabase, _db.subscriptions);
}
