import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/backup_dao.dart';
import 'daos/reminder_dao.dart';
import 'daos/settings_dao.dart';
import 'daos/subtask_dao.dart';
import 'daos/tag_dao.dart';
import 'daos/task_dao.dart';
import 'tables/app_settings_table.dart';
import 'tables/reminders_table.dart';
import 'tables/subtasks_table.dart';
import 'tables/tags_table.dart';
import 'tables/tasks_table.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: <Type>[Tasks, Tags, Subtasks, Reminders, AppSettingsTable],
  daos: <Type>[TaskDao, TagDao, SubtaskDao, ReminderDao, SettingsDao, BackupDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  /// For tests: an isolated in-memory database, never touching disk.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      // Seed the single settings row so callers can always assume it exists
      // rather than null-checking a row that "might not have been created yet".
      // `id` must be passed explicitly: SQLite auto-assigns the rowid for an
      // omitted INTEGER PRIMARY KEY column regardless of its SQL DEFAULT, so
      // leaving it absent here would silently seed row id=1, not id=0.
      await into(
        appSettingsTable,
      ).insert(const AppSettingsTableCompanion(id: Value<int>(0)));
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // v1 -> v2: date-only due dates (Tasks.dueDateHasTime), see
      // lib/core/db/tables/tasks_table.dart.
      if (from < 2) {
        await m.addColumn(tasks, tasks.dueDateHasTime);
      }
      // v2 -> v3: widget tap-action customization
      // (AppSettingsTable.widgetTapAction), see
      // lib/core/db/tables/app_settings_table.dart.
      if (from < 3) {
        await m.addColumn(appSettingsTable, appSettingsTable.widgetTapAction);
      }
      // v3 -> v4: urgent (alarm-sound) reminder channel option, see
      // lib/core/db/tables/app_settings_table.dart.
      if (from < 4) {
        await m.addColumn(appSettingsTable, appSettingsTable.urgentReminderSound);
      }
    },
    // Each future schema bump gets one explicit step here, added under
    // lib/core/db/migrations/ per the project's migration convention —
    // never a drop/recreate of a table that's already shipped.
  );

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final File file = await resolveDatabaseFile();
      return NativeDatabase.createInBackground(file);
    });
  }

  /// The single source of truth for where the on-disk database lives —
  /// shared with the notification-action background isolate
  /// (core/notifications/notification_actions.dart), which opens its own
  /// connection and must resolve the exact same file.
  static Future<File> resolveDatabaseFile() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, 'slate.sqlite'));
  }
}
