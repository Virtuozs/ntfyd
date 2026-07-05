import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/feed/domain/repositories/feed_repository.dart';

class DisconnectFeedParams {
  const DisconnectFeedParams({required this.serverId, required this.topic});

  final String serverId;
  final String topic;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DisconnectFeedParams &&
          other.serverId == serverId &&
          other.topic == topic);

  @override
  int get hashCode => Object.hash(serverId, topic);
}

/// Tears down the screen-scoped WS session — called from `FeedBloc.close()`
/// when `TopicDetailPage` unmounts.
@injectable
class DisconnectFeed implements UseCase<DisconnectFeedParams, void> {
  DisconnectFeed(this._repository);

  final FeedRepository _repository;

  @override
  Future<Result<void>> call(DisconnectFeedParams params) =>
      _repository.disconnect(params.serverId, params.topic);
}
