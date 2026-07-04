# P3 — Subscriptions Feature: Design

Status: Approved (pending spec self-review)
Branch: `feature/subscriptions`
Source specs: `Plan/P4.md` (mislabeled — content is P3), `Plan/Base Plan/Base-Plan.md` §5 (P3), §8.5 (OI3), `Plan/api_spec.md` §1, §5.1

## 1. Scope

Subscribe/unsubscribe to ntfy topics, per-topic mute (priority threshold) and pin,
and the first-subscribe credential validation flow (D14/R5): the first time a user
subscribes to a topic on a given server, the app validates stored credentials via
`GET /v1/account`; a 401/403 routes the user to a credential-edit affordance instead
of silently failing.

Out of scope for this phase (explicitly deferred to later phases per Base-Plan WBS):
- The real Group-centric Home screen (FAB, topic cards, unread counts) — P4-9/P8.
- Group ("Tags") membership on subscribe — P8.
- Wiring `SubscribeTopicSheet` into permanent navigation — deferred; only a
  debug-only trigger is added this phase (see §5).

## 2. Domain Layer

`lib/features/subscription/domain/entities/subscription.dart` (`@freezed`):

```
Subscription {
  id: String,
  serverId: String,
  topic: String,
  displayName: String,
  priorityThreshold: int (default 1),
  muted: bool (default false),
  pinned: bool (default false),
  createdAt: DateTime,
}
```

`static Result<Subscription> validate(...)` (mirrors `ServerConfig.validate`):
- `topic` non-empty → else `Failure.validation(field: 'topic', ...)`
- `priorityThreshold` in `[1..5]` → else `Failure.validation(field: 'priorityThreshold', ...)`
- `(serverId, topic)` uniqueness is enforced at the DB layer (existing `uniqueKeys`
  constraint on the `Subscriptions` Drift table); use-case/repository surfaces DB
  constraint violations as a `Failure` rather than re-validating in-memory.

`lib/features/subscription/domain/repositories/subscription_repository.dart`:

```dart
abstract class SubscriptionRepository {
  Stream<List<Subscription>> watchByServer(String serverId);
  Future<Result<Subscription>> subscribe(Subscription sub);
  Future<Result<void>> unsubscribe(String serverId, String topic);
  Future<Result<void>> togglePin(String id);
  Future<Result<void>> toggleMute(String id);
  Future<Result<void>> updatePriorityThreshold(String id, int threshold);
}
```

Use cases (`@injectable`, one class per file, `UseCase<Params, Return>` base,
pattern matching `AddServer`/`ValidateServerHealth`):

- **`SubscribeToTopic(serverId, topic, displayName?)`**
  1. `ServerConfigRepository.getById(serverId)` → fails fast on not-found.
  2. `SecureCredentialVault.retrieve(credentialRef)` (or `ServerCredential.noAuth()`
     if `credentialRef` is null) to get the credential to validate.
  3. `AccountDataSource.getAccount(baseUrl, credential)` in try/catch →
     `ExceptionMapper.map(e)` on failure (same shape as `ValidateServerHealth`).
     A mapped `AuthFailure` (401/403) is returned as-is so callers/Bloc can
     distinguish it from other failures.
  4. On success: `Subscription.validate(...)` then `SubscriptionRepository.subscribe`.
- **`UnsubscribeFromTopic(serverId, topic)`**: `MessageDao.clearByTopic` then
  `repository.unsubscribe`.
- **`TogglePin(subscriptionId)`**, **`ToggleMute(subscriptionId)`**,
  **`UpdatePriorityThreshold(subscriptionId, threshold)`**: thin delegations to
  the repository.

## 3. Data Layer

