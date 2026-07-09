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
  bool hideLockScreenContent = true,
  Widget child = const Text('protected content'),
  Duration lockTimeout = const Duration(minutes: 10),
  DateTime Function() now = DateTime.now,
}) {
  return MaterialApp(
    home: AppLockGuard(
      biometricLock: biometricLock,
      hideLockScreenContent: hideLockScreenContent,
      appLockService: service,
      lockTimeout: lockTimeout,
      now: now,
      child: child,
    ),
  );
}

void _triggerResume() {
  WidgetsBinding.instance.handleAppLifecycleStateChanged(
    AppLifecycleState.resumed,
  );
}

void main() {
  late MockAppLockService service;

  setUp(() {
    service = MockAppLockService();

    when(
      () => service.authenticate(any()),
    ).thenAnswer((_) async => const Result.success(true));
  });

  group('biometricLock disabled', () {
    testWidgets('shows child without overlay and never authenticates', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildGuard(biometricLock: false, service: service),
      );
      await tester.pump();

      expect(find.text('protected content'), findsOneWidget);
      expect(find.byKey(const Key('lock_overlay')), findsNothing);
      verifyNever(() => service.authenticate(any()));
    });

    testWidgets('does not show overlay on resume when biometricLock is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildGuard(biometricLock: false, service: service),
      );

      _triggerResume();
      await tester.pump();

      expect(find.byKey(const Key('lock_overlay')), findsNothing);
    });
  });

  group('biometricLock enabled', () {
    testWidgets('locks immediately on cold start, before any resume event', (
      tester,
    ) async {
      final completer = Completer<Result<bool>>();
      when(
        () => service.authenticate(any()),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(
        _buildGuard(biometricLock: true, service: service),
      );
      await tester.pump();

      expect(find.byKey(const Key('lock_overlay')), findsOneWidget);
      verify(() => service.authenticate('Unlock ntfyd to continue')).called(1);

      completer.complete(const Result.success(true));
      await tester.pumpAndSettle();
    });

    testWidgets('locks when biometricLock flips from false to true', (
      tester,
    ) async {
      final completer = Completer<Result<bool>>();
      when(
        () => service.authenticate(any()),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(
        _buildGuard(biometricLock: false, service: service),
      );
      await tester.pump();
      expect(find.byKey(const Key('lock_overlay')), findsNothing);

      await tester.pumpWidget(
        _buildGuard(biometricLock: true, service: service),
      );
      await tester.pump();

      expect(find.byKey(const Key('lock_overlay')), findsOneWidget);

      completer.complete(const Result.success(true));
      await tester.pumpAndSettle();
    });

    testWidgets('removes overlay after successful authentication', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildGuard(biometricLock: true, service: service),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('lock_overlay')), findsNothing);
      expect(find.text('protected content'), findsOneWidget);
    });

    testWidgets(
      'keeps overlay and shows the failure message after failed authentication',
      (tester) async {
        when(() => service.authenticate(any())).thenAnswer(
          (_) async =>
              const Result.err(Failure.biometric(reason: 'cancelled')),
        );

        await tester.pumpWidget(
          _buildGuard(biometricLock: true, service: service),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('lock_overlay')), findsOneWidget);
        expect(find.text('Authentication failed. Try again.'), findsOneWidget);
      },
    );

    testWidgets('does not trigger concurrent auth calls on rapid resume', (
      tester,
    ) async {
      final completer = Completer<Result<bool>>();
      when(
        () => service.authenticate(any()),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(
        _buildGuard(biometricLock: true, service: service),
      );

      _triggerResume();
      await tester.pump();

      verify(() => service.authenticate(any())).called(1);

      completer.complete(const Result.success(true));
      await tester.pumpAndSettle();
    });

    testWidgets(
      'does not re-lock on a resume within the grace window after a '
      'successful authentication (e.g. the biometric prompt itself closing)',
      (tester) async {
        var now = DateTime(2026, 1, 1, 12);

        await tester.pumpWidget(
          _buildGuard(biometricLock: true, service: service, now: () => now),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('lock_overlay')), findsNothing);
        verify(() => service.authenticate(any())).called(1);

        now = now.add(const Duration(minutes: 5));
        _triggerResume();
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('lock_overlay')), findsNothing);
        verifyNever(() => service.authenticate(any()));
      },
    );

    testWidgets(
      're-locks on resume once the grace window has elapsed since the '
      'last successful authentication',
      (tester) async {
        var now = DateTime(2026, 1, 1, 12);

        await tester.pumpWidget(
          _buildGuard(
            biometricLock: true,
            service: service,
            now: () => now,
            lockTimeout: const Duration(minutes: 10),
          ),
        );
        await tester.pumpAndSettle();
        verify(() => service.authenticate(any())).called(1);

        final completer = Completer<Result<bool>>();
        when(
          () => service.authenticate(any()),
        ).thenAnswer((_) => completer.future);

        now = now.add(const Duration(minutes: 11));
        _triggerResume();
        await tester.pump();

        expect(find.byKey(const Key('lock_overlay')), findsOneWidget);
        verify(() => service.authenticate(any())).called(1);

        completer.complete(const Result.success(true));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('lock_overlay')), findsNothing);
      },
    );

    testWidgets('blurs the background when hideLockScreenContent is true', (
      tester,
    ) async {
      final completer = Completer<Result<bool>>();
      when(
        () => service.authenticate(any()),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(
        _buildGuard(
          biometricLock: true,
          service: service,
          hideLockScreenContent: true,
        ),
      );
      await tester.pump();

      expect(find.byType(BackdropFilter), findsOneWidget);

      completer.complete(const Result.success(true));
      await tester.pumpAndSettle();
    });

    testWidgets(
      'does not blur but still blocks interaction when hideLockScreenContent is false',
      (tester) async {
        final completer = Completer<Result<bool>>();
        when(
          () => service.authenticate(any()),
        ).thenAnswer((_) => completer.future);

        var tapped = false;

        await tester.pumpWidget(
          _buildGuard(
            biometricLock: true,
            service: service,
            hideLockScreenContent: false,
            child: GestureDetector(
              onTap: () => tapped = true,
              child: const Text('protected content'),
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(BackdropFilter), findsNothing);
        expect(find.byKey(const Key('lock_overlay')), findsOneWidget);

        await tester.tap(find.text('protected content'), warnIfMissed: false);
        await tester.pump();
        expect(tapped, isFalse);

        completer.complete(const Result.success(true));
        await tester.pumpAndSettle();
      },
    );
  });
}
