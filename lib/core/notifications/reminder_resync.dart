import '../db/database.dart';
import 'notification_service.dart';

/// Re-applies every stored reminder to the OS alarm scheduler. Exact alarms
/// don't survive a reboot on their own, and flutter_local_notifications'
/// own boot receiver only covers the common case — this sweep is the
/// belt-and-suspenders safety net that runs on every app startup, so the
/// DB (source of truth) and the OS scheduler can never drift for long.
/// Also doubles as timezone-change recovery: [NotificationService.initialize]
/// re-reads the device's current zone before this runs, so rescheduling
/// against the same stored UTC instant recomputes the correct local trigger.
Future<void> resyncAllReminders(AppDatabase db) async {
  final List<Reminder> reminders = await db.reminderDao
      .getAllPendingReminders();

  for (final Reminder reminder in reminders) {
    final Task? task = await db.taskDao.getTaskById(reminder.taskId);
    final bool stale = task == null || task.isCompleted;

    if (stale) {
      await NotificationService.cancelReminder(reminder.notificationId);
      await db.reminderDao.deleteReminder(reminder.id);
      continue;
    }

    // A reminder whose trigger time already passed while the app wasn't
    // running (a normal case — closing the app through a reminder time is
    // not an edge case) can't be zonedSchedule'd for the past. Fire it
    // almost immediately instead of silently dropping it, so a missed
    // reminder still surfaces once the app is reopened.
    final DateTime nowUtc = DateTime.now().toUtc();
    final DateTime triggerTimeUtc = reminder.triggerTimeUtc.isAfter(nowUtc)
        ? reminder.triggerTimeUtc
        : nowUtc.add(const Duration(seconds: 2));

    await NotificationService.scheduleReminder(
      notificationId: reminder.notificationId,
      taskId: task.id,
      taskTitle: task.title,
      triggerTimeUtc: triggerTimeUtc,
    );
  }
}
