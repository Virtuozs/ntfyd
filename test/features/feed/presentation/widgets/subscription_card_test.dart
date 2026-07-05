import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/features/feed/presentation/cubits/home_topic_summary.dart';
import 'package:ntfyd/features/feed/presentation/widgets/subscription_card.dart';
import 'package:ntfyd/features/subscription/domain/entities/subscription.dart';

void main() {
  final subscription = Subscription(
    id: 'sub-1',
    serverId: 'srv-1',
    topic: 'docker-alerts',
    displayName: 'docker-alerts',
    createdAt: DateTime.utc(2026, 1, 1),
  );

  Future<void> pumpCard(
    WidgetTester tester, {
    required HomeTopicSummary summary,
    required VoidCallback onTap,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SubscriptionCard(summary: summary, onTap: onTap),
        ),
      ),
    );
  }

  testWidgets('renders display name and unread count', (tester) async {
    await pumpCard(
      tester,
      summary: HomeTopicSummary(subscription: subscription, unreadCount: 12),
      onTap: () {},
    );

    expect(find.text('docker-alerts'), findsOneWidget);
    expect(find.text('12 unread'), findsOneWidget);
  });

  testWidgets('shows "No unread messages" when unreadCount is 0', (
    tester,
  ) async {
    await pumpCard(
      tester,
      summary: HomeTopicSummary(subscription: subscription, unreadCount: 0),
      onTap: () {},
    );

    expect(find.text('No unread messages'), findsOneWidget);
  });

  testWidgets('tapping the card invokes onTap', (tester) async {
    var tapped = false;
    await pumpCard(
      tester,
      summary: HomeTopicSummary(subscription: subscription, unreadCount: 0),
      onTap: () => tapped = true,
    );

    // NOTE: PopupMenuButton's default trigger also renders its own InkWell
    // (Flutter 3.44.2), so find.byType(InkWell) matches 2 widgets here.
    // `.first` targets the card's own outer InkWell (the intended tap
    // target), not the popup menu's internal one.
    await tester.tap(find.byType(InkWell).first);
    expect(tapped, isTrue);
  });
}
