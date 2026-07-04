import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';

class UpdatePriorityThresholdParams {
  const UpdatePriorityThresholdParams({
    required this.subscriptionId,
    required this.threshold,
  });

  final String subscriptionId;
  final int threshold;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UpdatePriorityThresholdParams &&
          other.subscriptionId == subscriptionId &&
          other.threshold == threshold);

  @override
  int get hashCode => Object.hash(subscriptionId, threshold);
}

@injectable
class UpdatePriorityThreshold
    implements UseCase<UpdatePriorityThresholdParams, void> {
  UpdatePriorityThreshold(this._repository);

  final SubscriptionRepository _repository;

  @override
  Future<Result<void>> call(UpdatePriorityThresholdParams params) {
    return _repository.updatePriorityThreshold(
      params.subscriptionId,
      params.threshold,
    );
  }
}
