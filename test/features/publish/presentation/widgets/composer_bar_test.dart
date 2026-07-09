import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/publish/domain/entities/publish_draft.dart';
import 'package:ntfyd/features/publish/presentation/cubits/publish_cubit.dart';
import 'package:ntfyd/features/publish/presentation/cubits/publish_state.dart';
import 'package:ntfyd/features/publish/presentation/widgets/composer_bar.dart';
import 'package:ntfyd/shared/theme/app_theme.dart';

class MockPublishCubit extends MockCubit<PublishState>
    implements PublishCubit {}

void main() {
  late MockPublishCubit cubit;

  setUpAll(() {
    registerFallbackValue(
      PublishDraft.validate(topic: 'alerts', body: 'x').valueOrThrow,
    );
  });

  setUp(() {
    cubit = MockPublishCubit();
    whenListen(
      cubit,
      const Stream<PublishState>.empty(),
      initialState: const PublishState.idle(),
    );
    when(() => cubit.submit(any(), any())).thenAnswer((_) async {});
  });

  Future<void> pumpBar(WidgetTester tester) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<PublishCubit>.value(
            value: cubit,
            child: const ComposerBar(serverId: 'srv-1', topic: 'alerts'),
          ),
        ),
      ),
    );
  }

  testWidgets('renders the text field and Send button', (tester) async {
    await pumpBar(tester);

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Send'), findsOneWidget);
  });

  testWidgets('tapping Send with text submits a validated draft', (
    tester,
  ) async {
    await pumpBar(tester);

    await tester.enterText(find.byType(TextField), 'Backup failed');
    await tester.tap(find.text('Send'));

    final captured = verify(
      () => cubit.submit('srv-1', captureAny()),
    ).captured;
    final draft = captured.single as PublishDraft;
    expect(draft.topic, 'alerts');
    expect(draft.body, 'Backup failed');
  });

  testWidgets('tapping Send with empty text does nothing', (tester) async {
    await pumpBar(tester);

    await tester.tap(find.text('Send'));

    verifyNever(() => cubit.submit(any(), any()));
  });

  testWidgets('shows a progress indicator while submitting', (tester) async {
    whenListen(
      cubit,
      const Stream<PublishState>.empty(),
      initialState: const PublishState.submitting(),
    );

    await pumpBar(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows a success snackbar when the cubit emits PublishSuccess', (
    tester,
  ) async {
    whenListen(
      cubit,
      Stream.fromIterable([const PublishState.success()]),
      initialState: const PublishState.idle(),
    );

    await pumpBar(tester);
    await tester.pump();

    expect(find.text('Message sent'), findsOneWidget);
  });

  testWidgets(
    'lays out cleanly under the app theme (Send sits next to an Expanded '
    'TextField in a Row, so it must not inherit the theme-wide full-width '
    'FilledButton minimumSize)',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.defaultDark(),
          home: Scaffold(
            body: BlocProvider<PublishCubit>.value(
              value: cubit,
              child: const ComposerBar(serverId: 'srv-1', topic: 'alerts'),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    },
  );
}
