import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/features/notifications/data/notification_channel_manager.dart';

class MockAndroidFlutterLocalNotificationsPlugin extends Mock
    implements AndroidFlutterLocalNotificationsPlugin {}

void main() {
  late MockAndroidFlutterLocalNotificationsPlugin androidPlugin;

  setUpAll(() {
    registerFallbackValue(
      const AndroidNotificationChannel('fallback', 'fallback'),
    );
  });

  setUp(() {
    androidPlugin = MockAndroidFlutterLocalNotificationsPlugin();
    when(
      () => androidPlugin.createNotificationChannel(any()),
    ).thenAnswer((_) async {});
  });

  test('creates exactly 5 channels, one per priority level', () async {
    final manager = NotificationChannelManager(androidPlugin);

    await manager.createChannels();

    verify(() => androidPlugin.createNotificationChannel(any())).called(5);
  });

  test('does nothing when the Android plugin implementation is unavailable', () async {
    final manager = NotificationChannelManager(null);

    await manager.createChannels();

    verifyNever(() => androidPlugin.createNotificationChannel(any()));
  });
}
