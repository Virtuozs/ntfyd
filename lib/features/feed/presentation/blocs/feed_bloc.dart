import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/feed/domain/entities/feed_connection_state.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';
import 'package:ntfyd/features/feed/domain/repositories/feed_repository.dart';
import 'package:ntfyd/features/feed/domain/usecases/connect_feed.dart';
import 'package:ntfyd/features/feed/domain/usecases/disconnect_feed.dart';
import 'package:ntfyd/features/feed/domain/usecases/refresh_feed_history.dart';
import 'package:ntfyd/features/feed/domain/usecases/toggle_message_pin.dart';
import 'package:ntfyd/features/feed/domain/usecases/toggle_message_read.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_event.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_state.dart';
import 'package:rxdart/rxdart.dart';

/// Follows the app's "Option A" feed data-flow (Base-Plan D9):
/// [FeedRepository.watchMessages]/`watchConnectionState` are the single
/// reactive source of truth for [FeedState.loaded]. `FeedLoad` opens the
/// screen-scoped WS session (`ConnectFeed`); this bloc's own [close] tears
/// it down (`DisconnectFeed`) when `TopicDetailPage` unmounts.
@injectable
class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc(
    this._repository,
    this._connectFeed,
    this._disconnectFeed,
    this._refreshFeedHistory,
    this._toggleMessageRead,
    this._toggleMessagePin,
  ) : super(const FeedState.loading()) {
    on<FeedLoad>(_onLoad);
    on<FeedRefresh>(_onRefresh);
    on<FeedToggleRead>(_onToggleRead);
    on<FeedTogglePin>(_onTogglePin);
  }

  final FeedRepository _repository;
  final ConnectFeed _connectFeed;
  final DisconnectFeed _disconnectFeed;
  final RefreshFeedHistory _refreshFeedHistory;
  final ToggleMessageRead _toggleMessageRead;
  final ToggleMessagePin _toggleMessagePin;

  String? _serverId;
  String? _topic;

  Future<void> _onLoad(FeedLoad event, Emitter<FeedState> emit) async {
    _serverId = event.serverId;
    _topic = event.topic;

    emit(const FeedState.loading());

    final connectResult = await _connectFeed.call(
      ConnectFeedParams(serverId: event.serverId, topic: event.topic),
    );
    if (!connectResult.isSuccess) {
      emit(FeedState.error(failure: connectResult.failureOrThrow));
      return;
    }

    await emit.forEach<FeedLoaded>(
      Rx.combineLatest2<
        List<NotificationMessage>,
        FeedConnectionState,
        FeedLoaded
      >(
        _repository.watchMessages(event.serverId, event.topic),
        _repository.watchConnectionState(event.serverId, event.topic),
        (messages, connectionState) =>
            FeedLoaded(messages: messages, connectionState: connectionState),
      ),
      onData: (loaded) => loaded,
    );
  }

  Future<void> _onRefresh(FeedRefresh event, Emitter<FeedState> emit) async {
    final serverId = _serverId;
    final topic = _topic;
    if (serverId == null || topic == null) return;

    final result = await _refreshFeedHistory.call(
      RefreshFeedHistoryParams(serverId: serverId, topic: topic),
    );
    if (!result.isSuccess) {
      final previousState = state;
      emit(FeedState.error(failure: result.failureOrThrow));
      // A failed refresh writes nothing to the DB, so the `watchMessages`/
      // `watchConnectionState` streams from `_onLoad`'s still-running
      // `emit.forEach` won't produce a new value to overwrite this error
      // state. Restore the previously-loaded list immediately so the error
      // is a transient blip (for a BlocListener to surface as a snackbar)
      // rather than a full-screen error that replaces the feed indefinitely.
      if (previousState is FeedLoaded) {
        emit(previousState);
      }
    }
  }

  Future<void> _onToggleRead(
    FeedToggleRead event,
    Emitter<FeedState> emit,
  ) async {
    final serverId = _serverId;
    if (serverId == null) return;
    await _toggleMessageRead.call(
      ToggleMessageReadParams(serverId: serverId, id: event.id),
    );
  }

  Future<void> _onTogglePin(
    FeedTogglePin event,
    Emitter<FeedState> emit,
  ) async {
    final serverId = _serverId;
    if (serverId == null) return;
    await _toggleMessagePin.call(
      ToggleMessagePinParams(serverId: serverId, id: event.id),
    );
  }

  @override
  Future<void> close() async {
    final serverId = _serverId;
    final topic = _topic;
    if (serverId != null && topic != null) {
      await _disconnectFeed.call(
        DisconnectFeedParams(serverId: serverId, topic: topic),
      );
    }
    return super.close();
  }
}
