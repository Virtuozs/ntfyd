# P3 — Subscriptions Feature Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement subscribe/unsubscribe to ntfy topics with per-topic mute/pin and the first-subscribe credential-validation flow (D14/R5), per the approved design at `docs/superpowers/specs/2026-07-04-p3-subscriptions-design.md`.

**Architecture:** Clean Architecture (feature-first), mirroring the existing `server_config` feature exactly: `domain` (pure Dart, Freezed entity + `Result<T>`/`UseCase` base) → `data` (Drift DAO + mapper + repository impl) ← `presentation` (Bloc + bottom-sheet widget). `SubscriptionBloc` follows the app's "Option A" data flow (Base-Plan D9): `SubscriptionRepository.watchByServer` is the single reactive source of truth; mutating events only ever emit failure states — successful mutations surface through the already-active `watchByServer` stream reacting to the DB write.

**Tech Stack:** Flutter, `flutter_bloc` 9.x, `freezed` 3.x, `drift` 2.x, `injectable`/`get_it`, `dio`, `mocktail`, `bloc_test`.

## Global Constraints

- Strict TDD: every task writes a failing test before implementation code (SKELETON → RED → GREEN → REFACTOR).
- `domain/` has zero imports from Flutter/Drift/Dio/FCM (enforced by `analyzer` + existing lint config).
- Credentials never in URLs — always via `Authorization` headers (NFR3). Not directly touched by this feature, but `SubscribeToTopic` retrieves credentials via `SecureCredentialVault`, never logs them.
- Freezed for pure data only; `SubscriptionBloc` (has logic) is plain Dart/Bloc, not `@freezed`.
- Always `import 'package:ntfyd/core/database/app_database.dart' as db;` when a file needs both a Drift row type and a domain entity of the same name (`Subscription` collides on both sides here, exactly like `ServerConfig` did in P2).
- `injectable` cannot resolve bare `Function`-typed constructor params — use the `XxxTestHooks` static-field pattern (see `AddServerTestHooks`) for ID generation / clock seams.
- All imports are `package:` imports (`always_use_package_imports: error` in `analysis_options.yaml`).
- Every new/modified `@injectable`/`@LazySingleton`/`@module`-annotated file requires `dart run build_runner build --delete-conflicting-outputs` before `injection_container.config.dart` reflects it.
- Branch: `feature/subscriptions`, branched from the current `feature/server-config` tip (main has none of the P1/P2 infra yet). Granular conventional commits, one per task.

---

### Task 1: Branch setup + `Subscription` domain entity + repository contract

**Files:**
- Create: `lib/features/subscription/domain/entities/subscription.dart`
- Create: `lib/features/subscription/domain/repositories/subscription_repository.dart`
- Test: `test/features/subscription/domain/entities/subscription_test.dart`

**Interfaces:**
- Consumes: `Result<T>` / `Failure` (`lib/core/usecase/result.dart`, `lib/core/error/failures.dart`) — already exist.
- Produces: `Subscription` entity with fields `id, serverId, topic, displayName, priorityThreshold (default 1), muted (default false), pinned (default false), createdAt`; `static Result<Subscription> Subscription.validate({required String id, required String serverId, required String topic, String? displayName, int priorityThreshold = 1, bool muted = false, bool pinned = false, required DateTime createdAt})`. `SubscriptionRepository` abstract class with 6 methods (below) — every later task's use cases/bloc depend on these exact signatures.

- [ ] **Step 1: Create the feature branch**

Run: `git checkout -b feature/subscriptions`
Expected: `Switched to a new branch 'feature/subscriptions'`

- [ ] **Step 2: Confirm the P2 baseline is green**

Run: `flutter test`
Expected: all existing tests PASS (0 failures). Do not proceed until this is true.

- [ ] **Step 3: Write the failing entity test**

Create `test/features/subscription/domain/entities/subscription_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';

void main() {
  final fixedNow = DateTime.utc(2026, 6, 8);

  group('Subscription.validate', () {
    test('returns ValidationFailure when topic is empty', () {
      final result = Subscription.validate(
        id: 'sub-1',
        serverId: 'srv-1',
        topic: '',
        displayName: 'Alerts',
        createdAt: fixedNow,
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<ValidationFailure>());
      expect((result.failureOrThrow as ValidationFailure).field, 'topic');
    });

    test('returns ValidationFailure when priorityThreshold is below 1', () {
      final result = Subscription.validate(
        id: 'sub-1',
        serverId: 'srv-1',
        topic: 'alerts',
        priorityThreshold: 0,
        createdAt: fixedNow,
      );

      expect(result.isSuccess, isFalse);
      expect(
        (result.failureOrThrow as ValidationFailure).field,
        'priorityThreshold',
      );
    });

    test('returns ValidationFailure when priorityThreshold is above 5', () {
      final result = Subscription.validate(
        id: 'sub-1',
        serverId: 'srv-1',
        topic: 'alerts',
        priorityThreshold: 6,
        createdAt: fixedNow,
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<ValidationFailure>());
    });

    test('pinned and muted default to false, priorityThreshold defaults to 1', () {
      final result = Subscription.validate(
        id: 'sub-1',
        serverId: 'srv-1',
        topic: 'alerts',
        createdAt: fixedNow,
      );

      expect(result.isSuccess, isTrue);
      final sub = result.valueOrThrow;
      expect(sub.pinned, isFalse);
      expect(sub.muted, isFalse);
      expect(sub.priorityThreshold, 1);
    });

    test('falls back displayName to topic when displayName is null/blank', () {
      final result = Subscription.validate(
        id: 'sub-1',
        serverId: 'srv-1',
        topic: 'alerts',
        displayName: '   ',
        createdAt: fixedNow,
      );

      expect(result.valueOrThrow.displayName, 'alerts');
    });

    test('two Subscriptions with identical fields are equal (Freezed equality)', () {
      final a = Subscription.validate(
        id: 'sub-1',
        serverId: 'srv-1',
        topic: 'alerts',
        createdAt: fixedNow,
      ).valueOrThrow;
      final b = Subscription.validate(
        id: 'sub-1',
        serverId: 'srv-1',
        topic: 'alerts',
        createdAt: fixedNow,
      ).valueOrThrow;

      expect(a, equals(b));
    });

    test('copyWith(pinned: true) produces a new, unequal instance', () {
      final sub = Subscription.validate(
        id: 'sub-1',
        serverId: 'srv-1',
        topic: 'alerts',
        createdAt: fixedNow,
      ).valueOrThrow;

      final pinned = sub.copyWith(pinned: true);

      expect(pinned.pinned, isTrue);
      expect(pinned, isNot(equals(sub)));
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/subscription/domain/entities/subscription_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:ntfyd/features/subscription/domain/entities/subscription.dart'`

- [ ] **Step 3: Write the entity**

Create `lib/features/subscription/domain/entities/subscription.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';

part 'subscription.freezed.dart';

@freezed
abstract class Subscription with _$Subscription {
  const factory Subscription({
    required String id,
    required String serverId,
    required String topic,
    required String displayName,
    @Default(1) int priorityThreshold,
    @Default(false) bool muted,
    @Default(false) bool pinned,
    required DateTime createdAt,
  }) = _Subscription;

  const Subscription._();

  /// Validates a candidate [Subscription], returning a [Result] containing
  /// either a valid [Subscription] or a [Failure.validation].
  ///
  /// Blank/null [displayName] falls back to [topic] (mirrors
  /// [ServerConfig.validate]'s host-fallback behavior).
  static Result<Subscription> validate({
    required String id,
    required String serverId,
    required String topic,
    String? displayName,
    int priorityThreshold = 1,
    bool muted = false,
    bool pinned = false,
    required DateTime createdAt,
  }) {
    if (topic.trim().isEmpty) {
      return const Result.err(
        Failure.validation(field: 'topic', message: 'topic must not be empty'),
      );
    }

    if (priorityThreshold < 1 || priorityThreshold > 5) {
      return const Result.err(
        Failure.validation(
          field: 'priorityThreshold',
          message: 'priorityThreshold must be between 1 and 5',
        ),
      );
    }

    final resolvedDisplayName = (displayName == null || displayName.trim().isEmpty)
        ? topic
        : displayName;

    return Result.success(
      Subscription(
        id: id,
        serverId: serverId,
        topic: topic,
        displayName: resolvedDisplayName,
        priorityThreshold: priorityThreshold,
        muted: muted,
        pinned: pinned,
        createdAt: createdAt,
      ),
    );
  }
}
```

Create `lib/features/subscription/domain/repositories/subscription_repository.dart`:

```dart
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';

abstract class SubscriptionRepository {
  Stream<List<Subscription>> watchByServer(String serverId);
  Future<Result<Subscription>> subscribe(Subscription sub);
  Future<Result<void>> unsubscribe(String serverId, String topic);
  Future<Result<void>> togglePin(String id);
  Future<Result<void>> toggleMute(String id);
  Future<Result<void>> updatePriorityThreshold(String id, int threshold);
}
```

- [ ] **Step 4: Generate Freezed code**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: completes with `subscription.freezed.dart` generated, no errors.

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/features/subscription/domain/entities/subscription_test.dart`
Expected: PASS (7/7).

- [ ] **Step 6: Commit**

```bash
git add lib/features/subscription/domain/entities/subscription.dart \
        lib/features/subscription/domain/entities/subscription.freezed.dart \
        lib/features/subscription/domain/repositories/subscription_repository.dart \
        test/features/subscription/domain/entities/subscription_test.dart
