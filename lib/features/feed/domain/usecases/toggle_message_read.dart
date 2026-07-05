import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/feed/domain/repositories/feed_repository.dart';

class ToggleMessageReadParams {
  const ToggleMessageReadParams({required this.serverId, required this.id});

  final String serverId;
  final String id;
}

/// Toggles read/unread on a single message (D19: the ✓ on each message
/// card/detail screen).
@injectable
class ToggleMessageRead implements UseCase<ToggleMessageReadParams, void> {
  ToggleMessageRead(this._repository);

  final FeedRepository _repository;

  @override
  Future<Result<void>> call(ToggleMessageReadParams params) =>
      _repository.toggleRead(params.serverId, params.id);
}
