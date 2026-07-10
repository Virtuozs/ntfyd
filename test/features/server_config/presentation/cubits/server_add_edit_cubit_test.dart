import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/secure_storage/server_credential.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';
import 'package:ntfyd/features/server_config/domain/usecases/add_server.dart';
import 'package:ntfyd/features/server_config/domain/usecases/edit_credentials.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_add_edit_cubit.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_add_edit_state.dart';

class MockAddServer extends Mock implements AddServer {}

class MockEditCredentials extends Mock implements EditCredentials {}

void main() {
  late MockAddServer addServer;
  late MockEditCredentials editCredentials;
  late ServerAddEditCubit cubit;

  setUpAll(() {
    registerFallbackValue(
      const AddServerParams(
        baseUrl: 'https://ntfy.sh',
        authType: AuthType.none,
        credential: ServerCredential.noAuth(),
      ),
    );
    registerFallbackValue(
      const EditCredentialsParams(
        serverId: 'srv-1',
        credential: ServerCredential.noAuth(),
      ),
    );
  });

  setUp(() {
    addServer = MockAddServer();
    editCredentials = MockEditCredentials();
    cubit = ServerAddEditCubit(addServer, editCredentials);
  });

  tearDown(() => cubit.close());

  group('ServerAddEditCubit.addServer', () {
    blocTest<ServerAddEditCubit, ServerAddEditState>(
      'emits [validating, success] on happy path',
      build: () {
        when(
          () => addServer.call(any()),
        ).thenAnswer((_) async => const Result.success(null));
        return cubit;
      },
      act: (c) => c.addServer(url: 'https://ntfy.sh'),
      expect: () => [
        const ServerAddEditState.validating(),
        const ServerAddEditState.success(),
      ],
    );

    blocTest<ServerAddEditCubit, ServerAddEditState>(
      'emits [validating, error] when AddServer fails',
      build: () {
        when(() => addServer.call(any())).thenAnswer(
          (_) async =>
              const Result.err(Failure.network(message: 'connection refused')),
        );
        return cubit;
      },
      act: (c) => c.addServer(url: 'https://unreachable.example'),
      expect: () => [
        const ServerAddEditState.validating(),
        const ServerAddEditState.error(
          failure: Failure.network(message: 'connection refused'),
        ),
      ],
    );

    blocTest<ServerAddEditCubit, ServerAddEditState>(
      'blank url is normalized to https://ntfy.sh before calling AddServer',
      build: () {
        when(
          () => addServer.call(any()),
        ).thenAnswer((_) async => const Result.success(null));
        return cubit;
      },
      act: (c) => c.addServer(url: ''),
      verify: (_) {
        final captured =
            verify(() => addServer.call(captureAny())).captured.single
                as AddServerParams;
        expect(captured.baseUrl, 'https://ntfy.sh');
      },
    );

    blocTest<ServerAddEditCubit, ServerAddEditState>(
      'non-blank username/password results in AuthType.basic credential',
      build: () {
        when(
          () => addServer.call(any()),
        ).thenAnswer((_) async => const Result.success(null));
        return cubit;
      },
      act: (c) => c.addServer(
        url: 'https://ntfy.sh',
        user: 'alice',
        password: 'secret',
      ),
      verify: (_) {
        final captured =
            verify(() => addServer.call(captureAny())).captured.single
                as AddServerParams;
        expect(captured.authType, AuthType.basic);
        expect(
          captured.credential,
          const ServerCredential.basicAuth(
            username: 'alice',
            password: 'secret',
          ),
        );
      },
    );

    blocTest<ServerAddEditCubit, ServerAddEditState>(
      'addServer() called while already validating is ignored',
      build: () {
        when(() => addServer.call(any())).thenAnswer(
          (_) => Future<Result<void>>.delayed(
            const Duration(seconds: 10),
            () => const Result.success(null),
          ),
        );
        return cubit;
      },
      act: (c) async {
        unawaited(c.addServer(url: 'https://ntfy.sh'));
        await c.addServer(url: 'https://ntfy.sh');
      },
      expect: () => [const ServerAddEditState.validating()],
      verify: (_) {
        verify(() => addServer.call(any())).called(1);
      },
    );
  });

  group('ServerAddEditCubit.editCredentials', () {
    blocTest<ServerAddEditCubit, ServerAddEditState>(
      'emits [validating, success] on happy path',
      build: () {
        when(
          () => editCredentials.call(any()),
        ).thenAnswer((_) async => const Result.success(null));
        return cubit;
      },
      act: (c) => c.editCredentials(
        serverId: 'srv-1',
        user: 'alice',
        password: 'newpass',
      ),
      expect: () => [
        const ServerAddEditState.validating(),
        const ServerAddEditState.success(),
      ],
      verify: (_) {
        final captured =
            verify(() => editCredentials.call(captureAny())).captured.single
                as EditCredentialsParams;
        expect(captured.serverId, 'srv-1');
        expect(
          captured.credential,
          const ServerCredential.basicAuth(
            username: 'alice',
            password: 'newpass',
          ),
        );
      },
    );

    blocTest<ServerAddEditCubit, ServerAddEditState>(
      'emits [validating, error] when EditCredentials fails',
      build: () {
        when(() => editCredentials.call(any())).thenAnswer(
          (_) async => const Result.err(
            Failure.validation(
              field: 'credentialRef',
              message: 'Server has no credential slot (anonymous server)',
            ),
          ),
        );
        return cubit;
      },
      act: (c) =>
          c.editCredentials(serverId: 'srv-1', user: 'alice', password: 'x'),
      expect: () => [
        const ServerAddEditState.validating(),
        const ServerAddEditState.error(
          failure: Failure.validation(
            field: 'credentialRef',
            message: 'Server has no credential slot (anonymous server)',
          ),
        ),
      ],
    );

    blocTest<ServerAddEditCubit, ServerAddEditState>(
      'blank username/password results in NoAuth credential',
      build: () {
        when(
          () => editCredentials.call(any()),
        ).thenAnswer((_) async => const Result.success(null));
        return cubit;
      },
      act: (c) => c.editCredentials(serverId: 'srv-1', user: '', password: ''),
      verify: (_) {
        final captured =
            verify(() => editCredentials.call(captureAny())).captured.single
                as EditCredentialsParams;
        expect(captured.credential, const ServerCredential.noAuth());
      },
    );
  });
}
