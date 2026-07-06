import 'dart:async';

import 'package:ntfyd/features/feed/domain/entities/connection_owner.dart';
import 'package:ntfyd/features/feed/domain/repositories/feed_repository.dart';
import 'package:ntfyd/features/notifications/data/foreground_service_controller.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';

/// Keeps a background-owned [FeedRepository] session open for every
/// subscription across every server, so messages keep arriving while the
/// app is backgrounded. Starts the OS foreground service (Android) so the
/// process survives long enough for those sessions to matter.
///
/// Note: this class does not itself guard the foreground-service calls
/// behind `Platform.isAndroid` — [ForegroundServiceController]'s calls are
/// harmless no-ops on other platforms in the underlying plugin, and the
/// platform check belongs at the bootstrap call site instead (Task 10),
/// not here.
class BackgroundDeliveryService {
  BackgroundDeliveryService(
    this._subscriptionRepository,
    this._feedRepository,
    this._foregroundServiceController,
  );

  final SubscriptionRepository _subscriptionRepository;
  final FeedRepository _feedRepository;
  final ForegroundServiceController _foregroundServiceController;

  StreamSubscription<List<Subscription>>? _subscription;
  Set<String> _connectedKeys = {};

  Future<void> start() async {
    await _foregroundServiceController.initialize();
    await _foregroundServiceController.start();

    _subscription = _subscriptionRepository.watchAll().listen(_syncConnections);
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
    _connectedKeys = {};

    await _foregroundServiceController.stop();
  }

  Future<void> _syncConnections(List<Subscription> subscriptions) async {
    final desiredKeys = subscriptions.map((s) => _key(s.serverId, s.topic)).toSet();

    for (final sub in subscriptions) {
      final key = _key(sub.serverId, sub.topic);
      if (!_connectedKeys.contains(key)) {
        await _feedRepository.connect(
          sub.serverId,
          sub.topic,
          owner: ConnectionOwner.background,
        );
      }
    }

    final removedKeys = _connectedKeys.difference(desiredKeys);
    for (final key in removedKeys) {
      final parts = key.split(' ');
      await _feedRepository.disconnect(
        parts[0],
        parts[1],
        owner: ConnectionOwner.background,
      );
    }

    _connectedKeys = desiredKeys;
  }

  String _key(String serverId, String topic) => '$serverId $topic';
}
