import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/presentation/pages/server_manager_page.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_bloc.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_event.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_state.dart';

/// Bottom sheet for subscribing to a topic on a chosen server.
///
/// [servers] populates the server picker; callers load it up-front (e.g.
/// via `ServerConfigRepository.getAll()`) — the sheet has no server-list
/// state of its own.
class SubscribeTopicSheet extends StatefulWidget {
  const SubscribeTopicSheet({super.key, required this.servers});

  final List<ServerConfig> servers;

  @override
  State<SubscribeTopicSheet> createState() => _SubscribeTopicSheetState();
}

class _SubscribeTopicSheetState extends State<SubscribeTopicSheet> {
  final _topicController = TextEditingController();
  final _displayNameController = TextEditingController();
  ServerConfig? _selectedServer;

  @override
  void initState() {
    super.initState();
    if (widget.servers.isNotEmpty) {
      _selectedServer = widget.servers.first;
    }
  }

  @override
  void dispose() {
    _topicController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  void _onSubscribePressed() {
    final server = _selectedServer;
    final topic = _topicController.text.trim();
    if (server == null || topic.isEmpty) return;

    final displayName = _displayNameController.text.trim();

    context.read<SubscriptionBloc>().add(
      SubscriptionEvent.subscribe(
        serverId: server.id,
        topic: topic,
        displayName: displayName.isEmpty ? null : displayName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<SubscriptionBloc, SubscriptionState>(
      listener: (context, state) {
        if (state is SubscriptionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_messageFor(state.failure))),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Subscribe to Topic', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            DropdownButtonFormField<ServerConfig>(
              initialValue: _selectedServer,
              decoration: const InputDecoration(labelText: 'Server'),
              items: widget.servers
                  .map(
                    (server) => DropdownMenuItem(
                      value: server,
                      child: Text(server.displayName),
                    ),
                  )
                  .toList(),
              onChanged: (server) => setState(() => _selectedServer = server),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _topicController,
              decoration: const InputDecoration(labelText: 'Topic'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _displayNameController,
              decoration: const InputDecoration(
                labelText: 'Display name (optional)',
              ),
            ),
            const SizedBox(height: 16),
            BlocBuilder<SubscriptionBloc, SubscriptionState>(
              builder: (context, state) {
                if (state is! SubscriptionAuthError) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Invalid credentials',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const ServerManagerPage(),
                            ),
                          );
                        },
                        child: const Text('Edit Credentials'),
                      ),
                    ],
                  ),
                );
              },
            ),
            FilledButton(
              onPressed: _onSubscribePressed,
              child: const Text('Subscribe'),
            ),
          ],
        ),
      ),
    );
  }

  String _messageFor(Failure failure) => switch (failure) {
    NetworkFailure() => 'Network error — check your connection.',
    _ => 'Something went wrong.',
  };
}
