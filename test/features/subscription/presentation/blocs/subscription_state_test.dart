import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_state.dart';

void main() {
  group('SubscriptionState', () {
    test('loaded states with identical lists are equal (Freezed equality)', () {
      const a = SubscriptionState.loaded(subscriptions: []);
      const b = SubscriptionState.loaded(subscriptions: []);

      expect(a, equals(b));
    });

    test('when() is exhaustive over all 4 variants', () {
      const states = [
        SubscriptionState.loading(),
        SubscriptionState.loaded(subscriptions: []),
        SubscriptionState.authError(failure: Failure.auth(statusCode: 401)),
        SubscriptionState.error(failure: Failure.cache(message: 'x')),
      ];

      for (final state in states) {
        final label = state.when(
          loading: () => 'loading',
          loaded: (_) => 'loaded',
          authError: (_) => 'authError',
          error: (_) => 'error',
        );
        expect(label, isNotEmpty);
      }
    });
  });
}