git commit -m "feat(subscription): add Subscription entity and repository contract"
```

---

### Task 2: Extend `SubscriptionDao` with `updatePriorityThreshold`

**Files:**
- Modify: `lib/core/database/daos/subscription_dao.dart`
- Modify: `test/core/database/daos/subscription_dao_test.dart` (append a group)

**Interfaces:**
- Consumes: existing `SubscriptionDao` (P1-8) — `watchByServer`, `findByTopic`, `upsert`, `deleteByTopic`, `togglePin`, `toggleMute` (unchanged).
- Produces: `Future<void> SubscriptionDao.updatePriorityThreshold(String id, int threshold)` — consumed by `SubscriptionRepositoryImpl` in Task 4.

- [ ] **Step 1: Write the failing DAO test**

Append to `test/core/database/daos/subscription_dao_test.dart` (before the final closing `}` of `main()`):

```dart
  group('updatePriorityThreshold', () {
    test('updates priorityThreshold for the given id', () async {
      await db.subscriptionDao.upsert(_sub('sub-1', 'srv-1', 'alerts'));

      await db.subscriptionDao.updatePriorityThreshold('sub-1', 4);

      final result = await db.subscriptionDao.findByTopic('srv-1', 'alerts');
      expect(result!.priorityThreshold, equals(4));
    });
  });
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/database/daos/subscription_dao_test.dart`
Expected: FAIL — `The method 'updatePriorityThreshold' isn't defined for the class 'SubscriptionDao'`

- [ ] **Step 3: Add the DAO method**

In `lib/core/database/daos/subscription_dao.dart`, add this method inside the `SubscriptionDao` class (after `toggleMute`):

```dart
  Future<void> updatePriorityThreshold(String id, int threshold) {
    return (update(
      subscriptions,
    )..where((t) => t.id.equals(id))).write(
      SubscriptionsCompanion(priorityThreshold: Value(threshold)),
    );
  }
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/core/database/daos/subscription_dao_test.dart`
Expected: PASS (all groups, including the new one).

- [ ] **Step 5: Commit**

```bash
git add lib/core/database/daos/subscription_dao.dart \
        test/core/database/daos/subscription_dao_test.dart
git commit -m "feat(subscription): add SubscriptionDao.updatePriorityThreshold"
```

---

### Task 3: `SubscriptionMapper`

**Files:**
- Create: `lib/features/subscription/data/mappers/subscription_mapper.dart`
- Test: `test/features/subscription/data/mappers/subscription_mapper_test.dart`

**Interfaces:**
- Consumes: `Subscription` entity (Task 1), Drift-generated `db.Subscription` row / `db.SubscriptionsCompanion` (from `lib/core/database/app_database.dart`, table already exists from P1).
- Produces: `SubscriptionMapper.toDomain(db.Subscription row) → Subscription`, `SubscriptionMapper.toCompanion(Subscription entity) → db.SubscriptionsCompanion` — consumed by `SubscriptionRepositoryImpl` in Task 4.

- [ ] **Step 1: Write the failing mapper test**

Create `test/features/subscription/data/mappers/subscription_mapper_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/database/app_database.dart' as db;
import 'package:ntfyd/features/subscription/data/mappers/subscription_mapper.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';

void main() {
  final now = DateTime.utc(2026, 1, 1);

  final row = db.Subscription(
    id: 'sub-1',
    serverId: 'srv-1',
    topic: 'alerts',
    displayName: 'Alerts',
    priorityThreshold: 3,
    muted: 1,
    pinned: 0,
    createdAt: now.millisecondsSinceEpoch,
  );

  final entity = Subscription(
    id: 'sub-1',
    serverId: 'srv-1',
    topic: 'alerts',
    displayName: 'Alerts',
    priorityThreshold: 3,
    muted: true,
    pinned: false,
    createdAt: now,
  );

  group('SubscriptionMapper', () {
    test('toDomain maps a Drift row to a domain entity', () {
      expect(SubscriptionMapper.toDomain(row), equals(entity));
    });

    test('toCompanion maps a domain entity to an insert companion', () {
      final companion = SubscriptionMapper.toCompanion(entity);

      expect(companion.id.value, 'sub-1');
      expect(companion.serverId.value, 'srv-1');
      expect(companion.topic.value, 'alerts');
      expect(companion.displayName.value, 'Alerts');
      expect(companion.priorityThreshold.value, 3);
      expect(companion.muted.value, 1);
      expect(companion.pinned.value, 0);
      expect(companion.createdAt.value, now.millisecondsSinceEpoch);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/subscription/data/mappers/subscription_mapper_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:ntfyd/features/subscription/data/mappers/subscription_mapper.dart'`

- [ ] **Step 3: Write the mapper**

Create `lib/features/subscription/data/mappers/subscription_mapper.dart`:

```dart
import 'package:drift/drift.dart' show Value;
import 'package:ntfyd/core/database/app_database.dart' as db;
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';

/// Maps between the Drift-generated [db.Subscription] row and the domain
/// [Subscription] entity.
///
/// [Subscription.muted]/[Subscription.pinned] map to/from `0`/`1`.
/// [Subscription.createdAt] maps to/from epoch milliseconds, treated as UTC
/// (matches [ServerConfigMapper]'s convention).
class SubscriptionMapper {
  static Subscription toDomain(db.Subscription row) {
    return Subscription(
      id: row.id,
      serverId: row.serverId,
      topic: row.topic,
      displayName: row.displayName,
      priorityThreshold: row.priorityThreshold,
      muted: row.muted == 1,
      pinned: row.pinned == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        row.createdAt,
        isUtc: true,
      ),
    );
  }

  static db.SubscriptionsCompanion toCompanion(Subscription entity) {
    return db.SubscriptionsCompanion.insert(
      id: entity.id,
      serverId: entity.serverId,
      topic: entity.topic,
      displayName: entity.displayName,
      priorityThreshold: Value(entity.priorityThreshold),
      muted: Value(entity.muted ? 1 : 0),
      pinned: Value(entity.pinned ? 1 : 0),
      createdAt: entity.createdAt.toUtc().millisecondsSinceEpoch,
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/subscription/data/mappers/subscription_mapper_test.dart`
Expected: PASS (2/2).

- [ ] **Step 5: Commit**

```bash
git add lib/features/subscription/data/mappers/subscription_mapper.dart \
        test/features/subscription/data/mappers/subscription_mapper_test.dart
git commit -m "feat(subscription): add SubscriptionMapper"
```

---

### Task 4: `SubscriptionRepositoryImpl` + DI wiring for `SubscriptionDao`

**Files:**
- Create: `lib/features/subscription/data/repositories/subscription_repository_impl.dart`
- Modify: `lib/core/di/core_module.dart` (add `subscriptionDao` provider)
- Test: `test/features/subscription/data/repositories/subscription_repository_impl_test.dart`

**Interfaces:**
- Consumes: `SubscriptionDao` (Task 2), `SubscriptionMapper` (Task 3), `SubscriptionRepository` contract (Task 1).
- Produces: `SubscriptionRepositoryImpl` implementing all 6 `SubscriptionRepository` methods, registered as `@LazySingleton(as: SubscriptionRepository)` — consumed by every use case from Task 5 onward.

- [ ] **Step 1: Write the failing repository test**

Create `test/features/subscription/data/repositories/subscription_repository_impl_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/database/app_database.dart' as db;
import 'package:ntfyd/core/database/daos/subscription_dao.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/features/subscription/data/repositories/subscription_repository_impl.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';

class MockSubscriptionDao extends Mock implements SubscriptionDao {}

void main() {
  late MockSubscriptionDao dao;
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
    repository = SubscriptionRepositoryImpl(dao);
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
    test('deletes by topic on success', () async {
      when(
        () => dao.deleteByTopic('srv-1', 'alerts'),
      ).thenAnswer((_) async {});

      final result = await repository.unsubscribe('srv-1', 'alerts');

      expect(result.isSuccess, isTrue);
      verify(() => dao.deleteByTopic('srv-1', 'alerts')).called(1);
    });

    test('returns Failure.cache when dao throws', () async {
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
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/subscription/data/repositories/subscription_repository_impl_test.dart`
Expected: FAIL — `Target of URI doesn't exist: '...subscription_repository_impl.dart'`

- [ ] **Step 3: Write the repository implementation**

Create `lib/features/subscription/data/repositories/subscription_repository_impl.dart`:

