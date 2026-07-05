// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../core/database/app_database.dart' as _i935;
import '../core/database/daos/message_dao.dart' as _i256;
import '../core/database/daos/server_config_dao.dart' as _i640;
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
import '../features/server_config/domain/usecases/validate_server_health.dart'
    as _i285;
import '../features/server_config/presentation/cubits/server_form_cubit.dart'
    as _i631;
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
  final serverConfigModule = _$ServerConfigModule();
  gh.lazySingleton<_i935.AppDatabase>(() => coreModule.appDatabase);
  gh.lazySingleton<_i558.FlutterSecureStorage>(() => coreModule.secureStorage);
  gh.lazySingleton<_i839.FeedPollDataSource>(
    () => feedModule.feedPollDataSource(),
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
  gh.lazySingleton<_i640.ServerConfigDao>(
    () => coreModule.serverConfigDao(gh<_i935.AppDatabase>()),
  );
  gh.lazySingleton<_i245.SubscriptionDao>(
    () => coreModule.subscriptionDao(gh<_i935.AppDatabase>()),
  );
  gh.lazySingleton<_i256.MessageDao>(
    () => coreModule.messageDao(gh<_i935.AppDatabase>()),
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
  gh.lazySingleton<_i291.SubscriptionRepository>(
    () => _i221.SubscriptionRepositoryImpl(
      gh<_i245.SubscriptionDao>(),
      gh<_i256.MessageDao>(),
    ),
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
  gh.lazySingleton<_i917.FeedRepository>(
    () => feedModule.feedRepository(
      gh<_i668.ServerConfigRepository>(),
      gh<_i465.SecureCredentialVault>(),
      gh<_i256.MessageDao>(),
      gh<_i839.FeedPollDataSource>(),
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
  gh.factory<_i349.SubscribeToTopic>(
    () => _i349.SubscribeToTopic(
      gh<_i668.ServerConfigRepository>(),
      gh<_i465.SecureCredentialVault>(),
      gh<_i750.AccountDataSource>(),
      gh<_i291.SubscriptionRepository>(),
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
  return getIt;
}

class _$CoreModule extends _i747.CoreModule {}

class _$FeedModule extends _i172.FeedModule {}

class _$ServerConfigModule extends _i22.ServerConfigModule {}
