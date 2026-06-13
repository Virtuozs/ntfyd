import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/secure_storage/server_credential.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';
import 'package:ntfyd/features/server_config/domain/usecases/add_server.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_form_cubit.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_form_state.dart';

class MockAddServer extends Mock implements AddServer {}

void main() {
  late MockAddServer addServer;
  late ServerFormCubit cubit;

  setUp(() {
    addServer = MockAddServer();
    cubit = ServerFormCubit(addServer);

    registerFallbackValue(
      const AddServerParams(
        baseUrl: 'https://ntfy.sh',
        authType: AuthType.none,
        credential: ServerCredential.noAuth(),
      ),
    );
  });

  tearDown(() => cubit.close());

  group('ServerFormCubit.connect', () {
    blocTest<ServerFormCubit, ServerFormState>(
      'emits [validating, success] on happy path',
      build: () {
        when(
          () => addServer.call(any()),
        ).thenAnswer((_) async => const Result.success(null));
        return cubit;
      },
      act: (c) => c.connect(url: 'https://ntfy.sh'),
      expect: () => [
        const ServerFormState.validating(),
        const ServerFormState.success(),
      ],
    );

    blocTest<ServerFormCubit, ServerFormState>(
      'emits [validating, error(NetworkFailure)] when AddServer fails',
      build: () {
        when(() => addServer.call(any())).thenAnswer(
          (_) async =>
              const Result.err(Failure.network(message: 'connection refused')),
        );
        return cubit;
      },
      act: (c) => c.connect(url: 'https://unreachable.example'),
      expect: () => [
        const ServerFormState.validating(),
        const ServerFormState.error(
          failure: Failure.network(message: 'connection refused'),
        ),
      ],
    );

    blocTest<ServerFormCubit, ServerFormState>(
      'emits [validating, error(AuthFailure)] when AddServer returns 401',
      build: () {
        when(() => addServer.call(any())).thenAnswer(
          (_) async => const Result.err(Failure.auth(statusCode: 401)),
        );
        return cubit;
      },
      act: (c) => c.connect(
        url: 'https://ntfy.example',
        user: 'alice',
        password: 'wrong',
      ),
      expect: () => [
        const ServerFormState.validating(),
        const ServerFormState.error(failure: Failure.auth(statusCode: 401)),
      ],
    );

    blocTest<ServerFormCubit, ServerFormState>(
      'blank url is normalized to https://ntfy.sh before calling AddServer',
      build: () {
        when(
          () => addServer.call(any()),
        ).thenAnswer((_) async => const Result.success(null));
        return cubit;
      },
      act: (c) => c.connect(url: ''),
      verify: (_) {
        final captured =
            verify(() => addServer.call(captureAny())).captured.single
                as AddServerParams;
        expect(captured.baseUrl, 'https://ntfy.sh');
      },
    );

    blocTest<ServerFormCubit, ServerFormState>(
      'url without scheme is normalized to https://',
      build: () {
        when(
          () => addServer.call(any()),
        ).thenAnswer((_) async => const Result.success(null));
        return cubit;
      },
      act: (c) => c.connect(url: 'my.server.com'),
      verify: (_) {
        final captured =
            verify(() => addServer.call(captureAny())).captured.single
                as AddServerParams;
        expect(captured.baseUrl, 'https://my.server.com');
      },
    );

    blocTest<ServerFormCubit, ServerFormState>(
      'blank username/password results in AuthType.none and NoAuth credential',
      build: () {
        when(
          () => addServer.call(any()),
        ).thenAnswer((_) async => const Result.success(null));
        return cubit;
      },
      act: (c) => c.connect(url: 'https://ntfy.sh', user: '', password: ''),
      verify: (_) {
        final captured =
            verify(() => addServer.call(captureAny())).captured.single
                as AddServerParams;
        expect(captured.authType, AuthType.none);
        expect(captured.credential, const ServerCredential.noAuth());
      },
    );

    blocTest<ServerFormCubit, ServerFormState>(
      'non-blank username/password results in AuthType.basic and BasicAuth credential',
      build: () {
        when(
          () => addServer.call(any()),
        ).thenAnswer((_) async => const Result.success(null));
        return cubit;
      },
      act: (c) =>
          c.connect(url: 'https://ntfy.sh', user: 'alice', password: 'secret'),
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

    blocTest<ServerFormCubit, ServerFormState>(
      'connect() called while already validating is ignored '
      '(no duplicate AddServer call)',
      build: () {
        // Never completes -> cubit stays in `validating`.
        when(() => addServer.call(any())).thenAnswer(
          (_) => Future<Result<void>>.delayed(
            const Duration(seconds: 10),
            () => const Result.success(null),
          ),
        );
        return cubit;
      },
      act: (c) async {
        // Fire twice in quick succession without awaiting the first.
        unawaited(c.connect(url: 'https://ntfy.sh'));
        await c.connect(url: 'https://ntfy.sh');
      },
      expect: () => [const ServerFormState.validating()],
      verify: (_) {
        verify(() => addServer.call(any())).called(1);
      },
    );
  });
}
