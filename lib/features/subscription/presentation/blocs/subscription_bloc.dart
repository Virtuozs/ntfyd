import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:ntfyd/features/subscription/domain/usecases/subscribe_to_topic.dart';
import 'package:ntfyd/features/subscription/domain/usecases/toggle_mute.dart';
import 'package:ntfyd/features/subscription/domain/usecases/toggle_pin.dart';
import 'package:ntfyd/features/subscription/domain/usecases/unsubscribe_from_topic.dart';
import 'package:ntfyd/features/subscription/domain/usecases/update_priority_threshold.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_event.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_state.dart';

/// Follows the app's "Option A" feed data-flow (Base-Plan D9):
/// [SubscriptionRepository.watchByServer] is the single source of truth for
/// [SubscriptionState.loaded]. Mutating events only ever emit failure states
/// (`error`/`authError`) — a successful mutation surfaces through the
/// already-active `watchByServer` stream reacting to the DB write.
@injectable
class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc(
    this._repository,
    this._subscribeToTopic,
    this._unsubscribeFromTopic,
    this._togglePin,
    this._toggleMute,
    this._updatePriorityThreshold,
  ) : super(const SubscriptionState.loading()) {
    on<SubscriptionLoad>(_onLoad);
    on<SubscriptionSubscribe>(_onSubscribe);
    on<SubscriptionUnsubscribe>(_onUnsubscribe);
    on<SubscriptionTogglePin>(_onTogglePin);
    on<SubscriptionToggleMute>(_onToggleMute);
    on<SubscriptionUpdateThreshold>(_onUpdateThreshold);
  }

  final SubscriptionRepository _repository;
  final SubscribeToTopic _subscribeToTopic;
  final UnsubscribeFromTopic _unsubscribeFromTopic;
  final TogglePin _togglePin;
  final ToggleMute _toggleMute;
  final UpdatePriorityThreshold _updatePriorityThreshold;

  Future<void> _onLoad(
    SubscriptionLoad event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(const SubscriptionState.loading());
    await emit.forEach<List<Subscription>>(
      _repository.watchByServer(event.serverId),
      onData: (subscriptions) =>
          SubscriptionState.loaded(subscriptions: subscriptions),
    );
  }

  Future<void> _onSubscribe(
    SubscriptionSubscribe event,
    Emitter<SubscriptionState> emit,
  ) async {
    final result = await _subscribeToTopic.call(
      SubscribeToTopicParams(
        serverId: event.serverId,
        topic: event.topic,
        displayName: event.displayName,
      ),
    );
    _emitOnFailure(result, emit);
  }

  Future<void> _onUnsubscribe(
    SubscriptionUnsubscribe event,
    Emitter<SubscriptionState> emit,
  ) async {
    final result = await _unsubscribeFromTopic.call(
      UnsubscribeFromTopicParams(serverId: event.serverId, topic: event.topic),
    );
    _emitOnFailure(result, emit);
  }

  Future<void> _onTogglePin(
    SubscriptionTogglePin event,
    Emitter<SubscriptionState> emit,
  ) async {
    _emitOnFailure(await _togglePin.call(event.id), emit);
  }

  Future<void> _onToggleMute(
    SubscriptionToggleMute event,
    Emitter<SubscriptionState> emit,
  ) async {
    _emitOnFailure(await _toggleMute.call(event.id), emit);
  }

  Future<void> _onUpdateThreshold(
    SubscriptionUpdateThreshold event,
    Emitter<SubscriptionState> emit,
  ) async {
    final result = await _updatePriorityThreshold.call(
      UpdatePriorityThresholdParams(
        subscriptionId: event.id,
        threshold: event.threshold,
      ),
    );
    _emitOnFailure(result, emit);
  }

  void _emitOnFailure<T>(Result<T> result, Emitter<SubscriptionState> emit) {
    if (result.isSuccess) return;
    final failure = result.failureOrThrow;
    if (failure is AuthFailure) {
      emit(SubscriptionState.authError(failure: failure));
    } else {
      emit(SubscriptionState.error(failure: failure));
    }
  }
}
