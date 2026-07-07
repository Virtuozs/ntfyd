import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/feed/presentation/cubits/group_selector_cubit.dart';
import 'package:ntfyd/features/feed/presentation/cubits/group_selector_state.dart';
import 'package:ntfyd/features/groups/domain/entities/group.dart';
import 'package:ntfyd/features/groups/domain/repositories/group_repository.dart';
import 'package:ntfyd/features/groups/domain/usecases/delete_group.dart';

class MockGroupRepository extends Mock implements GroupRepository {}

class MockDeleteGroup extends Mock implements DeleteGroup {}

void main() {
  late MockGroupRepository groupRepository;
  late MockDeleteGroup deleteGroup;
  late StreamController<List<Group>> groupsController;

  final homelab = Group(id: 'grp-1', name: 'Homelab');

  setUpAll(() {
    registerFallbackValue(const DeleteGroupParams(groupId: 'grp-1'));
  });

  setUp(() {
    groupRepository = MockGroupRepository();
    deleteGroup = MockDeleteGroup();
    groupsController = StreamController<List<Group>>.broadcast();

    when(() => groupRepository.watchAll()).thenAnswer((_) => groupsController.stream);
    when(() => deleteGroup.call(any()))
        .thenAnswer((_) async => const Result.success(null));
  });

  tearDown(() async {
    await groupsController.close();
  });

  GroupSelectorCubit buildCubit() => GroupSelectorCubit(groupRepository, deleteGroup);

  blocTest<GroupSelectorCubit, GroupSelectorState>(
    'load() populates groups from the repository',
    build: buildCubit,
    act: (cubit) async {
      cubit.load();
      await Future<void>.delayed(Duration.zero);
      groupsController.add([homelab]);
    },
    expect: () => [
      GroupSelectorState(groups: [homelab]),
    ],
  );

  blocTest<GroupSelectorCubit, GroupSelectorState>(
    'select() updates selectedGroupId',
    build: buildCubit,
    act: (cubit) => cubit.select('grp-1'),
    expect: () => [
      const GroupSelectorState(selectedGroupId: 'grp-1'),
    ],
  );

  blocTest<GroupSelectorCubit, GroupSelectorState>(
    'deleteGroup() resets selection to null when the selected group is deleted',
    build: buildCubit,
    seed: () => const GroupSelectorState(selectedGroupId: 'grp-1'),
    act: (cubit) async {
      await cubit.deleteGroup('grp-1');
    },
    expect: () => [
      const GroupSelectorState(selectedGroupId: null),
    ],
  );

  blocTest<GroupSelectorCubit, GroupSelectorState>(
    'deleteGroup() leaves selection untouched when a different group is deleted',
    build: buildCubit,
    seed: () => const GroupSelectorState(selectedGroupId: 'grp-1'),
    act: (cubit) async {
      await cubit.deleteGroup('grp-2');
    },
    expect: () => [],
  );
}
