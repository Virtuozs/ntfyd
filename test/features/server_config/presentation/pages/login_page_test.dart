import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/di/injection_container.dart';
import 'package:ntfyd/features/feed/presentation/cubits/group_selector_cubit.dart';
import 'package:ntfyd/features/feed/presentation/cubits/group_selector_state.dart';
import 'package:ntfyd/features/feed/presentation/cubits/home_feed_cubit.dart';
import 'package:ntfyd/features/feed/presentation/cubits/home_feed_state.dart';
import 'package:ntfyd/features/feed/presentation/pages/home_page.dart';
import 'package:ntfyd/features/server_config/data/models/health_dto.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';
import 'package:ntfyd/features/server_config/domain/usecases/validate_server_health.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_form_cubit.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_form_state.dart';
import 'package:ntfyd/features/server_config/presentation/pages/login_page.dart';
import 'package:ntfyd/shared/theme/app_theme.dart';

class MockServerFormCubit extends MockCubit<ServerFormState>
    implements ServerFormCubit {}

class MockServerConfigRepository extends Mock implements ServerConfigRepository {}

class MockValidateServerHealth extends Mock implements ValidateServerHealth {}

class MockHomeFeedCubit extends Mock implements HomeFeedCubit {}

class MockGroupSelectorCubit extends Mock implements GroupSelectorCubit {}

void main() {
  final server = ServerConfig(
    id: 'srv-1',
    baseUrl: 'https://ntfy.sh',
    displayName: 'ntfy.sh',
    authType: AuthType.none,
    isDefault: true,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  late MockServerFormCubit cubit;
  late MockServerConfigRepository serverConfigRepository;
  late MockValidateServerHealth validateServerHealth;
  late MockHomeFeedCubit homeFeedCubit;
  late MockGroupSelectorCubit groupSelectorCubit;

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

    serverConfigRepository = MockServerConfigRepository();
    validateServerHealth = MockValidateServerHealth();
    homeFeedCubit = MockHomeFeedCubit();
    groupSelectorCubit = MockGroupSelectorCubit();

    when(
      () => serverConfigRepository.getAll(),
    ).thenAnswer((_) async => Result.success([server]));
    when(() => validateServerHealth.call('https://ntfy.sh')).thenAnswer(
      (_) async => const Result.success(HealthDto(healthy: true)),
    );
    when(
      () => homeFeedCubit.state,
    ).thenReturn(const HomeFeedState.loaded(items: []));
    when(
      () => homeFeedCubit.stream,
    ).thenAnswer((_) => const Stream<HomeFeedState>.empty());
    when(() => homeFeedCubit.load(groupId: any(named: 'groupId'))).thenReturn(null);
    when(() => homeFeedCubit.close()).thenAnswer((_) async {});
    when(() => groupSelectorCubit.state).thenReturn(const GroupSelectorState());
    when(
      () => groupSelectorCubit.stream,
    ).thenAnswer((_) => const Stream<GroupSelectorState>.empty());
    when(() => groupSelectorCubit.load()).thenReturn(null);
    when(() => groupSelectorCubit.close()).thenAnswer((_) async {});

    getIt
      ..reset()
      ..registerFactory<ServerConfigRepository>(() => serverConfigRepository)
      ..registerFactory<ValidateServerHealth>(() => validateServerHealth)
      ..registerFactory<HomeFeedCubit>(() => homeFeedCubit)
      ..registerFactory<GroupSelectorCubit>(() => groupSelectorCubit);
  });

  tearDown(() => getIt.reset());

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
        const ServerFormState.success(baseUrl: 'https://ntfy.sh'),
      ]),
      initialState: const ServerFormState.idle(),
    );

    await pumpPage(tester);
    await tester.pump(); // validating
    await tester.pump(); // success
    await tester.pump(const Duration(milliseconds: 400)); // wait for navigation animation

    expect(find.byType(HomePage), findsOneWidget);
  });
}
