import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/app_lock/local_auth_app_lock_service.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';

class MockLocalAuthentication extends Mock implements LocalAuthentication {}

void main() {
  late MockLocalAuthentication auth;
  late LocalAuthAppLockService service;

  setUp(() {
    auth = MockLocalAuthentication();
    service = LocalAuthAppLockService(auth);

    // Fallback stubs
    when(() => auth.isDeviceSupported()).thenAnswer((_) async => false);
    when(() => auth.canCheckBiometrics).thenAnswer((_) async => false);
    when(
      () => auth.authenticate(
        localizedReason: any(named: 'localizedReason'),
        biometricOnly: any(named: 'biometricOnly'),
        persistAcrossBackgrounding: any(named: 'persistAcrossBackgrounding'),
      ),
    ).thenAnswer((_) async => false);
  });

  group('isAvailable', () {
    test(
      'returns true when device supported and can check biometrics',
      () async {
        when(() => auth.isDeviceSupported()).thenAnswer((_) async => true);
        when(() => auth.canCheckBiometrics).thenAnswer((_) async => true);

        final result = await service.isAvailable();

        expect(result, isTrue);
      },
    );

    test('returns false when device is not supported', () async {
      when(() => auth.isDeviceSupported()).thenAnswer((_) async => false);
      when(() => auth.canCheckBiometrics).thenAnswer((_) async => true);

      final result = await service.isAvailable();

      expect(result, isFalse);
    });

    test('returns false when cannot check biometrics', () async {
      when(() => auth.isDeviceSupported()).thenAnswer((_) async => true);
      when(() => auth.canCheckBiometrics).thenAnswer((_) async => false);

      final result = await service.isAvailable();

      expect(result, isFalse);
    });
  });

  // ─── authenticate ─────────────────────────────────────────────────────────

  group('authenticate', () {
    test('returns Success(true) when local_auth succeeds', () async {
      when(
        () => auth.authenticate(
          localizedReason: any(named: 'localizedReason'),
          biometricOnly: any(named: 'biometricOnly'),
          persistAcrossBackgrounding: any(named: 'persistAcrossBackgrounding'),
        ),
      ).thenAnswer((_) async => true);

      final result = await service.authenticate('Please authenticate');

      expect(result.isSuccess, isTrue);
      expect(result.valueOrThrow, isTrue);
    });

    test(
      'returns Err(BiometricFailure) when local_auth returns false',
      () async {
        when(
          () => auth.authenticate(
            localizedReason: any(named: 'localizedReason'),
            biometricOnly: any(named: 'biometricOnly'),
            persistAcrossBackgrounding: any(
              named: 'persistAcrossBackgrounding',
            ),
          ),
        ).thenAnswer((_) async => false);

        final result = await service.authenticate('Please authenticate');

        expect(result.isSuccess, isFalse);
        expect(result.failureOrThrow, isA<BiometricFailure>());
      },
    );

    test(
      'returns Err(BiometricFailure) when noBiometricHardware thrown',
      () async {
        when(
          () => auth.authenticate(
            localizedReason: any(named: 'localizedReason'),
            biometricOnly: any(named: 'biometricOnly'),
            persistAcrossBackgrounding: any(
              named: 'persistAcrossBackgrounding',
            ),
          ),
        ).thenThrow(
          const LocalAuthException(
            code: LocalAuthExceptionCode.noBiometricHardware,
          ),
        );

        final result = await service.authenticate('Please authenticate');

        expect(result.isSuccess, isFalse);
        expect(result.failureOrThrow, isA<BiometricFailure>());
        expect(
          (result.failureOrThrow as BiometricFailure).reason,
          contains('not available'),
        );
      },
    );

    test(
      'returns Err(BiometricFailure) when temporaryLockout thrown',
      () async {
        when(
          () => auth.authenticate(
            localizedReason: any(named: 'localizedReason'),
            biometricOnly: any(named: 'biometricOnly'),
            persistAcrossBackgrounding: any(
              named: 'persistAcrossBackgrounding',
            ),
          ),
        ).thenThrow(
          const LocalAuthException(
            code: LocalAuthExceptionCode.temporaryLockout,
          ),
        );

        final result = await service.authenticate('Please authenticate');

        expect(result.isSuccess, isFalse);
        expect(result.failureOrThrow, isA<BiometricFailure>());
        expect(
          (result.failureOrThrow as BiometricFailure).reason,
          contains('locked out'),
        );
      },
    );

    test(
      'returns Err(BiometricFailure) when biometricLockout thrown',
      () async {
        when(
          () => auth.authenticate(
            localizedReason: any(named: 'localizedReason'),
            biometricOnly: any(named: 'biometricOnly'),
            persistAcrossBackgrounding: any(
              named: 'persistAcrossBackgrounding',
            ),
          ),
        ).thenThrow(
          const LocalAuthException(
            code: LocalAuthExceptionCode.biometricLockout,
          ),
        );

        final result = await service.authenticate('Please authenticate');

        expect(result.isSuccess, isFalse);
        expect(result.failureOrThrow, isA<BiometricFailure>());
        expect(
          (result.failureOrThrow as BiometricFailure).reason,
          contains('locked out'),
        );
      },
    );

    test('passes localizedReason to local_auth', () async {
      const reason = 'Unlock to view credentials';
      when(
        () => auth.authenticate(
          localizedReason: reason,
          biometricOnly: any(named: 'biometricOnly'),
          persistAcrossBackgrounding: any(named: 'persistAcrossBackgrounding'),
        ),
      ).thenAnswer((_) async => true);

      await service.authenticate(reason);

      verify(
        () => auth.authenticate(
          localizedReason: reason,
          biometricOnly: any(named: 'biometricOnly'),
          persistAcrossBackgrounding: any(named: 'persistAcrossBackgrounding'),
        ),
      ).called(1);
    });
  });
}
