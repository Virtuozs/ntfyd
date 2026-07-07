import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ntfyd/features/feed/domain/usecases/toggle_message_pin.dart';
import 'package:ntfyd/features/feed/domain/usecases/toggle_message_read.dart';
import 'package:ntfyd/features/groups/domain/repositories/group_repository.dart';
import 'package:ntfyd/features/groups/presentation/blocs/group_feed_event.dart';
import 'package:ntfyd/features/groups/presentation/blocs/group_feed_state.dart';

/// The merged feed for a group (or "All", `groupId == null`, Base-Plan
/// FR9). Unlike `FeedBloc`, this bloc never opens/closes a WS session:
/// every subscribed topic's transport already writes to Drift continuously
/// via the P7 background delivery service, regardless of whether this
/// screen is open (Option A, D9).
@injectable
class GroupFeedBloc extends Bloc<GroupFeedEvent, GroupFeedState> {
  GroupFeedBloc(
    this._repository,
    this._toggleMessageRead,
    this._toggleMessagePin,
  ) : super(const GroupFeedState.loading()) {
    on<GroupFeedLoad>(_onLoad);
    on<GroupFeedToggleRead>(_onToggleRead);
    on<GroupFeedTogglePin>(_onTogglePin);
  }

  final GroupRepository _repository;
  final ToggleMessageRead _toggleMessageRead;
  final ToggleMessagePin _toggleMessagePin;

  Future<void> _onLoad(GroupFeedLoad event, Emitter<GroupFeedState> emit) async {
    await emit.forEach<GroupFeedState>(
      _repository
          .watchFeed(event.groupId)
          .map((messages) => GroupFeedState.loaded(messages: messages)),
      onData: (loaded) => loaded,
    );
  }

  Future<void> _onToggleRead(
    GroupFeedToggleRead event,
    Emitter<GroupFeedState> emit,
  ) async {
    await _toggleMessageRead.call(
      ToggleMessageReadParams(serverId: event.serverId, id: event.id),
    );
  }

  Future<void> _onTogglePin(
    GroupFeedTogglePin event,
    Emitter<GroupFeedState> emit,
  ) async {
    await _toggleMessagePin.call(
      ToggleMessagePinParams(serverId: event.serverId, id: event.id),
    );
  }
}
