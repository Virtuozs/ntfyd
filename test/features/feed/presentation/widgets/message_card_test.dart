import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';
import 'package:ntfyd/features/feed/presentation/widgets/message_card.dart';

void main() {
  final message = NotificationMessage(
    id: 'msg-1',
    serverId: 'srv-1',
    topic: 'security',
    time: DateTime.now().subtract(const Duration(minutes: 2)),
    event: 'message',
    title: 'Backup failed',
    body: 'NAS disk usage 94%',
    priority: 5,
    receivedAt: DateTime.now(),
  );

  Future<void> pumpCard(
    WidgetTester tester, {
    required VoidCallback onTap,
    required VoidCallback onTogglePin,
    required VoidCallback onToggleRead,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MessageCard(
            message: message,
            onTap: onTap,
            onTogglePin: onTogglePin,
            onToggleRead: onToggleRead,
          ),
        ),
      ),
    );
  }

  testWidgets('renders title and relative time', (tester) async {
    await pumpCard(
      tester,
      onTap: () {},
      onTogglePin: () {},
      onToggleRead: () {},
    );

    expect(find.text('Backup failed'), findsOneWidget);
    expect(find.textContaining('min ago'), findsOneWidget);
  });

  testWidgets('tapping the card invokes onTap', (tester) async {
    var tapped = false;
    await pumpCard(
      tester,
      onTap: () => tapped = true,
      onTogglePin: () {},
      onToggleRead: () {},
    );

    await tester.tap(find.byType(InkWell));
    expect(tapped, isTrue);
  });

  testWidgets('tapping the pin icon invokes onTogglePin', (tester) async {
    var toggled = false;
    await pumpCard(
      tester,
      onTap: () {},
      onTogglePin: () => toggled = true,
      onToggleRead: () {},
    );

    await tester.tap(find.byIcon(Icons.push_pin));
    expect(toggled, isTrue);
  });

  testWidgets('tapping the check icon invokes onToggleRead', (tester) async {
    var toggled = false;
    await pumpCard(
      tester,
      onTap: () {},
      onTogglePin: () {},
      onToggleRead: () => toggled = true,
    );

    await tester.tap(find.byIcon(Icons.check));
    expect(toggled, isTrue);
  });

  testWidgets('shows sourceLabel next to the relative time when provided', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MessageCard(
            message: message,
            sourceLabel: 'security',
            onTap: () {},
            onTogglePin: () {},
            onToggleRead: () {},
          ),
        ),
      ),
    );

    expect(find.textContaining('security ·'), findsOneWidget);
  });

  testWidgets('omits the source separator when sourceLabel is null', (
    tester,
  ) async {
    await pumpCard(tester, onTap: () {}, onTogglePin: () {}, onToggleRead: () {});

    expect(find.textContaining('·'), findsNothing);
  });
}
