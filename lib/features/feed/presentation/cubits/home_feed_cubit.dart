import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';
import 'package:ntfyd/features/feed/domain/repositories/feed_repository.dart';
import 'package:ntfyd/features/feed/presentation/cubits/home_feed_state.dart';
import 'package:ntfyd/features/feed/presentation/cubits/home_topic_summary.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:rxdart/rxdart.dart';

/// Home's per-subscription card feed: re-derives whenever the subscription
/// list changes (add/remove/pin/mute) or any topic's latest message/unread
/// count changes. Reads Drift only (Base-Plan D9) — never opens a WS
/// session. `load` is a plain method (not an event) since Home has exactly
/// one trigger (page opened with a known serverId) — matching the
/// `ServerFormCubit.connect(...)`-style Cubit convention already used
/// elsewhere in this app (Blocs use events; Cubits expose direct methods).
@injectable
class HomeFeedCubit extends Cubit<HomeFeedState> {
  HomeFeedCubit(this._subscriptionRepository, this._feedRepository)
    : super(const HomeFeedState.loading());

  final SubscriptionRepository _subscriptionRepository;
  final FeedRepository _feedRepository;

  StreamSubscription<HomeFeedState>? _subscription;

  void load(String serverId) {
    unawaited(_subscription?.cancel());
    emit(const HomeFeedState.loading());

    final stream = _subscriptionRepository.watchByServer(serverId).switchMap<
      HomeFeedState
    >((subscriptions) {
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
