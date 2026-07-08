import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ntfyd/features/feed/presentation/cubits/group_selector_state.dart';
import 'package:ntfyd/features/groups/domain/repositories/group_repository.dart';
import 'package:ntfyd/features/groups/domain/usecases/delete_group.dart';

/// Drives Home's group selector (Base-Plan D15): the list of groups plus
/// which one (or "All", `null`) is currently selected. Read-model only —
/// mutations (create/edit) go through `GroupFormCubit`; this cubit only
/// selects and deletes.
@injectable
class GroupSelectorCubit extends Cubit<GroupSelectorState> {
  GroupSelectorCubit(this._groupRepository, this._deleteGroup)
    : super(const GroupSelectorState());

  final GroupRepository _groupRepository;
  final DeleteGroup _deleteGroup;

  StreamSubscription<GroupSelectorState>? _subscription;

  void load() {
    unawaited(_subscription?.cancel());
    _subscription = _groupRepository
        .watchAll()
        .map((groups) => state.copyWith(groups: groups))
        .listen(emit);
  }

  void select(String? groupId) => emit(state.copyWith(selectedGroupId: groupId));

  Future<void> deleteGroup(String groupId) async {
    await _deleteGroup.call(DeleteGroupParams(groupId: groupId));
    if (state.selectedGroupId == groupId) {
      emit(state.copyWith(selectedGroupId: null));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
