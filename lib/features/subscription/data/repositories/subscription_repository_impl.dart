import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/database/daos/subscription_dao.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/subscription/data/mappers/subscription_mapper.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';

@LazySingleton(as: SubscriptionRepository)
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  SubscriptionRepositoryImpl(this._dao);

  final SubscriptionDao _dao;

  @override
  Stream<List<Subscription>> watchByServer(String serverId) {
    return _dao
        .watchByServer(serverId)
        .map((rows) => rows.map(SubscriptionMapper.toDomain).toList());
  }

  @override
  Future<Result<Subscription>> subscribe(Subscription sub) async {
    try {
      await _dao.upsert(SubscriptionMapper.toCompanion(sub));
      return Result.success(sub);
    } catch (e) {
      return Result.err(Failure.cache(message: 'Failed to subscribe: $e'));
    }
  }

  @override
  Future<Result<void>> unsubscribe(String serverId, String topic) async {
    try {
      await _dao.deleteByTopic(serverId, topic);
      return const Result.success(null);
    } catch (e) {
      return Result.err(Failure.cache(message: 'Failed to unsubscribe: $e'));
    }
  }

  @override
  Future<Result<void>> togglePin(String id) async {
    try {
      await _dao.togglePin(id);
      return const Result.success(null);
    } catch (e) {
      return Result.err(Failure.cache(message: 'Failed to toggle pin: $e'));
    }
  }

  @override
  Future<Result<void>> toggleMute(String id) async {
    try {
      await _dao.toggleMute(id);
      return const Result.success(null);
    } catch (e) {
      return Result.err(Failure.cache(message: 'Failed to toggle mute: $e'));
    }
  }

  @override
  Future<Result<void>> updatePriorityThreshold(
    String id,
    int threshold,
  ) async {
    try {
      await _dao.updatePriorityThreshold(id, threshold);
      return const Result.success(null);
    } catch (e) {
      return Result.err(
        Failure.cache(message: 'Failed to update priority threshold: $e'),
      );
    }
  }
}
