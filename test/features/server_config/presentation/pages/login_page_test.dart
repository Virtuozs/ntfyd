import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/features/home/presentation/pages/home_page.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_form_cubit.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_form_state.dart';
import 'package:ntfyd/features/server_config/presentation/pages/login_page.dart';
import 'package:ntfyd/shared/theme/app_theme.dart';

class MockServerFormCubit extends MockCubit<ServerFormState>
    implements ServerFormCubit {}

void main() {
  late MockServerFormCubit cubit;

  setUp(() {
    cubit = MockServerFormCubit();
    when(() => cubit.state).thenReturn(const ServerFormState.idle());
    when(
      () => cubit.connect(
        url: any(named: 'url'),
        user: any(named: 'user'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});
  });

  Future<void> pumpPage(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.defaultDark(),
        home: BlocProvider<ServerFormCubit>.value(
          value: cubit,
          child: const LoginPage(),
        ),
      ),
    );
  }

  testWidgets('renders title and subtitle', (tester) async {
    await pumpPage(tester);

    expect(find.text('ntfyd'), findsOneWidget);
    expect(
      find.text('Self-hosted & public notification client'),
      findsOneWidget,
    );
  });

  testWidgets('renders 3 text fields with correct hints', (tester) async {
    await pumpPage(tester);

    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.text('Server URL (default:https://ntfy.sh)'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('renders Connect button and footer text', (tester) async {
    await pumpPage(tester);

    expect(find.widgetWithText(FilledButton, 'Connect'), findsOneWidget);
    expect(find.text('Supports self-hosted servers'), findsOneWidget);
  });

  testWidgets('shows progress indicator and disables button when validating', (
    tester,
  ) async {
    when(() => cubit.state).thenReturn(const ServerFormState.validating());
    whenListen(
      cubit,
      Stream.fromIterable([const ServerFormState.validating()]),
      initialState: const ServerFormState.validating(),
    );

    await pumpPage(tester);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('shows SnackBar with error message on error state', (
    tester,
  ) async {
    whenListen(
      cubit,
      Stream.fromIterable([
        const ServerFormState.validating(),
        const ServerFormState.error(
          failure: Failure.network(message: 'connection refused'),
        ),
      ]),
      initialState: const ServerFormState.idle(),
    );

    await pumpPage(tester);
    await tester.pump(); // validating
    await tester.pump(); // error
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('tapping Connect calls cubit.connect with field values', (
    tester,
  ) async {
    await pumpPage(tester);

    await tester.enterText(find.byType(TextFormField).at(0), 'ntfy.example');
    await tester.enterText(find.byType(TextFormField).at(1), 'alice');
    await tester.enterText(find.byType(TextFormField).at(2), 'secret');

    await tester.tap(find.widgetWithText(FilledButton, 'Connect'));
    await tester.pump();

    verify(
      () =>
          cubit.connect(url: 'ntfy.example', user: 'alice', password: 'secret'),
    ).called(1);
  });

  testWidgets('navigates to HomePage on success state', (tester) async {
    whenListen(
      cubit,
      Stream.fromIterable([
        const ServerFormState.validating(),
        const ServerFormState.success(),
      ]),
      initialState: const ServerFormState.idle(),
    );

    await pumpPage(tester);
    await tester.pump(); // validating
    await tester.pump(); // success
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
  });
}
