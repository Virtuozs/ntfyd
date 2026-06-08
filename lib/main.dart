// lib/main.dart
import 'package:flutter/material.dart';
import 'package:ntfyd/di/injection_container.dart';
import 'package:ntfyd/shared/theme/app_theme.dart';
import 'package:ntfyd/shared/theme/dynamic_color_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const NtfydApp());
}

class NtfydApp extends StatelessWidget {
  const NtfydApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const DynamicColorWrapper();
  }
}