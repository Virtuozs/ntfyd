import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/settings/domain/entities/app_settings.dart';
import 'package:ntfyd/features/settings/domain/repositories/settings_repository.dart';

class UpdateSettingsParams {
  const UpdateSettingsParams({required this.settings});

  final AppSettings settings;
}

/// Validates `quietHoursStart`/`quietHoursEnd` (both null, or both a
/// well-formed 24h `"HH:mm"`) before persisting via [SettingsRepository].
@injectable
class UpdateSettings implements UseCase<UpdateSettingsParams, AppSettings> {
  UpdateSettings(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Result<AppSettings>> call(UpdateSettingsParams params) async {
    final settings = params.settings;
    final start = settings.quietHoursStart;
    final end = settings.quietHoursEnd;

    if (start == null && end == null) {
      return _repository.update(settings);
    }

    if (start == null || end == null || !_isValidHHmm(start) || !_isValidHHmm(end)) {
      return const Result.err(
        Failure.validation(
          field: 'quietHours',
          message: 'quietHoursStart/quietHoursEnd must both be a valid "HH:mm" value',
        ),
      );
    }

    return _repository.update(settings);
  }

  bool _isValidHHmm(String value) {
    final parts = value.split(':');
    if (parts.length != 2) return false;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return false;
    return h >= 0 && h <= 23 && m >= 0 && m <= 59;
  }
}
