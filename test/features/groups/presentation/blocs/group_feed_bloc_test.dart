import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';
import 'package:ntfyd/features/feed/domain/usecases/toggle_message_pin.dart';
import 'package:ntfyd/features/feed/domain/usecases/toggle_message_read.dart';
import 'package:ntfyd/features/groups/domain/repositories/group_repository.dart';
import 'package:ntfyd/features/groups/presentation/blocs/group_feed_bloc.dart';
import 'package:ntfyd/features/groups/presentation/blocs/group_feed_event.dart';
import 'package:ntfyd/features/groups/presentation/blocs/group_feed_state.dart';

class MockGroupRepository extends Mock implements GroupRepository {}

class MockToggleMessageRead extends Mock implements ToggleMessageRead {}

class MockToggleMessagePin extends Mock implements ToggleMessagePin {}

void main() {
  late MockGroupRepository groupRepository;
  late MockToggleMessageRead toggleMessageRead;
  late MockToggleMessagePin toggleMessagePin;

  final now = DateTime.utc(2026, 1, 1);
  final message = NotificationMessage(
    id: 'msg-1',
    serverId: 'srv-1',
    topic: 'alerts',
    time: now,
    event: 'message',
    receivedAt: now,
  );

  setUp(() {
    groupRepository = MockGroupRepository();
    toggleMessageRead = MockToggleMessageRead();
    toggleMessagePin = MockToggleMessagePin();
  });

  GroupFeedBloc buildBloc() =>
      GroupFeedBloc(groupRepository, toggleMessageRead, toggleMessagePin);

  blocTest<GroupFeedBloc, GroupFeedState>(
    'load(groupId: null) emits loaded with the merged All feed',
    build: buildBloc,
    setUp: () {
      when(() => groupRepository.watchFeed(null)).thenAnswer(
        (_) => Stream.value([message]),
      );
    },
    act: (bloc) => bloc.add(const GroupFeedEvent.load()),
    expect: () => [
      GroupFeedState.loaded(messages: [message]),
    ],
  );

  blocTest<GroupFeedBloc, GroupFeedState>(
    'load(groupId: "grp-1") emits loaded with that group\'s feed',
    build: buildBloc,
    setUp: () {
      when(() => groupRepository.watchFeed('grp-1')).thenAnswer(
        (_) => Stream.value([message]),
      );
    },
    act: (bloc) => bloc.add(const GroupFeedEvent.load(groupId: 'grp-1')),
    expect: () => [
      GroupFeedState.loaded(messages: [message]),
    ],
  );

  blocTest<GroupFeedBloc, GroupFeedState>(
    'toggleRead delegates to ToggleMessageRead',
    build: buildBloc,
    setUp: () {
      when(() => groupRepository.watchFeed(null)).thenAnswer((_) => const Stream.empty());
      when(
        () => toggleMessageRead.call(
          const ToggleMessageReadParams(serverId: 'srv-1', id: 'msg-1'),
        ),
      ).thenAnswer((_) async => const Result.success(null));
    },
    act: (bloc) => bloc.add(
      const GroupFeedEvent.toggleRead(serverId: 'srv-1', id: 'msg-1'),
    ),
    verify: (_) {
      verify(
        () => toggleMessageRead.call(
          const ToggleMessageReadParams(serverId: 'srv-1', id: 'msg-1'),
        ),
      ).called(1);
    },
  );

  blocTest<GroupFeedBloc, GroupFeedState>(
    'togglePin delegates to ToggleMessagePin',
    build: buildBloc,
    setUp: () {
      when(() => groupRepository.watchFeed(null)).thenAnswer((_) => const Stream.empty());
      when(
        () => toggleMessagePin.call(
          const ToggleMessagePinParams(serverId: 'srv-1', id: 'msg-1'),
        ),
      ).thenAnswer((_) async => const Result.success(null));
    },
    act: (bloc) => bloc.add(
      const GroupFeedEvent.togglePin(serverId: 'srv-1', id: 'msg-1'),
    ),
    verify: (_) {
      verify(
        () => toggleMessagePin.call(
          const ToggleMessagePinParams(serverId: 'srv-1', id: 'msg-1'),
        ),
      ).called(1);
    },
  );
}
