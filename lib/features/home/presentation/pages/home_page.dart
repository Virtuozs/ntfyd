import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/di/injection_container.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';
import 'package:ntfyd/features/server_config/domain/usecases/validate_server_health.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_form_cubit.dart';
import 'package:ntfyd/features/server_config/presentation/pages/login_page.dart';

/// Temporary placeholder for the post-login Home screen.
///
/// Replaced by the full Group-centric HomePage in P4-9. Theme-aware only —
/// no hardcoded colors — so it renders correctly under both
/// [AppTheme.defaultDark] and Material You (dynamic/seed) themes.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

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

  /// DEBUG ONLY (P2-4 milestone): fetches the persisted default server
  /// and runs GET /v1/health against it to confirm login persisted
  /// correctly and the server is reachable after relaunch.
  /// Remove once HomePage (P4-9) has real connection-state wiring.
  Future<String> _checkConnection() async {
    final repository = getIt<ServerConfigRepository>();
    final validateHealth = getIt<ValidateServerHealth>();

    final serversResult = await repository.getAll();
    if (!serversResult.isSuccess) {
      return 'getAll() failed: ${serversResult.failureOrThrow}';
    }

    final servers = serversResult.valueOrThrow;
    if (servers.isEmpty) {
      return 'No server configured (Drift is empty)';
    }

    final server = servers.firstWhere(
      (s) => s.isDefault,
      orElse: () => servers.first,
    );

    final healthResult = await validateHealth.call(server.baseUrl);
    if (!healthResult.isSuccess) {
      return '${server.baseUrl} -> unreachable: ${healthResult.failureOrThrow}';
    }

    return '${server.baseUrl} -> healthy';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ntfyd'),
        // DEBUG ONLY (P2-4 milestone): provides a way back to LoginPage
        // since `pushReplacement` on success removes it from the stack.
        // Remove once HomePage (P4-9) has its own navigation.
        leading: kDebugMode
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Back to Login (debug)',
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
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
                  onPressed: () =>
                      setState(() => _statusFuture = _checkConnection()),
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
                'Home Page - under construction',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
