import 'package:ntfyd/core/usecase/result.dart';

abstract class AppLockService {
  /// Returns true if the device has biometric hardware AND enrolled
  /// credentials (fingerprint, face, etc.) or a device PIN/pattern.
  Future<bool> isAvailable();

  /// [reason] is the string shown in the system biometric dialog.
  /// Returns [Result.success(true)] on approval.
  /// Returns [Result.err(BiometricFailure)] on any failure:
  ///   - hardware not available
  ///   - no enrolled credentials
  ///   - too many failed attempts (locked out)
  ///   - user cancelled
  Future<Result<bool>> authenticate(String reason);
}
