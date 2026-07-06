import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/features/notifications/data/notification_presenter.dart';
import 'package:ntfyd/features/notifications/domain/entities/notification_channel_spec.dart';

class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

void main() {
  late MockFlutterLocalNotificationsPlugin plugin;
  late NotificationPresenter presenter;

  setUpAll(() {
    registerFallbackValue(0);
    registerFallbackValue('');
    registerFallbackValue(
      const NotificationDetails(
        android: AndroidNotificationDetails('fallback', 'fallback'),
      ),
    );
  });

  setUp(() {
    plugin = MockFlutterLocalNotificationsPlugin();
    presenter = NotificationPresenter(plugin);
    when(
      () => plugin.show(
        id: any(named: 'id'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        notificationDetails: any(named: 'notificationDetails'),
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) async {});
  });

  test('shows a notification on the channel matching the message priority', () async {
    await presenter.show(
      serverId: 'srv-1',
      messageId: 'msg-1',
      topic: 'alerts',
      title: 'Backup successful',
      body: 'Completed at 03:00',
      channel: NotificationChannelSpec.forPriority(5),
    );

    final captured = verify(
      () => plugin.show(
        id: captureAny(named: 'id'),
        title: 'Backup successful',
        body: 'Completed at 03:00',
        notificationDetails: captureAny(named: 'notificationDetails'),
        payload: captureAny(named: 'payload'),
      ),
    ).captured;

    final details = captured[1] as NotificationDetails;
    expect(details.android?.channelId, equals('ntfy_priority_5'));
    expect(captured[2], contains('"serverId":"srv-1"'));
    expect(captured[2], contains('"topic":"alerts"'));
  });
}
