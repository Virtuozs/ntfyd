import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';

part 'subscription_state.freezed.dart';

@freezed
sealed class SubscriptionState with _$SubscriptionState {
  const factory SubscriptionState.loading() = SubscriptionLoading;

  const factory SubscriptionState.loaded({
    required List<Subscription> subscriptions,
  }) = SubscriptionLoaded;

  const factory SubscriptionState.authError({required Failure failure}) =
      SubscriptionAuthError;

  const factory SubscriptionState.error({required Failure failure}) =
      SubscriptionError;
}
