import 'dart:async';

import 'package:flutter/material.dart';
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
import 'package:ntfyd/shared/startup/startup_gate.dart';

class MockServerConfigRepository extends Mock implements ServerConfigRepository {}

class MockValidateServerHealth extends Mock implements ValidateServerHealth {}

class MockHomeFeedCubit extends Mock implements HomeFeedCubit {}

class MockGroupSelectorCubit extends Mock implements GroupSelectorCubit {}

class MockServerFormCubit extends Mock implements ServerFormCubit {}

void main() {
  late MockServerConfigRepository serverConfigRepository;
  late MockValidateServerHealth validateServerHealth;
  late MockHomeFeedCubit homeFeedCubit;
  late MockGroupSelectorCubit groupSelectorCubit;
  late MockServerFormCubit serverFormCubit;

  setUp(() {
    serverConfigRepository = MockServerConfigRepository();
    validateServerHealth = MockValidateServerHealth();
    homeFeedCubit = MockHomeFeedCubit();
    groupSelectorCubit = MockGroupSelectorCubit();
    serverFormCubit = MockServerFormCubit();

    when(() => validateServerHealth.call(any())).thenAnswer(
      (_) async => const Result.success(HealthDto(healthy: true)),
    );
    when(
      () => homeFeedCubit.state,
    ).thenReturn(const HomeFeedState.loaded(items: []));
    when(
      () => homeFeedCubit.stream,
    ).thenAnswer((_) => const Stream<HomeFeedState>.empty());
    when(
      () => homeFeedCubit.load(groupId: any(named: 'groupId')),
    ).thenReturn(null);
    when(() => homeFeedCubit.close()).thenAnswer((_) async {});
    when(() => groupSelectorCubit.state).thenReturn(const GroupSelectorState());
    when(
      () => groupSelectorCubit.stream,
    ).thenAnswer((_) => const Stream<GroupSelectorState>.empty());
    when(() => groupSelectorCubit.load()).thenReturn(null);
    when(() => groupSelectorCubit.close()).thenAnswer((_) async {});
    when(() => serverFormCubit.state).thenReturn(const ServerFormState.idle());
    when(() => serverFormCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => serverFormCubit.close()).thenAnswer((_) async {});

    getIt
      ..reset()
      ..registerFactory<ServerConfigRepository>(() => serverConfigRepository)
      ..registerFactory<ValidateServerHealth>(() => validateServerHealth)
      ..registerFactory<HomeFeedCubit>(() => homeFeedCubit)
      ..registerFactory<GroupSelectorCubit>(() => groupSelectorCubit)
      ..registerFactory<ServerFormCubit>(() => serverFormCubit);
  });

  tearDown(() => getIt.reset());

  testWidgets('shows HomePage when a server is already configured', (
    tester,
  ) async {
    when(() => serverConfigRepository.getAll()).thenAnswer(
      (_) async => Result.success([
        ServerConfig(
          id: 'srv-1',
          baseUrl: 'https://ntfy.sh',
          displayName: 'ntfy.sh',
          authType: AuthType.none,
          isDefault: true,
          createdAt: DateTime.utc(2026, 1, 1),
        ),
      ]),
    );

    await tester.pumpWidget(const MaterialApp(home: StartupGate()));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(LoginPage), findsNothing);
  });

  testWidgets('shows LoginPage when no server is configured', (tester) async {
    when(
      () => serverConfigRepository.getAll(),
    ).thenAnswer((_) async => const Result.success([]));

    await tester.pumpWidget(const MaterialApp(home: StartupGate()));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);
  });

  testWidgets('shows LoginPage when the server lookup fails', (tester) async {
    when(() => serverConfigRepository.getAll()).thenAnswer(
      (_) async => const Result.err(Failure.cache(message: 'boom')),
    );

    await tester.pumpWidget(const MaterialApp(home: StartupGate()));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('shows a loading indicator before the lookup resolves', (
    tester,
  ) async {
    final completer = Completer<Result<List<ServerConfig>>>();
    when(
      () => serverConfigRepository.getAll(),
    ).thenAnswer((_) => completer.future);

    await tester.pumpWidget(const MaterialApp(home: StartupGate()));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(const Result.success([]));
    await tester.pumpAndSettle();
  });
}
