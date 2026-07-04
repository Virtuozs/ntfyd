import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/database/daos/message_dao.dart';
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

/// Unsubscribes from a topic: clears any locally cached messages for
/// `(serverId, topic)` first, then removes the subscription row.
@injectable
class UnsubscribeFromTopic
    implements UseCase<UnsubscribeFromTopicParams, void> {
  UnsubscribeFromTopic(this._repository, this._messageDao);

  final SubscriptionRepository _repository;
  final MessageDao _messageDao;

  @override
  Future<Result<void>> call(UnsubscribeFromTopicParams params) async {
    await _messageDao.clearByTopic(params.serverId, params.topic);
    return _repository.unsubscribe(params.serverId, params.topic);
  }
}
