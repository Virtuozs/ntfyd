import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ntfyd/core/utils/date_utils.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';
import 'package:ntfyd/features/feed/domain/entities/ntfy_action.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_bloc.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_event.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_state.dart';
import 'package:ntfyd/shared/theme/design_tokens.dart';

/// Message Detail (OI1, proposed layout): full rich fields for a single
/// message — title, Markdown body, absolute + relative time, priority
/// chip, tags as chips, pin/read toggle. Attachment renders as a plain
/// filename label (no thumbnail/download) and actions render as disabled
/// labels — both explicitly deferred (not yet designed against real
/// frames; see Base-Plan §8.5 OI1). Expects a `FeedBloc` already provided
/// above it in the tree (`TopicDetailPage`'s `BlocProvider.value`).
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
          body: ListView(
            padding: const EdgeInsets.all(Spacing.md),
            children: [
              Row(
                children: [
                  Chip(
                    label: Text('Priority ${resolvedMessage.priority}'),
                    backgroundColor: PriorityColors.forPriority(
                      resolvedMessage.priority,
                    ).withValues(alpha: 0.2),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Text(
                    '${resolvedMessage.time} '
                    '(${relativeTime(resolvedMessage.time)})',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.md),
              if (resolvedMessage.body != null)
                MarkdownBody(data: resolvedMessage.body!),
              if (resolvedMessage.tags.isNotEmpty) ...[
                const SizedBox(height: Spacing.md),
                Wrap(
                  spacing: Spacing.xs,
                  children: resolvedMessage.tags
                      .map((tag) => Chip(label: Text(tag)))
                      .toList(),
                ),
              ],
              if (resolvedMessage.attachment != null) ...[
                const SizedBox(height: Spacing.md),
                Row(
                  children: [
                    const Icon(Icons.attach_file),
                    const SizedBox(width: Spacing.xs),
                    Text(resolvedMessage.attachment!.name),
                  ],
                ),
              ],
              if (resolvedMessage.actions.isNotEmpty) ...[
                const SizedBox(height: Spacing.md),
                Wrap(
                  spacing: Spacing.xs,
                  children: resolvedMessage.actions
                      .map(
                        (action) => OutlinedButton(
                          onPressed: null,
                          child: Text(_actionLabel(action)),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  String _actionLabel(NtfyAction action) => action.when(
    view: (label, url, clear) => label,
    http: (label, url, method, headers, body, clear) => label,
    broadcast: (label, intent, extras, clear) => label,
    copy: (label, value, clear) => label,
  );
}
