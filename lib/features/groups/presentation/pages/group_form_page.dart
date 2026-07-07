import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntfyd/core/database/value_objects/message_filter.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/di/injection_container.dart';
import 'package:ntfyd/features/groups/domain/entities/group.dart';
import 'package:ntfyd/features/groups/domain/entities/group_membership.dart';
import 'package:ntfyd/features/groups/presentation/cubits/group_form_cubit.dart';
import 'package:ntfyd/features/groups/presentation/cubits/group_form_state.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:ntfyd/shared/theme/design_tokens.dart';

const _presetColors = <int>[
  0xFFE53935, // red
  0xFFFB8C00, // orange
  0xFFFDD835, // yellow
  0xFF43A047, // green
  0xFF1E88E5, // blue
  0xFF8E24AA, // purple
  0xFF6D4C41, // brown
  0xFF757575, // grey
];

const _priorityLabels = <int, String>{
  1: 'Min',
  2: 'Low',
  3: 'Default',
  4: 'High',
  5: 'Max',
};

/// Create/Edit Tag (Base-Plan OI3): name, a small preset color-swatch
/// picker, a cross-server topic picker, and an optional priority filter.
/// `group == null` is create mode; otherwise edit mode, pre-filled.
class GroupFormPage extends StatefulWidget {
  const GroupFormPage({super.key, this.group});

  final Group? group;

  @override
  State<GroupFormPage> createState() => _GroupFormPageState();
}

class _GroupFormPageState extends State<GroupFormPage> {
  late final GroupFormCubit _cubit;
  late final TextEditingController _nameController;
  int? _selectedColor;
  Set<GroupMembership> _selectedMembers = {};
  Set<int> _selectedPriorities = {};

  List<ServerConfig> _servers = const [];
  List<Subscription> _subscriptions = const [];
  bool _loadingPickerData = true;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<GroupFormCubit>();
    _nameController = TextEditingController(text: widget.group?.name ?? '');
    _selectedColor = widget.group?.color;
    _selectedMembers = {...?widget.group?.members};
    _selectedPriorities = {...?widget.group?.filter?.priorities};
    unawaited(_loadPickerData());
  }

  Future<void> _loadPickerData() async {
    final serversResult = await getIt<ServerConfigRepository>().getAll();
    final subscriptions = await getIt<SubscriptionRepository>().watchAll().first;
    if (!mounted) return;
    setState(() {
      _servers = serversResult.isSuccess ? serversResult.valueOrThrow : const [];
      _subscriptions = subscriptions;
      _loadingPickerData = false;
    });
  }

  @override
  void dispose() {
    _cubit.close();
    _nameController.dispose();
    super.dispose();
  }

  String _serverName(String serverId) => _servers
      .cast<ServerConfig?>()
      .firstWhere((s) => s!.id == serverId, orElse: () => null)
      ?.displayName ??
      serverId;

  void _onSave() {
    _cubit.submit(
      id: widget.group?.id,
      name: _nameController.text,
      color: _selectedColor,
      members: _selectedMembers,
      filter: _selectedPriorities.isEmpty
          ? null
          : MessageFilter(priorities: _selectedPriorities),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.group != null;

    return BlocProvider<GroupFormCubit>.value(
      value: _cubit,
      child: BlocListener<GroupFormCubit, GroupFormState>(
        listener: (context, state) {
          if (state is GroupFormSuccess) {
            Navigator.of(context).maybePop();
          }
          if (state is GroupFormError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Failed to save tag.')));
          }
        },
        child: Scaffold(
          appBar: AppBar(title: Text(isEditing ? 'Edit Tag' : 'New Tag')),
          body: _loadingPickerData
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(Spacing.md),
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    const SizedBox(height: Spacing.md),
                    Text('Color', style: theme.textTheme.titleSmall),
                    const SizedBox(height: Spacing.sm),
                    Wrap(
                      spacing: Spacing.sm,
                      children: _presetColors
                          .map(
                            (color) => GestureDetector(
                              onTap: () => setState(
                                () => _selectedColor =
                                    _selectedColor == color ? null : color,
                              ),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Color(color),
                                  shape: BoxShape.circle,
                                  border: _selectedColor == color
                                      ? Border.all(
                                          color: theme.colorScheme.onSurface,
                                          width: 2,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: Spacing.md),
                    Text('Topics', style: theme.textTheme.titleSmall),
                    for (final sub in _subscriptions)
                      CheckboxListTile(
                        value: _selectedMembers.contains(
                          GroupMembership(serverId: sub.serverId, topic: sub.topic),
                        ),
                        title: Text(sub.topic),
                        subtitle: Text(_serverName(sub.serverId)),
                        onChanged: (checked) => setState(() {
                          final membership = GroupMembership(
                            serverId: sub.serverId,
                            topic: sub.topic,
                          );
                          if (checked ?? false) {
                            _selectedMembers = {..._selectedMembers, membership};
                          } else {
                            _selectedMembers = _selectedMembers
                                .where((m) => m != membership)
                                .toSet();
                          }
                        }),
                      ),
                    const SizedBox(height: Spacing.md),
                    Text('Priority filter (optional)', style: theme.textTheme.titleSmall),
                    const SizedBox(height: Spacing.sm),
                    Wrap(
                      spacing: Spacing.xs,
                      children: _priorityLabels.entries
                          .map(
                            (entry) => FilterChip(
                              label: Text(entry.value),
                              selected: _selectedPriorities.contains(entry.key),
                              onSelected: (selected) => setState(() {
                                _selectedPriorities = selected
                                    ? {..._selectedPriorities, entry.key}
                                    : _selectedPriorities
                                        .where((p) => p != entry.key)
                                        .toSet();
                              }),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: Spacing.lg),
                    FilledButton(onPressed: _onSave, child: const Text('Save')),
                  ],
                ),
        ),
      ),
    );
  }
}
