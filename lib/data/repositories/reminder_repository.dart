import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';

const Uuid _uuid = Uuid();

class ReminderRepository {
  ReminderRepository(this._db);

  final AppDatabase _db;

  Stream<List<Reminder>> watchForTask(String taskId) =>
      _db.reminderDao.watchRemindersForTask(taskId);

  /// Used by the Phase 3 boot/timezone-change resync sweep to reschedule
  /// every stored reminder, since exact alarms don't survive a reboot.
  Future<List<Reminder>> getAllPending() =>
      _db.reminderDao.getAllPendingReminders();

  Future<String> addReminder({
    required String taskId,
    required DateTime triggerTimeUtc,
    required int notificationId,
  }) async {
    final String id = _uuid.v4();
    await _db.reminderDao.insertReminder(
      RemindersCompanion.insert(
        id: id,
        taskId: taskId,
        triggerTimeUtc: triggerTimeUtc,
        notificationId: notificationId,
        createdAt: DateTime.now(),
      ),
    );
    return id;
  }

  Future<void> deleteReminder(String id) => _db.reminderDao.deleteReminder(id);

  Future<void> deleteForTask(String taskId) =>
      _db.reminderDao.deleteRemindersForTask(taskId);

  Future<Reminder?> getForTask(String taskId) =>
      _db.reminderDao.getReminderForTask(taskId);
}

final Provider<ReminderRepository> reminderRepositoryProvider =
    Provider<ReminderRepository>((Ref ref) {
      return ReminderRepository(ref.watch(appDatabaseProvider));
    });