```dart
import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/database/daos/subscription_dao.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/subscription/data/mappers/subscription_mapper.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';

@LazySingleton(as: SubscriptionRepository)
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  SubscriptionRepositoryImpl(this._dao);

  final SubscriptionDao _dao;

  @override
  Stream<List<Subscription>> watchByServer(String serverId) {
    return _dao
        .watchByServer(serverId)
        .map((rows) => rows.map(SubscriptionMapper.toDomain).toList());
  }

  @override
  Future<Result<Subscription>> subscribe(Subscription sub) async {
    try {
      await _dao.upsert(SubscriptionMapper.toCompanion(sub));
      return Result.success(sub);
    } catch (e) {
      return Result.err(Failure.cache(message: 'Failed to subscribe: $e'));
    }
  }

  @override
  Future<Result<void>> unsubscribe(String serverId, String topic) async {
    try {
      await _dao.deleteByTopic(serverId, topic);
      return const Result.success(null);
    } catch (e) {
      return Result.err(Failure.cache(message: 'Failed to unsubscribe: $e'));
    }
  }

  @override
  Future<Result<void>> togglePin(String id) async {
    try {
      await _dao.togglePin(id);
      return const Result.success(null);
    } catch (e) {
      return Result.err(Failure.cache(message: 'Failed to toggle pin: $e'));
    }
  }

  @override
  Future<Result<void>> toggleMute(String id) async {
    try {
      await _dao.toggleMute(id);
      return const Result.success(null);
    } catch (e) {
      return Result.err(Failure.cache(message: 'Failed to toggle mute: $e'));
    }
  }

  @override
  Future<Result<void>> updatePriorityThreshold(
    String id,
    int threshold,
  ) async {
    try {
      await _dao.updatePriorityThreshold(id, threshold);
      return const Result.success(null);
    } catch (e) {
      return Result.err(
        Failure.cache(message: 'Failed to update priority threshold: $e'),
      );
    }
  }
}
```

- [ ] **Step 4: Register `SubscriptionDao` in `CoreModule`**

`SubscriptionDao` isn't provided to the DI graph yet (only `ServerConfigDao` is). In `lib/core/di/core_module.dart`, add the import and provider:

```dart
import 'package:ntfyd/core/database/daos/subscription_dao.dart';
```

Add this method inside the `CoreModule` class, next to `serverConfigDao`:

```dart
  @lazySingleton
  SubscriptionDao subscriptionDao(AppDatabase db) => db.subscriptionDao;
```

- [ ] **Step 5: Generate code and run tests**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: completes with no errors; `injection_container.config.dart` now includes `SubscriptionDao` and `SubscriptionRepository` registrations.

Run: `flutter test test/features/subscription/data/repositories/subscription_repository_impl_test.dart`
Expected: PASS (10/10).

- [ ] **Step 6: Commit**

```bash
git add lib/features/subscription/data/repositories/subscription_repository_impl.dart \
        lib/core/di/core_module.dart \
        lib/di/injection_container.config.dart \
        test/features/subscription/data/repositories/subscription_repository_impl_test.dart
git commit -m "feat(subscription): add SubscriptionRepositoryImpl and wire SubscriptionDao into DI"
```

---

### Task 5: `SubscribeToTopic` use case + `AccountDataSourceImpl` DI fix

**Files:**
- Create: `lib/features/subscription/domain/usecases/subscribe_to_topic.dart`
- Modify: `lib/features/server_config/data/datasources/account_data_source_impl.dart` (add `@LazySingleton(as: AccountDataSource)`)
- Test: `test/features/subscription/domain/usecases/subscribe_to_topic_test.dart`

**Interfaces:**
- Consumes: `ServerConfigRepository.getById` (existing), `SecureCredentialVault.retrieve` (existing), `AccountDataSource.getAccount` (existing, P2-3), `SubscriptionRepository.subscribe` (Task 4), `Subscription.validate` (Task 1), `ExceptionMapper.map` (existing).
- Produces: `SubscribeToTopicParams(serverId, topic, displayName?)`, `SubscribeToTopic implements UseCase<SubscribeToTopicParams, Subscription>`, `SubscribeToTopicTestHooks` (static `idGenerator`/`now` seams) — consumed by `SubscriptionBloc` in Task 9.

- [ ] **Step 1: Add the DI annotation fix**

`AccountDataSourceImpl` exists (P2-3) but was never registered for injection. In `lib/features/server_config/data/datasources/account_data_source_impl.dart`, add the import and annotation:

```dart
import 'package:injectable/injectable.dart';
```

Change the class declaration from:

```dart
class AccountDataSourceImpl implements AccountDataSource {
```

to:

```dart
@LazySingleton(as: AccountDataSource)
class AccountDataSourceImpl implements AccountDataSource {
```

- [ ] **Step 2: Write the failing use-case test**

Create `test/features/subscription/domain/usecases/subscribe_to_topic_test.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/secure_storage/secure_credential_vault.dart';
import 'package:ntfyd/core/secure_storage/server_credential.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/server_config/data/datasources/account_data_source.dart';
import 'package:ntfyd/features/server_config/data/models/account_dto.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:ntfyd/features/subscription/domain/usecases/subscribe_to_topic.dart';

class MockServerConfigRepository extends Mock
    implements ServerConfigRepository {}

class MockSecureCredentialVault extends Mock implements SecureCredentialVault {}

class MockAccountDataSource extends Mock implements AccountDataSource {}

class MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

void main() {
  late MockServerConfigRepository serverConfigRepository;
  late MockSecureCredentialVault vault;
  late MockAccountDataSource accountDataSource;
  late MockSubscriptionRepository subscriptionRepository;
  late SubscribeToTopic useCase;

  const fixedId = 'sub-11111111-1111-1111-1111-111111111111';
  final fixedNow = DateTime.utc(2026, 6, 8);

  final anonServer = ServerConfig(
    id: 'srv-1',
    baseUrl: 'https://ntfy.sh',
    displayName: 'ntfy.sh',
    authType: AuthType.none,
    isDefault: true,
    createdAt: fixedNow,
  );

  final basicServer = ServerConfig(
    id: 'srv-2',
    baseUrl: 'https://example.com',
    displayName: 'example.com',
    authType: AuthType.basic,
    credentialRef: 'srv-2',
    isDefault: false,
    createdAt: fixedNow,
  );

  setUpAll(() {
    registerFallbackValue(
      Subscription(
        id: fixedId,
        serverId: 'srv-1',
        topic: 'alerts',
        displayName: 'alerts',
        createdAt: fixedNow,
      ),
    );
  });

  setUp(() {
    serverConfigRepository = MockServerConfigRepository();
    vault = MockSecureCredentialVault();
    accountDataSource = MockAccountDataSource();
    subscriptionRepository = MockSubscriptionRepository();

    SubscribeToTopicTestHooks.idGenerator = () => fixedId;
    SubscribeToTopicTestHooks.now = () => fixedNow;

    useCase = SubscribeToTopic(
      serverConfigRepository,
      vault,
      accountDataSource,
      subscriptionRepository,
    );
  });

  tearDown(() {
    SubscribeToTopicTestHooks.idGenerator = null;
    SubscribeToTopicTestHooks.now = null;
  });

  group('SubscribeToTopic', () {
    test(
      'persists subscription when account check succeeds (anonymous server)',
      () async {
        when(
          () => serverConfigRepository.getById('srv-1'),
        ).thenAnswer((_) async => Result.success(anonServer));
        when(
          () => accountDataSource.getAccount(
            'https://ntfy.sh',
            const ServerCredential.noAuth(),
          ),
        ).thenAnswer(
          (_) async => const AccountDto(username: '', role: 'anonymous'),
        );
        when(() => subscriptionRepository.subscribe(any())).thenAnswer(
          (invocation) async =>
              Result.success(invocation.positionalArguments[0] as Subscription),
        );

        final result = await useCase.call(
          const SubscribeToTopicParams(serverId: 'srv-1', topic: 'alerts'),
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrThrow.topic, 'alerts');
        expect(result.valueOrThrow.id, fixedId);
        verifyNever(() => vault.retrieve(any()));
      },
    );

    test('retrieves credential from vault when server has a credentialRef', () async {
      when(
        () => serverConfigRepository.getById('srv-2'),
      ).thenAnswer((_) async => Result.success(basicServer));
      when(() => vault.retrieve('srv-2')).thenAnswer(
        (_) async =>
            const ServerCredential.basicAuth(username: 'u', password: 'p'),
      );
      when(
        () => accountDataSource.getAccount(
          'https://example.com',
          const ServerCredential.basicAuth(username: 'u', password: 'p'),
        ),
      ).thenAnswer((_) async => const AccountDto(username: 'u', role: 'user'));
      when(() => subscriptionRepository.subscribe(any())).thenAnswer(
        (invocation) async =>
            Result.success(invocation.positionalArguments[0] as Subscription),
      );

      final result = await useCase.call(
        const SubscribeToTopicParams(serverId: 'srv-2', topic: 'alerts'),
      );

      expect(result.isSuccess, isTrue);
      verify(() => vault.retrieve('srv-2')).called(1);
    });

    test('returns AuthFailure on 401 without persisting', () async {
      when(
        () => serverConfigRepository.getById('srv-2'),
      ).thenAnswer((_) async => Result.success(basicServer));
      when(() => vault.retrieve('srv-2')).thenAnswer(
        (_) async =>
            const ServerCredential.basicAuth(username: 'u', password: 'wrong'),
      );
      when(() => accountDataSource.getAccount(any(), any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/v1/account'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/v1/account'),
            statusCode: 401,
          ),
        ),
      );

      final result = await useCase.call(
        const SubscribeToTopicParams(serverId: 'srv-2', topic: 'alerts'),
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<AuthFailure>());
      verifyNever(() => subscriptionRepository.subscribe(any()));
    });

    test('returns AuthFailure on 403 without persisting', () async {
      when(
        () => serverConfigRepository.getById('srv-2'),
      ).thenAnswer((_) async => Result.success(basicServer));
      when(() => vault.retrieve('srv-2')).thenAnswer(
        (_) async =>
            const ServerCredential.basicAuth(username: 'u', password: 'p'),
      );
      when(() => accountDataSource.getAccount(any(), any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/v1/account'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/v1/account'),
            statusCode: 403,
          ),
        ),
      );

      final result = await useCase.call(
        const SubscribeToTopicParams(serverId: 'srv-2', topic: 'alerts'),
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<AuthFailure>());
      verifyNever(() => subscriptionRepository.subscribe(any()));
    });

    test('returns NetworkFailure when server unreachable', () async {
      when(
        () => serverConfigRepository.getById('srv-1'),
      ).thenAnswer((_) async => Result.success(anonServer));
      when(() => accountDataSource.getAccount(any(), any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/v1/account'),
          type: DioExceptionType.connectionError,
          error: 'Connection refused',
        ),
      );

      final result = await useCase.call(
        const SubscribeToTopicParams(serverId: 'srv-1', topic: 'alerts'),
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<NetworkFailure>());
    });

    test(
      'returns ValidationFailure for empty topic without persisting',
      () async {
        when(
          () => serverConfigRepository.getById('srv-1'),
        ).thenAnswer((_) async => Result.success(anonServer));
        when(() => accountDataSource.getAccount(any(), any())).thenAnswer(
          (_) async => const AccountDto(username: '', role: 'anonymous'),
        );

        final result = await useCase.call(
          const SubscribeToTopicParams(serverId: 'srv-1', topic: ''),
        );

        expect(result.isSuccess, isFalse);
        expect(result.failureOrThrow, isA<ValidationFailure>());
        verifyNever(() => subscriptionRepository.subscribe(any()));
      },
    );
  });
}
```

