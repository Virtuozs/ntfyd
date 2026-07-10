// test/features/server_config/presentation/cubits/server_manager_cubit_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/domain/usecases/list_servers.dart';
import 'package:ntfyd/features/server_config/domain/usecases/remove_server.dart';
import 'package:ntfyd/features/server_config/domain/usecases/set_default_server.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_manager_cubit.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_manager_state.dart';

class MockListServers extends Mock implements ListServers {}

class MockRemoveServer extends Mock implements RemoveServer {}

class MockSetDefaultServer extends Mock implements SetDefaultServer {}

void main() {
  late MockListServers listServers;
  late MockRemoveServer removeServer;
  late MockSetDefaultServer setDefaultServer;
  late ServerManagerCubit cubit;

  final server = ServerConfig(
    id: 'srv-1',
    baseUrl: 'https://ntfy.sh',
    displayName: 'ntfy.sh',
    authType: AuthType.none,
    isDefault: true,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  setUp(() {
    listServers = MockListServers();
    removeServer = MockRemoveServer();
    setDefaultServer = MockSetDefaultServer();
    cubit = ServerManagerCubit(listServers, removeServer, setDefaultServer);
  });

  tearDown(() => cubit.close());

  group('ServerManagerCubit.load', () {
    blocTest<ServerManagerCubit, ServerManagerState>(
      'emits [loading, loaded([server])] on success',
      build: () {
        when(
          () => listServers.call(const NoParams()),
        ).thenAnswer((_) async => Result.success([server]));
        return cubit;
      },
      act: (c) => c.load(),
      expect: () => [
        const ServerManagerState.loading(),
        ServerManagerState.loaded([server]),
      ],
    );

    blocTest<ServerManagerCubit, ServerManagerState>(
      'emits [loading, error] when ListServers fails',
      build: () {
        when(() => listServers.call(const NoParams())).thenAnswer(
          (_) async => const Result.err(Failure.cache(message: 'db error')),
        );
        return cubit;
      },
      act: (c) => c.load(),
      expect: () => [
        const ServerManagerState.loading(),
        const ServerManagerState.error(
          failure: Failure.cache(message: 'db error'),
        ),
      ],
    );
  });

  group('ServerManagerCubit.remove', () {
    blocTest<ServerManagerCubit, ServerManagerState>(
      'calls RemoveServer then reloads the list on success',
      build: () {
        when(
          () => removeServer.call('srv-1'),
        ).thenAnswer((_) async => const Result.success(null));
        when(
          () => listServers.call(const NoParams()),
        ).thenAnswer((_) async => Result.success([server]));
        return cubit;
      },
      act: (c) => c.remove('srv-1'),
      expect: () => [
        const ServerManagerState.loading(),
        ServerManagerState.loaded([server]),
      ],
      verify: (_) {
        verify(() => removeServer.call('srv-1')).called(1);
        verify(() => listServers.call(const NoParams())).called(1);
      },
    );

    blocTest<ServerManagerCubit, ServerManagerState>(
      'emits error when RemoveServer fails, does not reload',
      build: () {
        when(() => removeServer.call('srv-1')).thenAnswer(
          (_) async => const Result.err(Failure.notFound()),
        );
        return cubit;
      },
      act: (c) => c.remove('srv-1'),
      expect: () => [
        const ServerManagerState.error(failure: Failure.notFound()),
      ],
      verify: (_) {
        verifyNever(() => listServers.call(const NoParams()));
      },
    );
  });

  group('ServerManagerCubit.setDefault', () {
    blocTest<ServerManagerCubit, ServerManagerState>(
      'calls SetDefaultServer then reloads the list on success',
      build: () {
        when(
          () => setDefaultServer.call('srv-1'),
        ).thenAnswer((_) async => const Result.success(null));
        when(
          () => listServers.call(const NoParams()),
        ).thenAnswer((_) async => Result.success([server]));
        return cubit;
      },
      act: (c) => c.setDefault('srv-1'),
      expect: () => [
        const ServerManagerState.loading(),
        ServerManagerState.loaded([server]),
      ],
      verify: (_) {
        verify(() => setDefaultServer.call('srv-1')).called(1);
      },
    );

    blocTest<ServerManagerCubit, ServerManagerState>(
      'emits error when SetDefaultServer fails, does not reload',
      build: () {
        when(() => setDefaultServer.call('srv-1')).thenAnswer(
          (_) async => const Result.err(Failure.notFound()),
        );
        return cubit;
      },
      act: (c) => c.setDefault('srv-1'),
      expect: () => [
        const ServerManagerState.error(failure: Failure.notFound()),
      ],
      verify: (_) {
        verifyNever(() => listServers.call(const NoParams()));
      },
    );
  });
}
