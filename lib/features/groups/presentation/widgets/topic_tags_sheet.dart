import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntfyd/features/feed/presentation/cubits/group_selector_cubit.dart';
import 'package:ntfyd/features/feed/presentation/cubits/group_selector_state.dart';
import 'package:ntfyd/features/groups/domain/entities/group_membership.dart';
import 'package:ntfyd/features/groups/presentation/pages/group_form_page.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';
import 'package:ntfyd/shared/theme/design_tokens.dart';

/// Bottom sheet letting a subscribed topic be added to / removed from any
/// number of existing tags, without leaving Home. Multi-select — stays open
/// across taps, unlike [GroupSelectorSheet]'s single-choice "pop on tap".
class TopicTagsSheet extends StatelessWidget {
  const TopicTagsSheet({super.key, required this.subscription});

  final Subscription subscription;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final membership = GroupMembership(
      serverId: subscription.serverId,
      topic: subscription.topic,
    );

    return BlocBuilder<GroupSelectorCubit, GroupSelectorState>(
      builder: (context, state) {
        final sortedGroups = [...state.groups]
          ..sort((a, b) {
            final byOrder = a.sortOrder.compareTo(b.sortOrder);
            return byOrder != 0 ? byOrder : a.name.compareTo(b.name);
          });

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.md,
                  Spacing.md,
                  Spacing.md,
                  Spacing.sm,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Add "${subscription.topic}" to a tag',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ),
              for (final group in sortedGroups)
                CheckboxListTile(
                  value: group.members.contains(membership),
                  secondary: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: group.color != null
                          ? Color(group.color!)
                          : theme.colorScheme.onSurfaceVariant,
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Text(group.name),
                  onChanged: (_) => context
                      .read<GroupSelectorCubit>()
                      .toggleMembership(group, membership),
                ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('New Tag'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const GroupFormPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
