
import 'package:ntfyd/core/usecase/result.dart';

abstract class UseCase<Params, Return> {
  Future<Result<Return>> call(Params params);
}

/// [Params] when a use case takes no input.
class NoParams {
  const NoParams();

  @override
  bool operator ==(Object other) => other is NoParams;

  @override
  int get hashCode => 0;
}