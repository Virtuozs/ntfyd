import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/app_lock/app_lock_guard.dart';
import 'package:ntfyd/core/app_lock/app_lock_service.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';

class MockAppLockService extends Mock implements AppLockService {}

Widget _buildGuard({
  required bool biometricLock,
  required AppLockService service,
}) {
  return MaterialApp(
    home: AppLockGuard(
      biometricLock: biometricLock,
      appLockService: service,
      child: const Text('protected content'),
    ),
  );
}

void _triggerResume() {
  WidgetsBinding.instance.handleAppLifecycleStateChanged(
    AppLifecycleState.resumed,
  );
}

void _triggerPause() {
  WidgetsBinding.instance.handleAppLifecycleStateChanged(
    AppLifecycleState.paused,
  );
}

void main() {
  late MockAppLockService service;

  setUp(() {
    service = MockAppLockService();

    // Fallback stubs
    when(
      () => service.authenticate(any()),
    ).thenAnswer((_) async => const Result.success(true));

    when(() => service.isAvailable()).thenAnswer((_) async => true);
  });

  group('biometricLock disabled', () {
    testWidgets('shows child without overlay when biometricLock is false', (
      tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        _buildGuard(biometricLock: false, service: service),
      );
      await tester.pump();

      // Assert
      expect(find.text('protected content'), findsOneWidget);
      expect(find.byKey(const Key('lock_overlay')), findsNothing);
    });

    testWidgets('does not call authenticate when biometricLock is false', (
      tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        _buildGuard(biometricLock: false, service: service),
      );
      _triggerResume();
      await tester.pump();

      // Assert
      verifyNever(() => service.authenticate(any()));
    });

    testWidgets('does not show overlay on resume when biometricLock is false', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        _buildGuard(biometricLock: false, service: service),
      );

      // Act
      _triggerResume();
      await tester.pump();

      // Assert
      expect(find.byKey(const Key('lock_overlay')), findsNothing);
    });
  });

  group('biometricLock enabled', () {
    testWidgets('shows lock overlay on app resume', (tester) async {
      final completer = Completer<Result<bool>>();
      when(
        () => service.authenticate(any()),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(
        _buildGuard(biometricLock: true, service: service),
      );

      _triggerResume();
      await tester.pump();

      expect(find.byKey(const Key('lock_overlay')), findsOneWidget);
      completer.complete(const Result.success(true));
      await tester.pumpAndSettle();
    });

    testWidgets('removes overlay after successful authentication', (
      tester,
    ) async {
      // Arrange
      when(
        () => service.authenticate(any()),
      ).thenAnswer((_) async => const Result.success(true));

      await tester.pumpWidget(
        _buildGuard(biometricLock: true, service: service),
      );

      // Act
      _triggerResume();
      await tester.pumpAndSettle();

      // Assert
      expect(find.byKey(const Key('lock_overlay')), findsNothing);
      expect(find.text('protected content'), findsOneWidget);
    });

    testWidgets('keeps overlay after failed authentication', (tester) async {
      // Arrange
      when(() => service.authenticate(any())).thenAnswer(
        (_) async => Result.err(const Failure.biometric(reason: 'cancelled')),
      );

      await tester.pumpWidget(
        _buildGuard(biometricLock: true, service: service),
      );

      // Act
      _triggerResume();
      await tester.pumpAndSettle();

      // Assert
      expect(find.byKey(const Key('lock_overlay')), findsOneWidget);
    });

    testWidgets('calls authenticate with correct reason', (tester) async {
      // Arrange
      await tester.pumpWidget(
        _buildGuard(biometricLock: true, service: service),
      );

      // Act
      _triggerResume();
      await tester.pumpAndSettle();

      // Assert
      verify(() => service.authenticate('Unlock ntfyd to continue')).called(1);
    });

    testWidgets(
      'shows "Use device PIN" option after $maxAttempts failed attempts',
      (tester) async {
        // Arrange
        when(() => service.authenticate(any())).thenAnswer(
          (_) async => Result.err(const Failure.biometric(reason: 'failed')),
        );

        await tester.pumpWidget(
          _buildGuard(biometricLock: true, service: service),
        );

        // Act — each paused→resumed cycle triggers a new auth attempt
        for (var i = 0; i < maxAttempts; i++) {
          _triggerPause();
          _triggerResume();
          await tester.pumpAndSettle();
        }

        // Assert
        expect(find.text('Use device PIN'), findsOneWidget);
      },
    );

    testWidgets('does not show "Use device PIN" before max attempts', (
      tester,
    ) async {
      // Arrange
      when(() => service.authenticate(any())).thenAnswer(
        (_) async => Result.err(const Failure.biometric(reason: 'failed')),
      );

      await tester.pumpWidget(
        _buildGuard(biometricLock: true, service: service),
      );

      // Act — one less than max
      for (var i = 0; i < maxAttempts - 1; i++) {
        _triggerPause();
        _triggerResume();
        await tester.pumpAndSettle();
      }

      // Assert
      expect(find.text('Use device PIN'), findsNothing);
      expect(find.byKey(const Key('lock_overlay')), findsOneWidget);
    });

    testWidgets('does not trigger concurrent auth calls', (tester) async {
      final completer = Completer<Result<bool>>();
      when(
        () => service.authenticate(any()),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(
        _buildGuard(biometricLock: true, service: service),
      );

      // trigger resume twice rapidly
      _triggerResume();
      _triggerResume();
      await tester.pump();

      // authenticate called only once despite two resumes
      verify(() => service.authenticate(any())).called(1);

      completer.complete(const Result.success(true));
      await tester.pumpAndSettle();
    });
  });
}

const maxAttempts = 3;