- [ ] **Step 3: Run test to verify it fails**

Run: `flutter test test/features/subscription/domain/usecases/subscribe_to_topic_test.dart`
Expected: FAIL — `Target of URI doesn't exist: '...subscribe_to_topic.dart'`

- [ ] **Step 4: Write the use case**

Create `lib/features/subscription/domain/usecases/subscribe_to_topic.dart`:

```dart
import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/error/exception_mapper.dart';
import 'package:ntfyd/core/secure_storage/secure_credential_vault.dart';
import 'package:ntfyd/core/secure_storage/server_credential.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/server_config/data/datasources/account_data_source.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:uuid/uuid.dart';

class SubscribeToTopicParams {
  const SubscribeToTopicParams({
    required this.serverId,
    required this.topic,
    this.displayName,
  });

  final String serverId;
  final String topic;
  final String? displayName;
}

/// Subscribes to a topic on [SubscribeToTopicParams.serverId], validating
/// stored credentials via `GET /v1/account` first (D14: first-subscribe
/// credential check). A 401/403 here surfaces as [AuthFailure] so the
/// presentation layer can route the user to credential edit (R5).
@injectable
class SubscribeToTopic
    implements UseCase<SubscribeToTopicParams, Subscription> {
  SubscribeToTopic(
    this._serverConfigRepository,
    this._vault,
    this._accountDataSource,
    this._subscriptionRepository,
  );

  final ServerConfigRepository _serverConfigRepository;
  final SecureCredentialVault _vault;
  final AccountDataSource _accountDataSource;
  final SubscriptionRepository _subscriptionRepository;

  String Function() get _idGenerator =>
      SubscribeToTopicTestHooks.idGenerator ?? (() => const Uuid().v4());

  DateTime Function() get _now =>
      SubscribeToTopicTestHooks.now ?? DateTime.now;

  @override
  Future<Result<Subscription>> call(SubscribeToTopicParams params) async {
    final serverResult = await _serverConfigRepository.getById(
      params.serverId,
    );
    if (!serverResult.isSuccess) {
      return Result.err(serverResult.failureOrThrow);
    }
    final server = serverResult.valueOrThrow;

    final credentialRef = server.credentialRef;
    final credential = credentialRef == null
        ? const ServerCredential.noAuth()
        : (await _vault.retrieve(credentialRef)) ??
              const ServerCredential.noAuth();

    try {
      await _accountDataSource.getAccount(server.baseUrl, credential);
    } catch (e) {
      return Result.err(ExceptionMapper.map(e));
    }

    final validateResult = Subscription.validate(
      id: _idGenerator(),
      serverId: params.serverId,
      topic: params.topic,
      displayName: params.displayName,
      createdAt: _now(),
    );
    if (!validateResult.isSuccess) {
      return Result.err(validateResult.failureOrThrow);
    }

    return _subscriptionRepository.subscribe(validateResult.valueOrThrow);
  }
}

/// Test-only seams for [SubscribeToTopic]'s ID generation and clock.
///
/// Tests MUST reset both fields to `null` in `tearDown` to avoid leaking
/// state across tests.
class SubscribeToTopicTestHooks {
  static String Function()? idGenerator;
  static DateTime Function()? now;
}
```

- [ ] **Step 5: Generate code and run tests**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: no errors; `injection_container.config.dart` now registers `AccountDataSource` → `AccountDataSourceImpl` and `SubscribeToTopic`.

Run: `flutter test test/features/subscription/domain/usecases/subscribe_to_topic_test.dart`
Expected: PASS (6/6).

Run: `flutter test` (full suite, since the `AccountDataSourceImpl` annotation is a shared-file change)
Expected: all PASS, no regressions in `server_config` tests.

- [ ] **Step 6: Commit**

```bash
git add lib/features/subscription/domain/usecases/subscribe_to_topic.dart \
        lib/features/server_config/data/datasources/account_data_source_impl.dart \
        lib/di/injection_container.config.dart \
        test/features/subscription/domain/usecases/subscribe_to_topic_test.dart
git commit -m "feat(subscription): add SubscribeToTopic use case, register AccountDataSourceImpl in DI"
```

---

### Task 6: `UnsubscribeFromTopic` use case + DI wiring for `MessageDao`

**Files:**
- Create: `lib/features/subscription/domain/usecases/unsubscribe_from_topic.dart`
- Modify: `lib/core/di/core_module.dart` (add `messageDao` provider)
- Test: `test/features/subscription/domain/usecases/unsubscribe_from_topic_test.dart`

**Interfaces:**
- Consumes: `MessageDao.clearByTopic` (existing, P1-8), `SubscriptionRepository.unsubscribe` (Task 4).
- Produces: `UnsubscribeFromTopicParams(serverId, topic)`, `UnsubscribeFromTopic implements UseCase<UnsubscribeFromTopicParams, void>` — consumed by `SubscriptionBloc` in Task 9.

- [ ] **Step 1: Write the failing use-case test**

Create `test/features/subscription/domain/usecases/unsubscribe_from_topic_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/database/daos/message_dao.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:ntfyd/features/subscription/domain/usecases/unsubscribe_from_topic.dart';

class MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

class MockMessageDao extends Mock implements MessageDao {}

void main() {
  late MockSubscriptionRepository repository;
  late MockMessageDao messageDao;
  late UnsubscribeFromTopic useCase;

  setUp(() {
    repository = MockSubscriptionRepository();
    messageDao = MockMessageDao();
    useCase = UnsubscribeFromTopic(repository, messageDao);
  });

  group('UnsubscribeFromTopic', () {
    test('clears messages then unsubscribes', () async {
      when(
        () => messageDao.clearByTopic('srv-1', 'alerts'),
      ).thenAnswer((_) async {});
      when(
        () => repository.unsubscribe('srv-1', 'alerts'),
      ).thenAnswer((_) async => const Result.success(null));

      final result = await useCase.call(
        const UnsubscribeFromTopicParams(serverId: 'srv-1', topic: 'alerts'),
      );

      expect(result.isSuccess, isTrue);
      verifyInOrder([
        () => messageDao.clearByTopic('srv-1', 'alerts'),
        () => repository.unsubscribe('srv-1', 'alerts'),
      ]);
    });

    test('propagates Failure from repository.unsubscribe', () async {
      when(
        () => messageDao.clearByTopic('srv-1', 'alerts'),
      ).thenAnswer((_) async {});
      when(() => repository.unsubscribe('srv-1', 'alerts')).thenAnswer(
        (_) async => const Result.err(Failure.cache(message: 'db error')),
      );

      final result = await useCase.call(
        const UnsubscribeFromTopicParams(serverId: 'srv-1', topic: 'alerts'),
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<CacheFailure>());
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/subscription/domain/usecases/unsubscribe_from_topic_test.dart`
Expected: FAIL — `Target of URI doesn't exist: '...unsubscribe_from_topic.dart'`

- [ ] **Step 3: Write the use case**

Create `lib/features/subscription/domain/usecases/unsubscribe_from_topic.dart`:

```dart
import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/database/daos/message_dao.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';

class UnsubscribeFromTopicParams {
  const UnsubscribeFromTopicParams({
    required this.serverId,
    required this.topic,
  });

  final String serverId;
  final String topic;
}

/// Unsubscribes from a topic: clears any locally cached messages for
/// `(serverId, topic)` first, then removes the subscription row.
@injectable
class UnsubscribeFromTopic
    implements UseCase<UnsubscribeFromTopicParams, void> {
  UnsubscribeFromTopic(this._repository, this._messageDao);

  final SubscriptionRepository _repository;
  final MessageDao _messageDao;

  @override
  Future<Result<void>> call(UnsubscribeFromTopicParams params) async {
    await _messageDao.clearByTopic(params.serverId, params.topic);
    return _repository.unsubscribe(params.serverId, params.topic);
  }
}
```

- [ ] **Step 4: Register `MessageDao` in `CoreModule`**

In `lib/core/di/core_module.dart`, add the import:

