import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/feed/domain/entities/connection_owner.dart';
import 'package:ntfyd/features/feed/domain/repositories/feed_repository.dart';
import 'package:ntfyd/features/notifications/data/background_delivery_service.dart';
import 'package:ntfyd/features/notifications/data/foreground_service_controller.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';

class MockSubscriptionRepository extends Mock implements SubscriptionRepository {}

class MockFeedRepository extends Mock implements FeedRepository {}

class MockForegroundServiceController extends Mock
    implements ForegroundServiceController {}

void main() {
  late MockSubscriptionRepository subscriptionRepository;
  late MockFeedRepository feedRepository;
  late MockForegroundServiceController foregroundServiceController;
  late StreamController<List<Subscription>> subscriptionsController;
  late BackgroundDeliveryService service;

  final now = DateTime.utc(2026, 1, 1);

  setUpAll(() {
    registerFallbackValue(ConnectionOwner.background);
  });

  Subscription sub(String serverId, String topic) => Subscription(
    id: '$serverId:$topic',
    serverId: serverId,
    topic: topic,
    displayName: topic,
    createdAt: now,
  );

  setUp(() {
    subscriptionRepository = MockSubscriptionRepository();
    feedRepository = MockFeedRepository();
    foregroundServiceController = MockForegroundServiceController();
    subscriptionsController = StreamController<List<Subscription>>.broadcast();

    when(
      () => subscriptionRepository.watchAll(),
    ).thenAnswer((_) => subscriptionsController.stream);
    when(() => foregroundServiceController.initialize()).thenAnswer((_) async {});
    when(() => foregroundServiceController.start()).thenAnswer((_) async => true);
    when(() => foregroundServiceController.stop()).thenAnswer((_) async {});
    when(
      () => feedRepository.connect(any(), any(), owner: any(named: 'owner')),
    ).thenAnswer((_) async => const Result.success(null));
    when(
      () => feedRepository.disconnect(any(), any(), owner: any(named: 'owner')),
    ).thenAnswer((_) async => const Result.success(null));

    service = BackgroundDeliveryService(
      subscriptionRepository,
      feedRepository,
      foregroundServiceController,
    );
  });

  tearDown(() async {
    await subscriptionsController.close();
  });

  test('connects every subscription with ConnectionOwner.background on start', () async {
    await service.start();
    subscriptionsController.add([sub('srv-1', 'alerts'), sub('srv-2', 'news')]);
    await Future<void>.delayed(Duration.zero);

    verify(
      () => feedRepository.connect(
        'srv-1',
        'alerts',
        owner: ConnectionOwner.background,
      ),
    ).called(1);
    verify(
      () => feedRepository.connect(
        'srv-2',
        'news',
        owner: ConnectionOwner.background,
      ),
    ).called(1);
  });

  test('disconnects a subscription that is removed from a later emission', () async {
    await service.start();
    subscriptionsController.add([sub('srv-1', 'alerts')]);
    await Future<void>.delayed(Duration.zero);

    subscriptionsController.add(<Subscription>[]);
    await Future<void>.delayed(Duration.zero);

    verify(
      () => feedRepository.disconnect(
        'srv-1',
        'alerts',
        owner: ConnectionOwner.background,
      ),
    ).called(1);
  });

  test('does not reconnect a subscription already connected in an earlier emission', () async {
    await service.start();
    subscriptionsController.add([sub('srv-1', 'alerts')]);
    await Future<void>.delayed(Duration.zero);

    subscriptionsController.add([sub('srv-1', 'alerts')]);
    await Future<void>.delayed(Duration.zero);

    verify(
      () => feedRepository.connect(
        'srv-1',
        'alerts',
        owner: ConnectionOwner.background,
      ),
    ).called(1);
  });

  test('initializes and starts the foreground service on start()', () async {
    await service.start();

    verify(() => foregroundServiceController.initialize()).called(1);
    verify(() => foregroundServiceController.start()).called(1);
  });

  test('stop() cancels the subscription watch and stops the foreground service', () async {
    await service.start();
    subscriptionsController.add([sub('srv-1', 'alerts')]);
    await Future<void>.delayed(Duration.zero);

    await service.stop();

    verify(() => foregroundServiceController.stop()).called(1);

    subscriptionsController.add([sub('srv-1', 'alerts'), sub('srv-2', 'news')]);
    await Future<void>.delayed(Duration.zero);
    verifyNever(
      () => feedRepository.connect(
        'srv-2',
        'news',
        owner: ConnectionOwner.background,
      ),
    );
  });
}
