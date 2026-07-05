import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/secure_storage/secure_credential_vault.dart';
import 'package:ntfyd/features/publish/data/repositories/publish_repository_impl.dart';
import 'package:ntfyd/features/publish/domain/repositories/publish_repository.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';

/// [PublishRepositoryImpl] is registered here via a factory method rather
/// than a class-level `@LazySingleton` annotation: `injectable` cannot
/// resolve its bare `Function`-typed optional constructor param
/// (`NtfyPublishHttpClientFactory`) — same limitation as
/// `FeedModule.feedRepository`.
@module
abstract class PublishModule {
  @LazySingleton(as: PublishRepository)
  PublishRepositoryImpl publishRepository(
    ServerConfigRepository serverConfigRepository,
    SecureCredentialVault vault,
  ) => PublishRepositoryImpl(serverConfigRepository, vault);
}