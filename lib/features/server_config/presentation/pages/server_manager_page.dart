// lib/features/server_config/presentation/pages/server_manager_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntfyd/di/injection_container.dart';
import 'package:ntfyd/features/server_config/domain/entities/auth_type.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_add_edit_cubit.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_manager_cubit.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_manager_state.dart';
import 'package:ntfyd/features/server_config/presentation/failure_message.dart';
import 'package:ntfyd/features/server_config/presentation/pages/add_server_page.dart';

/// Lists configured servers and lets the user add, remove, set a
/// default, or edit an existing server's credentials.
class ServerManagerPage extends StatelessWidget {
  const ServerManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ServerManagerCubit>(
      create: (_) => getIt<ServerManagerCubit>()..load(),
      child: const _ServerManagerView(),
    );
  }
}

class _ServerManagerView extends StatelessWidget {
  const _ServerManagerView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Server Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openAddServer(context),
          ),
        ],
      ),
      body: BlocBuilder<ServerManagerCubit, ServerManagerState>(
        builder: (context, state) {
          return switch (state) {
            ServerManagerLoading() =>
              const Center(child: CircularProgressIndicator()),
            ServerManagerError(:final failure) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(friendlyFailureMessage(failure)),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () =>
                          context.read<ServerManagerCubit>().load(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ServerManagerLoaded(:final servers) => servers.isEmpty
                ? const Center(child: Text('No servers configured'))
                : ListView.builder(
                    itemCount: servers.length,
                    itemBuilder: (context, index) =>
                        _ServerTile(server: servers[index]),
                  ),
          };
        },
      ),
    );
  }

  Future<void> _openAddServer(BuildContext context) async {
    final cubit = context.read<ServerManagerCubit>();
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider<ServerAddEditCubit>(
          create: (_) => getIt<ServerAddEditCubit>(),
          child: const AddServerPage(),
        ),
      ),
    );
    cubit.load();
  }
}

enum _ServerAction { setDefault, editCredentials, remove }

class _ServerTile extends StatelessWidget {
  const _ServerTile({required this.server});

  final ServerConfig server;

  String get _credentialLabel => switch (server.authType) {
        AuthType.none => 'No auth',
        AuthType.basic => 'Basic auth',
        AuthType.bearer => 'Bearer token',
      };

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Flexible(child: Text(server.displayName)),
          if (server.isDefault) ...[
            const SizedBox(width: 8),
            const Chip(
              label: Text('Default'),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ],
      ),
      subtitle: Text('${server.baseUrl}\n$_credentialLabel'),
      isThreeLine: true,
      trailing: PopupMenuButton<_ServerAction>(
        onSelected: (action) => _onAction(context, action),
        itemBuilder: (context) => [
          if (!server.isDefault)
            const PopupMenuItem(
              value: _ServerAction.setDefault,
              child: Text('Set as default'),
            ),
          if (server.credentialRef != null)
            const PopupMenuItem(
              value: _ServerAction.editCredentials,
              child: Text('Edit credentials'),
            ),
          const PopupMenuItem(
            value: _ServerAction.remove,
            child: Text('Remove'),
          ),
        ],
      ),
    );
  }

  Future<void> _onAction(BuildContext context, _ServerAction action) async {
    final cubit = context.read<ServerManagerCubit>();
    switch (action) {
      case _ServerAction.setDefault:
        cubit.setDefault(server.id);
      case _ServerAction.editCredentials:
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => BlocProvider<ServerAddEditCubit>(
              create: (_) => getIt<ServerAddEditCubit>(),
              child: AddServerPage(existing: server),
            ),
          ),
        );
        cubit.load();
      case _ServerAction.remove:
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text('Remove ${server.displayName}?'),
            content: const Text('This deletes its stored credentials.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Remove'),
              ),
            ],
          ),
        );
        if (confirmed ?? false) {
          cubit.remove(server.id);
        }
    }
  }
}
