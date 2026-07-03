// Exercises the real MigrationStrategy in lib/core/db/database.dart against
// hand-built "old schema" database files, since drift_dev's schema-snapshot
// tooling can only export the *current* schema — there's no historical v1/v2
// snapshot to verify against. The CREATE TABLE statements below are the
// current schema's real SQL (each table's DAO/table definition) with the
// column each migration step adds removed again, which is exactly what a
// real user's on-disk database looked like before updating. After each
// migration runs, `validateDatabaseSchema()` (drift_dev's own schema
// verification helper) checks the *entire* resulting schema — not just the
// couple of columns asserted below — against what the current Dart table
// definitions expect, so a migration step that's subtly wrong (wrong type,
// missing constraint, etc.) fails loudly here instead of surfacing as data
// corruption on a real device.

import 'dart:io';

import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:slate/core/db/database.dart';
import 'package:slate/core/db/tables/app_settings_table.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;

const String _tagsSql =
    'CREATE TABLE "tags" ("id" TEXT NOT NULL, "name" TEXT NOT NULL, '
    '"icon_ref" TEXT NOT NULL, "created_at" INTEGER NOT NULL, '
    'PRIMARY KEY ("id"), UNIQUE ("name"));';

const String _subtasksSql =
    'CREATE TABLE "subtasks" ("id" TEXT NOT NULL, "task_id" TEXT NOT NULL '
    'REFERENCES tasks (id), "title" TEXT NOT NULL, "is_completed" INTEGER '
    'NOT NULL DEFAULT 0 CHECK ("is_completed" IN (0, 1)), "sort_order" '
    'INTEGER NOT NULL DEFAULT 0, "created_at" INTEGER NOT NULL, '
    '"updated_at" INTEGER NOT NULL, PRIMARY KEY ("id"));';

const String _remindersSql =
    'CREATE TABLE "reminders" ("id" TEXT NOT NULL, "task_id" TEXT NOT NULL '
    'REFERENCES tasks (id), "trigger_time_utc" INTEGER NOT NULL, '
    '"is_snoozed" INTEGER NOT NULL DEFAULT 0 CHECK ("is_snoozed" IN (0, 1)), '
    '"snooze_until_utc" INTEGER NULL, "notification_id" INTEGER NOT NULL, '
    '"created_at" INTEGER NOT NULL, PRIMARY KEY ("id"));';

/// v1 shape: no `due_date_has_time` on tasks, no `widget_tap_action` on
/// app_settings_table (both added by later migration steps).
String _tasksSqlV1() =>
    'CREATE TABLE "tasks" ("id" TEXT NOT NULL, "title" TEXT NOT NULL, '
    '"description" TEXT NULL, "due_date_time_local" INTEGER NULL, '
    '"timezone_id" TEXT NULL, "is_recurring" INTEGER NOT NULL DEFAULT 0 '
    'CHECK ("is_recurring" IN (0, 1)), "recurrence_rule" TEXT NULL, '
    '"priority" INTEGER NOT NULL DEFAULT 0, "tag_id" TEXT NULL REFERENCES '
    'tags (id), "voice_note_path" TEXT NULL, "is_completed" INTEGER NOT '
    'NULL DEFAULT 0 CHECK ("is_completed" IN (0, 1)), "completed_at" '
    'INTEGER NULL, "sort_order" INTEGER NOT NULL DEFAULT 0, "created_at" '
    'INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("id"));';

/// v2 shape: tasks already has `due_date_has_time`, app_settings_table
/// still lacks `widget_tap_action`.
String _tasksSqlV2() =>
    'CREATE TABLE "tasks" ("id" TEXT NOT NULL, "title" TEXT NOT NULL, '
    '"description" TEXT NULL, "due_date_time_local" INTEGER NULL, '
    '"timezone_id" TEXT NULL, "due_date_has_time" INTEGER NOT NULL '
    'DEFAULT 1 CHECK ("due_date_has_time" IN (0, 1)), "is_recurring" '
    'INTEGER NOT NULL DEFAULT 0 CHECK ("is_recurring" IN (0, 1)), '
    '"recurrence_rule" TEXT NULL, "priority" INTEGER NOT NULL DEFAULT 0, '
    '"tag_id" TEXT NULL REFERENCES tags (id), "voice_note_path" TEXT NULL, '
    '"is_completed" INTEGER NOT NULL DEFAULT 0 CHECK ("is_completed" IN '
    '(0, 1)), "completed_at" INTEGER NULL, "sort_order" INTEGER NOT NULL '
    'DEFAULT 0, "created_at" INTEGER NOT NULL, "updated_at" INTEGER NOT '
    'NULL, PRIMARY KEY ("id"));';

