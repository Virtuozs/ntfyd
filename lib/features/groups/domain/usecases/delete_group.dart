import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/groups/domain/repositories/group_repository.dart';

class DeleteGroupParams {
  const DeleteGroupParams({required this.groupId});

  final String groupId;
}

@injectable
class DeleteGroup implements UseCase<DeleteGroupParams, void> {
  DeleteGroup(this._repository);

  final GroupRepository _repository;

  @override
  Future<Result<void>> call(DeleteGroupParams params) =>
      _repository.delete(params.groupId);
}