```dart
import 'package:ntfyd/core/database/daos/message_dao.dart';
```

Add this method inside the `CoreModule` class:

```dart
  @lazySingleton
  MessageDao messageDao(AppDatabase db) => db.messageDao;
```

- [ ] **Step 5: Generate code and run tests**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: no errors; `injection_container.config.dart` now includes `MessageDao` and `UnsubscribeFromTopic`.

Run: `flutter test test/features/subscription/domain/usecases/unsubscribe_from_topic_test.dart`
Expected: PASS (2/2).

- [ ] **Step 6: Commit**

```bash
git add lib/features/subscription/domain/usecases/unsubscribe_from_topic.dart \
        lib/core/di/core_module.dart \
        lib/di/injection_container.config.dart \
        test/features/subscription/domain/usecases/unsubscribe_from_topic_test.dart
git commit -m "feat(subscription): add UnsubscribeFromTopic use case, wire MessageDao into DI"
```

---

### Task 7: `TogglePin`, `ToggleMute`, `UpdatePriorityThreshold` use cases

**Files:**
- Create: `lib/features/subscription/domain/usecases/toggle_pin.dart`
- Create: `lib/features/subscription/domain/usecases/toggle_mute.dart`
- Create: `lib/features/subscription/domain/usecases/update_priority_threshold.dart`
- Test: `test/features/subscription/domain/usecases/toggle_pin_test.dart`
- Test: `test/features/subscription/domain/usecases/toggle_mute_test.dart`
- Test: `test/features/subscription/domain/usecases/update_priority_threshold_test.dart`

**Interfaces:**
- Consumes: `SubscriptionRepository.togglePin/toggleMute/updatePriorityThreshold` (Task 4).
- Produces: `TogglePin implements UseCase<String, void>`, `ToggleMute implements UseCase<String, void>`, `UpdatePriorityThresholdParams(subscriptionId, threshold)` + `UpdatePriorityThreshold implements UseCase<UpdatePriorityThresholdParams, void>` — all consumed by `SubscriptionBloc` in Task 9.

- [ ] **Step 1: Write the three failing tests**

Create `test/features/subscription/domain/usecases/toggle_pin_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:ntfyd/features/subscription/domain/usecases/toggle_pin.dart';

class MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

void main() {
  late MockSubscriptionRepository repository;
  late TogglePin useCase;

  setUp(() {
    repository = MockSubscriptionRepository();
    useCase = TogglePin(repository);
  });

  group('TogglePin', () {
    test('delegates to repository.togglePin', () async {
      when(
        () => repository.togglePin('sub-1'),
      ).thenAnswer((_) async => const Result.success(null));

      final result = await useCase.call('sub-1');

      expect(result.isSuccess, isTrue);
      verify(() => repository.togglePin('sub-1')).called(1);
    });

    test('propagates Failure from repository', () async {
      when(() => repository.togglePin('sub-1')).thenAnswer(
        (_) async => const Result.err(Failure.cache(message: 'db error')),
      );

      final result = await useCase.call('sub-1');

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<CacheFailure>());
    });
  });
}
```

Create `test/features/subscription/domain/usecases/toggle_mute_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:ntfyd/features/subscription/domain/usecases/toggle_mute.dart';

class MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

void main() {
  late MockSubscriptionRepository repository;
  late ToggleMute useCase;

  setUp(() {
    repository = MockSubscriptionRepository();
    useCase = ToggleMute(repository);
  });

  group('ToggleMute', () {
    test('delegates to repository.toggleMute', () async {
      when(
        () => repository.toggleMute('sub-1'),
      ).thenAnswer((_) async => const Result.success(null));

      final result = await useCase.call('sub-1');

      expect(result.isSuccess, isTrue);
      verify(() => repository.toggleMute('sub-1')).called(1);
    });

    test('propagates Failure from repository', () async {
      when(() => repository.toggleMute('sub-1')).thenAnswer(
        (_) async => const Result.err(Failure.cache(message: 'db error')),
      );

      final result = await useCase.call('sub-1');

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<CacheFailure>());
    });
  });
}
```

Create `test/features/subscription/domain/usecases/update_priority_threshold_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:ntfyd/features/subscription/domain/usecases/update_priority_threshold.dart';

class MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

void main() {
  late MockSubscriptionRepository repository;
  late UpdatePriorityThreshold useCase;

  setUp(() {
    repository = MockSubscriptionRepository();
    useCase = UpdatePriorityThreshold(repository);
  });

  group('UpdatePriorityThreshold', () {
    test('delegates to repository.updatePriorityThreshold', () async {
      when(
        () => repository.updatePriorityThreshold('sub-1', 4),
      ).thenAnswer((_) async => const Result.success(null));

      final result = await useCase.call(
        const UpdatePriorityThresholdParams(
          subscriptionId: 'sub-1',
          threshold: 4,
        ),
      );

      expect(result.isSuccess, isTrue);
      verify(() => repository.updatePriorityThreshold('sub-1', 4)).called(1);
    });

    test('propagates Failure from repository', () async {
      when(() => repository.updatePriorityThreshold('sub-1', 4)).thenAnswer(
        (_) async => const Result.err(Failure.cache(message: 'db error')),
      );

      final result = await useCase.call(
        const UpdatePriorityThresholdParams(
          subscriptionId: 'sub-1',
          threshold: 4,
        ),
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<CacheFailure>());
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/subscription/domain/usecases/toggle_pin_test.dart test/features/subscription/domain/usecases/toggle_mute_test.dart test/features/subscription/domain/usecases/update_priority_threshold_test.dart`
Expected: all 3 FAIL — target files don't exist.

- [ ] **Step 3: Write the three use cases**

Create `lib/features/subscription/domain/usecases/toggle_pin.dart`:

```dart
import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';

@injectable
class TogglePin implements UseCase<String, void> {
  TogglePin(this._repository);

  final SubscriptionRepository _repository;

  @override
  Future<Result<void>> call(String subscriptionId) {
    return _repository.togglePin(subscriptionId);
  }
}
```

Create `lib/features/subscription/domain/usecases/toggle_mute.dart`:

```dart
import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';

@injectable
class ToggleMute implements UseCase<String, void> {
  ToggleMute(this._repository);

  final SubscriptionRepository _repository;

  @override
  Future<Result<void>> call(String subscriptionId) {
    return _repository.toggleMute(subscriptionId);
  }
}
```

Create `lib/features/subscription/domain/usecases/update_priority_threshold.dart`:

```dart
import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';

class UpdatePriorityThresholdParams {
  const UpdatePriorityThresholdParams({
    required this.subscriptionId,
    required this.threshold,
  });

  final String subscriptionId;
  final int threshold;
}

@injectable
class UpdatePriorityThreshold
    implements UseCase<UpdatePriorityThresholdParams, void> {
  UpdatePriorityThreshold(this._repository);

  final SubscriptionRepository _repository;

  @override
  Future<Result<void>> call(UpdatePriorityThresholdParams params) {
    return _repository.updatePriorityThreshold(
      params.subscriptionId,
      params.threshold,
    );
  }
}
```

- [ ] **Step 4: Generate code and run tests**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: no errors.

Run: `flutter test test/features/subscription/domain/usecases/toggle_pin_test.dart test/features/subscription/domain/usecases/toggle_mute_test.dart test/features/subscription/domain/usecases/update_priority_threshold_test.dart`
Expected: PASS (2/2 each, 6 total).

- [ ] **Step 5: Commit**

```bash
git add lib/features/subscription/domain/usecases/toggle_pin.dart \
        lib/features/subscription/domain/usecases/toggle_mute.dart \
        lib/features/subscription/domain/usecases/update_priority_threshold.dart \
        lib/di/injection_container.config.dart \
        test/features/subscription/domain/usecases/toggle_pin_test.dart \
        test/features/subscription/domain/usecases/toggle_mute_test.dart \
        test/features/subscription/domain/usecases/update_priority_threshold_test.dart
git commit -m "feat(subscription): add TogglePin, ToggleMute, UpdatePriorityThreshold use cases"
```

---

### Task 8: `SubscriptionEvent` + `SubscriptionState`

**Files:**
- Create: `lib/features/subscription/presentation/blocs/subscription_event.dart`
- Create: `lib/features/subscription/presentation/blocs/subscription_state.dart`
- Test: `test/features/subscription/presentation/blocs/subscription_state_test.dart`

**Interfaces:**
- Consumes: `Subscription` entity (Task 1), `Failure`/`AuthFailure` (existing).
- Produces: `SubscriptionEvent` sealed union (`load`, `subscribe`, `unsubscribe`, `togglePin`, `toggleMute`, `updateThreshold`); `SubscriptionState` sealed union (`loading`, `loaded(subscriptions)`, `authError(failure)`, `error(failure)`) — consumed by `SubscriptionBloc` in Task 9 and `SubscribeTopicSheet` in Task 11.

- [ ] **Step 1: Write the failing state test**

