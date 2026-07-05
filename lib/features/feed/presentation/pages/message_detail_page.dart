import 'package:flutter/material.dart';
import 'package:ntfyd/features/feed/domain/entities/notification_message.dart';

class MessageDetailPage extends StatelessWidget {
  const MessageDetailPage({super.key, required this.message});

  final NotificationMessage message;

  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: Text(message.title ?? message.topic)));
}
