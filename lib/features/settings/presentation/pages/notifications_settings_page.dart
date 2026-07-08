import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntfyd/features/notifications/domain/entities/notification_channel_spec.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_cubit.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_state.dart';

class NotificationsSettingsPage extends StatelessWidget {
  const NotificationsSettingsPage({super.key});

  Future<void> _pickTime(
    BuildContext context,
    SettingsCubit cubit,
    bool enabled,
    String? start,
    String? end, {
    required bool isStart,
  }) async {
    final initial = _parseTimeOfDay(isStart ? start : end) ?? TimeOfDay.now();
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) return;

    final formatted =
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    await cubit.setQuietHours(
      enabled: enabled,
      start: isStart ? formatted : start,
      end: isStart ? end : formatted,
    );
  }

  TimeOfDay? _parseTimeOfDay(String? value) {
    if (value == null) return null;
    final parts = value.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h, minute: m);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is! SettingsLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          final settings = state.settings;
          final cubit = context.read<SettingsCubit>();

          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Quiet hours'),
                value: settings.quietHoursEnabled,
                onChanged: (value) => cubit.setQuietHours(
                  enabled: value,
                  start: settings.quietHoursStart,
                  end: settings.quietHoursEnd,
                ),
              ),
              ListTile(
                title: const Text('Start'),
                trailing: Text(settings.quietHoursStart ?? '--:--'),
                onTap: () => _pickTime(
                  context,
                  cubit,
                  settings.quietHoursEnabled,
                  settings.quietHoursStart,
                  settings.quietHoursEnd,
                  isStart: true,
                ),
              ),
              ListTile(
                title: const Text('End'),
                trailing: Text(settings.quietHoursEnd ?? '--:--'),
                onTap: () => _pickTime(
                  context,
                  cubit,
                  settings.quietHoursEnabled,
                  settings.quietHoursStart,
                  settings.quietHoursEnd,
                  isStart: false,
                ),
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Priority channels'),
              ),
              for (final channel in NotificationChannelSpec.all)
                ListTile(title: Text(channel.name)),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Sound and vibration are managed by your device's "
                  'notification settings once a channel is created.',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
