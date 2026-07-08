import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntfyd/features/feed/presentation/cubits/group_selector_cubit.dart';
import 'package:ntfyd/features/feed/presentation/cubits/group_selector_state.dart';
import 'package:ntfyd/features/groups/domain/entities/group.dart';
import 'package:ntfyd/features/groups/presentation/pages/group_form_page.dart';

/// Home's group ("Tag") selector (Base-Plan D15): "All" (first, built-in,
/// non-deletable) plus every user-created group, ordered by `sortOrder`
/// then name (no reorder UI yet, so every group defaults to `sortOrder: 0`
/// — effectively alphabetical). Reads the `GroupSelectorCubit` already
/// provided above it (same instance `HomePage` uses, passed via
/// `BlocProvider.value` into the modal route).
class GroupSelectorSheet extends StatelessWidget {
  const GroupSelectorSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<GroupSelectorCubit, GroupSelectorState>(
      builder: (context, state) {
        final sortedGroups = [...state.groups]..sort((a, b) {
          final byOrder = a.sortOrder.compareTo(b.sortOrder);
          return byOrder != 0 ? byOrder : a.name.compareTo(b.name);
        });

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: state.selectedGroupId == null
                    ? Icon(Icons.check, color: theme.colorScheme.primary)
                    : const SizedBox(width: 24),
                title: const Text('All'),
                onTap: () {
                  context.read<GroupSelectorCubit>().select(null);
                  Navigator.of(context).pop();
                },
              ),
              for (final group in sortedGroups)
                ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check,
                        color: group.id == state.selectedGroupId
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                      ),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: group.color != null
                              ? Color(group.color!)
                              : theme.colorScheme.onSurfaceVariant,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  title: Text(group.name),
                  onTap: () {
                    context.read<GroupSelectorCubit>().select(group.id);
                    Navigator.of(context).pop();
                  },
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) => _onMenuSelected(context, value, group),
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('New Tag'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const GroupFormPage()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onMenuSelected(BuildContext context, String value, Group group) {
    final cubit = context.read<GroupSelectorCubit>();
    if (value == 'edit') {
      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => GroupFormPage(group: group)),
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete tag?'),
        content: Text('This removes "${group.name}" but keeps its subscriptions.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              cubit.deleteGroup(group.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
