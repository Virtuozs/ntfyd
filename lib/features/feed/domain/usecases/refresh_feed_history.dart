import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/feed/domain/repositories/feed_repository.dart';

class RefreshFeedHistoryParams {
  const RefreshFeedHistoryParams({
    required this.serverId,
    required this.topic,
  });

  final String serverId;
  final String topic;
}

/// Manual pull-to-refresh: fetches history since the last known message id
/// without touching the WS session.
@injectable
class RefreshFeedHistory implements UseCase<RefreshFeedHistoryParams, void> {
  RefreshFeedHistory(this._repository);

  final FeedRepository _repository;

  @override
  Future<Result<void>> call(RefreshFeedHistoryParams params) =>
      _repository.refreshHistory(params.serverId, params.topic);
}
