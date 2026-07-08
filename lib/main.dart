// lib/main.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ntfyd/core/app_lock/app_lock_service.dart';
import 'package:ntfyd/core/database/daos/message_dao.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/di/injection_container.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_bloc.dart';
import 'package:ntfyd/features/feed/presentation/blocs/feed_event.dart';
import 'package:ntfyd/features/feed/presentation/pages/topic_detail_page.dart';
import 'package:ntfyd/features/notifications/notifications.dart';
import 'package:ntfyd/features/publish/presentation/cubits/publish_cubit.dart';
import 'package:ntfyd/features/settings/domain/repositories/settings_repository.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_cubit.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_state.dart';
import 'package:ntfyd/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:ntfyd/shared/theme/app_theme_controller.dart';
import 'package:ntfyd/shared/theme/dynamic_color_wrapper.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await _initNotifications();
  await _purgeMessagesOnStartup();
  runApp(
    NtfydApp(
      appThemeController: AppThemeController(),
      navigatorKey: navigatorKey,
    ),
  );
}

Future<void> _initNotifications() async {
  final plugin = getIt<FlutterLocalNotificationsPlugin>();
  await plugin.initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
    onDidReceiveNotificationResponse: _onNotificationTap,
  );

  await getIt<NotificationChannelManager>().createChannels();
  getIt<NotificationsCoordinator>().start();

  if (Platform.isAndroid) {
    await getIt<BackgroundDeliveryService>().start();
  }
}

/// Enforces the user's message retention policy once per app launch.
/// `retentionMaxAgeDays == null` means "Forever" — skip entirely, since
/// `MessageDao.purgeByRetention(0, 0)` means "delete everything".
Future<void> _purgeMessagesOnStartup() async {
  final settings = await getIt<SettingsRepository>().watch().first;
  final maxAgeDays = settings.retentionMaxAgeDays;
  if (maxAgeDays == null) return;

  await getIt<MessageDao>().purgeByRetention(
    maxAgeDays,
    settings.retentionMaxRows ?? 10000,
  );
}

void _onNotificationTap(NotificationResponse response) {
  final payload = response.payload;
  if (payload == null) return;

  final decoded = jsonDecode(payload) as Map<String, dynamic>;
  final serverId = decoded['serverId'] as String;
  final topic = decoded['topic'] as String;
  unawaited(_openTopicDetail(serverId, topic));
}

Future<void> _openTopicDetail(String serverId, String topic) async {
  final navigatorState = navigatorKey.currentState;
  if (navigatorState == null) return;

  final result = await getIt<SubscriptionRepository>().getByTopic(
    serverId,
    topic,
  );
  if (!result.isSuccess) return;
  final subscription = result.valueOrThrow;

  unawaited(
    navigatorState.push(
      MaterialPageRoute<void>(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<FeedBloc>(
              create: (_) =>
                  getIt<FeedBloc>()
                    ..add(FeedEvent.load(serverId: serverId, topic: topic)),
            ),
            BlocProvider<PublishCubit>(create: (_) => getIt<PublishCubit>()),
          ],
          child: TopicDetailPage(subscription: subscription),
        ),
      ),
    ),
  );
}

class NtfydApp extends StatelessWidget {
  const NtfydApp({
    super.key,
    required this.appThemeController,
    required this.navigatorKey,
  });

  final AppThemeController appThemeController;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>(
      create: (_) => getIt<SettingsCubit>()..load(),
      child: BlocListener<SettingsCubit, SettingsState>(
        listenWhen: (previous, current) => current is SettingsLoaded,
        listener: (context, state) {
          appThemeController.value = (state as SettingsLoaded).settings.themeMode;
        },
        child: BlocSelector<SettingsCubit, SettingsState, bool>(
          selector: (state) =>
              state is SettingsLoaded && state.settings.biometricLock,
          builder: (context, biometricLock) {
            return DynamicColorWrapper(
              controller: appThemeController,
              navigatorKey: navigatorKey,
              biometricLock: biometricLock,
              appLockService: getIt<AppLockService>(),
            );
          },
        ),
      ),
    );
  }
}
