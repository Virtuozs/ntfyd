// lib/main.dart
import 'package:flutter/material.dart';
import 'package:ntfyd/di/injection_container.dart';
import 'package:ntfyd/shared/theme/dynamic_color_wrapper.dart';
import 'package:ntfyd/shared/theme/material_you_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(NtfydApp(materialYouController: MaterialYouController()));
}

class NtfydApp extends StatelessWidget {
  const NtfydApp({super.key, required this.materialYouController});

  final MaterialYouController materialYouController;

  @override
  Widget build(BuildContext context) {
    return DynamicColorWrapper(controller: materialYouController);
  }
}
