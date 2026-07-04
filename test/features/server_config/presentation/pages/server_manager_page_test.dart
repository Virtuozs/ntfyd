import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/features/server_config/presentation/pages/server_manager_page.dart';

void main() {
  testWidgets('renders app bar title and placeholder body', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ServerManagerPage()));

    expect(find.text('Server Manager'), findsOneWidget);
    expect(find.text('Server Manager — coming soon'), findsOneWidget);
  });
}
