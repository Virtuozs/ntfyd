import 'package:local_auth/local_auth.dart';
import 'package:ntfyd/core/app_lock/app_lock_service.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';

class LocalAuthAppLockService implements AppLockService {
  LocalAuthAppLockService(this._auth);

  final LocalAuthentication _auth;

  @override
  Future<bool> isAvailable() async {
    final supported = await _auth.isDeviceSupported();
    final canCheck = await _auth.canCheckBiometrics;
    return supported && canCheck;
  }

  @override
  Future<Result<bool>> authenticate(String reason) async {
    try {
      final authenticated = await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: false, // allows PIN/pattern fallback
        persistAcrossBackgrounding: true,
      );

      if (authenticated) return const Result.success(true);

      return const Result.err(
        Failure.biometric(reason: 'Authentication failed or cancelled'),
      );
    } on LocalAuthException catch (e) {
      return Result.err(Failure.biometric(reason: _mapCode(e.code)));
    }
  }

  String _mapCode(LocalAuthExceptionCode code) {
    return switch (code) {
      LocalAuthExceptionCode.noBiometricHardware =>
        'Biometrics not available on this device',
      LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable =>
        'Biometrics temporarily unavailable',
      LocalAuthExceptionCode.noBiometricsEnrolled =>
        'No biometrics enrolled on this device',
      LocalAuthExceptionCode.noCredentialsSet =>
        'No device credentials set (PIN, pattern, or passcode)',
      LocalAuthExceptionCode.temporaryLockout =>
        'Too many attempts — temporarily locked out',
      LocalAuthExceptionCode.biometricLockout =>
        'Too many attempts — permanently locked out',
      LocalAuthExceptionCode.userCanceled => 'Authentication cancelled by user',
      LocalAuthExceptionCode.userRequestedFallback =>
        'User requested fallback authentication',
      _ => 'Biometric error: ${code.name}',
    };
  }
}
