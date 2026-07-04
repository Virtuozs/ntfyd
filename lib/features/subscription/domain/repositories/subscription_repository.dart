import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';

abstract class SubscriptionRepository {
  Stream<List<Subscription>> watchByServer(String serverId);
  Future<Result<Subscription>> subscribe(Subscription sub);
  Future<Result<void>> unsubscribe(String serverId, String topic);
  Future<Result<void>> togglePin(String id);
  Future<Result<void>> toggleMute(String id);
  Future<Result<void>> updatePriorityThreshold(String id, int threshold);
}
