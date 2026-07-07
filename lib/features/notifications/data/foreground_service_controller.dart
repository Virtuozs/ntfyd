import 'package:flutter_foreground_task/flutter_foreground_task.dart';

/// Thin wrapper around the `flutter_foreground_task` static API so it can
/// be mocked in tests. Its only job is to keep the whole app process alive
/// while backgrounded (Android foreground-service guarantee) — it does NOT
/// run any of this app's business logic in its isolate; see the design note
/// on [BackgroundDeliveryService] for why.
class ForegroundServiceController {
  Future<void> initialize() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'ntfyd_background_service',
        channelName: 'ntfyd background delivery',
        channelDescription:
            'Keeps ntfyd connected to your servers while the app is backgrounded.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        autoRunOnBoot: false,
        allowWakeLock: true,
      ),
    );
  }

  Future<bool> start() async {
    final permission = await FlutterForegroundTask.checkNotificationPermission();
    if (permission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    final result = await FlutterForegroundTask.startService(
      serviceId: 300,
      notificationTitle: 'ntfyd',
      notificationText: 'Listening for notifications',
      callback: _foregroundTaskCallback,
    );

    return result is ServiceRequestSuccess;
  }

  Future<void> stop() async {
    await FlutterForegroundTask.stopService();
  }
}

@pragma('vm:entry-point')
void _foregroundTaskCallback() {
  FlutterForegroundTask.setTaskHandler(_NoopTaskHandler());
}

class _NoopTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {}

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {}
}