Create `test/features/subscription/presentation/blocs/subscription_state_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_state.dart';

void main() {
  group('SubscriptionState', () {
    test('loaded states with identical lists are equal (Freezed equality)', () {
      const a = SubscriptionState.loaded(subscriptions: []);
      const b = SubscriptionState.loaded(subscriptions: []);

      expect(a, equals(b));
    });

    test('when() is exhaustive over all 4 variants', () {
      const states = [
        SubscriptionState.loading(),
        SubscriptionState.loaded(subscriptions: []),
        SubscriptionState.authError(failure: Failure.auth(statusCode: 401)),
        SubscriptionState.error(failure: Failure.cache(message: 'x')),
      ];

      for (final state in states) {
        final label = state.when(
          loading: () => 'loading',
          loaded: (_) => 'loaded',
          authError: (_) => 'authError',
          error: (_) => 'error',
        );
        expect(label, isNotEmpty);
      }
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/subscription/presentation/blocs/subscription_state_test.dart`
Expected: FAIL — `Target of URI doesn't exist: '...subscription_state.dart'`

- [ ] **Step 3: Write the event and state files**

Create `lib/features/subscription/presentation/blocs/subscription_event.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_event.freezed.dart';

@freezed
sealed class SubscriptionEvent with _$SubscriptionEvent {
  const factory SubscriptionEvent.load({required String serverId}) =
      SubscriptionLoad;

  const factory SubscriptionEvent.subscribe({
    required String serverId,
    required String topic,
    String? displayName,
  }) = SubscriptionSubscribe;

  const factory SubscriptionEvent.unsubscribe({
    required String serverId,
    required String topic,
  }) = SubscriptionUnsubscribe;

  const factory SubscriptionEvent.togglePin({required String id}) =
      SubscriptionTogglePin;

  const factory SubscriptionEvent.toggleMute({required String id}) =
      SubscriptionToggleMute;

  const factory SubscriptionEvent.updateThreshold({
    required String id,
    required int threshold,
  }) = SubscriptionUpdateThreshold;
}
```

Create `lib/features/subscription/presentation/blocs/subscription_state.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';

part 'subscription_state.freezed.dart';

@freezed
sealed class SubscriptionState with _$SubscriptionState {
  const factory SubscriptionState.loading() = SubscriptionLoading;

  const factory SubscriptionState.loaded({
    required List<Subscription> subscriptions,
  }) = SubscriptionLoaded;

  const factory SubscriptionState.authError({required AuthFailure failure}) =
      SubscriptionAuthError;

  const factory SubscriptionState.error({required Failure failure}) =
      SubscriptionError;
}
```

- [ ] **Step 4: Generate code and run test**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: no errors.

Run: `flutter test test/features/subscription/presentation/blocs/subscription_state_test.dart`
Expected: PASS (2/2).

- [ ] **Step 5: Commit**

```bash
git add lib/features/subscription/presentation/blocs/subscription_event.dart \
        lib/features/subscription/presentation/blocs/subscription_event.freezed.dart \
        lib/features/subscription/presentation/blocs/subscription_state.dart \
        lib/features/subscription/presentation/blocs/subscription_state.freezed.dart \
        test/features/subscription/presentation/blocs/subscription_state_test.dart
git commit -m "feat(subscription): add SubscriptionEvent and SubscriptionState"
```

---

### Task 9: `SubscriptionBloc`

**Files:**
- Create: `lib/features/subscription/presentation/blocs/subscription_bloc.dart`
- Test: `test/features/subscription/presentation/blocs/subscription_bloc_test.dart`

**Interfaces:**
- Consumes: `SubscriptionRepository.watchByServer` (Task 4), `SubscribeToTopic` (Task 5), `UnsubscribeFromTopic` (Task 6), `TogglePin`/`ToggleMute`/`UpdatePriorityThreshold` (Task 7), `SubscriptionEvent`/`SubscriptionState` (Task 8).
- Produces: `SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState>` — consumed by `SubscribeTopicSheet` (Task 11) and `HomePage`'s debug FAB (Task 12).

- [ ] **Step 1: Write the failing bloc test**

Create `test/features/subscription/presentation/blocs/subscription_bloc_test.dart`:

```dart
import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:ntfyd/features/subscription/domain/usecases/subscribe_to_topic.dart';
import 'package:ntfyd/features/subscription/domain/usecases/toggle_mute.dart';
import 'package:ntfyd/features/subscription/domain/usecases/toggle_pin.dart';
import 'package:ntfyd/features/subscription/domain/usecases/unsubscribe_from_topic.dart';
import 'package:ntfyd/features/subscription/domain/usecases/update_priority_threshold.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_bloc.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_event.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_state.dart';

class MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

class MockSubscribeToTopic extends Mock implements SubscribeToTopic {}

class MockUnsubscribeFromTopic extends Mock implements UnsubscribeFromTopic {}

class MockTogglePin extends Mock implements TogglePin {}

class MockToggleMute extends Mock implements ToggleMute {}

class MockUpdatePriorityThreshold extends Mock
    implements UpdatePriorityThreshold {}

void main() {
  late MockSubscriptionRepository repository;
  late MockSubscribeToTopic subscribeToTopic;
  late MockUnsubscribeFromTopic unsubscribeFromTopic;
  late MockTogglePin togglePin;
  late MockToggleMute toggleMute;
  late MockUpdatePriorityThreshold updatePriorityThreshold;

  final now = DateTime.utc(2026, 1, 1);
  final sub1 = Subscription(
    id: 'sub-1',
    serverId: 'srv-1',
    topic: 'alerts',
    displayName: 'alerts',
    createdAt: now,
  );
  final sub2 = Subscription(
    id: 'sub-2',
    serverId: 'srv-1',
    topic: 'minecraft',
    displayName: 'minecraft',
    createdAt: now,
  );

  setUpAll(() {
    registerFallbackValue(
      const SubscribeToTopicParams(serverId: 'srv-1', topic: 'alerts'),
    );
    registerFallbackValue(
      const UnsubscribeFromTopicParams(serverId: 'srv-1', topic: 'alerts'),
    );
    registerFallbackValue(
      const UpdatePriorityThresholdParams(
        subscriptionId: 'sub-1',
        threshold: 3,
      ),
    );
  });

  setUp(() {
    repository = MockSubscriptionRepository();
    subscribeToTopic = MockSubscribeToTopic();
    unsubscribeFromTopic = MockUnsubscribeFromTopic();
    togglePin = MockTogglePin();
    toggleMute = MockToggleMute();
    updatePriorityThreshold = MockUpdatePriorityThreshold();
  });

  SubscriptionBloc buildBloc() => SubscriptionBloc(
    repository,
    subscribeToTopic,
    unsubscribeFromTopic,
    togglePin,
    toggleMute,
    updatePriorityThreshold,
  );

  group('SubscriptionBloc', () {
    blocTest<SubscriptionBloc, SubscriptionState>(
      'Load emits [loading, loaded([sub1, sub2])]',
      build: () {
        when(
          () => repository.watchByServer('srv-1'),
        ).thenAnswer((_) => Stream.value([sub1, sub2]));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const SubscriptionEvent.load(serverId: 'srv-1')),
      expect: () => [
        const SubscriptionState.loading(),
        SubscriptionState.loaded(subscriptions: [sub1, sub2]),
      ],
    );

    blocTest<SubscriptionBloc, SubscriptionState>(
      'a successful Subscribe surfaces the new row via the active '
      'watchByServer stream (Option A: repository stream is single source)',
      build: () {
        final controller = StreamController<List<Subscription>>();
        addTearDown(controller.close);
        when(
          () => repository.watchByServer('srv-1'),
        ).thenAnswer((_) => controller.stream);
        when(
          () => subscribeToTopic.call(any()),
        ).thenAnswer((_) async => Result.success(sub1));
        controller.add(const []);
        controller.add([sub1]);
        return buildBloc();
      },
      act: (bloc) async {
        bloc.add(const SubscriptionEvent.load(serverId: 'srv-1'));
        await Future<void>.delayed(Duration.zero);
        bloc.add(
          const SubscriptionEvent.subscribe(
            serverId: 'srv-1',
            topic: 'alerts',
          ),
        );
      },
      expect: () => [
        const SubscriptionState.loading(),
        const SubscriptionState.loaded(subscriptions: []),
        SubscriptionState.loaded(subscriptions: [sub1]),
      ],
    );

    blocTest<SubscriptionBloc, SubscriptionState>(
      'Subscribe on AuthFailure emits authError',
      build: () {
        when(
          () => subscribeToTopic.call(any()),
        ).thenAnswer(
          (_) async => const Result.err(Failure.auth(statusCode: 401)),
        );
        return buildBloc();
      },
      seed: () => const SubscriptionState.loaded(subscriptions: []),
      act: (bloc) => bloc.add(
        const SubscriptionEvent.subscribe(serverId: 'srv-1', topic: 'alerts'),
      ),
      expect: () => [
        const SubscriptionState.authError(
          failure: Failure.auth(statusCode: 401),
        ),
      ],
    );

    blocTest<SubscriptionBloc, SubscriptionState>(
      'TogglePin failure emits error state',
      build: () {
        when(() => togglePin.call('sub-1')).thenAnswer(
          (_) async => const Result.err(Failure.cache(message: 'db error')),
        );
        return buildBloc();
      },
      seed: () => const SubscriptionState.loaded(subscriptions: []),
      act: (bloc) => bloc.add(const SubscriptionEvent.togglePin(id: 'sub-1')),
      expect: () => [isA<SubscriptionError>()],
    );

    blocTest<SubscriptionBloc, SubscriptionState>(
      'ToggleMute failure emits error state',
      build: () {
        when(() => toggleMute.call('sub-1')).thenAnswer(
          (_) async => const Result.err(Failure.cache(message: 'db error')),
        );
        return buildBloc();
      },
      seed: () => const SubscriptionState.loaded(subscriptions: []),
      act: (bloc) => bloc.add(const SubscriptionEvent.toggleMute(id: 'sub-1')),
      expect: () => [isA<SubscriptionError>()],
    );

    blocTest<SubscriptionBloc, SubscriptionState>(
      'UpdateThreshold failure emits error state',
      build: () {
        when(
          () => updatePriorityThreshold.call(
            const UpdatePriorityThresholdParams(
              subscriptionId: 'sub-1',
              threshold: 4,
            ),
          ),
        ).thenAnswer(
          (_) async => const Result.err(Failure.cache(message: 'db error')),
        );
        return buildBloc();
      },
      seed: () => const SubscriptionState.loaded(subscriptions: []),
      act: (bloc) => bloc.add(
        const SubscriptionEvent.updateThreshold(id: 'sub-1', threshold: 4),
      ),
      expect: () => [isA<SubscriptionError>()],
    );

    blocTest<SubscriptionBloc, SubscriptionState>(
      'Unsubscribe failure emits error state',
      build: () {
        when(
          () => unsubscribeFromTopic.call(
            const UnsubscribeFromTopicParams(
              serverId: 'srv-1',
              topic: 'alerts',
            ),
          ),
        ).thenAnswer(
          (_) async => const Result.err(Failure.cache(message: 'db error')),
        );
        return buildBloc();
      },
      seed: () => const SubscriptionState.loaded(subscriptions: []),
      act: (bloc) => bloc.add(
        const SubscriptionEvent.unsubscribe(serverId: 'srv-1', topic: 'alerts'),
      ),
      expect: () => [isA<SubscriptionError>()],
    );

    test('SubscriptionState.when() is exhaustive (sanity check)', () {
      const state = SubscriptionState.loaded(subscriptions: []);
      expect(
        state.when(
          loading: () => 0,
          loaded: (_) => 1,
          authError: (_) => 2,
          error: (_) => 3,
        ),
        1,
      );
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/subscription/presentation/blocs/subscription_bloc_test.dart`
Expected: FAIL — `Target of URI doesn't exist: '...subscription_bloc.dart'`

