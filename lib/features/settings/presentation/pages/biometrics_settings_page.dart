import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntfyd/core/app_lock/app_lock_service.dart';
import 'package:ntfyd/di/injection_container.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_cubit.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_state.dart';

class BiometricsSettingsPage extends StatefulWidget {
  const BiometricsSettingsPage({super.key});

  @override
  State<BiometricsSettingsPage> createState() => _BiometricsSettingsPageState();
}

class _BiometricsSettingsPageState extends State<BiometricsSettingsPage> {
  late Future<bool> _availableFuture;

  @override
  void initState() {
    super.initState();
    _availableFuture = getIt<AppLockService>().isAvailable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biometrics')),
      body: FutureBuilder<bool>(
        future: _availableFuture,
        builder: (context, snapshot) {
          final available = snapshot.data ?? false;
          return BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              if (state is! SettingsLoaded) {
                return const Center(child: CircularProgressIndicator());
              }
              final cubit = context.read<SettingsCubit>();
              return ListView(
                children: [
                  SwitchListTile(
                    title: const Text('Lock app with biometrics'),
                    value: state.settings.biometricLock,
                    onChanged: available
                        ? (value) => cubit.setBiometricLock(value)
                        : null,
                  ),
                  if (!available)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'No biometric hardware or device PIN is enrolled on '
                        'this device.',
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
