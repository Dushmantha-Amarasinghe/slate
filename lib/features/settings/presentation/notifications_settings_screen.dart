import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

import '../../../core/db/database.dart';
import '../../../core/notifications/notification_service.dart';
import '../../../core/theme/tokens/color_tokens.dart';
import '../../../core/theme/tokens/spacing_tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_label.dart';
import '../application/settings_controller.dart';
import 'widgets/settings_nav_row.dart';

const List<int> _kLeadTimeOptions = <int>[0, 5, 15, 30, 60];
const List<int> _kSnoozePresets = <int>[5, 15, 30, 60, 1440];

class NotificationsSettingsScreen extends ConsumerStatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  ConsumerState<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends ConsumerState<NotificationsSettingsScreen>
    with WidgetsBindingObserver {
  bool _notificationsGranted = false;
  bool _exactAlarmsGranted = false;
  bool _batteryUnrestricted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshPermissionStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refreshPermissionStatus();
  }

  Future<void> _refreshPermissionStatus() async {
    final bool notifications = await NotificationService.areNotificationsEnabled();
    final bool exactAlarms = await NotificationService.canScheduleExactAlarms();
    final bool battery = await ph.Permission.ignoreBatteryOptimizations.isGranted;
    if (!mounted) return;
    setState(() {
      _notificationsGranted = notifications;
      _exactAlarmsGranted = exactAlarms;
      _batteryUnrestricted = battery;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<AppSettingsTableData> settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications & Reminders')),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object e, StackTrace st) => Center(child: Text('Something went wrong: $e')),
        data: (AppSettingsTableData settings) => _buildBody(context, settings),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppSettingsTableData settings) {
    final List<int> snoozeMinutes = _decodeSnooze(settings.snoozeOptionsMinutesJson);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: <Widget>[
        const SectionLabel('Permissions'),
        const SizedBox(height: AppSpacing.xs),
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            children: <Widget>[
              SettingsNavRow(
                icon: Icons.notifications_active_outlined,
                title: 'Notifications',
                subtitle: _notificationsGranted ? 'Allowed' : 'Not allowed — tap to enable',
                trailing: _statusIcon(_notificationsGranted),
                onTap: () async {
                  await NotificationService.requestNotificationPermission();
                  _refreshPermissionStatus();
                },
              ),
              const SettingsRowDivider(),
              SettingsNavRow(
                icon: Icons.alarm_outlined,
                title: 'Exact alarms',
                subtitle: _exactAlarmsGranted
                    ? 'Allowed — reminders fire on time'
                    : 'Not allowed — reminders may be delayed',
                trailing: _statusIcon(_exactAlarmsGranted),
                onTap: () async {
                  await NotificationService.requestExactAlarmPermission();
                  _refreshPermissionStatus();
                },
              ),
              const SettingsRowDivider(),
              SettingsNavRow(
                icon: Icons.battery_saver_outlined,
                title: 'Battery optimization',
                subtitle: _batteryUnrestricted
                    ? 'Unrestricted — reminders survive Doze'
                    : 'Restricted — some devices delay reminders in the background',
                trailing: _statusIcon(_batteryUnrestricted),
                onTap: () async {
                  await ph.Permission.ignoreBatteryOptimizations.request();
                  _refreshPermissionStatus();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Text(
            'On some devices (Xiaomi, Samsung, Oppo) you may also need to enable '
            '"Autostart" for Slate from the manufacturer\'s battery settings for '
            'reminders to work reliably in the background.',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const SectionLabel('Reminders'),
        const SizedBox(height: AppSpacing.xs),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Default lead time', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'How long before the due time a reminder fires by default.',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.xs,
                children: _kLeadTimeOptions.map((int minutes) {
                  final bool selected = settings.defaultReminderLeadMinutes == minutes;
                  return ChoiceChip(
                    label: Text(_leadLabel(minutes)),
                    selected: selected,
                    onSelected: (_) => ref
                        .read(settingsControllerProvider)
                        .update(
                          AppSettingsTableCompanion(
                            defaultReminderLeadMinutes: Value<int>(minutes),
                          ),
                        ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Snooze options', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Which snooze durations appear on a reminder notification.',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.xs,
                children: _kSnoozePresets.map((int minutes) {
                  final bool selected = snoozeMinutes.contains(minutes);
                  return FilterChip(
                    label: Text(_leadLabel(minutes)),
                    selected: selected,
                    onSelected: (bool value) {
                      final List<int> updated = List<int>.from(snoozeMinutes);
                      if (value) {
                        updated.add(minutes);
                      } else {
                        updated.remove(minutes);
                      }
                      updated.sort();
                      if (updated.isEmpty) return;
                      ref
                          .read(settingsControllerProvider)
                          .update(
                            AppSettingsTableCompanion(
                              snoozeOptionsMinutesJson: Value<String>(jsonEncode(updated)),
                            ),
                          );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SettingsNavRow(
                icon: Icons.volume_up_outlined,
                title: 'Notification sound',
                trailing: Switch(
                  value: settings.soundEnabled,
                  onChanged: (bool value) => ref
                      .read(settingsControllerProvider)
                      .update(AppSettingsTableCompanion(soundEnabled: Value<bool>(value))),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Opacity(
                opacity: settings.soundEnabled ? 1 : 0.4,
                child: IgnorePointer(
                  ignoring: !settings.soundEnabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Reminder tone', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Urgent uses your device\'s alarm sound instead of the '
                        'regular notification sound — louder, and hard to miss.',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.xs,
                        children: <Widget>[
                          ChoiceChip(
                            label: const Text('Standard'),
                            selected: !settings.urgentReminderSound,
                            onSelected: (_) => ref
                                .read(settingsControllerProvider)
                                .update(
                                  const AppSettingsTableCompanion(
                                    urgentReminderSound: Value<bool>(false),
                                  ),
                                ),
                          ),
                          ChoiceChip(
                            label: const Text('Urgent'),
                            selected: settings.urgentReminderSound,
                            onSelected: (_) => ref
                                .read(settingsControllerProvider)
                                .update(
                                  const AppSettingsTableCompanion(
                                    urgentReminderSound: Value<bool>(true),
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusIcon(bool granted) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    if (granted) {
      return Icon(Icons.check_circle_outline, size: 20, color: scheme.onSurface.withValues(alpha: 0.5));
    }
    return Icon(
      Icons.error_outline,
      size: 20,
      color: isDark ? AppColors.destructiveOnDark : AppColors.destructive,
    );
  }

  List<int> _decodeSnooze(String json) {
    try {
      final List<dynamic> decoded = jsonDecode(json) as List<dynamic>;
      return decoded.cast<int>();
    } catch (_) {
      return const <int>[15, 60, 1440];
    }
  }

  String _leadLabel(int minutes) {
    if (minutes == 0) return 'At due time';
    if (minutes < 60) return '$minutes min';
    if (minutes < 1440) return '${minutes ~/ 60} hr';
    return '${minutes ~/ 1440} day';
  }
}
