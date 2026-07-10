import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntfyd/features/feed/domain/entities/feed_connection_state.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_bloc.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_event.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_state.dart';
import 'package:ntfyd/features/feed/presentation/pages/message_detail_page.dart';
import 'package:ntfyd/features/feed/presentation/widgets/message_card.dart';
import 'package:ntfyd/features/publish/presentation/widgets/composer_bar.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';

/// Live feed for a single topic (§8.3): connection indicator ("Live ●" /
/// "Connecting…" / "Reconnecting…" / "Offline"), minimal `MessageCard`
/// list (D18), pull-to-refresh, and tap-through to `MessageDetailPage`.
/// Expects a `FeedBloc` already provided above it in the tree (the caller
/// wires `FeedEvent.load`; this page only reacts to state).
class TopicDetailPage extends StatelessWidget {
  const TopicDetailPage({super.key, required this.subscription});

  final Subscription subscription;

  void _openMessageDetail(BuildContext context, NotificationMessage message) {
    final feedBloc = context.read<FeedBloc>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider<FeedBloc>.value(
          value: feedBloc,
          child: MessageDetailPage(message: message),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(subscription.displayName)),
      bottomNavigationBar: ComposerBar(
        serverId: subscription.serverId,
        topic: subscription.topic,
      ),
      body: BlocConsumer<FeedBloc, FeedState>(
        listenWhen: (previous, current) => previous is FeedLoaded && current is FeedError,
        listener: (context, state) {
          if (state is FeedError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Refresh failed. Showing cached messages.'),
              ),
            );
          }
        },
        builder: (context, state) {
          return switch (state) {
            FeedLoading() => const Center(child: CircularProgressIndicator()),
            FeedError(:final failure) => Center(
              child: Text('Something went wrong: $failure'),
            ),
            FeedLoaded(:final messages, :final connectionState) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _ConnectionIndicator(state: connectionState),
                  ),
                ),
                Expanded(
                  child: messages.isEmpty
                      ? Center(
                          child: Text(
                            'No messages yet',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            context.read<FeedBloc>().add(
                              const FeedEvent.refresh(),
                            );
                          },
                          child: ListView.builder(
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              return MessageCard(
                                message: message,
                                onTap: () =>
                                    _openMessageDetail(context, message),
                                onTogglePin: () => context.read<FeedBloc>().add(
                                  FeedEvent.togglePin(id: message.id),
                                ),
                                onToggleRead: () => context
                                    .read<FeedBloc>()
                                    .add(FeedEvent.toggleRead(id: message.id)),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          };
        },
      ),
    );
  }
}

class _ConnectionIndicator extends StatelessWidget {
  const _ConnectionIndicator({required this.state});

  final FeedConnectionState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (label, color) = switch (state) {
      FeedConnectionState.live => ('Live', theme.colorScheme.primary),
      FeedConnectionState.connecting => (
        'Connecting…',
        theme.colorScheme.onSurfaceVariant,
      ),
      FeedConnectionState.reconnecting => (
        'Reconnecting…',
        theme.colorScheme.error,
      ),
      FeedConnectionState.offline => (
        'Offline',
        theme.colorScheme.onSurfaceVariant,
      ),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(color: color),
        ),
        const SizedBox(width: 6),
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ],
    );
  }
}
