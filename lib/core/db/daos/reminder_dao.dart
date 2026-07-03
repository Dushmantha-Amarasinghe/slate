import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/reminders_table.dart';

part 'reminder_dao.g.dart';

@DriftAccessor(tables: <Type>[Reminders])
class ReminderDao extends DatabaseAccessor<AppDatabase>
    with _$ReminderDaoMixin {
  ReminderDao(super.db);

  Future<int> insertReminder(RemindersCompanion reminder) =>
      into(reminders).insert(reminder);

  Future<bool> updateReminder(RemindersCompanion reminder) =>
      update(reminders).replace(reminder);

  Future<int> deleteReminder(String id) =>
      (delete(reminders)..where((Reminders r) => r.id.equals(id))).go();

  Future<int> deleteRemindersForTask(String taskId) =>
      (delete(reminders)..where((Reminders r) => r.taskId.equals(taskId))).go();

  Future<Reminder?> getReminderForTask(String taskId) => (select(
    reminders,
  )..where((Reminders r) => r.taskId.equals(taskId))).getSingleOrNull();

  Stream<List<Reminder>> watchRemindersForTask(String taskId) {
    final SimpleSelectStatement<Reminders, Reminder> query = select(reminders)
      ..where((Reminders r) => r.taskId.equals(taskId));
    return query.watch();
  }

  /// All non-snoozed-past reminders — the boot/timezone-change resync sweep
  /// (Phase 3) reschedules every row this returns, since exact alarms don't
  /// survive a reboot.
  Future<List<Reminder>> getAllPendingReminders() => select(reminders).get();
}