- [ ] **Step 3: Write the bloc**

Create `lib/features/subscription/presentation/blocs/subscription_bloc.dart`:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:ntfyd/features/subscription/domain/usecases/subscribe_to_topic.dart';
import 'package:ntfyd/features/subscription/domain/usecases/toggle_mute.dart';
import 'package:ntfyd/features/subscription/domain/usecases/toggle_pin.dart';
import 'package:ntfyd/features/subscription/domain/usecases/unsubscribe_from_topic.dart';
import 'package:ntfyd/features/subscription/domain/usecases/update_priority_threshold.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_event.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_state.dart';

/// Follows the app's "Option A" feed data-flow (Base-Plan D9):
/// [SubscriptionRepository.watchByServer] is the single source of truth for
/// [SubscriptionState.loaded]. Mutating events only ever emit failure states
/// (`error`/`authError`) — a successful mutation surfaces through the
/// already-active `watchByServer` stream reacting to the DB write.
@injectable
class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc(
    this._repository,
    this._subscribeToTopic,
    this._unsubscribeFromTopic,
    this._togglePin,
    this._toggleMute,
    this._updatePriorityThreshold,
  ) : super(const SubscriptionState.loading()) {
    on<SubscriptionLoad>(_onLoad);
    on<SubscriptionSubscribe>(_onSubscribe);
    on<SubscriptionUnsubscribe>(_onUnsubscribe);
    on<SubscriptionTogglePin>(_onTogglePin);
    on<SubscriptionToggleMute>(_onToggleMute);
    on<SubscriptionUpdateThreshold>(_onUpdateThreshold);
  }

  final SubscriptionRepository _repository;
  final SubscribeToTopic _subscribeToTopic;
  final UnsubscribeFromTopic _unsubscribeFromTopic;
  final TogglePin _togglePin;
  final ToggleMute _toggleMute;
  final UpdatePriorityThreshold _updatePriorityThreshold;

  Future<void> _onLoad(
    SubscriptionLoad event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(const SubscriptionState.loading());
    await emit.forEach<List<Subscription>>(
      _repository.watchByServer(event.serverId),
      onData: (subscriptions) =>
          SubscriptionState.loaded(subscriptions: subscriptions),
    );
  }

  Future<void> _onSubscribe(
    SubscriptionSubscribe event,
    Emitter<SubscriptionState> emit,
  ) async {
    final result = await _subscribeToTopic.call(
      SubscribeToTopicParams(
        serverId: event.serverId,
        topic: event.topic,
        displayName: event.displayName,
      ),
    );
    _emitOnFailure(result, emit);
  }

  Future<void> _onUnsubscribe(
    SubscriptionUnsubscribe event,
    Emitter<SubscriptionState> emit,
  ) async {
    final result = await _unsubscribeFromTopic.call(
      UnsubscribeFromTopicParams(serverId: event.serverId, topic: event.topic),
    );
    _emitOnFailure(result, emit);
  }

  Future<void> _onTogglePin(
    SubscriptionTogglePin event,
    Emitter<SubscriptionState> emit,
  ) async {
    _emitOnFailure(await _togglePin.call(event.id), emit);
  }

  Future<void> _onToggleMute(
    SubscriptionToggleMute event,
    Emitter<SubscriptionState> emit,
  ) async {
    _emitOnFailure(await _toggleMute.call(event.id), emit);
  }

  Future<void> _onUpdateThreshold(
    SubscriptionUpdateThreshold event,
    Emitter<SubscriptionState> emit,
  ) async {
    final result = await _updatePriorityThreshold.call(
      UpdatePriorityThresholdParams(
        subscriptionId: event.id,
        threshold: event.threshold,
      ),
    );
    _emitOnFailure(result, emit);
  }

  void _emitOnFailure<T>(Result<T> result, Emitter<SubscriptionState> emit) {
    if (result.isSuccess) return;
    final failure = result.failureOrThrow;
    if (failure is AuthFailure) {
      emit(SubscriptionState.authError(failure: failure));
    } else {
      emit(SubscriptionState.error(failure: failure));
    }
  }
}
```

- [ ] **Step 4: Generate code and run tests**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: no errors; `SubscriptionBloc` now registered in `injection_container.config.dart`.

Run: `flutter test test/features/subscription/presentation/blocs/subscription_bloc_test.dart`
Expected: PASS (8/8).

- [ ] **Step 5: Commit**

```bash
git add lib/features/subscription/presentation/blocs/subscription_bloc.dart \
        lib/di/injection_container.config.dart \
        test/features/subscription/presentation/blocs/subscription_bloc_test.dart
git commit -m "feat(subscription): add SubscriptionBloc"
```

---

### Task 10: `ServerManagerPage` placeholder

**Files:**
- Create: `lib/features/server_config/presentation/pages/server_manager_page.dart`
- Test: `test/features/server_config/presentation/pages/server_manager_page_test.dart`

**Interfaces:**
- Consumes: nothing (stateless placeholder).
- Produces: `ServerManagerPage extends StatelessWidget` — consumed by `SubscribeTopicSheet`'s "Edit Credentials" action in Task 11.

- [ ] **Step 1: Write the failing widget test**

Create `test/features/server_config/presentation/pages/server_manager_page_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/features/server_config/presentation/pages/server_manager_page.dart';

