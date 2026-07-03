import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/reminder_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../db/database.dart';
import 'notification_service.dart';

/// Orchestrates Task <-> Reminder <-> OS-level exact alarm. A task has at
/// most one active reminder tied to its due date (custom multi-reminder
/// scheduling is out of scope for v1); the notification id is derived
/// deterministically from the task id so it's stable across app restarts
/// without needing a separate id-allocation table.
class AlarmScheduler {
  AlarmScheduler(this._reminders, this._settings);

  final ReminderRepository _reminders;
  final SettingsRepository _settings;

  int notificationIdForTask(String taskId) => taskId.hashCode & 0x7FFFFFFF;

  /// Schedules (or replaces) the reminder for a task's due date, keeping
  /// the Reminders table row and the OS alarm in sync.
  Future<void> scheduleForTask({
    required String taskId,
    required String taskTitle,
    required DateTime triggerTimeUtc,
  }) async {
    final int notificationId = notificationIdForTask(taskId);
    final AppSettingsTableData settings = await _settings.watch().first;
    final String channelId = NotificationService.channelIdFor(
      soundEnabled: settings.soundEnabled,
      urgentSound: settings.urgentReminderSound,
    );

    await NotificationService.scheduleReminder(
      notificationId: notificationId,
      taskId: taskId,
      taskTitle: taskTitle,
      triggerTimeUtc: triggerTimeUtc,
      channelId: channelId,
    );

    final Reminder? existing = await _reminders.getForTask(taskId);
    if (existing != null) {
      await _reminders.deleteReminder(existing.id);
    }
    await _reminders.addReminder(
      taskId: taskId,
      triggerTimeUtc: triggerTimeUtc,
      notificationId: notificationId,
    );
  }

  Future<void> cancelForTask(String taskId) async {
    await NotificationService.cancelReminder(notificationIdForTask(taskId));
    await _reminders.deleteForTask(taskId);
  }
}

final Provider<AlarmScheduler> alarmSchedulerProvider =
    Provider<AlarmScheduler>((Ref ref) {
      return AlarmScheduler(
        ref.watch(reminderRepositoryProvider),
        ref.watch(settingsRepositoryProvider),
      );
    });
