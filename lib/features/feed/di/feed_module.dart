import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/database/daos/message_dao.dart';
import 'package:ntfyd/core/secure_storage/secure_credential_vault.dart';
import 'package:ntfyd/features/feed/data/datasources/feed_poll_data_source.dart';
import 'package:ntfyd/features/feed/data/repositories/feed_repository_impl.dart';
import 'package:ntfyd/features/feed/domain/repositories/feed_repository.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';

@module
abstract class FeedModule {
  /// Registers [FeedPollDataSource] via a factory method rather than a
  /// class-level `@LazySingleton` annotation: `injectable` cannot resolve the
  /// bare `NtfyPollHttpClientFactory` (`Function`-typed) constructor param,
  /// even though it's optional. Using the no-arg constructor here falls back
  /// to [FeedPollDataSource]'s built-in production factory.
  @LazySingleton()
  FeedPollDataSource feedPollDataSource() => FeedPollDataSource();

  /// Registers [FeedRepositoryImpl] via a factory method rather than a
  /// class-level `@LazySingleton` annotation: `injectable` cannot resolve the
  /// bare `FeedWsDataSourceFactory` (`Function`-typed) constructor param,
  /// even though it's optional. Using the no-arg constructor here falls back
  /// to [FeedRepositoryImpl]'s built-in production factory.
  @LazySingleton(as: FeedRepository)
  FeedRepositoryImpl feedRepository(
    ServerConfigRepository serverConfigRepository,
    SecureCredentialVault vault,
    MessageDao messageDao,
    FeedPollDataSource pollDataSource,
  ) =>
      FeedRepositoryImpl(
        serverConfigRepository,
        vault,
        messageDao,
        pollDataSource,
      );
}