void main() {
  testWidgets('renders app bar title and placeholder body', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ServerManagerPage()));

    expect(find.text('Server Manager'), findsOneWidget);
    expect(find.text('Server Manager — coming soon'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/server_config/presentation/pages/server_manager_page_test.dart`
Expected: FAIL — `Target of URI doesn't exist: '...server_manager_page.dart'`

- [ ] **Step 3: Write the page**

Create `lib/features/server_config/presentation/pages/server_manager_page.dart`:

```dart
import 'package:flutter/material.dart';

/// Temporary placeholder for the full multi-server manager (FR2).
///
/// Reached from [SubscribeTopicSheet]'s "Edit Credentials" action when a
/// first-subscribe credential check fails (D14/R5). Replaced by the full
/// list/add/edit-creds/set-default/remove UI in a later phase.
class ServerManagerPage extends StatelessWidget {
  const ServerManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Server Manager')),
      body: Center(
        child: Text(
          'Server Manager — coming soon',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/server_config/presentation/pages/server_manager_page_test.dart`
Expected: PASS (1/1).

- [ ] **Step 5: Commit**

```bash
git add lib/features/server_config/presentation/pages/server_manager_page.dart \
        test/features/server_config/presentation/pages/server_manager_page_test.dart
git commit -m "feat(server_config): add ServerManagerPage placeholder"
```

---

### Task 11: `SubscribeTopicSheet` widget

**Files:**
- Create: `lib/features/subscription/presentation/pages/subscribe_topic_sheet.dart`
- Test: `test/features/subscription/presentation/pages/subscribe_topic_sheet_test.dart`

**Interfaces:**
- Consumes: `SubscriptionBloc`/`SubscriptionEvent`/`SubscriptionState` (Tasks 8–9), `ServerConfig` entity (existing), `ServerManagerPage` (Task 10).
- Produces: `SubscribeTopicSheet({required List<ServerConfig> servers})` — consumed by `HomePage`'s debug FAB in Task 12.

- [ ] **Step 1: Write the failing widget tests**

Create `test/features/subscription/presentation/pages/subscribe_topic_sheet_test.dart`:

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/presentation/pages/server_manager_page.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_bloc.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_event.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_state.dart';
import 'package:ntfyd/features/subscription/presentation/pages/subscribe_topic_sheet.dart';

class MockSubscriptionBloc
    extends MockBloc<SubscriptionEvent, SubscriptionState>
    implements SubscriptionBloc {}

void main() {
  late MockSubscriptionBloc bloc;

  final servers = [
    ServerConfig(
      id: 'srv-1',
      baseUrl: 'https://ntfy.sh',
      displayName: 'ntfy.sh',
      authType: AuthType.none,
      isDefault: true,
      createdAt: DateTime.utc(2026, 1, 1),
    ),
    ServerConfig(
      id: 'srv-2',
      baseUrl: 'https://home.example.com',
      displayName: 'Homelab',
      authType: AuthType.basic,
      credentialRef: 'srv-2',
      isDefault: false,
      createdAt: DateTime.utc(2026, 1, 1),
    ),
  ];

  setUpAll(() {
    registerFallbackValue(const SubscriptionEvent.load(serverId: 'srv-1'));
  });

  setUp(() {
    bloc = MockSubscriptionBloc();
    whenListen(
      bloc,
      const Stream<SubscriptionState>.empty(),
      initialState: const SubscriptionState.loaded(subscriptions: []),
    );
  });

  Future<void> pumpSheet(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<SubscriptionBloc>.value(
            value: bloc,
            child: SubscribeTopicSheet(servers: servers),
          ),
        ),
      ),
    );
  }

  testWidgets('renders server picker with server names', (tester) async {
    await pumpSheet(tester);

    expect(find.text('ntfy.sh'), findsOneWidget);
    expect(find.byType(DropdownButtonFormField<ServerConfig>), findsOneWidget);
  });

  testWidgets('tapping Subscribe dispatches Subscribe event', (tester) async {
    await pumpSheet(tester);

    await tester.enterText(find.byType(TextField).at(0), 'alerts');
    await tester.tap(find.widgetWithText(FilledButton, 'Subscribe'));
    await tester.pump();

    verify(
      () => bloc.add(
        const SubscriptionEvent.subscribe(serverId: 'srv-1', topic: 'alerts'),
      ),
    ).called(1);
  });

  testWidgets('authError state shows Edit Credentials button', (
    tester,
  ) async {
    whenListen(
      bloc,
      const Stream<SubscriptionState>.empty(),
      initialState: const SubscriptionState.authError(
        failure: Failure.auth(statusCode: 401),
      ),
    );

    await pumpSheet(tester);

    expect(find.text('Invalid credentials'), findsOneWidget);
    expect(
      find.widgetWithText(OutlinedButton, 'Edit Credentials'),
      findsOneWidget,
    );

    await tester.tap(find.widgetWithText(OutlinedButton, 'Edit Credentials'));
    await tester.pumpAndSettle();

    expect(find.byType(ServerManagerPage), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/subscription/presentation/pages/subscribe_topic_sheet_test.dart`
Expected: FAIL — `Target of URI doesn't exist: '...subscribe_topic_sheet.dart'`

- [ ] **Step 3: Write the sheet widget**

Create `lib/features/subscription/presentation/pages/subscribe_topic_sheet.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/presentation/pages/server_manager_page.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_bloc.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_event.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_state.dart';

/// Bottom sheet for subscribing to a topic on a chosen server.
///
/// [servers] populates the server picker; callers load it up-front (e.g.
/// via `ServerConfigRepository.getAll()`) — the sheet has no server-list
/// state of its own.
class SubscribeTopicSheet extends StatefulWidget {
  const SubscribeTopicSheet({super.key, required this.servers});

  final List<ServerConfig> servers;

  @override
  State<SubscribeTopicSheet> createState() => _SubscribeTopicSheetState();
}

class _SubscribeTopicSheetState extends State<SubscribeTopicSheet> {
  final _topicController = TextEditingController();
  final _displayNameController = TextEditingController();
  ServerConfig? _selectedServer;

  @override
  void initState() {
    super.initState();
    if (widget.servers.isNotEmpty) {
      _selectedServer = widget.servers.first;
    }
  }

  @override
  void dispose() {
    _topicController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  void _onSubscribePressed() {
    final server = _selectedServer;
    final topic = _topicController.text.trim();
    if (server == null || topic.isEmpty) return;

    final displayName = _displayNameController.text.trim();

    context.read<SubscriptionBloc>().add(
      SubscriptionEvent.subscribe(
        serverId: server.id,
        topic: topic,
        displayName: displayName.isEmpty ? null : displayName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<SubscriptionBloc, SubscriptionState>(
      listener: (context, state) {
        if (state is SubscriptionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_messageFor(state.failure))),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Subscribe to Topic', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            DropdownButtonFormField<ServerConfig>(
              initialValue: _selectedServer,
              decoration: const InputDecoration(labelText: 'Server'),
              items: widget.servers
                  .map(
                    (server) => DropdownMenuItem(
                      value: server,
                      child: Text(server.displayName),
                    ),
                  )
                  .toList(),
              onChanged: (server) => setState(() => _selectedServer = server),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _topicController,
              decoration: const InputDecoration(labelText: 'Topic'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _displayNameController,
              decoration: const InputDecoration(
                labelText: 'Display name (optional)',
              ),
            ),
            const SizedBox(height: 16),
            BlocBuilder<SubscriptionBloc, SubscriptionState>(
              builder: (context, state) {
                if (state is! SubscriptionAuthError) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Invalid credentials',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const ServerManagerPage(),
                            ),
                          );
                        },
                        child: const Text('Edit Credentials'),
                      ),
                    ],
                  ),
                );
              },
            ),
            FilledButton(
              onPressed: _onSubscribePressed,
              child: const Text('Subscribe'),
            ),
          ],
        ),
      ),
    );
  }

  String _messageFor(Failure failure) => switch (failure) {
    NetworkFailure() => 'Network error — check your connection.',
    _ => 'Something went wrong.',
  };
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/subscription/presentation/pages/subscribe_topic_sheet_test.dart`
Expected: PASS (3/3).

- [ ] **Step 5: Commit**

```bash
git add lib/features/subscription/presentation/pages/subscribe_topic_sheet.dart \
        test/features/subscription/presentation/pages/subscribe_topic_sheet_test.dart
git commit -m "feat(subscription): add SubscribeTopicSheet"
```

---

### Task 12: Debug FAB on `HomePage` + final DI/verification pass

**Files:**
- Modify: `lib/features/home/presentation/pages/home_page.dart`

**Interfaces:**
- Consumes: `getIt<ServerConfigRepository>()` (existing), `getIt<SubscriptionBloc>()` (Task 9), `SubscribeTopicSheet` (Task 11).
- Produces: nothing new for later tasks — this is the final integration point for P3.

This debug-only affordance follows the same manual-verification convention as `HomePage`'s existing P2 debug health check (which also has no dedicated widget test) — it exists solely so you can manually confirm the sheet works end-to-end; it is not the real Home UI (that's P4-9/P8).

- [ ] **Step 1: Add the debug FAB**

In `lib/features/home/presentation/pages/home_page.dart`, add these imports:

```dart
import 'package:ntfyd/di/injection_container.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_bloc.dart';
import 'package:ntfyd/features/subscription/presentation/pages/subscribe_topic_sheet.dart';
```

(`injection_container.dart` and `flutter/foundation.dart` for `kDebugMode` are already imported.)

Add a `floatingActionButton` to the `Scaffold` returned by `build`, alongside the existing `appBar`/`body`:

```dart
      floatingActionButton: kDebugMode
          ? FloatingActionButton(
              tooltip: 'Subscribe to topic (debug)',
              onPressed: () async {
                final serversResult = await getIt<ServerConfigRepository>()
                    .getAll();
                if (!serversResult.isSuccess || !context.mounted) return;

                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => BlocProvider<SubscriptionBloc>(
                    create: (_) => getIt<SubscriptionBloc>(),
                    child: SubscribeTopicSheet(
                      servers: serversResult.valueOrThrow,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
```

- [ ] **Step 2: Regenerate DI config and run the full test suite**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: no errors.

Run: `flutter test`
Expected: all tests PASS (P2 + all new P3 tests), 0 failures.

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 3: Manually verify the debug flow**

Run: `flutter run` (or use your emulator/device of choice), log in via `LoginPage` to reach `HomePage`, tap the debug FAB, confirm `SubscribeTopicSheet` opens with the server picker populated, enter a topic and tap Subscribe, confirm no crash and (if the server rejects credentials) the "Edit Credentials" affordance appears and navigates to `ServerManagerPage`.

- [ ] **Step 4: Commit**

```bash
git add lib/features/home/presentation/pages/home_page.dart
git commit -m "feat(subscription): add debug-only Subscribe FAB on HomePage"
```

---

## Post-implementation

All P3 exit criteria from the design doc should now hold:
- Subscriptions persisted in Drift via `SubscriptionDao` ✓
- Pin/mute toggles work and persist ✓
- 401 on first subscribe routes user to credential edit (via `SubscribeTopicSheet` → `ServerManagerPage`) ✓
- All subscription use-case and Bloc tests pass ✓
- `flutter analyze` clean ✓

Next step after this branch is reviewed/merged: proceed to P4 (Feed) per Base-Plan §5.
