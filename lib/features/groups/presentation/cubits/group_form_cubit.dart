import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/database/value_objects/message_filter.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/groups/domain/entities/group.dart';
import 'package:ntfyd/features/groups/domain/entities/group_membership.dart';
import 'package:ntfyd/features/groups/domain/usecases/save_group.dart';
import 'package:ntfyd/features/groups/presentation/cubits/group_form_state.dart';

/// Drives the Create/Edit Tag screen (Base-Plan OI3).
@injectable
class GroupFormCubit extends Cubit<GroupFormState> {
  GroupFormCubit(this._saveGroup) : super(const GroupFormState.idle());

  final SaveGroup _saveGroup;

  Future<void> submit({
    String? id,
    required String name,
    int? color,
    Set<GroupMembership> members = const {},
    MessageFilter? filter,
  }) async {
    if (state is GroupFormSubmitting) return;

    emit(const GroupFormState.submitting());

    final result = await _saveGroup.call(
      SaveGroupParams(
        id: id,
        name: name,
        color: color,
        members: members,
        filter: filter,
      ),
    );

    switch (result) {
      case Success<Group>(value: final group):
        emit(GroupFormState.success(group: group));
      case Err<Group>(failure: final failure):
        emit(GroupFormState.error(failure: failure));
    }
  }
}
