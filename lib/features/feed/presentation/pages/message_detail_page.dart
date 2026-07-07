import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_bloc.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_event.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_state.dart';
import 'package:ntfyd/features/feed/presentation/widgets/message_detail_body.dart';

/// Message Detail (OI1, proposed layout): AppBar (title, pin/read toggle
/// actions) plus the shared [MessageDetailBody]. Expects a `FeedBloc`
/// already provided above it in the tree (`TopicDetailPage`'s
/// `BlocProvider.value`).
class MessageDetailPage extends StatelessWidget {
  const MessageDetailPage({super.key, required this.message});

  final NotificationMessage message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        // Resolve the live version of this message from the bloc's current
        // FeedLoaded state (so pin/read toggles reflect immediately on this
        // page), falling back to the originally-passed snapshot if the
        // state isn't loaded yet or the message was removed from the list.
        final resolvedMessage = state is FeedLoaded
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
                onPressed: () => context.read<FeedBloc>().add(
                  FeedEvent.togglePin(id: resolvedMessage.id),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.check,
                  color: resolvedMessage.read ? theme.colorScheme.primary : null,
                ),
                tooltip: resolvedMessage.read ? 'Mark unread' : 'Mark read',
                onPressed: () => context.read<FeedBloc>().add(
                  FeedEvent.toggleRead(id: resolvedMessage.id),
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
