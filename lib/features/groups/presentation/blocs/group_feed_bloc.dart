import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/error/exception_mapper.dart';
import 'package:ntfyd/features/feed/domain/usecases/toggle_message_pin.dart';
import 'package:ntfyd/features/feed/domain/usecases/toggle_message_read.dart';
import 'package:ntfyd/features/groups/domain/entities/group.dart';
import 'package:ntfyd/features/groups/domain/repositories/group_repository.dart';
import 'package:ntfyd/features/groups/presentation/blocs/group_feed_event.dart';
import 'package:ntfyd/features/groups/presentation/blocs/group_feed_state.dart';
import 'package:rxdart/rxdart.dart';

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
    final groupId = event.groupId;

    // "All" (groupId == null) has no group to resolve a filter from, so
    // it stays unfiltered. Otherwise, resolve the group's saved priority
    // filter from `watchAll()` (mirrors `HomeFeedCubit.load()`'s
    // group-filtered branch) and re-derive the feed stream whenever that
    // filter changes.
    final feedStream = groupId == null
        ? _repository.watchFeed(null)
        : _repository.watchAll().switchMap((groups) {
            final group = groups
                .cast<Group?>()
                .firstWhere((g) => g!.id == groupId, orElse: () => null);
            return _repository.watchFeed(groupId, filter: group?.filter);
          });

    await emit.forEach<GroupFeedState>(
      feedStream.map((messages) => GroupFeedState.loaded(messages: messages)),
      onData: (loaded) => loaded,
      onError: (error, stackTrace) =>
          GroupFeedState.error(failure: ExceptionMapper.map(error)),
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
