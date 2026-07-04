import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/error/exception_mapper.dart';
import 'package:ntfyd/core/secure_storage/secure_credential_vault.dart';
import 'package:ntfyd/core/secure_storage/server_credential.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/server_config/data/datasources/account_data_source.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:uuid/uuid.dart';

class SubscribeToTopicParams {
  const SubscribeToTopicParams({
    required this.serverId,
    required this.topic,
    this.displayName,
  });

  final String serverId;
  final String topic;
  final String? displayName;
}

/// Subscribes to a topic on [SubscribeToTopicParams.serverId], validating
/// stored credentials via `GET /v1/account` first (D14: first-subscribe
/// credential check). A 401/403 here surfaces as [AuthFailure] so the
/// presentation layer can route the user to credential edit (R5).
@injectable
class SubscribeToTopic
    implements UseCase<SubscribeToTopicParams, Subscription> {
  SubscribeToTopic(
    this._serverConfigRepository,
    this._vault,
    this._accountDataSource,
    this._subscriptionRepository,
  );

  final ServerConfigRepository _serverConfigRepository;
  final SecureCredentialVault _vault;
  final AccountDataSource _accountDataSource;
  final SubscriptionRepository _subscriptionRepository;

  String Function() get _idGenerator =>
      SubscribeToTopicTestHooks.idGenerator ?? (() => const Uuid().v4());

  DateTime Function() get _now =>
      SubscribeToTopicTestHooks.now ?? DateTime.now;

  @override
  Future<Result<Subscription>> call(SubscribeToTopicParams params) async {
    final serverResult = await _serverConfigRepository.getById(
      params.serverId,
    );
    if (!serverResult.isSuccess) {
      return Result.err(serverResult.failureOrThrow);
    }
    final server = serverResult.valueOrThrow;

    final credentialRef = server.credentialRef;
    final credential = credentialRef == null
        ? const ServerCredential.noAuth()
        : (await _vault.retrieve(credentialRef)) ??
              const ServerCredential.noAuth();

    try {
      await _accountDataSource.getAccount(server.baseUrl, credential);
    } catch (e) {
      return Result.err(ExceptionMapper.map(e));
    }

    final validateResult = Subscription.validate(
      id: _idGenerator(),
      serverId: params.serverId,
      topic: params.topic,
      displayName: params.displayName,
      createdAt: _now(),
    );
    if (!validateResult.isSuccess) {
      return Result.err(validateResult.failureOrThrow);
    }

    return _subscriptionRepository.subscribe(validateResult.valueOrThrow);
  }
}

/// Test-only seams for [SubscribeToTopic]'s ID generation and clock.
///
/// Tests MUST reset both fields to `null` in `tearDown` to avoid leaking
/// state across tests.
class SubscribeToTopicTestHooks {
  static String Function()? idGenerator;
  static DateTime Function()? now;
}
