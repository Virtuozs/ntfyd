import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/settings/domain/repositories/settings_repository.dart';
import 'package:ntfyd/features/settings/domain/usecases/clear_all_data.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late MockSettingsRepository repository;
  late ClearAllData useCase;

  setUp(() {
    repository = MockSettingsRepository();
    useCase = ClearAllData(repository);
  });

  test('delegates to repository.clearAllData', () async {
    when(() => repository.clearAllData()).thenAnswer(
      (_) async => const Result.success(null),
    );

    final result = await useCase.call(const NoParams());

    expect(result.isSuccess, isTrue);
    verify(() => repository.clearAllData()).called(1);
  });
}
