import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_event.freezed.dart';

@freezed
sealed class SubscriptionEvent with _$SubscriptionEvent {
  const factory SubscriptionEvent.load({required String serverId}) =
      SubscriptionLoad;

  const factory SubscriptionEvent.subscribe({
    required String serverId,
    required String topic,
    String? displayName,
  }) = SubscriptionSubscribe;

  const factory SubscriptionEvent.unsubscribe({
    required String serverId,
    required String topic,
  }) = SubscriptionUnsubscribe;

  const factory SubscriptionEvent.togglePin({required String id}) =
      SubscriptionTogglePin;

  const factory SubscriptionEvent.toggleMute({required String id}) =
      SubscriptionToggleMute;

  const factory SubscriptionEvent.updateThreshold({
    required String id,
    required int threshold,
  }) = SubscriptionUpdateThreshold;
}
