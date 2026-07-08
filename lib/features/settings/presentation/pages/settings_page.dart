import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntfyd/di/injection_container.dart';
import 'package:ntfyd/features/server_config/presentation/pages/server_manager_page.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_cubit.dart';
import 'package:ntfyd/features/settings/presentation/pages/biometrics_settings_page.dart';
import 'package:ntfyd/features/settings/presentation/pages/cache_sync_settings_page.dart';
import 'package:ntfyd/features/settings/presentation/pages/notifications_settings_page.dart';
import 'package:ntfyd/features/settings/presentation/pages/privacy_settings_page.dart';
import 'package:ntfyd/features/settings/presentation/pages/theme_settings_page.dart';

/// Matches `Plan/UI/Settings.png`: a single list of 6 rows. "Server URL"
/// pushes the existing (currently placeholder) `ServerManagerPage`
/// unchanged; the other 5 push a `SettingsCubit`-backed sub-page.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>(
      create: (_) => getIt<SettingsCubit>()..load(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SettingsTile(
              title: 'Server URL',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const ServerManagerPage()),
              ),
            ),
            const SizedBox(height: 12),
            _SettingsTile(
              title: 'Theme',
              onTap: () => _pushSubPage(context, const ThemeSettingsPage()),
            ),
            const SizedBox(height: 12),
            _SettingsTile(
              title: 'Biometrics',
              onTap: () => _pushSubPage(context, const BiometricsSettingsPage()),
            ),
            const SizedBox(height: 12),
            _SettingsTile(
              title: 'Notifications',
              onTap: () => _pushSubPage(context, const NotificationsSettingsPage()),
            ),
            const SizedBox(height: 12),
            _SettingsTile(
              title: 'Cache & Sync',
              onTap: () => _pushSubPage(context, const CacheSyncSettingsPage()),
            ),
            const SizedBox(height: 12),
            _SettingsTile(
              title: 'Privacy',
              onTap: () => _pushSubPage(context, const PrivacySettingsPage()),
            ),
          ],
        ),
      ),
    );
  }

  void _pushSubPage(BuildContext context, Widget page) {
    final cubit = context.read<SettingsCubit>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider<SettingsCubit>.value(value: cubit, child: page),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: theme.textTheme.bodyLarge),
            Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
