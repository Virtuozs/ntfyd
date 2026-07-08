import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/settings/domain/repositories/settings_repository.dart';
import 'package:ntfyd/features/settings/domain/usecases/clear_cache.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late MockSettingsRepository repository;
  late ClearCache useCase;

  setUp(() {
    repository = MockSettingsRepository();
    useCase = ClearCache(repository);
  });

  test('delegates to repository.clearCache', () async {
    when(() => repository.clearCache()).thenAnswer(
      (_) async => const Result.success(null),
    );

    final result = await useCase.call(const NoParams());

    expect(result.isSuccess, isTrue);
    verify(() => repository.clearCache()).called(1);
  });
}
