import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/database/value_objects/message_filter.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/groups/domain/entities/group.dart';
import 'package:ntfyd/features/groups/domain/entities/group_membership.dart';
import 'package:ntfyd/features/groups/domain/repositories/group_repository.dart';
import 'package:uuid/uuid.dart';

class SaveGroupParams {
  const SaveGroupParams({
    this.id,
    required this.name,
    this.color,
    this.members = const {},
    this.filter,
    this.sortOrder = 0,
  });

  final String? id;
  final String name;
  final int? color;
  final Set<GroupMembership> members;
  final MessageFilter? filter;
  final int sortOrder;
}

/// Creates (when [SaveGroupParams.id] is null) or updates (when present) a
/// [Group], validating via [Group.validate] first.
@injectable
class SaveGroup implements UseCase<SaveGroupParams, Group> {
  SaveGroup(this._repository);

  final GroupRepository _repository;

  String Function() get _idGenerator =>
      SaveGroupTestHooks.idGenerator ?? (() => const Uuid().v4());

  @override
  Future<Result<Group>> call(SaveGroupParams params) async {
    final validateResult = Group.validate(
      id: params.id ?? _idGenerator(),
      name: params.name,
      color: params.color,
      members: params.members,
      filter: params.filter,
      sortOrder: params.sortOrder,
    );
    if (!validateResult.isSuccess) {
      return Result.err(validateResult.failureOrThrow);
    }

    return _repository.save(validateResult.valueOrThrow);
  }
}

/// Test-only seam for [SaveGroup]'s ID generation.
///
/// Tests MUST reset this to `null` in `tearDown` to avoid leaking state
/// across tests.
class SaveGroupTestHooks {
  static String Function()? idGenerator;
}
