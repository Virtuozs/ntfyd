import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/settings/domain/entities/app_settings.dart';
import 'package:ntfyd/features/settings/domain/repositories/settings_repository.dart';
import 'package:ntfyd/features/settings/domain/usecases/update_settings.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late MockSettingsRepository repository;
  late UpdateSettings useCase;

  setUpAll(() {
    registerFallbackValue(const AppSettings());
  });

  setUp(() {
    repository = MockSettingsRepository();
    useCase = UpdateSettings(repository);
  });

  group('UpdateSettings', () {
    test('delegates to repository.update when quiet hours are both null', () async {
      const settings = AppSettings(themeMode: AppThemeMode.white);
      when(() => repository.update(settings)).thenAnswer(
        (_) async => const Result.success(settings),
      );

      final result = await useCase.call(
        const UpdateSettingsParams(settings: settings),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrThrow, settings);
      verify(() => repository.update(settings)).called(1);
    });

    test('delegates to repository.update when quiet hours are both well-formed', () async {
      const settings = AppSettings(
        quietHoursEnabled: true,
        quietHoursStart: '22:00',
        quietHoursEnd: '07:30',
      );
      when(() => repository.update(settings)).thenAnswer(
        (_) async => const Result.success(settings),
      );

      final result = await useCase.call(
        const UpdateSettingsParams(settings: settings),
      );

      expect(result.isSuccess, isTrue);
      verify(() => repository.update(settings)).called(1);
    });

    test('returns ValidationFailure when only quietHoursStart is set', () async {
      const settings = AppSettings(quietHoursStart: '22:00');

      final result = await useCase.call(
        const UpdateSettingsParams(settings: settings),
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<ValidationFailure>());
      verifyNever(() => repository.update(any()));
    });

    test('returns ValidationFailure for a malformed HH:mm value', () async {
      const settings = AppSettings(
        quietHoursStart: '22:00',
        quietHoursEnd: '25:99',
      );

      final result = await useCase.call(
        const UpdateSettingsParams(settings: settings),
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<ValidationFailure>());
      verifyNever(() => repository.update(any()));
    });
  });
}
