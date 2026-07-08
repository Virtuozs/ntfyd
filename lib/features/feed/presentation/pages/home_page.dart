import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/di/injection_container.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_bloc.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_event.dart';
import 'package:ntfyd/features/feed/presentation/cubits/group_selector_cubit.dart';
import 'package:ntfyd/features/feed/presentation/cubits/group_selector_state.dart';
import 'package:ntfyd/features/feed/presentation/cubits/home_feed_cubit.dart';
import 'package:ntfyd/features/feed/presentation/cubits/home_feed_state.dart';
import 'package:ntfyd/features/feed/presentation/cubits/home_topic_summary.dart';
import 'package:ntfyd/features/feed/presentation/pages/topic_detail_page.dart';
import 'package:ntfyd/features/feed/presentation/widgets/subscription_card.dart';
import 'package:ntfyd/features/groups/domain/entities/group.dart';
import 'package:ntfyd/features/groups/presentation/blocs/group_feed_bloc.dart';
import 'package:ntfyd/features/groups/presentation/blocs/group_feed_event.dart';
import 'package:ntfyd/features/groups/presentation/pages/group_feed_page.dart';
import 'package:ntfyd/features/groups/presentation/pages/group_form_page.dart';
import 'package:ntfyd/features/groups/presentation/widgets/group_selector_sheet.dart';
import 'package:ntfyd/features/publish/presentation/cubits/publish_cubit.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';
import 'package:ntfyd/features/server_config/domain/usecases/validate_server_health.dart';
import 'package:ntfyd/features/settings/presentation/pages/settings_page.dart';
import 'package:ntfyd/features/subscription/presentation/blocs/subscription_bloc.dart';
import 'package:ntfyd/features/subscription/presentation/pages/subscribe_topic_sheet.dart';
import 'package:ntfyd/shared/theme/design_tokens.dart';

/// Group-centric Home (§8.2): header (title + default-server connection
/// state), a group ("Tag") selector with a built-in "All" entry (D15),
/// subscription list filtered to the selected group across every server
/// (not just the default one), a merged-feed shortcut, and a FAB into
/// Subscribe Topic / Create Tag.
///
/// Always resolves the **default** `ServerConfig` fresh from
/// `ServerConfigRepository` rather than trusting a passed-in base URL —
/// this is what lets the "Connected" indicator work correctly both right
/// after first login and on any later app open. This is independent of
/// which group is selected: the indicator always reflects the default
/// server's health, not the currently-filtered feed.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeFeedCubit _homeFeedCubit;
  late final GroupSelectorCubit _groupSelectorCubit;
  List<ServerConfig> _servers = const [];
  ServerConfig? _defaultServer;
  bool _isHealthy = false;
  bool _loadingServer = true;
  bool _fabOpen = false;

  @override
  void initState() {
    super.initState();
    _homeFeedCubit = getIt<HomeFeedCubit>();
    _groupSelectorCubit = getIt<GroupSelectorCubit>();
    _homeFeedCubit.load();
    _groupSelectorCubit.load();
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
    _groupSelectorCubit.close();
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

  void _openCreateGroup() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const GroupFormPage()),
    );
  }

  void _openGroupSelector() {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => BlocProvider<GroupSelectorCubit>.value(
          value: _groupSelectorCubit,
          child: const GroupSelectorSheet(),
        ),
      ),
    );
  }

  void _openGroupFeed(String? groupId, String title) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider<GroupFeedBloc>(
          create: (_) => getIt<GroupFeedBloc>()
            ..add(GroupFeedEvent.load(groupId: groupId)),
          child: GroupFeedPage(groupId: groupId, title: title),
        ),
      ),
    );
  }

  void _openTopicDetail(HomeTopicSummary summary) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<FeedBloc>(
              create: (_) => getIt<FeedBloc>()
                ..add(
                  FeedEvent.load(
                    serverId: summary.subscription.serverId,
                    topic: summary.subscription.topic,
                  ),
                ),
            ),
            BlocProvider<PublishCubit>(create: (_) => getIt<PublishCubit>()),
          ],
          child: TopicDetailPage(subscription: summary.subscription),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeFeedCubit>.value(value: _homeFeedCubit),
        BlocProvider<GroupSelectorCubit>.value(value: _groupSelectorCubit),
      ],
      child: BlocListener<GroupSelectorCubit, GroupSelectorState>(
        listenWhen: (previous, current) =>
            previous.selectedGroupId != current.selectedGroupId,
        listener: (context, state) => _homeFeedCubit.load(groupId: state.selectedGroupId),
        child: Scaffold(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ntfyd',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings_outlined),
                            tooltip: 'Settings',
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const SettingsPage(),
                              ),
                            ),
                          ),
                        ],
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
                      BlocBuilder<GroupSelectorCubit, GroupSelectorState>(
                        builder: (context, groupState) {
                          final selectedGroup = groupState.groups
                              .cast<Group?>()
                              .firstWhere(
                                (g) => g!.id == groupState.selectedGroupId,
                                orElse: () => null,
                              );
                          final label = selectedGroup?.name ?? 'All';

                          return Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.cardBorderRadius,
                                  ),
                                  onTap: _openGroupSelector,
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
                                        Row(
                                          children: [
                                            if (selectedGroup?.color != null) ...[
                                              Container(
                                                width: 10,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  color: Color(selectedGroup!.color!),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: Spacing.xs),
                                            ],
                                            Text(label),
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color: theme.colorScheme.onSurfaceVariant,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: 'View merged feed',
                                icon: const Icon(Icons.dynamic_feed),
                                onPressed: () => _openGroupFeed(
                                  groupState.selectedGroupId,
                                  label,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                Expanded(
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
              ],
            ),
          ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_fabOpen) ...[
                FloatingActionButton.small(
                  heroTag: 'createTag',
                  tooltip: 'Create Tag',
                  onPressed: () {
                    setState(() => _fabOpen = false);
                    _openCreateGroup();
                  },
                  child: const Icon(Icons.label_outline),
                ),
                const SizedBox(height: Spacing.sm),
                FloatingActionButton.small(
                  heroTag: 'subscribeTopic',
                  tooltip: 'Subscribe to topic',
                  onPressed: () {
                    setState(() => _fabOpen = false);
                    _openSubscribeSheet();
                  },
                  child: const Icon(Icons.rss_feed),
                ),
                const SizedBox(height: Spacing.sm),
              ],
              FloatingActionButton(
                tooltip: _fabOpen ? 'Close' : 'Add',
                onPressed: () => setState(() => _fabOpen = !_fabOpen),
                child: Icon(_fabOpen ? Icons.close : Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
