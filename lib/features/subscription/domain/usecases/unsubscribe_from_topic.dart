import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';

class UnsubscribeFromTopicParams {
  const UnsubscribeFromTopicParams({
    required this.serverId,
    required this.topic,
  });

  final String serverId;
  final String topic;
}

/// Unsubscribes from a topic. Clearing cached messages for the topic is
/// handled by [SubscriptionRepository.unsubscribe] itself (data layer),
/// keeping this use case free of Drift/DAO dependencies per the
/// domain-purity constraint.
@injectable
class UnsubscribeFromTopic
    implements UseCase<UnsubscribeFromTopicParams, void> {
  UnsubscribeFromTopic(this._repository);

  final SubscriptionRepository _repository;

  @override
  Future<Result<void>> call(UnsubscribeFromTopicParams params) {
    return _repository.unsubscribe(params.serverId, params.topic);
  }
}
