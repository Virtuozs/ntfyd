import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/di/injection_container.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_bloc.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_event.dart';
import 'package:ntfyd/features/feed/presentation/cubits/home_feed_cubit.dart';
import 'package:ntfyd/features/feed/presentation/cubits/home_feed_state.dart';
import 'package:ntfyd/features/feed/presentation/cubits/home_topic_summary.dart';
import 'package:ntfyd/features/feed/presentation/pages/topic_detail_page.dart';
import 'package:ntfyd/features/feed/presentation/widgets/subscription_card.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';
import 'package:ntfyd/features/server_config/domain/usecases/validate_server_health.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_bloc.dart';
import 'package:ntfyd/features/subscription/presentation/pages/subscribe_topic_sheet.dart';
import 'package:ntfyd/shared/theme/design_tokens.dart';

/// Group-centric Home (§8.2): header (title + default-server connection
/// state), a disabled "All" selector (Groups/"Tags" is P8, not built),
/// subscription list, and a FAB into the existing `SubscribeTopicSheet`.
///
/// Always resolves the **default** `ServerConfig` fresh from
/// `ServerConfigRepository` rather than trusting a passed-in base URL —
/// this is what lets Home work correctly both right after first login and
/// on any later app open.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeFeedCubit _homeFeedCubit;
  List<ServerConfig> _servers = const [];
  ServerConfig? _defaultServer;
  bool _isHealthy = false;
  bool _loadingServer = true;

  @override
  void initState() {
    super.initState();
    _homeFeedCubit = getIt<HomeFeedCubit>();
    unawaited(_loadDefaultServer());
  }

  Future<void> _loadDefaultServer() async {
    final serversResult = await getIt<ServerConfigRepository>().getAll();
    if (!serversResult.isSuccess || !mounted) return;

    final servers = serversResult.valueOrThrow;
    final defaultServer = servers.cast<ServerConfig?>().firstWhere(
      (s) => s!.isDefault,
      orElse: () => servers.isEmpty ? null : servers.first,
    );

    setState(() {
      _servers = servers;
      _defaultServer = defaultServer;
      _loadingServer = false;
    });

    if (defaultServer == null) return;

    _homeFeedCubit.load(defaultServer.id);

    final healthResult = await getIt<ValidateServerHealth>().call(
      defaultServer.baseUrl,
    );
    if (mounted) {
      setState(
        () => _isHealthy = healthResult.isSuccess && healthResult.valueOrThrow.healthy,
      );
    }
  }

  @override
  void dispose() {
    _homeFeedCubit.close();
    super.dispose();
  }

  void _openSubscribeSheet() {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => BlocProvider<SubscriptionBloc>(
          create: (_) => getIt<SubscriptionBloc>(),
          child: SubscribeTopicSheet(servers: _servers),
        ),
      ),
    );
  }

  void _openTopicDetail(HomeTopicSummary summary) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider<FeedBloc>(
          create: (_) => getIt<FeedBloc>()
            ..add(
              FeedEvent.load(
                serverId: summary.subscription.serverId,
                topic: summary.subscription.topic,
              ),
            ),
          child: TopicDetailPage(subscription: summary.subscription),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Spacing.md,
                Spacing.md,
                Spacing.md,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ntfyd',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  if (!_loadingServer && _defaultServer != null)
                    Row(
                      children: [
                        Text(
                          _isHealthy ? 'Connected' : 'Disconnected',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: _isHealthy
                                ? theme.colorScheme.primary
                                : theme.colorScheme.error,
                          ),
                        ),
                        const SizedBox(width: Spacing.xs),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: _isHealthy
                                ? theme.colorScheme.primary
                                : theme.colorScheme.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: Spacing.md),
                  IgnorePointer(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.md,
                        vertical: Spacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.cardBorderRadius,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('All'),
                          Icon(
                            Icons.arrow_drop_down,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Expanded(
              child: BlocProvider<HomeFeedCubit>.value(
                value: _homeFeedCubit,
                child: BlocBuilder<HomeFeedCubit, HomeFeedState>(
                  builder: (context, state) {
                    return switch (state) {
                      HomeFeedLoading() => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      HomeFeedError(:final failure) => Center(
                        child: Text('Something went wrong: $failure'),
                      ),
                      HomeFeedLoaded(:final items) => items.isEmpty
                          ? Center(
                              child: Text(
                                'No subscriptions yet',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final summary = items[index];
                                return SubscriptionCard(
                                  summary: summary,
                                  onTap: () => _openTopicDetail(summary),
                                );
                              },
                            ),
                    };
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Subscribe to topic',
        onPressed: _openSubscribeSheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}
