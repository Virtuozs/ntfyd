import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';
import 'package:ntfyd/features/feed/presentation/widgets/message_detail_body.dart';
import 'package:ntfyd/features/groups/presentation/blocs/group_feed_bloc.dart';
import 'package:ntfyd/features/groups/presentation/blocs/group_feed_event.dart';
import 'package:ntfyd/features/groups/presentation/blocs/group_feed_state.dart';

/// Tap-through detail for a message inside a merged Group feed. Same shape
/// as `MessageDetailPage` but wired to `GroupFeedBloc` instead of
/// `FeedBloc` — both compose the shared `MessageDetailBody`.
class GroupMessageDetailPage extends StatelessWidget {
  const GroupMessageDetailPage({super.key, required this.message});

  final NotificationMessage message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<GroupFeedBloc, GroupFeedState>(
      builder: (context, state) {
        final resolvedMessage = state is GroupFeedLoaded
            ? state.messages.firstWhere(
                (m) => m.id == message.id,
                orElse: () => message,
              )
            : message;

        return Scaffold(
          appBar: AppBar(
            title: Text(resolvedMessage.title ?? resolvedMessage.topic),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.push_pin,
                  color: resolvedMessage.pinned ? theme.colorScheme.error : null,
                ),
                tooltip: resolvedMessage.pinned ? 'Unpin' : 'Pin',
                onPressed: () => context.read<GroupFeedBloc>().add(
                  GroupFeedEvent.togglePin(
                    serverId: resolvedMessage.serverId,
                    id: resolvedMessage.id,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.check,
                  color: resolvedMessage.read ? theme.colorScheme.primary : null,
                ),
                tooltip: resolvedMessage.read ? 'Mark unread' : 'Mark read',
                onPressed: () => context.read<GroupFeedBloc>().add(
                  GroupFeedEvent.toggleRead(
                    serverId: resolvedMessage.serverId,
                    id: resolvedMessage.id,
                  ),
                ),
              ),
            ],
          ),
          body: MessageDetailBody(message: resolvedMessage),
        );
      },
    );
  }
}
