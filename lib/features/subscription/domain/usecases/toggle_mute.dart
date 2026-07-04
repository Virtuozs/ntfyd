import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';

@injectable
class ToggleMute implements UseCase<String, void> {
  ToggleMute(this._repository);

  final SubscriptionRepository _repository;

  @override
  Future<Result<void>> call(String subscriptionId) {
    return _repository.toggleMute(subscriptionId);
  }
}
