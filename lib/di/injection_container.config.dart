// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i163;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:local_auth/local_auth.dart' as _i152;

import '../core/app_lock/app_lock_service.dart' as _i646;
import '../core/app_lock/local_auth_app_lock_service.dart' as _i188;
import '../core/database/app_database.dart' as _i935;
import '../core/database/daos/group_dao.dart' as _i978;
import '../core/database/daos/message_dao.dart' as _i256;
import '../core/database/daos/server_config_dao.dart' as _i640;
import '../core/database/daos/setting_dao.dart' as _i922;
import '../core/database/daos/subscription_dao.dart' as _i245;
import '../core/di/core_module.dart' as _i747;
import '../core/secure_storage/secure_credential_vault.dart' as _i465;
import '../features/feed/data/datasources/feed_poll_data_source.dart' as _i839;
import '../features/feed/di/feed_module.dart' as _i172;
import '../features/feed/domain/repositories/feed_repository.dart' as _i917;
import '../features/feed/domain/usecases/connect_feed.dart' as _i106;
import '../features/feed/domain/usecases/disconnect_feed.dart' as _i120;
import '../features/feed/domain/usecases/refresh_feed_history.dart' as _i959;
import '../features/feed/domain/usecases/toggle_message_pin.dart' as _i294;
import '../features/feed/domain/usecases/toggle_message_read.dart' as _i57;
import '../features/feed/presentation/blocs/feed_bloc.dart' as _i916;
import '../features/feed/presentation/cubits/group_selector_cubit.dart'
    as _i221;
import '../features/feed/presentation/cubits/home_feed_cubit.dart' as _i955;
import '../features/groups/data/repositories/group_repository_impl.dart'
    as _i868;
import '../features/groups/domain/repositories/group_repository.dart' as _i1048;
import '../features/groups/domain/usecases/delete_group.dart' as _i649;
import '../features/groups/domain/usecases/save_group.dart' as _i1063;
import '../features/groups/presentation/blocs/group_feed_bloc.dart' as _i491;
import '../features/groups/presentation/cubits/group_form_cubit.dart' as _i764;
import '../features/notifications/data/background_delivery_service.dart'
    as _i985;
import '../features/notifications/data/foreground_service_controller.dart'
    as _i810;
import '../features/notifications/data/notification_channel_manager.dart'
    as _i0;
import '../features/notifications/data/notification_presenter.dart' as _i598;
import '../features/notifications/data/notifications_coordinator.dart'
    as _i1055;
import '../features/notifications/di/notifications_module.dart' as _i473;
import '../features/notifications/domain/services/notification_policy.dart'
    as _i966;
import '../features/notifications/presentation/currently_viewed_topic.dart'
    as _i76;
import '../features/publish/di/publish_module.dart' as _i973;
import '../features/publish/domain/repositories/publish_repository.dart'
    as _i476;
import '../features/publish/domain/usecases/publish_message.dart' as _i228;
import '../features/publish/presentation/cubits/publish_cubit.dart' as _i461;
import '../features/server_config/data/datasources/account_data_source.dart'
    as _i750;
import '../features/server_config/data/datasources/health_data_source.dart'
    as _i394;
import '../features/server_config/data/datasources/health_data_source_impl.dart'
    as _i201;
import '../features/server_config/data/repositories/server_config_repository_impl.dart'
    as _i462;
import '../features/server_config/di/server_config_module.dart' as _i22;
import '../features/server_config/domain/repositories/server_config_repository.dart'
    as _i668;
import '../features/server_config/domain/usecases/add_server.dart' as _i36;
import '../features/server_config/domain/usecases/edit_credentials.dart'
    as _i787;
import '../features/server_config/domain/usecases/list_servers.dart' as _i113;
import '../features/server_config/domain/usecases/remove_server.dart' as _i524;
import '../features/server_config/domain/usecases/set_default_server.dart'
    as _i933;
import '../features/server_config/domain/usecases/validate_server_health.dart'
    as _i285;
import '../features/server_config/presentation/cubits/server_add_edit_cubit.dart'
    as _i248;
import '../features/server_config/presentation/cubits/server_form_cubit.dart'
    as _i631;
import '../features/server_config/presentation/cubits/server_manager_cubit.dart'
    as _i13;
import '../features/settings/data/repositories/settings_repository_impl.dart'
    as _i1064;
