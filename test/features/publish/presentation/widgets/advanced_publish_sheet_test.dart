import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/features/publish/domain/entities/publish_draft.dart';
import 'package:ntfyd/features/publish/presentation/widgets/advanced_publish_sheet.dart';

void main() {
  // The default (non-isScrollControlled) modal bottom sheet caps content
  // height at 9/16 of the available window height (see Flutter's
  // `_getConstraintsForChild` in bottom_sheet.dart). The default 800x600
  // test window leaves too little room for AdvancedPublishSheet's fields,
  // so the "Publish" button ends up laid out below the visible viewport
  // and `tap()` misses it. Widen the simulated window so the sheet (as
  // used verbatim, without isScrollControlled, matching this test's own
  // showModalBottomSheet call) renders fully on-screen. Production usage
  // via ComposerBar passes isScrollControlled: true and doesn't hit this.

  testWidgets(
    'Publish returns a validated PublishDraft with the entered fields',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );

      final resultFuture = showModalBottomSheet<PublishDraft>(
        context: capturedContext,
        builder: (_) => const AdvancedPublishSheet(topic: 'alerts'),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), 'Backup failed');
      await tester.tap(find.text('Publish'));
      await tester.pumpAndSettle();

      final draft = await resultFuture;
      expect(draft?.topic, 'alerts');
      expect(draft?.body, 'Backup failed');
      expect(draft?.priority, 3);
    },
  );

  testWidgets(
    'Publish does nothing when body is empty and no attachment is set',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );

      final resultFuture = showModalBottomSheet<PublishDraft>(
        context: capturedContext,
        builder: (_) => const AdvancedPublishSheet(topic: 'alerts'),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Publish'));
      await tester.pump();

      expect(find.text('Advanced publish'), findsOneWidget);

      // The sheet is still open (Publish was a no-op) — dismiss it manually
      // so `resultFuture` resolves and the test doesn't leak a pending route.
      Navigator.of(capturedContext).pop();
      await tester.pumpAndSettle();
      expect(await resultFuture, isNull);
    },
  );

  testWidgets(
    'does not overflow at the default test window size used in production '
    '(isScrollControlled: true, no oversized window)',
    (tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );

      unawaited(
        showModalBottomSheet<PublishDraft>(
          context: capturedContext,
          isScrollControlled: true,
          builder: (_) => const AdvancedPublishSheet(topic: 'alerts'),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    },
  );
}
