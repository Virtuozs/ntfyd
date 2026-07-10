import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntfyd/features/notifications/domain/entities/notification_channel_spec.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_cubit.dart';
import 'package:ntfyd/features/settings/presentation/cubits/settings_state.dart';

class NotificationsSettingsPage extends StatelessWidget {
  const NotificationsSettingsPage({super.key});

  static const _defaultQuietHoursStart = '22:00';
  static const _defaultQuietHoursEnd = '07:00';

  Future<void> _toggleQuietHours(
    SettingsCubit cubit,
    bool enabled,
    String? start,
    String? end,
  ) {
    return cubit.setQuietHours(
      enabled: enabled,
      start: start ?? _defaultQuietHoursStart,
      end: end ?? _defaultQuietHoursEnd,
    );
  }

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
      start: isStart ? formatted : (start ?? _defaultQuietHoursStart),
      end: isStart ? (end ?? _defaultQuietHoursEnd) : formatted,
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
                onChanged: (value) => _toggleQuietHours(
                  cubit,
                  value,
                  settings.quietHoursStart,
                  settings.quietHoursEnd,
                ),
              ),
              ListTile(
                title: const Text('Start'),
                trailing: Text(settings.quietHoursStart ?? '--:--'),
                enabled: settings.quietHoursEnabled,
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
                enabled: settings.quietHoursEnabled,
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
              ListTile(
                title: const Text('Priority channels'),
                subtitle: const Text(
                  'Messages below the selected priority are not shown as notifications.',
                ),
                trailing: DropdownButton<int>(
                  value: settings.priorityThreshold,
                  items: [
                    for (final channel in NotificationChannelSpec.all)
                      DropdownMenuItem(
                        value: channel.priorityLevel,
                        child: Text(channel.name),
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null) cubit.setPriorityThreshold(value);
                  },
                ),
              ),
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