import '../features/settings/domain/repositories/settings_repository.dart'
    as _i89;
import '../features/settings/domain/usecases/clear_all_data.dart' as _i138;
import '../features/settings/domain/usecases/clear_cache.dart' as _i436;
import '../features/settings/domain/usecases/update_settings.dart' as _i303;
import '../features/settings/presentation/cubits/settings_cubit.dart' as _i6;
import '../features/subscription/data/repositories/subscription_repository_impl.dart'
    as _i221;
import '../features/subscription/domain/repositories/subscription_repository.dart'
    as _i291;
import '../features/subscription/domain/usecases/subscribe_to_topic.dart'
    as _i349;
import '../features/subscription/domain/usecases/toggle_mute.dart' as _i110;
import '../features/subscription/domain/usecases/toggle_pin.dart' as _i164;
import '../features/subscription/domain/usecases/unsubscribe_from_topic.dart'
    as _i436;
import '../features/subscription/domain/usecases/update_priority_threshold.dart'
    as _i106;
import '../features/subscription/presentation/blocs/subscription_bloc.dart'
    as _i974;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final coreModule = _$CoreModule();
  final feedModule = _$FeedModule();
  final notificationsModule = _$NotificationsModule();
  final serverConfigModule = _$ServerConfigModule();
  final publishModule = _$PublishModule();
  gh.lazySingleton<_i935.AppDatabase>(() => coreModule.appDatabase);
  gh.lazySingleton<_i558.FlutterSecureStorage>(() => coreModule.secureStorage);
  gh.lazySingleton<_i152.LocalAuthentication>(
    () => coreModule.localAuthentication,
  );
  gh.lazySingleton<_i839.FeedPollDataSource>(
    () => feedModule.feedPollDataSource(),
  );
  gh.lazySingleton<_i163.FlutterLocalNotificationsPlugin>(
    () => notificationsModule.flutterLocalNotificationsPlugin(),
  );
  gh.lazySingleton<_i966.NotificationPolicy>(
    () => notificationsModule.notificationPolicy(),
  );
  gh.lazySingleton<_i810.ForegroundServiceController>(
    () => notificationsModule.foregroundServiceController(),
  );
  gh.lazySingleton<_i76.CurrentlyViewedTopic>(
    () => _i76.CurrentlyViewedTopic(),
  );
  gh.lazySingleton<_i201.NtfyHttpClientFactory>(
    () => _i201.NtfyHttpClientFactory(),
  );
  gh.lazySingleton<_i394.HealthDataSource>(
    () => _i201.HealthDataSourceImpl(gh<_i201.NtfyHttpClientFactory>()),
  );
  gh.lazySingleton<_i465.SecureCredentialVault>(
    () => coreModule.secureCredentialVault(gh<_i558.FlutterSecureStorage>()),
  );
  gh.lazySingleton<_i750.AccountDataSource>(
    () => serverConfigModule.accountDataSource(),
  );
  gh.lazySingleton<_i0.NotificationChannelManager>(
    () => notificationsModule.notificationChannelManager(
      gh<_i163.FlutterLocalNotificationsPlugin>(),
    ),
  );
  gh.lazySingleton<_i598.NotificationPresenter>(
    () => notificationsModule.notificationPresenter(
      gh<_i163.FlutterLocalNotificationsPlugin>(),
    ),
  );
  gh.lazySingleton<_i646.AppLockService>(
    () => _i188.LocalAuthAppLockService(gh<_i152.LocalAuthentication>()),
  );
  gh.lazySingleton<_i640.ServerConfigDao>(
    () => coreModule.serverConfigDao(gh<_i935.AppDatabase>()),
  );
  gh.lazySingleton<_i245.SubscriptionDao>(
    () => coreModule.subscriptionDao(gh<_i935.AppDatabase>()),
  );
  gh.lazySingleton<_i256.MessageDao>(
    () => coreModule.messageDao(gh<_i935.AppDatabase>()),
  );
  gh.lazySingleton<_i922.SettingDao>(
    () => coreModule.settingDao(gh<_i935.AppDatabase>()),
  );
  gh.lazySingleton<_i978.GroupDao>(
    () => coreModule.groupDao(gh<_i935.AppDatabase>()),
  );
  gh.factory<_i285.ValidateServerHealth>(
    () => _i285.ValidateServerHealth(gh<_i394.HealthDataSource>()),
  );
  gh.lazySingleton<_i668.ServerConfigRepository>(
    () => _i462.ServerConfigRepositoryImpl(
      gh<_i640.ServerConfigDao>(),
      gh<_i465.SecureCredentialVault>(),
    ),
  );
  gh.lazySingleton<_i476.PublishRepository>(
    () => publishModule.publishRepository(
      gh<_i668.ServerConfigRepository>(),
      gh<_i465.SecureCredentialVault>(),
    ),
  );
  gh.lazySingleton<_i1048.GroupRepository>(
    () => _i868.GroupRepositoryImpl(gh<_i978.GroupDao>()),
  );
  gh.factory<_i228.PublishMessage>(
    () => _i228.PublishMessage(gh<_i476.PublishRepository>()),
  );
  gh.lazySingleton<_i1055.NotificationsCoordinator>(
    () => notificationsModule.notificationsCoordinator(
      gh<_i256.MessageDao>(),
      gh<_i245.SubscriptionDao>(),
      gh<_i922.SettingDao>(),
      gh<_i598.NotificationPresenter>(),
      gh<_i76.CurrentlyViewedTopic>(),
      gh<_i966.NotificationPolicy>(),
    ),
  );
  gh.factory<_i787.EditCredentials>(
    () => _i787.EditCredentials(gh<_i668.ServerConfigRepository>()),
  );
  gh.factory<_i113.ListServers>(
    () => _i113.ListServers(gh<_i668.ServerConfigRepository>()),
  );
  gh.factory<_i524.RemoveServer>(
    () => _i524.RemoveServer(gh<_i668.ServerConfigRepository>()),
  );
  gh.factory<_i933.SetDefaultServer>(
    () => _i933.SetDefaultServer(gh<_i668.ServerConfigRepository>()),
  );
  gh.lazySingleton<_i89.SettingsRepository>(
    () => _i1064.SettingsRepositoryImpl(
      gh<_i922.SettingDao>(),
      gh<_i256.MessageDao>(),
      gh<_i935.AppDatabase>(),
      gh<_i465.SecureCredentialVault>(),
    ),
  );
  gh.lazySingleton<_i291.SubscriptionRepository>(
    () => _i221.SubscriptionRepositoryImpl(
      gh<_i245.SubscriptionDao>(),
      gh<_i256.MessageDao>(),
    ),
  );
  gh.factory<_i138.ClearAllData>(
    () => _i138.ClearAllData(gh<_i89.SettingsRepository>()),
  );
  gh.factory<_i436.ClearCache>(
    () => _i436.ClearCache(gh<_i89.SettingsRepository>()),
  );
  gh.factory<_i303.UpdateSettings>(
    () => _i303.UpdateSettings(gh<_i89.SettingsRepository>()),
  );
  gh.factory<_i36.AddServer>(
    () => _i36.AddServer(
      gh<_i668.ServerConfigRepository>(),
      gh<_i285.ValidateServerHealth>(),
    ),
  );
  gh.factory<_i110.ToggleMute>(
    () => _i110.ToggleMute(gh<_i291.SubscriptionRepository>()),
  );
  gh.factory<_i164.TogglePin>(
    () => _i164.TogglePin(gh<_i291.SubscriptionRepository>()),
  );
  gh.factory<_i436.UnsubscribeFromTopic>(
    () => _i436.UnsubscribeFromTopic(gh<_i291.SubscriptionRepository>()),
  );
  gh.factory<_i106.UpdatePriorityThreshold>(
    () => _i106.UpdatePriorityThreshold(gh<_i291.SubscriptionRepository>()),
  );
  gh.factory<_i461.PublishCubit>(
    () => _i461.PublishCubit(gh<_i228.PublishMessage>()),
  );
  gh.lazySingleton<_i917.FeedRepository>(
    () => feedModule.feedRepository(
      gh<_i668.ServerConfigRepository>(),
      gh<_i465.SecureCredentialVault>(),
      gh<_i256.MessageDao>(),
      gh<_i839.FeedPollDataSource>(),
    ),
  );
  gh.factory<_i649.DeleteGroup>(
    () => _i649.DeleteGroup(gh<_i1048.GroupRepository>()),
  );
  gh.factory<_i1063.SaveGroup>(
    () => _i1063.SaveGroup(gh<_i1048.GroupRepository>()),
  );
  gh.lazySingleton<_i985.BackgroundDeliveryService>(
    () => notificationsModule.backgroundDeliveryService(
      gh<_i291.SubscriptionRepository>(),
      gh<_i917.FeedRepository>(),
      gh<_i810.ForegroundServiceController>(),
    ),
  );
  gh.factory<_i631.ServerFormCubit>(
    () => _i631.ServerFormCubit(gh<_i36.AddServer>()),
  );
  gh.factory<_i106.ConnectFeed>(
    () => _i106.ConnectFeed(gh<_i917.FeedRepository>()),
  );
  gh.factory<_i120.DisconnectFeed>(
    () => _i120.DisconnectFeed(gh<_i917.FeedRepository>()),
  );
  gh.factory<_i959.RefreshFeedHistory>(
    () => _i959.RefreshFeedHistory(gh<_i917.FeedRepository>()),
  );
  gh.factory<_i294.ToggleMessagePin>(
    () => _i294.ToggleMessagePin(gh<_i917.FeedRepository>()),
  );
  gh.factory<_i57.ToggleMessageRead>(
    () => _i57.ToggleMessageRead(gh<_i917.FeedRepository>()),
  );
  gh.factory<_i6.SettingsCubit>(
    () => _i6.SettingsCubit(
      gh<_i89.SettingsRepository>(),
      gh<_i303.UpdateSettings>(),
      gh<_i436.ClearCache>(),
      gh<_i138.ClearAllData>(),
    ),
  );
  gh.factory<_i13.ServerManagerCubit>(
    () => _i13.ServerManagerCubit(
      gh<_i113.ListServers>(),
      gh<_i524.RemoveServer>(),
      gh<_i933.SetDefaultServer>(),
    ),
  );
  gh.factory<_i221.GroupSelectorCubit>(
    () => _i221.GroupSelectorCubit(
      gh<_i1048.GroupRepository>(),
      gh<_i649.DeleteGroup>(),
    ),
  );
  gh.factory<_i349.SubscribeToTopic>(
    () => _i349.SubscribeToTopic(
      gh<_i668.ServerConfigRepository>(),
      gh<_i465.SecureCredentialVault>(),
      gh<_i750.AccountDataSource>(),
      gh<_i291.SubscriptionRepository>(),
    ),
  );
  gh.factory<_i248.ServerAddEditCubit>(
    () => _i248.ServerAddEditCubit(
      gh<_i36.AddServer>(),
      gh<_i787.EditCredentials>(),
    ),
  );
  gh.factory<_i974.SubscriptionBloc>(
    () => _i974.SubscriptionBloc(
      gh<_i291.SubscriptionRepository>(),
      gh<_i349.SubscribeToTopic>(),
      gh<_i436.UnsubscribeFromTopic>(),
      gh<_i164.TogglePin>(),
      gh<_i110.ToggleMute>(),
      gh<_i106.UpdatePriorityThreshold>(),
    ),
  );
  gh.factory<_i764.GroupFormCubit>(
    () => _i764.GroupFormCubit(gh<_i1063.SaveGroup>()),
  );
  gh.factory<_i916.FeedBloc>(
    () => _i916.FeedBloc(
      gh<_i917.FeedRepository>(),
      gh<_i106.ConnectFeed>(),
      gh<_i120.DisconnectFeed>(),
      gh<_i959.RefreshFeedHistory>(),
      gh<_i57.ToggleMessageRead>(),
      gh<_i294.ToggleMessagePin>(),
      gh<_i76.CurrentlyViewedTopic>(),
    ),
  );
  gh.factory<_i955.HomeFeedCubit>(
    () => _i955.HomeFeedCubit(
      gh<_i291.SubscriptionRepository>(),
      gh<_i917.FeedRepository>(),
      gh<_i1048.GroupRepository>(),
    ),
  );
  gh.factory<_i491.GroupFeedBloc>(
    () => _i491.GroupFeedBloc(
      gh<_i1048.GroupRepository>(),
      gh<_i57.ToggleMessageRead>(),
      gh<_i294.ToggleMessagePin>(),
    ),
  );
  return getIt;
}

class _$CoreModule extends _i747.CoreModule {}

class _$FeedModule extends _i172.FeedModule {}

class _$NotificationsModule extends _i473.NotificationsModule {}

class _$ServerConfigModule extends _i22.ServerConfigModule {}

class _$PublishModule extends _i973.PublishModule {}
