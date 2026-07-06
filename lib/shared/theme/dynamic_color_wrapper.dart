import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntfyd/di/injection_container.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_form_cubit.dart';
import 'package:ntfyd/features/server_config/presentation/pages/login_page.dart';
import 'package:ntfyd/shared/theme/app_theme.dart';
import 'package:ntfyd/shared/theme/material_you_controller.dart';

/// Root theming widget.
///
/// - When [controller] is `false` (default): the app uses the fixed [AppTheme.defaultDark]
/// - When [controller] is `true`: falls back to [DynamicColorBuilder],
class DynamicColorWrapper extends StatelessWidget {
  const DynamicColorWrapper({
    super.key,
    required this.controller,
    required this.navigatorKey,
  });

  final MaterialYouController controller;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller,
      builder: (context, materialYouEnabled, _) {
        if (!materialYouEnabled) {
          final theme = AppTheme.defaultDark();
          return MaterialApp(
            title: 'ntfyd',
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            theme: theme,
            darkTheme: theme,
            themeMode: ThemeMode.system,
            home: _buildHome(),
          );
        }

        return DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
            return MaterialApp(
              title: 'ntfyd',
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              theme: AppTheme.light(dynamicScheme: lightDynamic),
              darkTheme: AppTheme.dark(dynamicScheme: darkDynamic),
              themeMode: ThemeMode.system,
              home: _buildHome(),
            );
          },
        );
      },
    );
  }

  Widget _buildHome() {
    return BlocProvider<ServerFormCubit>(
      create: (_) => getIt<ServerFormCubit>(),
      child: const LoginPage(),
    );
  }
}
