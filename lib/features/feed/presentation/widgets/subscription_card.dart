import 'package:flutter/material.dart';
import 'package:ntfyd/di/injection_container.dart';
import 'package:ntfyd/features/feed/presentation/cubits/home_topic_summary.dart';
import 'package:ntfyd/features/subscription/domain/usecases/toggle_mute.dart';
import 'package:ntfyd/features/subscription/domain/usecases/toggle_pin.dart';
import 'package:ntfyd/features/subscription/domain/usecases/unsubscribe_from_topic.dart';
import 'package:ntfyd/shared/theme/design_tokens.dart';

/// Home's per-subscription card (D15/§8.2): display name, derived unread
/// count, latest-message preview, priority accent bar, pin, and a `⋮` menu
/// (pin/mute/unsubscribe). Mutations go straight through the existing P3
/// use cases via `getIt` — Home doesn't need a `SubscriptionBloc` instance
/// of its own because `HomeFeedCubit`'s underlying
/// `SubscriptionRepository.watchByServer` stream already reacts to the
/// resulting DB write (Option A, D9).
class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({
    super.key,
    required this.summary,
    required this.onTap,
    required this.onManageTags,
  });

  final HomeTopicSummary summary;
  final VoidCallback onTap;
  final ValueChanged<HomeTopicSummary> onManageTags;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subscription = summary.subscription;
    final latest = summary.latestMessage;
    final accentColor = PriorityColors.forPriority(latest?.priority ?? 3);
    final preview = latest?.title ?? latest?.body ?? '';

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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                subscription.displayName,
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: Spacing.xs),
                              Text(
                                summary.unreadCount > 0
                                    ? '${summary.unreadCount} unread'
                                    : 'No unread messages',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              if (preview.isNotEmpty) ...[
                                const SizedBox(height: Spacing.xs),
                                Text(
                                  preview,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                        Icon(
                          Icons.push_pin,
                          color: subscription.pinned
                              ? theme.colorScheme.error
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) => _onMenuSelected(value),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'pin',
                              child: Text(
                                subscription.pinned ? 'Unpin' : 'Pin',
                              ),
                            ),
                            PopupMenuItem(
                              value: 'mute',
                              child: Text(
                                subscription.muted ? 'Unmute' : 'Mute',
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'add_to_tag',
                              child: Text('Add to tag'),
                            ),
                            const PopupMenuItem(
                              value: 'unsubscribe',
                              child: Text('Unsubscribe'),
                            ),
                          ],
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

  void _onMenuSelected(String value) {
    final subscription = summary.subscription;
    switch (value) {
      case 'pin':
        getIt<TogglePin>().call(subscription.id);
      case 'mute':
        getIt<ToggleMute>().call(subscription.id);
      case 'add_to_tag':
        onManageTags(summary);
      case 'unsubscribe':
        getIt<UnsubscribeFromTopic>().call(
          UnsubscribeFromTopicParams(
            serverId: subscription.serverId,
            topic: subscription.topic,
          ),
        );
    }
  }
}
