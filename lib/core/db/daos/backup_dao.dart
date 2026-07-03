import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/app_settings_table.dart';
import '../tables/reminders_table.dart';
import '../tables/subtasks_table.dart';
import '../tables/tags_table.dart';
import '../tables/tasks_table.dart';

part 'backup_dao.g.dart';

/// Bulk read/write across every user-data table, used only by
/// [DataManagementService] for JSON export/import and "delete all data" —
/// everyday CRUD goes through the per-table DAOs instead.
@DriftAccessor(
  tables: <Type>[Tasks, Tags, Subtasks, Reminders, AppSettingsTable],
)
class BackupDao extends DatabaseAccessor<AppDatabase> with _$BackupDaoMixin {
  BackupDao(super.db);

  Future<List<Tag>> getAllTagsOnce() => select(tags).get();
  Future<List<Task>> getAllTasksOnce() => select(tasks).get();
  Future<List<Subtask>> getAllSubtasksOnce() => select(subtasks).get();
  Future<List<Reminder>> getAllRemindersOnce() => select(reminders).get();

  Future<AppSettingsTableData> getSettingsOnce() =>
      (select(appSettingsTable)
            ..where((AppSettingsTable s) => s.id.equals(0)))
          .getSingle();

  /// Wipes every existing row and replaces it with the backup's contents —
  /// used by the import flow's "Replace" choice.
  Future<void> replaceAll({
    required List<TagsCompanion> tagsData,
    required List<TasksCompanion> tasksData,
    required List<SubtasksCompanion> subtasksData,
    required List<RemindersCompanion> remindersData,
    AppSettingsTableCompanion? settingsData,
  }) {
    return transaction(() async {
      await delete(reminders).go();
      await delete(subtasks).go();
      await delete(tasks).go();
      await delete(tags).go();
      await batch((Batch b) {
        b.insertAll(tags, tagsData);
        b.insertAll(tasks, tasksData);
        b.insertAll(subtasks, subtasksData);
        b.insertAll(reminders, remindersData);
      });
      if (settingsData != null) {
        await (update(
          appSettingsTable,
        )..where((AppSettingsTable s) => s.id.equals(0))).write(settingsData);
      }
    });
  }

  /// Upserts the backup's rows on top of what's already there — used by the
  /// import flow's "Merge" choice. IDs are UUIDs, so a row from the backup
  /// overwrites the existing row with the same id rather than duplicating it.
  Future<void> mergeAll({
    required List<TagsCompanion> tagsData,
    required List<TasksCompanion> tasksData,
    required List<SubtasksCompanion> subtasksData,
    required List<RemindersCompanion> remindersData,
  }) {
    return transaction(() async {
      await batch((Batch b) {
        b.insertAll(tags, tagsData, mode: InsertMode.insertOrReplace);
        b.insertAll(tasks, tasksData, mode: InsertMode.insertOrReplace);
        b.insertAll(subtasks, subtasksData, mode: InsertMode.insertOrReplace);
        b.insertAll(
          reminders,
          remindersData,
          mode: InsertMode.insertOrReplace,
        );
      });
    });
  }

  /// Deletes every task/tag/subtask/reminder row. Voice note files on disk
  /// and OS-scheduled alarms are the caller's responsibility (see
  /// [DataManagementService.deleteAllData]) since this DAO only touches SQL.
  Future<void> deleteAllRows() {
    return transaction(() async {
      await delete(reminders).go();
      await delete(subtasks).go();
      await delete(tasks).go();
      await delete(tags).go();
    });
  }
}
