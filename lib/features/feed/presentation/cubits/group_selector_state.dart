import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ntfyd/features/groups/domain/entities/group.dart';

part 'group_selector_state.freezed.dart';

/// `selectedGroupId == null` means the built-in "All" view (Base-Plan D15).
@freezed
abstract class GroupSelectorState with _$GroupSelectorState {
  const factory GroupSelectorState({
    @Default([]) List<Group> groups,
    String? selectedGroupId,
  }) = _GroupSelectorState;
}
