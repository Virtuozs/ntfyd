import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:ntfyd/core/database/daos/message_dao.dart';
import 'package:ntfyd/core/database/value_objects/message_filter.dart';
import 'package:ntfyd/core/error/exception_mapper.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/network/ws_connector.dart';
import 'package:ntfyd/core/secure_storage/secure_credential_vault.dart';
import 'package:ntfyd/core/secure_storage/server_credential.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/feed/data/datasources/feed_poll_data_source.dart';
import 'package:ntfyd/features/feed/data/datasources/feed_ws_data_source.dart';
import 'package:ntfyd/features/feed/data/mappers/feed_mapper.dart';
import 'package:ntfyd/features/feed/data/models/message_dto.dart';
import 'package:ntfyd/features/feed/domain/entities/feed_connection_state.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';
import 'package:ntfyd/features/feed/domain/repositories/feed_repository.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';

typedef FeedWsDataSourceFactory = FeedWsDataSource Function({
  required String baseUrl,
  required String topic,
  String? authHeader,
});

FeedWsDataSource _defaultFeedWsDataSourceFactory({
  required String baseUrl,
  required String topic,
  String? authHeader,
}) => FeedWsDataSource(
  WsConnector(baseUrl: baseUrl, topic: topic, authHeader: authHeader),
);

class _FeedSession {
  _FeedSession({
    required this.ws,
    required this.frameSub,
    required this.stateSub,
  });

  final FeedWsDataSource ws;
  final StreamSubscription<Map<String, dynamic>> frameSub;
  final StreamSubscription<FeedConnectionState> stateSub;
}

/// Manages one screen-scoped WS session per (serverId, topic) key, writing
/// every transport (WS frames, poll catch-up) straight to [MessageDao] —
/// the single source of truth the UI watches (Base-Plan D9, "Option A").
///
/// Registered for DI via `FeedModule.feedRepository` rather than a
/// class-level `@LazySingleton` annotation: `injectable` cannot resolve the
/// bare `FeedWsDataSourceFactory` (`Function`-typed) constructor param,
/// even though it's optional (same constraint as
/// `AccountDataSourceImpl`/`ServerConfigModule.accountDataSource`).
class FeedRepositoryImpl implements FeedRepository {
  FeedRepositoryImpl(
    this._serverConfigRepository,
    this._vault,
    this._messageDao,
    this._pollDataSource, {
    FeedWsDataSourceFactory? wsDataSourceFactory,
  }) : _wsDataSourceFactory =
           wsDataSourceFactory ?? _defaultFeedWsDataSourceFactory;

  final ServerConfigRepository _serverConfigRepository;
  final SecureCredentialVault _vault;
  final MessageDao _messageDao;
  final FeedPollDataSource _pollDataSource;
  final FeedWsDataSourceFactory _wsDataSourceFactory;

  final Map<String, _FeedSession> _sessions = {};
  final Map<String, BehaviorSubject<FeedConnectionState>> _connectionSubjects = {};

  @override
  Stream<List<NotificationMessage>> watchMessages(
    String serverId,
    String topic, {
    MessageFilter? filter,
  }) {
    return _messageDao
        .watchByTopic(serverId, topic, filter: filter)
        .map((rows) => rows.map(FeedMapper.toDomain).toList());
  }

  @override
  Stream<int> watchUnreadCount(String serverId, String topic) =>
      _messageDao.watchUnreadCount(serverId, topic);

  @override
  Stream<NotificationMessage?> watchLatestMessage(
    String serverId,
    String topic,
  ) {
    return _messageDao
        .watchLatestByTopic(serverId, topic)
        .map((row) => row == null ? null : FeedMapper.toDomain(row));
  }

  @override
  Stream<FeedConnectionState> watchConnectionState(
    String serverId,
    String topic,
  ) => _getOrCreateConnectionSubject(_key(serverId, topic)).stream;

