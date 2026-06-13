import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_form_state.dart';

void main() {
  group('ServerFormState', () {
    test('should_be_exhaustive_in_when', () {
      const states = <ServerFormState>[
        ServerFormState.idle(),
        ServerFormState.validating(),
        ServerFormState.success(),
        ServerFormState.error(failure: Failure.network(message: 'x')),
      ];

      for (final state in states) {
        final result = state.when(
          idle: () => 'idle',
          validating: () => 'validating',
          success: () => 'success',
          error: (failure) => 'error: ${failure.runtimeType}',
        );
        expect(result, isNotEmpty);
      }
    });

    test('ServerFormError_equality_same_failure_is_equal', () {
      const a = ServerFormState.error(
        failure: Failure.network(message: 'down'),
      );
      const b = ServerFormState.error(
        failure: Failure.network(message: 'down'),
      );

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('ServerFormError_inequality_different_failure', () {
      const a = ServerFormState.error(
        failure: Failure.network(message: 'down'),
      );
      const b = ServerFormState.error(failure: Failure.auth(statusCode: 401));

      expect(a, isNot(b));
    });
  });
}
