import 'package:flutter/material.dart';

/// Temporary placeholder for the full multi-server manager (FR2).
///
/// Reached from [SubscribeTopicSheet]'s "Edit Credentials" action when a
/// first-subscribe credential check fails (D14/R5). Replaced by the full
/// list/add/edit-creds/set-default/remove UI in a later phase.
class ServerManagerPage extends StatelessWidget {
  const ServerManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Server Manager')),
      body: Center(
        child: Text(
          'Server Manager — coming soon',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
