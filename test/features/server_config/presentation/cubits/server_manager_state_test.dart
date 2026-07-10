import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_manager_state.dart';

void main() {
  final server = ServerConfig(
    id: 'srv-1',
    baseUrl: 'https://ntfy.sh',
    displayName: 'ntfy.sh',
    authType: AuthType.none,
    isDefault: true,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  group('ServerManagerState', () {
    test('should_be_exhaustive_in_when', () {
      final states = <ServerManagerState>[
        const ServerManagerState.loading(),
        ServerManagerState.loaded([server]),
        const ServerManagerState.error(
          failure: Failure.cache(message: 'db error'),
        ),
      ];

      for (final state in states) {
        final result = state.when(
          loading: () => 'loading',
          loaded: (servers) => 'loaded',
          error: (failure) => 'error: ${failure.runtimeType}',
        );
        expect(result, isNotEmpty);
      }
    });

    test('ServerManagerLoaded_equality_same_list_is_equal', () {
      final a = ServerManagerState.loaded([server]);
      final b = ServerManagerState.loaded([server]);

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('ServerManagerError_inequality_different_failure', () {
      const a = ServerManagerState.error(
        failure: Failure.cache(message: 'down'),
      );
      const b = ServerManagerState.error(failure: Failure.notFound());

      expect(a, isNot(b));
    });
  });
}
