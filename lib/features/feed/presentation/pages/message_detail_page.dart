import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ntfyd/core/utils/date_utils.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';
import 'package:ntfyd/features/feed/domain/entities/ntfy_action.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_bloc.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_event.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(message.title ?? message.topic),
        actions: [
          IconButton(
            icon: Icon(
              Icons.push_pin,
              color: message.pinned ? theme.colorScheme.error : null,
            ),
            tooltip: message.pinned ? 'Unpin' : 'Pin',
            onPressed: () =>
                context.read<FeedBloc>().add(FeedEvent.togglePin(id: message.id)),
          ),
          IconButton(
            icon: Icon(
              Icons.check,
              color: message.read ? theme.colorScheme.primary : null,
            ),
            tooltip: message.read ? 'Mark unread' : 'Mark read',
            onPressed: () => context.read<FeedBloc>().add(
              FeedEvent.toggleRead(id: message.id),
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
                label: Text('Priority ${message.priority}'),
                backgroundColor: PriorityColors.forPriority(
                  message.priority,
                ).withValues(alpha: 0.2),
              ),
              const SizedBox(width: Spacing.sm),
              Text(
                '${message.time} (${relativeTime(message.time)})',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          if (message.body != null) MarkdownBody(data: message.body!),
          if (message.tags.isNotEmpty) ...[
            const SizedBox(height: Spacing.md),
            Wrap(
              spacing: Spacing.xs,
              children: message.tags
                  .map((tag) => Chip(label: Text(tag)))
                  .toList(),
            ),
          ],
          if (message.attachment != null) ...[
            const SizedBox(height: Spacing.md),
            Row(
              children: [
                const Icon(Icons.attach_file),
                const SizedBox(width: Spacing.xs),
                Text(message.attachment!.name),
              ],
            ),
          ],
          if (message.actions.isNotEmpty) ...[
            const SizedBox(height: Spacing.md),
            Wrap(
              spacing: Spacing.xs,
              children: message.actions
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
  }

  String _actionLabel(NtfyAction action) => action.when(
    view: (label, url, clear) => label,
    http: (label, url, method, headers, body, clear) => label,
    broadcast: (label, intent, extras, clear) => label,
    copy: (label, value, clear) => label,
  );
}
