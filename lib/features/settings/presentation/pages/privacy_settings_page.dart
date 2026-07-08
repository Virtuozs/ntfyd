import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntfyd/di/injection_container.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_form_cubit.dart';
import 'package:ntfyd/features/server_config/presentation/pages/login_page.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_cubit.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_state.dart';

class PrivacySettingsPage extends StatelessWidget {
  const PrivacySettingsPage({super.key});

  Future<void> _confirmClearAllData(BuildContext context, SettingsCubit cubit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear all data?'),
        content: const Text(
          'This permanently deletes every server, subscription, message, '
          'and tag on this device. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Clear all data'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await cubit.clearAllData();
    }
  }

  void _goToFirstRunLogin(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider<ServerFormCubit>(
          create: (_) => getIt<ServerFormCubit>(),
          child: const LoginPage(),
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (previous, current) => current is SettingsDataCleared,
      listener: (context, state) => _goToFirstRunLogin(context),
      child: Scaffold(
        appBar: AppBar(title: const Text('Privacy')),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            if (state is! SettingsLoaded) {
              return const Center(child: CircularProgressIndicator());
            }
            final settings = state.settings;
            final cubit = context.read<SettingsCubit>();
            final theme = Theme.of(context);

            return ListView(
              children: [
                SwitchListTile(
                  title: const Text('Hide content on lock screen'),
                  value: settings.hideLockScreenContent,
                  onChanged: (value) => cubit.setHideLockScreenContent(value),
                ),
                SwitchListTile(
                  title: const Text('Opt out of analytics'),
                  value: settings.analyticsOptOut,
                  onChanged: (value) => cubit.setAnalyticsOptOut(value),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.error,
                      foregroundColor: theme.colorScheme.onError,
                    ),
                    onPressed: () => _confirmClearAllData(context, cubit),
                    child: const Text('Clear all data'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
