import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_add_edit_state.dart';

void main() {
  group('ServerAddEditState', () {
    test('should_be_exhaustive_in_when', () {
      const states = <ServerAddEditState>[
        ServerAddEditState.idle(),
        ServerAddEditState.validating(),
        ServerAddEditState.success(),
        ServerAddEditState.error(failure: Failure.notFound()),
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

    test('ServerAddEditError_equality_same_failure_is_equal', () {
      const a = ServerAddEditState.error(failure: Failure.notFound());
      const b = ServerAddEditState.error(failure: Failure.notFound());

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });
  });
}
