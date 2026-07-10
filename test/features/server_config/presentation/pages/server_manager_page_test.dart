// test/features/server_config/presentation/pages/server_manager_page_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/di/injection_container.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_manager_cubit.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_manager_state.dart';
import 'package:ntfyd/features/server_config/presentation/pages/server_manager_page.dart';

class MockServerManagerCubit extends MockCubit<ServerManagerState>
    implements ServerManagerCubit {}

void main() {
  late MockServerManagerCubit cubit;

  final noAuthServer = ServerConfig(
    id: 'srv-1',
    baseUrl: 'https://ntfy.sh',
    displayName: 'ntfy.sh',
    authType: AuthType.none,
    isDefault: true,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  final basicAuthServer = ServerConfig(
    id: 'srv-2',
    baseUrl: 'https://home.example.com',
    displayName: 'Homelab',
    authType: AuthType.basic,
    credentialRef: 'srv-2',
    isDefault: false,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  setUp(() {
    cubit = MockServerManagerCubit();
    when(() => cubit.load()).thenAnswer((_) async {});
    when(() => cubit.setDefault(any())).thenAnswer((_) async {});
    when(() => cubit.remove(any())).thenAnswer((_) async {});

    // ServerManagerPage self-provisions its ServerManagerCubit via GetIt
    // (matching the settings/subscribe-topic-sheet call sites, which push
    // `const ServerManagerPage()` with no ancestor BlocProvider). Register
    // the same mock instance here so the widget's internally created
    // provider resolves to it.
    getIt.registerFactory<ServerManagerCubit>(() => cubit);
  });

  tearDown(() async {
    await getIt.reset();
  });

  Future<void> pumpPage(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ServerManagerCubit>.value(
          value: cubit,
          child: const ServerManagerPage(),
        ),
      ),
    );
  }

  testWidgets('shows loading indicator in loading state', (tester) async {
    when(() => cubit.state).thenReturn(const ServerManagerState.loading());

    await pumpPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders each server with name, url, and credential type', (
    tester,
  ) async {
    when(() => cubit.state).thenReturn(
      ServerManagerState.loaded([noAuthServer, basicAuthServer]),
    );

    await pumpPage(tester);

    expect(find.text('ntfy.sh'), findsOneWidget);
    expect(find.textContaining('No auth'), findsOneWidget);
    expect(find.text('Homelab'), findsOneWidget);
    expect(find.textContaining('Basic auth'), findsOneWidget);
  });

  testWidgets('shows Default badge only on the default server', (
    tester,
  ) async {
    when(() => cubit.state).thenReturn(
      ServerManagerState.loaded([noAuthServer, basicAuthServer]),
    );

    await pumpPage(tester);

    expect(find.widgetWithText(Chip, 'Default'), findsOneWidget);
  });

  testWidgets('error state shows message and retry button', (tester) async {
    when(() => cubit.state).thenReturn(
      const ServerManagerState.error(
        failure: Failure.cache(message: 'db error'),
      ),
    );

    await pumpPage(tester);

    expect(find.widgetWithText(OutlinedButton, 'Retry'), findsOneWidget);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Retry'));
    await tester.pump();

    verify(() => cubit.load()).called(greaterThanOrEqualTo(1));
  });

  testWidgets(
    'menu for the default no-auth server omits Set as default and Edit credentials',
    (tester) async {
      when(() => cubit.state).thenReturn(
        ServerManagerState.loaded([noAuthServer]),
      );

      await pumpPage(tester);

      await tester.tap(find.byWidgetPredicate((w) => w is PopupMenuButton));
      await tester.pumpAndSettle();

      expect(find.text('Set as default'), findsNothing);
      expect(find.text('Edit credentials'), findsNothing);
      expect(find.text('Remove'), findsOneWidget);
    },
  );

  testWidgets(
    'menu for a non-default basic-auth server offers Set as default and Edit credentials',
    (tester) async {
      when(() => cubit.state).thenReturn(
        ServerManagerState.loaded([basicAuthServer]),
      );

      await pumpPage(tester);

      await tester.tap(find.byWidgetPredicate((w) => w is PopupMenuButton));
      await tester.pumpAndSettle();

      expect(find.text('Set as default'), findsOneWidget);
      expect(find.text('Edit credentials'), findsOneWidget);
      expect(find.text('Remove'), findsOneWidget);
    },
  );

  testWidgets('tapping Set as default calls cubit.setDefault', (
    tester,
  ) async {
    when(() => cubit.state).thenReturn(
      ServerManagerState.loaded([basicAuthServer]),
    );

    await pumpPage(tester);

    await tester.tap(find.byWidgetPredicate((w) => w is PopupMenuButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Set as default'));
    await tester.pumpAndSettle();

    verify(() => cubit.setDefault('srv-2')).called(1);
  });

  testWidgets('Remove shows confirm dialog; confirming calls cubit.remove', (
    tester,
  ) async {
    when(() => cubit.state).thenReturn(
      ServerManagerState.loaded([noAuthServer]),
    );

    await pumpPage(tester);

    await tester.tap(find.byWidgetPredicate((w) => w is PopupMenuButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Remove ntfy.sh?'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Remove'));
    await tester.pumpAndSettle();

    verify(() => cubit.remove('srv-1')).called(1);
  });

  testWidgets('Remove dialog Cancel does not call cubit.remove', (
    tester,
  ) async {
    when(() => cubit.state).thenReturn(
      ServerManagerState.loaded([noAuthServer]),
    );

    await pumpPage(tester);

    await tester.tap(find.byWidgetPredicate((w) => w is PopupMenuButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();

    verifyNever(() => cubit.remove(any()));
  });
}
