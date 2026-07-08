import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';
import 'package:ntfyd/features/feed/presentation/widgets/message_card.dart';
import 'package:ntfyd/features/groups/presentation/blocs/group_feed_bloc.dart';
import 'package:ntfyd/features/groups/presentation/blocs/group_feed_event.dart';
import 'package:ntfyd/features/groups/presentation/blocs/group_feed_state.dart';
import 'package:ntfyd/features/groups/presentation/pages/group_message_detail_page.dart';

/// Merged feed across a group's topics (or "All", `groupId == null`,
/// Base-Plan FR9). Expects a `GroupFeedBloc` already provided above it in
/// the tree, with `GroupFeedEvent.load` already dispatched by the caller
/// (mirrors `TopicDetailPage`'s contract with `FeedBloc`).
class GroupFeedPage extends StatelessWidget {
  const GroupFeedPage({super.key, required this.groupId, required this.title});

  final String? groupId;
  final String title;

  void _openMessageDetail(BuildContext context, NotificationMessage message) {
    final bloc = context.read<GroupFeedBloc>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider<GroupFeedBloc>.value(
          value: bloc,
          child: GroupMessageDetailPage(message: message),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: BlocBuilder<GroupFeedBloc, GroupFeedState>(
        builder: (context, state) {
          return switch (state) {
            GroupFeedLoading() => const Center(child: CircularProgressIndicator()),
            GroupFeedError(:final failure) => Center(
              child: Text('Something went wrong: $failure'),
            ),
            GroupFeedLoaded(:final messages) => messages.isEmpty
                ? Center(
                    child: Text(
                      'No messages yet',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return MessageCard(
                        message: message,
                        sourceLabel: message.topic,
                        onTap: () => _openMessageDetail(context, message),
                        onTogglePin: () => context.read<GroupFeedBloc>().add(
                          GroupFeedEvent.togglePin(
                            serverId: message.serverId,
                            id: message.id,
                          ),
                        ),
                        onToggleRead: () => context.read<GroupFeedBloc>().add(
                          GroupFeedEvent.toggleRead(
                            serverId: message.serverId,
                            id: message.id,
                          ),
                        ),
                      );
                    },
                  ),
          };
        },
      ),
    );
  }
}
