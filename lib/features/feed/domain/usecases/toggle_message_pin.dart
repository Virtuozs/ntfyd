import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/feed/domain/repositories/feed_repository.dart';

class ToggleMessagePinParams {
  const ToggleMessagePinParams({required this.serverId, required this.id});

  final String serverId;
  final String id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ToggleMessagePinParams &&
          other.serverId == serverId &&
          other.id == id);

  @override
  int get hashCode => Object.hash(serverId, id);
}

/// Toggles pin on a single message (D17: `NotificationMessage.pinned`).
@injectable
class ToggleMessagePin implements UseCase<ToggleMessagePinParams, void> {
  ToggleMessagePin(this._repository);

  final FeedRepository _repository;

  @override
  Future<Result<void>> call(ToggleMessagePinParams params) =>
      _repository.togglePin(params.serverId, params.id);
}