String _appSettingsSql({required bool includeWidgetTapAction}) {
  final String widgetTapActionColumn = includeWidgetTapAction
      ? ', "widget_tap_action" INTEGER NOT NULL DEFAULT 0'
      : '';
  return 'CREATE TABLE "app_settings_table" ("id" INTEGER NOT NULL DEFAULT '
      '0, "theme_mode" INTEGER NOT NULL DEFAULT 0, "accent_color_id" TEXT '
      'NOT NULL DEFAULT \'electricBlue\', "swipe_direction" INTEGER NOT '
      'NULL DEFAULT 0, "haptics_enabled" INTEGER NOT NULL DEFAULT 1 CHECK '
      '("haptics_enabled" IN (0, 1)), "sound_enabled" INTEGER NOT NULL '
      'DEFAULT 1 CHECK ("sound_enabled" IN (0, 1)), "reduce_motion" '
      'INTEGER NOT NULL DEFAULT 0 CHECK ("reduce_motion" IN (0, 1)), '
      '"default_sort" INTEGER NOT NULL DEFAULT 0, "default_grouping" '
      'INTEGER NOT NULL DEFAULT 0, "week_start_day" INTEGER NOT NULL '
      'DEFAULT 0, "default_priority" INTEGER NOT NULL DEFAULT 0, '
      '"default_reminder_lead_minutes" INTEGER NOT NULL DEFAULT 0, '
      '"snooze_options_minutes_json" TEXT NOT NULL DEFAULT '
      '\'[15,60,1440]\', "widget_task_count" INTEGER NOT NULL DEFAULT 5, '
      '"widget_filter_mode" INTEGER NOT NULL DEFAULT 1'
      '$widgetTapActionColumn, PRIMARY KEY ("id"));';
}

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('slate_migration_test');
  });

  tearDown(() {
    if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
  });

  test('migrates a v1 database up to v3, preserving data and backfilling new columns', () async {
    final File file = File(p.join(tempDir.path, 'v1.sqlite'));
    final sqlite3.Database raw = sqlite3.sqlite3.open(file.path);
    raw.execute(<String>[
      _tagsSql,
      _tasksSqlV1(),
      _subtasksSql,
      _remindersSql,
      _appSettingsSql(includeWidgetTapAction: false),
    ].join('\n'));
    raw.execute('''
      INSERT INTO tags (id, name, icon_ref, created_at) VALUES ('tag1', 'Work', 'briefcase', 1700000000000);
      INSERT INTO tasks (id, title, description, due_date_time_local, timezone_id, is_recurring, recurrence_rule, priority, tag_id, voice_note_path, is_completed, completed_at, sort_order, created_at, updated_at)
      VALUES ('task1', 'Pre-migration task', NULL, NULL, NULL, 0, NULL, 0, 'tag1', NULL, 0, NULL, 0, 1700000000000, 1700000000000);
      INSERT INTO app_settings_table (id) VALUES (0);
    ''');
    raw.execute('PRAGMA user_version = 1;');
    raw.dispose();

    final AppDatabase migrated = AppDatabase(NativeDatabase(file));
    final List<Task> tasks = await migrated.select(migrated.tasks).get();
    expect(tasks, hasLength(1));
    expect(tasks.single.id, 'task1');
    expect(tasks.single.title, 'Pre-migration task');
    // Backfilled by the v1->v2 migration's column default.
    expect(tasks.single.dueDateHasTime, isTrue);

    final AppSettingsTableData settings = await migrated.settingsDao.watchSettings().first;
    // Backfilled by the v2->v3 migration's column default.
    expect(settings.widgetTapAction, WidgetTapAction.openDetail);

    await migrated.validateDatabaseSchema();
    await migrated.close();
  });

  test('migrates a v2 database up to v3, preserving data and backfilling the new column', () async {
    final File file = File(p.join(tempDir.path, 'v2.sqlite'));
    final sqlite3.Database raw = sqlite3.sqlite3.open(file.path);
    raw.execute(<String>[
      _tagsSql,
      _tasksSqlV2(),
      _subtasksSql,
      _remindersSql,
      _appSettingsSql(includeWidgetTapAction: false),
    ].join('\n'));
    raw.execute('''
      INSERT INTO tasks (id, title, description, due_date_time_local, timezone_id, due_date_has_time, is_recurring, recurrence_rule, priority, tag_id, voice_note_path, is_completed, completed_at, sort_order, created_at, updated_at)
      VALUES ('task2', 'Already has time flag', NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, 0, NULL, 0, 1700000000000, 1700000000000);
      INSERT INTO app_settings_table (id) VALUES (0);
    ''');
    raw.execute('PRAGMA user_version = 2;');
    raw.dispose();

    final AppDatabase migrated = AppDatabase(NativeDatabase(file));
    final List<Task> tasks = await migrated.select(migrated.tasks).get();
    expect(tasks, hasLength(1));
    expect(tasks.single.dueDateHasTime, isFalse); // pre-existing value, untouched by the v2->v3 step

    final AppSettingsTableData settings = await migrated.settingsDao.watchSettings().first;
    expect(settings.widgetTapAction, WidgetTapAction.openDetail);

    await migrated.validateDatabaseSchema();
    await migrated.close();
  });
}
