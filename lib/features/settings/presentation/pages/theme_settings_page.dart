import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntfyd/features/settings/domain/entities/app_settings.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_cubit.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_state.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theme')),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is! SettingsLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          final mode = state.settings.themeMode;
          final cubit = context.read<SettingsCubit>();

          return ListView(
            children: [
              RadioListTile<AppThemeMode>(
                title: const Text('White'),
                value: AppThemeMode.white,
                groupValue: mode,
                onChanged: (value) => cubit.setThemeMode(value!),
              ),
              RadioListTile<AppThemeMode>(
                title: const Text('Dark'),
                value: AppThemeMode.dark,
                groupValue: mode,
                onChanged: (value) => cubit.setThemeMode(value!),
              ),
              RadioListTile<AppThemeMode>(
                title: const Text('Material You'),
                subtitle: const Text('Colors from your wallpaper'),
                value: AppThemeMode.materialYou,
                groupValue: mode,
                onChanged: (value) => cubit.setThemeMode(value!),
              ),
            ],
          );
        },
      ),
    );
  }
}
