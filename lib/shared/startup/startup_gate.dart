import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/di/injection_container.dart';
import 'package:ntfyd/features/feed/presentation/pages/home_page.dart';
import 'package:ntfyd/features/server_config/domain/repositories/server_config_repository.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_form_cubit.dart';
import 'package:ntfyd/features/server_config/presentation/pages/login_page.dart';

/// Decides the app's initial screen on launch: [HomePage] when a server
/// is already configured (skipping the first-run [LoginPage]), otherwise
/// [LoginPage] itself.
class StartupGate extends StatefulWidget {
  const StartupGate({super.key});

  @override
  State<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends State<StartupGate> {
  late final Future<bool> _hasServerFuture;

  @override
  void initState() {
    super.initState();
    _hasServerFuture = _hasConfiguredServer();
  }

  Future<bool> _hasConfiguredServer() async {
    final result = await getIt<ServerConfigRepository>().getAll();
    return result.isSuccess && result.valueOrThrow.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasServerFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data!) {
          return const HomePage();
        }
        return BlocProvider<ServerFormCubit>(
          create: (_) => getIt<ServerFormCubit>(),
          child: const LoginPage(),
        );
      },
    );
  }
}
