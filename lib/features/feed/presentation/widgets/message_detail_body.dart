import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ntfyd/core/utils/date_utils.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';
import 'package:ntfyd/features/feed/domain/entities/ntfy_action.dart';
import 'package:ntfyd/shared/theme/design_tokens.dart';

/// The rich-fields body shared by `MessageDetailPage` (Topic Detail) and
/// `GroupMessageDetailPage` (merged Group feed, Base-Plan P8): priority
/// chip, absolute + relative time, Markdown body, tag chips, attachment
/// row, and (disabled, per Base-Plan §8.5 OI1) action buttons. Pure
/// presentation — pin/read toggles live in the AppBar of whichever page
/// composes this widget.
class MessageDetailBody extends StatelessWidget {
  const MessageDetailBody({super.key, required this.message});

  final NotificationMessage message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
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
            children: message.tags.map((tag) => Chip(label: Text(tag))).toList(),
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
    );
  }

  String _actionLabel(NtfyAction action) => action.when(
    view: (label, url, clear) => label,
    http: (label, url, method, headers, body, clear) => label,
    broadcast: (label, intent, extras, clear) => label,
    copy: (label, value, clear) => label,
  );
}
