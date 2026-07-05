import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/di/injection_container.dart';
import 'package:ntfyd/features/feed/presentation/cubits/home_feed_cubit.dart';
import 'package:ntfyd/features/feed/presentation/cubits/home_feed_state.dart';
import 'package:ntfyd/features/feed/presentation/pages/home_page.dart';
import 'package:ntfyd/features/server_config/data/models/health_dto.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';
import 'package:ntfyd/features/server_config/domain/usecases/validate_server_health.dart';

class MockServerConfigRepository extends Mock implements ServerConfigRepository {}

class MockValidateServerHealth extends Mock implements ValidateServerHealth {}

class MockHomeFeedCubit extends Mock implements HomeFeedCubit {}

void main() {
  final server = ServerConfig(
    id: 'srv-1',
    baseUrl: 'https://ntfy.sh',
    displayName: 'ntfy.sh',
    authType: AuthType.none,
    isDefault: true,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  late MockServerConfigRepository serverConfigRepository;
  late MockValidateServerHealth validateServerHealth;
  late MockHomeFeedCubit homeFeedCubit;

  setUp(() {
    serverConfigRepository = MockServerConfigRepository();
    validateServerHealth = MockValidateServerHealth();
    homeFeedCubit = MockHomeFeedCubit();

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
    when(() => homeFeedCubit.load(any())).thenReturn(null);
    when(() => homeFeedCubit.close()).thenAnswer((_) async {});

    getIt
      ..reset()
      ..registerFactory<ServerConfigRepository>(() => serverConfigRepository)
      ..registerFactory<ValidateServerHealth>(() => validateServerHealth)
      ..registerFactory<HomeFeedCubit>(() => homeFeedCubit);
  });

  tearDown(() => getIt.reset());

  testWidgets('renders the ntfyd title, empty state, and a subscribe FAB', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();

    expect(find.text('ntfyd'), findsOneWidget);
    expect(find.text('No subscriptions yet'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    verify(() => homeFeedCubit.load('srv-1')).called(1);
  });

  testWidgets('shows Connected once the default server health check succeeds', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();

    expect(find.text('Connected'), findsOneWidget);
  });
}