  @override
  Future<Result<void>> connect(String serverId, String topic) async {
    final key = _key(serverId, topic);
    if (_sessions.containsKey(key)) return const Result.success(null);

    final resolved = await _resolveServer(serverId);
    if (!resolved.isSuccess) return Result.err(resolved.failureOrThrow);
    final (baseUrl: baseUrl, credential: credential) = resolved.valueOrThrow;

    try {
      final ws = _wsDataSourceFactory(
        baseUrl: baseUrl,
        topic: topic,
        authHeader: _authHeaderFor(credential),
      );

      final stateSub = ws.connectionState.listen(
        (state) => _getOrCreateConnectionSubject(key).add(state),
      );
      final frameSub = ws.frames.listen(
        (frame) => _handleFrame(serverId, topic, frame),
      );

      _sessions[key] = _FeedSession(
        ws: ws,
        frameSub: frameSub,
        stateSub: stateSub,
      );

      await ws.connect();
      await _catchUp(serverId, topic, baseUrl, credential);

      return const Result.success(null);
    } catch (e) {
      final session = _sessions.remove(key);
      try {
        await session?.ws.disconnect();
      } catch (_) {
        // best-effort teardown regardless of disconnect failures
      }
      await session?.frameSub.cancel();
      await session?.stateSub.cancel();
      _getOrCreateConnectionSubject(key).add(FeedConnectionState.offline);
      return Result.err(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Result<void>> disconnect(String serverId, String topic) async {
    final session = _sessions.remove(_key(serverId, topic));
    if (session == null) return const Result.success(null);

    try {
      await session.ws.disconnect();
    } catch (_) {
      // best-effort teardown regardless of disconnect failures
    }
    await session.frameSub.cancel();
    await session.stateSub.cancel();
    _getOrCreateConnectionSubject(
      _key(serverId, topic),
    ).add(FeedConnectionState.offline);
    return const Result.success(null);
  }

  @override
  Future<Result<void>> refreshHistory(String serverId, String topic) async {
    final resolved = await _resolveServer(serverId);
    if (!resolved.isSuccess) return Result.err(resolved.failureOrThrow);
    final (baseUrl: baseUrl, credential: credential) = resolved.valueOrThrow;

    try {
      await _catchUp(serverId, topic, baseUrl, credential);
      return const Result.success(null);
    } catch (e) {
      return Result.err(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Result<void>> toggleRead(String serverId, String id) async {
    try {
      await _messageDao.toggleRead(serverId, id);
      return const Result.success(null);
    } catch (e) {
      return Result.err(Failure.cache(message: 'Failed to toggle read: $e'));
    }
  }

  @override
  Future<Result<void>> togglePin(String serverId, String id) async {
    try {
      await _messageDao.togglePin(serverId, id);
      return const Result.success(null);
    } catch (e) {
      return Result.err(Failure.cache(message: 'Failed to toggle pin: $e'));
    }
  }

  Future<void> _catchUp(
    String serverId,
    String topic,
    String baseUrl,
    ServerCredential credential,
  ) async {
    final lastId = await _messageDao.getLastId(serverId, topic);
    final history = await _pollDataSource.fetchHistory(
      baseUrl: baseUrl,
      topic: topic,
      credential: credential,
      since: lastId ?? 'all',
    );
    for (final dto in history) {
      final msg = FeedMapper.fromDto(
        dto,
        serverId: serverId,
        receivedAt: DateTime.now(),
      );
      if (msg != null) {
        await _messageDao.insertOrReplace(FeedMapper.toCompanion(msg));
      }
    }
  }

  Future<void> _handleFrame(
    String serverId,
    String topic,
    Map<String, dynamic> frame,
  ) async {
    switch (frame['event']) {
      case 'message':
        final dto = MessageDto.fromJson(frame);
        final msg = FeedMapper.fromDto(
          dto,
          serverId: serverId,
          receivedAt: DateTime.now(),
        );
        if (msg != null) {
          await _messageDao.insertOrReplace(FeedMapper.toCompanion(msg));
        }
      case 'message_delete':
        final id = frame['id'] as String?;
        if (id != null) await _messageDao.deleteById(serverId, id);
      case 'message_clear':
        await _messageDao.clearByTopic(serverId, topic);
    }
  }

  Future<Result<({String baseUrl, ServerCredential credential})>>
  _resolveServer(String serverId) async {
    final serverResult = await _serverConfigRepository.getById(serverId);
    if (!serverResult.isSuccess) {
      return Result.err(serverResult.failureOrThrow);
    }
    final server = serverResult.valueOrThrow;

    final credentialRef = server.credentialRef;
    final credential = credentialRef == null
        ? const ServerCredential.noAuth()
        : (await _vault.retrieve(credentialRef)) ??
              const ServerCredential.noAuth();

    return Result.success((baseUrl: server.baseUrl, credential: credential));
  }

  String? _authHeaderFor(ServerCredential credential) => credential.when(
    noAuth: () => null,
    basicAuth: (username, password) =>
        'Basic ${base64Encode(utf8.encode('$username:$password'))}',
    bearerToken: (token) => 'Bearer $token',
  );

  BehaviorSubject<FeedConnectionState> _getOrCreateConnectionSubject(
    String key,
  ) => _connectionSubjects.putIfAbsent(
    key,
    () => BehaviorSubject.seeded(FeedConnectionState.offline),
  );

  String _key(String serverId, String topic) => '$serverId:$topic';
}
