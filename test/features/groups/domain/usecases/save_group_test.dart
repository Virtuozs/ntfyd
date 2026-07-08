import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/groups/domain/entities/group.dart';
import 'package:ntfyd/features/groups/domain/entities/group_membership.dart';
import 'package:ntfyd/features/groups/domain/repositories/group_repository.dart';
import 'package:ntfyd/features/groups/domain/usecases/save_group.dart';

class MockGroupRepository extends Mock implements GroupRepository {}

void main() {
  late MockGroupRepository repository;
  late SaveGroup useCase;

  const fixedId = 'grp-11111111-1111-1111-1111-111111111111';

  setUpAll(() {
    registerFallbackValue(Group(id: fixedId, name: 'placeholder'));
  });

  setUp(() {
    repository = MockGroupRepository();
    SaveGroupTestHooks.idGenerator = () => fixedId;
    useCase = SaveGroup(repository);
  });

  tearDown(() {
    SaveGroupTestHooks.idGenerator = null;
  });

  group('SaveGroup', () {
    test('generates an id and saves when creating (id == null)', () async {
      when(() => repository.save(any())).thenAnswer(
        (invocation) async =>
            Result.success(invocation.positionalArguments[0] as Group),
      );

      final result = await useCase.call(
        const SaveGroupParams(name: 'Homelab'),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrThrow.id, fixedId);
      verify(
        () => repository.save(
          any(that: predicate<Group>((g) => g.id == fixedId && g.name == 'Homelab')),
        ),
      ).called(1);
    });

    test('reuses the given id when updating', () async {
      when(() => repository.save(any())).thenAnswer(
        (invocation) async =>
            Result.success(invocation.positionalArguments[0] as Group),
      );

      final result = await useCase.call(
        const SaveGroupParams(id: 'grp-existing', name: 'Homelab'),
      );

      expect(result.valueOrThrow.id, 'grp-existing');
    });

    test('passes members and sortOrder through to the saved Group', () async {
      when(() => repository.save(any())).thenAnswer(
        (invocation) async =>
            Result.success(invocation.positionalArguments[0] as Group),
      );
      final members = {const GroupMembership(serverId: 'srv-1', topic: 'alerts')};

      final result = await useCase.call(
        SaveGroupParams(name: 'Homelab', members: members, sortOrder: 3),
      );

      expect(result.valueOrThrow.members, members);
      expect(result.valueOrThrow.sortOrder, 3);
    });

    test('returns ValidationFailure for a blank name without saving', () async {
      final result = await useCase.call(const SaveGroupParams(name: '  '));

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<ValidationFailure>());
      verifyNever(() => repository.save(any()));
    });
  });
}
