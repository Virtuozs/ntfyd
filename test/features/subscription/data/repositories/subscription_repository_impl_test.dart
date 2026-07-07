import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/database/app_database.dart' as db;
import 'package:ntfyd/core/database/daos/message_dao.dart';
import 'package:ntfyd/core/database/daos/subscription_dao.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/subscription/data/repositories/subscription_repository_impl.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';

class MockSubscriptionDao extends Mock implements SubscriptionDao {}

class MockMessageDao extends Mock implements MessageDao {}

void main() {
  late MockSubscriptionDao dao;
  late MockMessageDao messageDao;
  late SubscriptionRepositoryImpl repository;

  final now = DateTime.utc(2026, 1, 1);

  final row = db.Subscription(
    id: 'sub-1',
    serverId: 'srv-1',
    topic: 'alerts',
    displayName: 'Alerts',
    priorityThreshold: 1,
    muted: 0,
    pinned: 0,
    createdAt: now.millisecondsSinceEpoch,
  );

  final entity = Subscription(
    id: 'sub-1',
    serverId: 'srv-1',
    topic: 'alerts',
    displayName: 'Alerts',
    createdAt: now,
  );

  setUpAll(() {
    registerFallbackValue(const db.SubscriptionsCompanion());
  });

  setUp(() {
    dao = MockSubscriptionDao();
    messageDao = MockMessageDao();
    repository = SubscriptionRepositoryImpl(dao, messageDao);
  });

  group('watchByServer', () {
    test('maps DAO rows to domain entities', () async {
      when(
        () => dao.watchByServer('srv-1'),
      ).thenAnswer((_) => Stream.value([row]));

      final result = await repository.watchByServer('srv-1').first;

      expect(result, [entity]);
    });
  });

  group('subscribe', () {
    test('upserts and returns Success(sub) on success', () async {
      when(() => dao.upsert(any())).thenAnswer((_) async {});

      final result = await repository.subscribe(entity);

      expect(result.isSuccess, isTrue);
      expect(result.valueOrThrow, entity);
      verify(() => dao.upsert(any())).called(1);
    });

    test('returns Failure.cache when dao.upsert throws', () async {
      when(() => dao.upsert(any())).thenThrow(Exception('unique violation'));

      final result = await repository.subscribe(entity);

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<CacheFailure>());
    });
  });

  group('unsubscribe', () {
    test('clears cached messages then deletes by topic on success', () async {
      when(
        () => messageDao.clearByTopic('srv-1', 'alerts'),
      ).thenAnswer((_) async {});
      when(() => dao.deleteByTopic('srv-1', 'alerts')).thenAnswer((_) async {});

      final result = await repository.unsubscribe('srv-1', 'alerts');

      expect(result.isSuccess, isTrue);
      verifyInOrder([
        () => messageDao.clearByTopic('srv-1', 'alerts'),
        () => dao.deleteByTopic('srv-1', 'alerts'),
      ]);
    });

    test('returns Failure.cache when messageDao.clearByTopic throws', () async {
      when(
        () => messageDao.clearByTopic('srv-1', 'alerts'),
      ).thenThrow(Exception('db error'));

      final result = await repository.unsubscribe('srv-1', 'alerts');

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<CacheFailure>());
      verifyNever(() => dao.deleteByTopic('srv-1', 'alerts'));
    });

    test('returns Failure.cache when dao throws', () async {
      when(
        () => messageDao.clearByTopic('srv-1', 'alerts'),
      ).thenAnswer((_) async {});
      when(
        () => dao.deleteByTopic('srv-1', 'alerts'),
      ).thenThrow(Exception('db error'));

      final result = await repository.unsubscribe('srv-1', 'alerts');

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<CacheFailure>());
    });
  });

  group('togglePin', () {
    test('delegates to dao.togglePin', () async {
      when(() => dao.togglePin('sub-1')).thenAnswer((_) async {});

      final result = await repository.togglePin('sub-1');

      expect(result.isSuccess, isTrue);
      verify(() => dao.togglePin('sub-1')).called(1);
    });

    test('returns Failure.cache when dao throws', () async {
      when(() => dao.togglePin('sub-1')).thenThrow(Exception('db error'));

      final result = await repository.togglePin('sub-1');

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<CacheFailure>());
    });
  });

  group('toggleMute', () {
    test('delegates to dao.toggleMute', () async {
      when(() => dao.toggleMute('sub-1')).thenAnswer((_) async {});

      final result = await repository.toggleMute('sub-1');

      expect(result.isSuccess, isTrue);
      verify(() => dao.toggleMute('sub-1')).called(1);
    });

    test('returns Failure.cache when dao throws', () async {
      when(() => dao.toggleMute('sub-1')).thenThrow(Exception('db error'));

      final result = await repository.toggleMute('sub-1');

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<CacheFailure>());
    });
  });

  group('updatePriorityThreshold', () {
    test('delegates to dao.updatePriorityThreshold', () async {
      when(
        () => dao.updatePriorityThreshold('sub-1', 4),
      ).thenAnswer((_) async {});

      final result = await repository.updatePriorityThreshold('sub-1', 4);

      expect(result.isSuccess, isTrue);
      verify(() => dao.updatePriorityThreshold('sub-1', 4)).called(1);
    });

    test('returns Failure.cache when dao throws', () async {
      when(
        () => dao.updatePriorityThreshold('sub-1', 4),
      ).thenThrow(Exception('db error'));

      final result = await repository.updatePriorityThreshold('sub-1', 4);

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<CacheFailure>());
    });
  });

  group('watchAll', () {
    test('maps every dao row to a domain Subscription', () async {
      when(() => dao.watchAll()).thenAnswer((_) => Stream.value([row]));

      final result = await repository.watchAll().first;

      expect(result, equals([entity]));
    });
  });

  group('getByTopic', () {
    test('returns the mapped Subscription when found', () async {
      when(
        () => dao.findByTopic('srv-1', 'alerts'),
      ).thenAnswer((_) async => row);

      final result = await repository.getByTopic('srv-1', 'alerts');

      expect(result.isSuccess, isTrue);
      expect(result.valueOrThrow, equals(entity));
    });

    test('returns Failure.notFound when no subscription matches', () async {
      when(
        () => dao.findByTopic('srv-1', 'alerts'),
      ).thenAnswer((_) async => null);

      final result = await repository.getByTopic('srv-1', 'alerts');

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<NotFoundFailure>());
    });
  });
}
