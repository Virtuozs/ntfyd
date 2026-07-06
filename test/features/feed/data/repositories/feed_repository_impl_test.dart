import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/database/app_database.dart' as db;
import 'package:ntfyd/core/database/daos/message_dao.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/secure_storage/secure_credential_vault.dart';
import 'package:ntfyd/core/secure_storage/server_credential.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/feed/data/datasources/feed_poll_data_source.dart';
import 'package:ntfyd/features/feed/data/datasources/feed_ws_data_source.dart';
import 'package:ntfyd/features/feed/data/models/message_dto.dart';
import 'package:ntfyd/features/feed/data/repositories/feed_repository_impl.dart';
import 'package:ntfyd/features/feed/domain/entities/connection_owner.dart';
import 'package:ntfyd/features/feed/domain/entities/feed_connection_state.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';

class MockServerConfigRepository extends Mock implements ServerConfigRepository {}

class MockSecureCredentialVault extends Mock implements SecureCredentialVault {}

class MockMessageDao extends Mock implements MessageDao {}

class MockFeedPollDataSource extends Mock implements FeedPollDataSource {}

class MockFeedWsDataSource extends Mock implements FeedWsDataSource {}

void main() {
  late MockServerConfigRepository serverConfigRepository;
  late MockSecureCredentialVault vault;
  late MockMessageDao messageDao;
  late MockFeedPollDataSource pollDataSource;
  late MockFeedWsDataSource ws;
  late FeedRepositoryImpl repository;

  late StreamController<Map<String, dynamic>> framesController;
  late StreamController<FeedConnectionState> connectionStateController;

  final anonServer = ServerConfig(
    id: 'srv-1',
    baseUrl: 'https://ntfy.sh',
    displayName: 'ntfy.sh',
    authType: AuthType.none,
    isDefault: true,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(const db.NotificationMessagesCompanion());
    registerFallbackValue(const ServerCredential.noAuth());
  });

  setUp(() {
    serverConfigRepository = MockServerConfigRepository();
    vault = MockSecureCredentialVault();
    messageDao = MockMessageDao();
    pollDataSource = MockFeedPollDataSource();
    ws = MockFeedWsDataSource();
    framesController = StreamController<Map<String, dynamic>>.broadcast();
    connectionStateController = StreamController<FeedConnectionState>.broadcast();

    when(() => ws.frames).thenAnswer((_) => framesController.stream);
    when(
      () => ws.connectionState,
    ).thenAnswer((_) => connectionStateController.stream);
    when(() => ws.connect()).thenAnswer((_) async {});
    when(() => ws.disconnect()).thenAnswer((_) async {});

    repository = FeedRepositoryImpl(
      serverConfigRepository,
      vault,
      messageDao,
      pollDataSource,
      wsDataSourceFactory: ({required baseUrl, required topic, authHeader}) => ws,
    );
  });

  tearDown(() async {
    await framesController.close();
    await connectionStateController.close();
  });

  group('connect', () {
    test('resolves the server, opens the WS session, and catches up history', () async {
      when(
        () => serverConfigRepository.getById('srv-1'),
      ).thenAnswer((_) async => Result.success(anonServer));
      when(
        () => messageDao.getLastId('srv-1', 'alerts'),
      ).thenAnswer((_) async => null);
      when(
        () => pollDataSource.fetchHistory(
          baseUrl: 'https://ntfy.sh',
          topic: 'alerts',
          credential: const ServerCredential.noAuth(),
          since: 'all',
        ),
      ).thenAnswer(
        (_) async => [
          const MessageDto(
            id: 'msg-1',
            time: 100,
            event: 'message',
            topic: 'alerts',
          ),
        ],
      );
      when(() => messageDao.insertOrReplace(any())).thenAnswer((_) async {});

      final result = await repository.connect('srv-1', 'alerts', owner: ConnectionOwner.screen);

      expect(result.isSuccess, isTrue);
      verify(() => ws.connect()).called(1);
      verify(() => messageDao.insertOrReplace(any())).called(1);
    });

    test('is idempotent — a second connect() for the same key is a no-op', () async {
      when(
        () => serverConfigRepository.getById('srv-1'),
      ).thenAnswer((_) async => Result.success(anonServer));
      when(
        () => messageDao.getLastId('srv-1', 'alerts'),
      ).thenAnswer((_) async => null);
      when(
        () => pollDataSource.fetchHistory(
          baseUrl: any(named: 'baseUrl'),
          topic: any(named: 'topic'),
          credential: any(named: 'credential'),
          since: any(named: 'since'),
        ),
      ).thenAnswer((_) async => []);

      await repository.connect('srv-1', 'alerts', owner: ConnectionOwner.screen);
      await repository.connect('srv-1', 'alerts', owner: ConnectionOwner.screen);

      verify(() => ws.connect()).called(1);
      verify(() => serverConfigRepository.getById('srv-1')).called(1);
    });

    test('catches up with since=<lastId> when history already exists', () async {
      when(
        () => serverConfigRepository.getById('srv-1'),
      ).thenAnswer((_) async => Result.success(anonServer));
      when(
        () => messageDao.getLastId('srv-1', 'alerts'),
      ).thenAnswer((_) async => 'msg-9');
      when(
        () => pollDataSource.fetchHistory(
          baseUrl: 'https://ntfy.sh',
          topic: 'alerts',
          credential: const ServerCredential.noAuth(),
          since: 'msg-9',
        ),
      ).thenAnswer((_) async => []);

      final result = await repository.connect('srv-1', 'alerts', owner: ConnectionOwner.screen);

      expect(result.isSuccess, isTrue);
      verify(
        () => pollDataSource.fetchHistory(
          baseUrl: 'https://ntfy.sh',
          topic: 'alerts',
          credential: const ServerCredential.noAuth(),
          since: 'msg-9',
        ),
      ).called(1);
    });

    test('returns the Failure from ServerConfigRepository without opening a session', () async {
      when(() => serverConfigRepository.getById('srv-1')).thenAnswer(
        (_) async => const Result.err(Failure.notFound()),
      );

      final result = await repository.connect('srv-1', 'alerts', owner: ConnectionOwner.screen);

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<NotFoundFailure>());
      verifyNever(() => ws.connect());
    });

    test('disconnects the WS and clears the session when catch-up history fetch throws', () async {
      when(
        () => serverConfigRepository.getById('srv-1'),
      ).thenAnswer((_) async => Result.success(anonServer));
      when(
        () => messageDao.getLastId('srv-1', 'alerts'),
      ).thenAnswer((_) async => null);
      when(
        () => pollDataSource.fetchHistory(
          baseUrl: any(named: 'baseUrl'),
          topic: any(named: 'topic'),
          credential: any(named: 'credential'),
          since: any(named: 'since'),
        ),
      ).thenThrow(Exception('poll failed'));

      final result = await repository.connect('srv-1', 'alerts', owner: ConnectionOwner.screen);

      expect(result.isSuccess, isFalse);
      verify(() => ws.disconnect()).called(1);

      // The failed session must have been cleaned up rather than cached: a
      // subsequent connect() re-resolves the server instead of treating the
      // half-broken state as an idempotent no-op.
      when(
        () => pollDataSource.fetchHistory(
          baseUrl: any(named: 'baseUrl'),
          topic: any(named: 'topic'),
          credential: any(named: 'credential'),
          since: any(named: 'since'),
        ),
      ).thenAnswer((_) async => []);

      await repository.connect('srv-1', 'alerts', owner: ConnectionOwner.screen);

      verify(() => serverConfigRepository.getById('srv-1')).called(2);
    });

    test('resets watchConnectionState to offline when connect() fails after the WS session already opened', () async {
      when(
        () => serverConfigRepository.getById('srv-1'),
      ).thenAnswer((_) async => Result.success(anonServer));
      when(
        () => messageDao.getLastId('srv-1', 'alerts'),
      ).thenAnswer((_) async => null);

      final fetchCompleter = Completer<List<MessageDto>>();
      when(
        () => pollDataSource.fetchHistory(
          baseUrl: any(named: 'baseUrl'),
          topic: any(named: 'topic'),
          credential: any(named: 'credential'),
          since: any(named: 'since'),
        ),
      ).thenAnswer((_) => fetchCompleter.future);

      final states = <FeedConnectionState>[];
      repository.watchConnectionState('srv-1', 'alerts').listen(states.add);
      await Future<void>.delayed(Duration.zero);

      final connectFuture = repository.connect('srv-1', 'alerts', owner: ConnectionOwner.screen);
      await Future<void>.delayed(Duration.zero);

      // The WS session is open and forwarding real lifecycle events while
      // catch-up is in flight — simulate a real "live" event arriving before
      // the catch-up fetch fails.
      connectionStateController.add(FeedConnectionState.live);
      await Future<void>.delayed(Duration.zero);
      expect(states.last, FeedConnectionState.live);

      fetchCompleter.completeError(Exception('poll failed'));
      final result = await connectFuture;
      await Future<void>.delayed(Duration.zero);

      expect(result.isSuccess, isFalse);
      expect(states.last, FeedConnectionState.offline);
    });

    test('forwards frame events to MessageDao (message/message_delete/message_clear)', () async {
      when(
        () => serverConfigRepository.getById('srv-1'),
      ).thenAnswer((_) async => Result.success(anonServer));
      when(
        () => messageDao.getLastId('srv-1', 'alerts'),
      ).thenAnswer((_) async => null);
      when(
        () => pollDataSource.fetchHistory(
          baseUrl: any(named: 'baseUrl'),
          topic: any(named: 'topic'),
          credential: any(named: 'credential'),
          since: any(named: 'since'),
        ),
      ).thenAnswer((_) async => []);
      when(() => messageDao.insertOrReplace(any())).thenAnswer((_) async {});
      when(
        () => messageDao.deleteById('srv-1', 'msg-1'),
      ).thenAnswer((_) async {});
      when(
        () => messageDao.clearByTopic('srv-1', 'alerts'),
      ).thenAnswer((_) async {});

      await repository.connect('srv-1', 'alerts', owner: ConnectionOwner.screen);

      framesController.add({
        'id': 'msg-1',
        'time': 100,
        'event': 'message',
        'topic': 'alerts',
      });
      await Future<void>.delayed(Duration.zero);
      verify(() => messageDao.insertOrReplace(any())).called(1);

      framesController.add({'event': 'message_delete', 'id': 'msg-1'});
      await Future<void>.delayed(Duration.zero);
      verify(() => messageDao.deleteById('srv-1', 'msg-1')).called(1);

      framesController.add({'event': 'message_clear'});
      await Future<void>.delayed(Duration.zero);
      verify(() => messageDao.clearByTopic('srv-1', 'alerts')).called(1);
    });
  });

  group('disconnect', () {
    test('tears down an open session', () async {
      when(
        () => serverConfigRepository.getById('srv-1'),
      ).thenAnswer((_) async => Result.success(anonServer));
      when(
        () => messageDao.getLastId('srv-1', 'alerts'),
      ).thenAnswer((_) async => null);
      when(
        () => pollDataSource.fetchHistory(
          baseUrl: any(named: 'baseUrl'),
          topic: any(named: 'topic'),
          credential: any(named: 'credential'),
          since: any(named: 'since'),
        ),
      ).thenAnswer((_) async => []);

      await repository.connect('srv-1', 'alerts', owner: ConnectionOwner.screen);
      final result = await repository.disconnect('srv-1', 'alerts', owner: ConnectionOwner.screen);

      expect(result.isSuccess, isTrue);
      verify(() => ws.disconnect()).called(1);
    });

    test('disconnecting a topic with no session is a no-op success', () async {
      final result = await repository.disconnect('srv-1', 'alerts', owner: ConnectionOwner.screen);

      expect(result.isSuccess, isTrue);
      verifyNever(() => ws.disconnect());
    });

    test('resets watchConnectionState to offline after tearing down a session', () async {
      when(
        () => serverConfigRepository.getById('srv-1'),
      ).thenAnswer((_) async => Result.success(anonServer));
      when(
        () => messageDao.getLastId('srv-1', 'alerts'),
      ).thenAnswer((_) async => null);
      when(
        () => pollDataSource.fetchHistory(
          baseUrl: any(named: 'baseUrl'),
          topic: any(named: 'topic'),
          credential: any(named: 'credential'),
          since: any(named: 'since'),
        ),
      ).thenAnswer((_) async => []);

      final states = <FeedConnectionState>[];
      repository.watchConnectionState('srv-1', 'alerts').listen(states.add);
      await Future<void>.delayed(Duration.zero);

      await repository.connect('srv-1', 'alerts', owner: ConnectionOwner.screen);
      connectionStateController.add(FeedConnectionState.live);
      await Future<void>.delayed(Duration.zero);

      await repository.disconnect('srv-1', 'alerts', owner: ConnectionOwner.screen);
      await Future<void>.delayed(Duration.zero);

      expect(states.last, FeedConnectionState.offline);
    });
  });

  group('watchConnectionState', () {
    test('forwards WS connection states pushed during an open session', () async {
      when(
        () => serverConfigRepository.getById('srv-1'),
      ).thenAnswer((_) async => Result.success(anonServer));
      when(
        () => messageDao.getLastId('srv-1', 'alerts'),
      ).thenAnswer((_) async => null);
      when(
        () => pollDataSource.fetchHistory(
          baseUrl: any(named: 'baseUrl'),
          topic: any(named: 'topic'),
          credential: any(named: 'credential'),
          since: any(named: 'since'),
        ),
      ).thenAnswer((_) async => []);

      final states = <FeedConnectionState>[];
      repository.watchConnectionState('srv-1', 'alerts').listen(states.add);
      await Future<void>.delayed(Duration.zero);

      await repository.connect('srv-1', 'alerts', owner: ConnectionOwner.screen);
      connectionStateController.add(FeedConnectionState.live);
      await Future<void>.delayed(Duration.zero);

      expect(states, [FeedConnectionState.offline, FeedConnectionState.live]);
    });
  });

  group('refreshHistory', () {
    test('fetches since the last known id and inserts results', () async {
      when(
        () => serverConfigRepository.getById('srv-1'),
      ).thenAnswer((_) async => Result.success(anonServer));
      when(
        () => messageDao.getLastId('srv-1', 'alerts'),
      ).thenAnswer((_) async => 'msg-5');
      when(
        () => pollDataSource.fetchHistory(
          baseUrl: 'https://ntfy.sh',
          topic: 'alerts',
          credential: const ServerCredential.noAuth(),
          since: 'msg-5',
        ),
      ).thenAnswer(
        (_) async => [
          const MessageDto(
            id: 'msg-6',
            time: 100,
            event: 'message',
            topic: 'alerts',
          ),
        ],
      );
      when(() => messageDao.insertOrReplace(any())).thenAnswer((_) async {});

      final result = await repository.refreshHistory('srv-1', 'alerts');

      expect(result.isSuccess, isTrue);
      verify(() => messageDao.insertOrReplace(any())).called(1);
    });
  });

  group('toggleRead / togglePin', () {
    test('toggleRead delegates to MessageDao.toggleRead', () async {
      when(
        () => messageDao.toggleRead('srv-1', 'msg-1'),
      ).thenAnswer((_) async {});

      final result = await repository.toggleRead('srv-1', 'msg-1');

      expect(result.isSuccess, isTrue);
      verify(() => messageDao.toggleRead('srv-1', 'msg-1')).called(1);
    });

    test('toggleRead returns Failure.cache when MessageDao throws', () async {
      when(
        () => messageDao.toggleRead('srv-1', 'msg-1'),
      ).thenThrow(Exception('db error'));

      final result = await repository.toggleRead('srv-1', 'msg-1');

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<CacheFailure>());
    });

    test('togglePin delegates to MessageDao.togglePin', () async {
      when(
        () => messageDao.togglePin('srv-1', 'msg-1'),
      ).thenAnswer((_) async {});

      final result = await repository.togglePin('srv-1', 'msg-1');

      expect(result.isSuccess, isTrue);
      verify(() => messageDao.togglePin('srv-1', 'msg-1')).called(1);
    });
  });

  group('reference-counted connections', () {
    test('a background connect after a screen connect keeps the session open on screen disconnect', () async {
      when(
        () => serverConfigRepository.getById('srv-1'),
      ).thenAnswer((_) async => Result.success(anonServer));
      when(
        () => messageDao.getLastId('srv-1', 'alerts'),
      ).thenAnswer((_) async => null);
      when(
        () => pollDataSource.fetchHistory(
          baseUrl: any(named: 'baseUrl'),
          topic: any(named: 'topic'),
          credential: any(named: 'credential'),
          since: any(named: 'since'),
        ),
      ).thenAnswer((_) async => []);

      await repository.connect('srv-1', 'alerts', owner: ConnectionOwner.screen);
      await repository.connect('srv-1', 'alerts', owner: ConnectionOwner.background);

      await repository.disconnect('srv-1', 'alerts', owner: ConnectionOwner.screen);
      verifyNever(() => ws.disconnect());

      await repository.disconnect('srv-1', 'alerts', owner: ConnectionOwner.background);
      verify(() => ws.disconnect()).called(1);
    });

    test('disconnecting an owner that never connected is a no-op while the other owner holds the session', () async {
      when(
        () => serverConfigRepository.getById('srv-1'),
      ).thenAnswer((_) async => Result.success(anonServer));
      when(
        () => messageDao.getLastId('srv-1', 'alerts'),
      ).thenAnswer((_) async => null);
      when(
        () => pollDataSource.fetchHistory(
          baseUrl: any(named: 'baseUrl'),
          topic: any(named: 'topic'),
          credential: any(named: 'credential'),
          since: any(named: 'since'),
        ),
      ).thenAnswer((_) async => []);

      await repository.connect('srv-1', 'alerts', owner: ConnectionOwner.screen);

      await repository.disconnect('srv-1', 'alerts', owner: ConnectionOwner.background);
      verifyNever(() => ws.disconnect());

      await repository.disconnect('srv-1', 'alerts', owner: ConnectionOwner.screen);
      verify(() => ws.disconnect()).called(1);
    });

    test('a second connect from the same owner does not duplicate ownership', () async {
      when(
        () => serverConfigRepository.getById('srv-1'),
      ).thenAnswer((_) async => Result.success(anonServer));
      when(
        () => messageDao.getLastId('srv-1', 'alerts'),
      ).thenAnswer((_) async => null);
      when(
        () => pollDataSource.fetchHistory(
          baseUrl: any(named: 'baseUrl'),
          topic: any(named: 'topic'),
          credential: any(named: 'credential'),
          since: any(named: 'since'),
        ),
      ).thenAnswer((_) async => []);

      await repository.connect('srv-1', 'alerts', owner: ConnectionOwner.screen);
      await repository.connect('srv-1', 'alerts', owner: ConnectionOwner.screen);

      await repository.disconnect('srv-1', 'alerts', owner: ConnectionOwner.screen);
      verify(() => ws.disconnect()).called(1);
    });
  });
}
