import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_add_edit_cubit.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_add_edit_state.dart';
import 'package:ntfyd/features/server_config/presentation/pages/add_server_page.dart';

class MockServerAddEditCubit extends MockCubit<ServerAddEditState>
    implements ServerAddEditCubit {}

void main() {
  late MockServerAddEditCubit cubit;

  final existing = ServerConfig(
    id: 'srv-1',
    baseUrl: 'https://ntfy.sh',
    displayName: 'ntfy.sh',
    authType: AuthType.basic,
    credentialRef: 'srv-1',
    isDefault: true,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  setUp(() {
    cubit = MockServerAddEditCubit();
    when(() => cubit.state).thenReturn(const ServerAddEditState.idle());
    when(
      () => cubit.addServer(
        url: any(named: 'url'),
        user: any(named: 'user'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => cubit.editCredentials(
        serverId: any(named: 'serverId'),
        user: any(named: 'user'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});
  });

  Future<void> pumpPage(WidgetTester tester, {ServerConfig? existing}) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ServerAddEditCubit>.value(
          value: cubit,
          child: AddServerPage(existing: existing),
        ),
      ),
    );
  }

  testWidgets('add mode shows URL field, 3 fields total, and Add button', (
    tester,
  ) async {
    await pumpPage(tester);

    expect(find.text('Add Server'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.widgetWithText(FilledButton, 'Add'), findsOneWidget);
  });

  testWidgets('edit mode shows read-only URL text, 2 fields, and Save button', (
    tester,
  ) async {
    await pumpPage(tester, existing: existing);

    expect(find.text('Edit Credentials'), findsOneWidget);
    expect(find.text('https://ntfy.sh'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.widgetWithText(FilledButton, 'Save'), findsOneWidget);
  });

  testWidgets('tapping Add calls cubit.addServer with field values', (
    tester,
  ) async {
    await pumpPage(tester);

    await tester.enterText(find.byType(TextFormField).at(0), 'ntfy.example');
    await tester.enterText(find.byType(TextFormField).at(1), 'alice');
    await tester.enterText(find.byType(TextFormField).at(2), 'secret');

    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await tester.pump();

    verify(
      () => cubit.addServer(
        url: 'ntfy.example',
        user: 'alice',
        password: 'secret',
      ),
    ).called(1);
  });

  testWidgets(
    'tapping Save in edit mode calls cubit.editCredentials with existing id',
    (tester) async {
      await pumpPage(tester, existing: existing);

      await tester.enterText(find.byType(TextFormField).at(0), 'alice');
      await tester.enterText(find.byType(TextFormField).at(1), 'newpass');

      await tester.tap(find.widgetWithText(FilledButton, 'Save'));
      await tester.pump();

      verify(
        () => cubit.editCredentials(
          serverId: 'srv-1',
          user: 'alice',
          password: 'newpass',
        ),
      ).called(1);
    },
  );

  testWidgets('edit mode with both fields blank disables the Save button', (
    tester,
  ) async {
    await pumpPage(tester, existing: existing);

    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Save'),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('edit mode enables Save once a field has text', (tester) async {
    await pumpPage(tester, existing: existing);

    await tester.enterText(find.byType(TextFormField).at(0), 'alice');
    await tester.pump();

    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Save'),
    );
    expect(button.onPressed, isNotNull);
  });

  testWidgets('pops on success state', (tester) async {
    whenListen(
      cubit,
      Stream.fromIterable([
        const ServerAddEditState.validating(),
        const ServerAddEditState.success(),
      ]),
      initialState: const ServerAddEditState.idle(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute<void>(
            builder: (_) => BlocProvider<ServerAddEditCubit>.value(
              value: cubit,
              child: const AddServerPage(),
            ),
          ),
        ),
      ),
    );
    await tester.pump(); // validating
    await tester.pump(); // success
    await tester.pumpAndSettle();

    expect(find.byType(AddServerPage), findsNothing);
  });

  testWidgets('shows SnackBar with error message on error state', (
    tester,
  ) async {
    whenListen(
      cubit,
      Stream.fromIterable([
        const ServerAddEditState.validating(),
        const ServerAddEditState.error(
          failure: Failure.network(message: 'connection refused'),
        ),
      ]),
      initialState: const ServerAddEditState.idle(),
    );

    await pumpPage(tester);
    await tester.pump(); // validating
    await tester.pump(); // error
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(SnackBar), findsOneWidget);
  });
}
