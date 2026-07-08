import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_cubit.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_state.dart';

class CacheSyncSettingsPage extends StatelessWidget {
  const CacheSyncSettingsPage({super.key});

  static const _presets = <int?, String>{
    7: '7 days',
    30: '30 days',
    90: '90 days',
    null: 'Forever',
  };

  Future<void> _confirmClearCache(BuildContext context, SettingsCubit cubit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear cache?'),
        content: const Text(
          'This deletes all stored messages. Subscriptions and settings '
          'are kept. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Clear cache'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await cubit.clearCache();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cache & Sync')),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is! SettingsLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          final current = state.settings.retentionMaxAgeDays;
          final cubit = context.read<SettingsCubit>();

          return ListView(
            children: [
              for (final entry in _presets.entries)
                RadioListTile<int?>(
                  title: Text(entry.value),
                  value: entry.key,
                  groupValue: current,
                  onChanged: (value) => cubit.setRetentionMaxAgeDays(value),
                ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.tonal(
                  onPressed: () => _confirmClearCache(context, cubit),
                  child: const Text('Clear cache now'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
