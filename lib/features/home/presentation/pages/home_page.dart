import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/di/injection_container.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';
import 'package:ntfyd/features/server_config/domain/usecases/validate_server_health.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_form_cubit.dart';
import 'package:ntfyd/features/server_config/presentation/pages/login_page.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_bloc.dart';
import 'package:ntfyd/features/subscription/presentation/pages/subscribe_topic_sheet.dart';

/// Temporary placeholder for the post-login Home screen.
///
/// Replaced by the full Group-centric HomePage in P4-9. Theme-aware only —
/// no hardcoded colors — so it renders correctly under both
/// [AppTheme.defaultDark] and Material You (dynamic/seed) themes.
class HomePage extends StatefulWidget {
  const HomePage({super.key, this.baseUrl});

  /// The server the user just logged into (normalized base URL),
  /// passed from [LoginPage] on success. Used by the debug connection
  /// check below.
  final String? baseUrl;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<String> _statusFuture;

  @override
  void initState() {
    super.initState();
    _statusFuture = _checkConnection();
  }

  /// DEBUG ONLY: runs GET /v1/health against
  /// [widget.baseUrl] (the server just logged into) to confirm the
  /// just-completed login is reachable.
  Future<String> _checkConnection() async {
    final baseUrl = widget.baseUrl;
    if (baseUrl == null) {
      return 'No server passed to HomePage (debug)';
    }

    final validateHealth = getIt<ValidateServerHealth>();
    final healthResult = await validateHealth.call(baseUrl);

    if (!healthResult.isSuccess) {
      return '$baseUrl -> unreachable: ${healthResult.failureOrThrow}';
    }

    return '$baseUrl -> healthy';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ntfyd'),
        leading: kDebugMode
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to Login (debug)',
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => BlocProvider<ServerFormCubit>(
                  create: (_) => getIt<ServerFormCubit>(),
                  child: const LoginPage(),
                ),
              ),
            );
          },
        )
            : null,
          actions: kDebugMode
              ? [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Re-check connection (debug)',
              onPressed: () {
                final future = _checkConnection();
                setState(() {
                  _statusFuture = future;
                });
              },
            ),
          ]
              : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ntfyd',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            if (kDebugMode)
              FutureBuilder<String>(
                future: _statusFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Row(
                      children: [
                        SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Checking…',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    );
                  }

                  final status = snapshot.data!;
                  final isHealthy = status.endsWith('healthy');

                  return Row(
                    children: [
                      Text(
                        isHealthy ? 'Connected' : 'Disconnected',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isHealthy
                              ? theme.colorScheme.primary
                              : theme.colorScheme.error,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: isHealthy
                              ? theme.colorScheme.primary
                              : theme.colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          status,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                },
              ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'Home Page',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: kDebugMode
          ? FloatingActionButton(
              tooltip: 'Subscribe to topic (debug)',
              onPressed: () async {
                final serversResult = await getIt<ServerConfigRepository>()
                    .getAll();
                if (!serversResult.isSuccess || !context.mounted) return;

                unawaited(
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => BlocProvider<SubscriptionBloc>(
                      create: (_) => getIt<SubscriptionBloc>(),
                      child: SubscribeTopicSheet(
                        servers: serversResult.valueOrThrow,
                      ),
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}