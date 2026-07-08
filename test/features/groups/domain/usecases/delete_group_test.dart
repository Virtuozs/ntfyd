import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/groups/domain/repositories/group_repository.dart';
import 'package:ntfyd/features/groups/domain/usecases/delete_group.dart';

class MockGroupRepository extends Mock implements GroupRepository {}

void main() {
  late MockGroupRepository repository;
  late DeleteGroup useCase;

  setUp(() {
    repository = MockGroupRepository();
    useCase = DeleteGroup(repository);
  });

  test('delegates to repository.delete', () async {
    when(() => repository.delete('grp-1')).thenAnswer(
      (_) async => const Result.success(null),
    );

    final result = await useCase.call(const DeleteGroupParams(groupId: 'grp-1'));

    expect(result.isSuccess, isTrue);
    verify(() => repository.delete('grp-1')).called(1);
  });
}