- `SubscriptionRepositoryImpl` (`@LazySingleton(as: SubscriptionRepository)`):
  delegates to `SubscriptionDao` (already implemented, P1-8), wraps unexpected
  errors as `Failure.cache` (matching `ServerConfigRepositoryImpl`'s style).
  `subscribe()` calls `AccountDataSource` is NOT here — that lives in the
  `SubscribeToTopic` use case per the layering rule (repository has no HTTP
  concerns beyond persistence); the repository's `subscribe()` only upserts.
- `SubscriptionMapper`: static `toDomain(SubscriptionRow)` /
  `toCompanion(Subscription)`, matching `ServerConfigMapper`.
- **Existing-code fix**: `AccountDataSourceImpl` (P2-3) exists but is not
  currently `@injectable` despite the spec's assumption that it is. Add
  `@LazySingleton(as: AccountDataSource)` to it as part of this phase's DI
  wiring — additive only, no behavior change.

## 4. Presentation Layer

`SubscriptionState` (`@freezed` sealed union,
`lib/features/subscription/presentation/blocs/subscription_state.dart`):

```
loading()
loaded(subscriptions: List<Subscription>)
authError(failure: AuthFailure)
error(failure: Failure)
```

`SubscriptionBloc` (`@injectable`), events: `Load(serverId)`, `Subscribe(serverId,
topic, displayName?)`, `Unsubscribe(serverId, topic)`, `TogglePin(id)`,
`ToggleMute(id)`, `UpdateThreshold(id, threshold)`.
- `Load` subscribes to `watchByServer` and re-emits `loaded` on every DB change.
- `Subscribe` on `AuthFailure` emits `authError` (not `error`) so the sheet can
  show the re-auth affordance distinctly.

`SubscribeTopicSheet` (`lib/features/subscription/presentation/pages/subscribe_topic_sheet.dart`):
- Server picker (`DropdownButton`, populated from `ServerConfigRepository.getAll()`).
- Topic text field (required), optional display-name text field, Subscribe button.
- `BlocListener<SubscriptionBloc, SubscriptionState>`: on `authError` → "Invalid
  credentials" message + "Edit Credentials" button that pushes `ServerManagerPage`.

`ServerManagerPage` placeholder
(`lib/features/server_config/presentation/pages/server_manager_page.dart`):
minimal `Scaffold` (app bar "Server Manager" + placeholder body), same spirit as
the existing P2 `HomePage` placeholder. Replaced by the full multi-server manager
in a later phase (Base-Plan FR2).

**Debug entry point**: `HomePage` gets a `kDebugMode`-only `FloatingActionButton`
that opens `SubscribeTopicSheet` via `showModalBottomSheet`, wrapped in
`BlocProvider<SubscriptionBloc>(create: (_) => getIt<SubscriptionBloc>())` — same
DI-lookup pattern `HomePage` already uses for `ValidateServerHealth`. This is the
only wiring added this phase; the real Home FAB/navigation is P4-9/P8.

## 5. DI

`subscription_module.dart` stays an empty `@module` (injectable annotations on
concrete classes handle registration, matching `server_config`'s pattern). New
registrations (repository, 5 use cases, bloc, `AccountDataSourceImpl` fix) flow
into `injection_container.config.dart` via `build_runner build`.

## 6. Testing (strict TDD — tests written before implementation)

Before starting: run `flutter test` to confirm the P2 baseline is green.

- **Domain** (`subscription_test.dart`): empty topic → `ValidationFailure`;
  `priorityThreshold` outside `[1..5]` → `ValidationFailure`; `pinned` defaults to
  `false`; Freezed equality; `copyWith` produces new instance.
- **Use cases** (mocktail): `SubscribeToTopic` persists on 200, returns
  `AuthFailure` on 401/403, returns `NetworkFailure` when unreachable;
  `UnsubscribeFromTopic` calls `MessageDao.clearByTopic` + `repository.unsubscribe`;
  `TogglePin`/`ToggleMute` delegate correctly.
- **Repository** (mocktail): `subscribe()` upserts via DAO; `unsubscribe()`
  deletes row + clears messages.
- **Bloc** (`bloc_test`): `Load` → `[loading, loaded([...])]`; `Subscribe` success
  → `loaded` with new subscription; `Subscribe` on `AuthFailure` → `authError`;
  `TogglePin` → updates `pinned` in state; exhaustive `when()` over all 4 variants.
- **Widget** (`flutter_test`): sheet renders server picker with names; Subscribe
  tap dispatches `Subscribe`; `authError` state shows "Edit Credentials" button.

## 7. File Structure

```
lib/features/subscription/
├── domain/
│   ├── entities/subscription.dart
│   ├── entities/subscription.freezed.dart  (generated)
│   └── repositories/subscription_repository.dart
├── data/
│   ├── mappers/subscription_mapper.dart
│   └── repositories/subscription_repository_impl.dart
├── presentation/
│   ├── blocs/subscription_bloc.dart
│   ├── blocs/subscription_event.dart
│   ├── blocs/subscription_state.dart
│   ├── blocs/subscription_state.freezed.dart  (generated)
│   └── pages/subscribe_topic_sheet.dart
└── di/subscription_module.dart  (unchanged, empty @module)

lib/features/server_config/presentation/pages/server_manager_page.dart  (new placeholder)
lib/features/home/presentation/pages/home_page.dart  (debug FAB added)
lib/features/server_config/data/datasources/account_data_source_impl.dart  (add @LazySingleton)

test/features/subscription/
├── domain/entities/subscription_test.dart
├── domain/usecases/subscribe_to_topic_test.dart
├── domain/usecases/unsubscribe_from_topic_test.dart
├── domain/usecases/toggle_pin_test.dart
├── domain/usecases/toggle_mute_test.dart
├── domain/usecases/update_priority_threshold_test.dart
├── data/repositories/subscription_repository_impl_test.dart
└── presentation/blocs/subscription_bloc_test.dart
test/features/subscription/presentation/pages/subscribe_topic_sheet_test.dart
```

## 8. Deliverables

1. `Subscription` domain entity + `SubscriptionRepository` contract
2. 5 use cases (Subscribe, Unsubscribe, TogglePin, ToggleMute, UpdatePriorityThreshold)
3. `SubscriptionRepositoryImpl` + `SubscriptionMapper`
4. `SubscriptionBloc` + `SubscriptionState` (`@freezed`)
5. `SubscribeTopicSheet` bottom sheet
6. `ServerManagerPage` placeholder + debug FAB on `HomePage`
7. `AccountDataSourceImpl` DI annotation fix
8. All tests green, `flutter analyze` clean, `build_runner` clean
9. Granular conventional commits per task on `feature/subscriptions` branch
