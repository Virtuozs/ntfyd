import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';
import 'package:ntfyd/features/feed/domain/repositories/feed_repository.dart';
import 'package:ntfyd/features/feed/presentation/cubits/home_feed_state.dart';
import 'package:ntfyd/features/feed/presentation/cubits/home_topic_summary.dart';
import 'package:ntfyd/features/groups/domain/entities/group.dart';
import 'package:ntfyd/features/groups/domain/entities/group_membership.dart';
import 'package:ntfyd/features/groups/domain/repositories/group_repository.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:rxdart/rxdart.dart';

/// Home's per-subscription card feed: re-derives whenever the subscription
/// list changes (add/remove/pin/mute) or any topic's latest message/unread
/// count changes. Reads Drift only (Base-Plan D9) — never opens a WS
/// session.
///
/// `load({groupId})` is Group-centric (Base-Plan D15): `groupId == null`
/// is the built-in "All" view — every subscription across every server,
/// not just one — and a non-null `groupId` filters to that group's
/// `(serverId, topic)` members.
@injectable
class HomeFeedCubit extends Cubit<HomeFeedState> {
  HomeFeedCubit(
    this._subscriptionRepository,
    this._feedRepository,
    this._groupRepository,
  ) : super(const HomeFeedState.loading());

  final SubscriptionRepository _subscriptionRepository;
  final FeedRepository _feedRepository;
  final GroupRepository _groupRepository;

  StreamSubscription<HomeFeedState>? _subscription;

  void load({String? groupId}) {
    unawaited(_subscription?.cancel());
    emit(const HomeFeedState.loading());

    final subscriptionsStream = groupId == null
        ? _subscriptionRepository.watchAll()
        : _groupRepository.watchAll().switchMap((groups) {
            final group = groups
                .cast<Group?>()
                .firstWhere((g) => g!.id == groupId, orElse: () => null);
            final members = group?.members ?? const <GroupMembership>{};
            return _subscriptionRepository.watchAll().map(
              (subs) => subs
                  .where(
                    (s) => members.contains(
                      GroupMembership(serverId: s.serverId, topic: s.topic),
                    ),
                  )
                  .toList(),
            );
          });

    final stream = subscriptionsStream.switchMap<HomeFeedState>((subscriptions) {
      if (subscriptions.isEmpty) {
        return Stream.value(const HomeFeedState.loaded(items: []));
      }

      final perTopic = subscriptions
          .map(
            (sub) => Rx.combineLatest2<
              NotificationMessage?,
              int,
              HomeTopicSummary
            >(
              _feedRepository.watchLatestMessage(sub.serverId, sub.topic),
              _feedRepository.watchUnreadCount(sub.serverId, sub.topic),
              (latest, unread) => HomeTopicSummary(
                subscription: sub,
                latestMessage: latest,
                unreadCount: unread,
              ),
            ),
          )
          .toList();

      return Rx.combineLatestList(
        perTopic,
      ).map((items) => HomeFeedState.loaded(items: items));
    });

    _subscription = stream.listen(emit);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
