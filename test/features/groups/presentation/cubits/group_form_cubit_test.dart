import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/groups/domain/entities/group.dart';
import 'package:ntfyd/features/groups/domain/entities/group_membership.dart';
import 'package:ntfyd/features/groups/domain/usecases/save_group.dart';
import 'package:ntfyd/features/groups/presentation/cubits/group_form_cubit.dart';
import 'package:ntfyd/features/groups/presentation/cubits/group_form_state.dart';

class MockSaveGroup extends Mock implements SaveGroup {}

void main() {
  late MockSaveGroup saveGroup;

  setUpAll(() {
    registerFallbackValue(const SaveGroupParams(name: 'placeholder'));
  });

  setUp(() {
    saveGroup = MockSaveGroup();
  });

  GroupFormCubit buildCubit() => GroupFormCubit(saveGroup);

  blocTest<GroupFormCubit, GroupFormState>(
    'submit() emits submitting then success on success',
    build: buildCubit,
    setUp: () {
      when(() => saveGroup.call(any())).thenAnswer(
        (_) async => const Result.success(Group(id: 'grp-1', name: 'Homelab')),
      );
    },
    act: (cubit) => cubit.submit(name: 'Homelab'),
    expect: () => [
      const GroupFormState.submitting(),
      const GroupFormState.success(group: Group(id: 'grp-1', name: 'Homelab')),
    ],
  );

  blocTest<GroupFormCubit, GroupFormState>(
    'submit() emits submitting then error on failure',
    build: buildCubit,
    setUp: () {
      when(() => saveGroup.call(any())).thenAnswer(
        (_) async => const Result.err(
          Failure.validation(field: 'name', message: 'name must not be empty'),
        ),
      );
    },
    act: (cubit) => cubit.submit(name: ''),
    expect: () => [
      const GroupFormState.submitting(),
      const GroupFormState.error(
        failure: Failure.validation(field: 'name', message: 'name must not be empty'),
      ),
    ],
  );

  blocTest<GroupFormCubit, GroupFormState>(
    'submit() passes id, color, members, and filter through to SaveGroupParams',
    build: buildCubit,
    setUp: () {
      when(() => saveGroup.call(any())).thenAnswer(
        (_) async => const Result.success(Group(id: 'grp-1', name: 'Homelab')),
      );
    },
    act: (cubit) => cubit.submit(
      id: 'grp-1',
      name: 'Homelab',
      color: 0xFF0000FF,
      members: {const GroupMembership(serverId: 'srv-1', topic: 'alerts')},
    ),
    verify: (_) {
      verify(
        () => saveGroup.call(
          any(
            that: predicate<SaveGroupParams>(
              (p) =>
                  p.id == 'grp-1' &&
                  p.name == 'Homelab' &&
                  p.color == 0xFF0000FF &&
                  p.members.contains(
                    const GroupMembership(serverId: 'srv-1', topic: 'alerts'),
                  ),
            ),
          ),
        ),
      ).called(1);
    },
  );
}
