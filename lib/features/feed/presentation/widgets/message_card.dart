import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ntfyd/core/utils/date_utils.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';
import 'package:ntfyd/shared/theme/design_tokens.dart';

/// Minimal feed card (D18): title, Markdown-rendered body, relative time,
/// priority accent bar, per-message pin, and a read/unread toggle. Rich
/// fields (tags, attachment, actions) render on tap-through in
/// `MessageDetailPage`, not here.
class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.message,
    required this.onTap,
    required this.onTogglePin,
    required this.onToggleRead,
  });

  final NotificationMessage message;
  final VoidCallback onTap;
  final VoidCallback onTogglePin;
  final VoidCallback onToggleRead;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = PriorityColors.forPriority(message.priority);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.xs,
      ),
      child: Material(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: AppDimensions.priorityBarWidth,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(AppDimensions.cardBorderRadius),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(Spacing.md),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (message.title != null)
                                Text(
                                  message.title!,
                                  style: theme.textTheme.titleMedium,
                                ),
                              if (message.body != null) ...[
                                const SizedBox(height: Spacing.xs),
                                MarkdownBody(data: message.body!),
                              ],
                              const SizedBox(height: Spacing.xs),
                              Text(
                                relativeTime(message.time),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Tooltip(
                          message: message.pinned ? 'Unpin' : 'Pin',
                          child: GestureDetector(
                            onTap: onTogglePin,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Icon(
                                Icons.push_pin,
                                color: message.pinned
                                    ? theme.colorScheme.error
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                        Tooltip(
                          message: message.read ? 'Mark unread' : 'Mark read',
                          child: GestureDetector(
                            onTap: onToggleRead,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Icon(
                                Icons.check,
                                color: message.read
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
