import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../data/repositories/reminder_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../db/database.dart';
import 'alarm_scheduler.dart';
import 'notification_service.dart';

String encodeReminderPayload({
  required String taskId,
  required int notificationId,
}) {
  return jsonEncode(<String, Object?>{
    'taskId': taskId,
    'notificationId': notificationId,
  });
}

Map<String, Object?>? _decodeReminderPayload(String? payload) {
  if (payload == null) return null;
  try {
    return jsonDecode(payload) as Map<String, Object?>;
  } catch (_) {
    return null;
  }
}

/// Foreground handler — the app (and its normal Riverpod `AppDatabase`) is
/// already running, but this callback fires outside the widget tree, so it
/// opens its own short-lived connection rather than reaching into a
/// provider container it doesn't have a handle to.
@pragma('vm:entry-point')
void handleNotificationResponse(NotificationResponse response) {
  _handleAction(response);
}

/// Background handler — runs in a separate isolate when the user taps
/// Done/Snooze from the notification shade without opening the app. Must
/// be a top-level (or static) function per flutter_local_notifications'
/// background-isolate contract.
@pragma('vm:entry-point')
void handleNotificationResponseBackground(NotificationResponse response) {
  _handleAction(response);
}

void _handleAction(NotificationResponse response) {
  final Map<String, Object?>? data = _decodeReminderPayload(response.payload);
  if (data == null) return;

  final String taskId = data['taskId']! as String;
  final int notificationId = data['notificationId']! as int;

  switch (response.actionId) {
    case NotificationService.actionDone:
      _markTaskDone(taskId, notificationId);
    case NotificationService.actionSnooze:
      _snoozeReminder(taskId, notificationId);
  }
}

Future<void> _markTaskDone(String taskId, int notificationId) async {
  final AppDatabase db = AppDatabase(
    NativeDatabase.createInBackground(await _dbFile()),
  );
  try {
    final Task? task = await db.taskDao.getTaskById(taskId);
    if (task != null) {
      await db.taskDao.updateTask(
        task
            .toCompanion(true)
            .copyWith(
              isCompleted: const Value<bool>(true),
              completedAt: Value<DateTime?>(DateTime.now()),
            ),
      );
    }
    await NotificationService.cancelReminder(notificationId);
  } finally {
    await db.close();
  }
}

Future<void> _snoozeReminder(String taskId, int notificationId) async {
  final AppDatabase db = AppDatabase(
    NativeDatabase.createInBackground(await _dbFile()),
  );
  try {
    final Task? task = await db.taskDao.getTaskById(taskId);
    if (task == null) return;
    final DateTime snoozeUntil = DateTime.now().toUtc().add(
      const Duration(minutes: 15),
    );
    // Goes through AlarmScheduler (not NotificationService directly) so the
    // Reminders table row's triggerTimeUtc gets updated to the new snoozed
    // time, not just the native alarm. Leaving the DB row pointing at the
    // original (now past) time was the actual bug behind "snoozed reminder
    // fires repeatedly" — the boot/app-open resync sweep (reminder_resync.dart)
    // reads that stale row on every startup, sees a trigger time already in
    // the past, and reschedules it for a couple seconds from now, silently
    // overriding the snooze every time the app was reopened.
    await AlarmScheduler(ReminderRepository(db), SettingsRepository(db)).scheduleForTask(
      taskId: taskId,
      taskTitle: task.title,
      triggerTimeUtc: snoozeUntil,
    );
  } finally {
    await db.close();
  }
}

Future<File> _dbFile() => AppDatabase.resolveDatabaseFile();
