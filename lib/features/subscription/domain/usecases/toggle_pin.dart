import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';

@injectable
class TogglePin implements UseCase<String, void> {
  TogglePin(this._repository);

  final SubscriptionRepository _repository;

  @override
  Future<Result<void>> call(String subscriptionId) {
    return _repository.togglePin(subscriptionId);
  }
}
