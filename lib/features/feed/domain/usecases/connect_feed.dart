import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/feed/domain/repositories/feed_repository.dart';

class ConnectFeedParams {
  const ConnectFeedParams({required this.serverId, required this.topic});

  final String serverId;
  final String topic;
}

/// Opens (or reuses) the screen-scoped WS session for a topic, per
/// Base-Plan D9 — called from `FeedBloc` when `TopicDetailPage` loads.
@injectable
class ConnectFeed implements UseCase<ConnectFeedParams, void> {
  ConnectFeed(this._repository);

  final FeedRepository _repository;

  @override
  Future<Result<void>> call(ConnectFeedParams params) =>
      _repository.connect(params.serverId, params.topic);
}
