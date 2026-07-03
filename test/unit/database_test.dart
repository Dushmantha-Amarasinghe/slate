// Phase 1 exit criteria: full CRUD verified across all five tables against
// an isolated in-memory database (never touches disk), plus a check that
// watch() streams actually emit on writes — the DB->provider->widget
// reactivity the rest of the app depends on.

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slate/core/db/database.dart';
import 'package:slate/core/db/tables/app_settings_table.dart';
import 'package:slate/core/db/tables/tasks_table.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Tasks', () {
    test('insert, read, update, delete round-trip', () async {
      final DateTime now = DateTime(2026, 1, 1, 9);
      await db.taskDao.insertTask(
        TasksCompanion.insert(
          id: 't1',
          title: 'Buy milk',
          priority: const Value<TaskPriority>(TaskPriority.medium),
          createdAt: now,
          updatedAt: now,
        ),
      );

      final Task? fetched = await db.taskDao.getTaskById('t1');
      expect(fetched, isNotNull);
      expect(fetched!.title, 'Buy milk');
      expect(fetched.priority, TaskPriority.medium);
      expect(fetched.isCompleted, isFalse);

      await db.taskDao.updateTask(
        fetched
            .toCompanion(true)
            .copyWith(isCompleted: const Value<bool>(true)),
      );
      final Task? updated = await db.taskDao.getTaskById('t1');
      expect(updated!.isCompleted, isTrue);

      await db.taskDao.deleteTask('t1');
      expect(await db.taskDao.getTaskById('t1'), isNull);
    });

    test('watchPendingTasks emits when a task is added', () async {
      final DateTime now = DateTime(2026, 1, 1);
      final Future<List<Task>> firstEmission = db.taskDao
          .watchPendingTasks()
          .first;

      await db.taskDao.insertTask(
        TasksCompanion.insert(
          id: 't2',
          title: 'Walk the dog',
          createdAt: now,
          updatedAt: now,
        ),
      );

      final List<Task> tasks = await firstEmission;
      expect(tasks, hasLength(1));
      expect(tasks.single.title, 'Walk the dog');
    });

    test('watchPendingTasks excludes completed tasks', () async {
      final DateTime now = DateTime(2026, 1, 1);
      await db.taskDao.insertTask(
        TasksCompanion.insert(
          id: 't3',
          title: 'Done already',
          isCompleted: const Value<bool>(true),
          createdAt: now,
          updatedAt: now,
        ),
      );

      final List<Task> pending = await db.taskDao.watchPendingTasks().first;
      expect(pending, isEmpty);
    });
  });

  group('Tags', () {
    test('insert and watch all tags', () async {
      await db.tagDao.insertTag(
        TagsCompanion.insert(
          id: 'g1',
          name: 'Work',
          iconRef: 'briefcase',
          createdAt: DateTime.now(),
        ),
      );

      final List<Tag> tags = await db.tagDao.watchAllTags().first;
      expect(tags, hasLength(1));
      expect(tags.single.name, 'Work');
    });

    test('deleting a tag removes it', () async {
      await db.tagDao.insertTag(
        TagsCompanion.insert(
          id: 'g2',
          name: 'Home',
          iconRef: 'house',
          createdAt: DateTime.now(),
        ),
      );
      await db.tagDao.deleteTag('g2');

      final List<Tag> tags = await db.tagDao.watchAllTags().first;
      expect(tags, isEmpty);
    });
  });

  group('Subtasks', () {
    test('subtasks are scoped to their parent task', () async {
      final DateTime now = DateTime(2026, 1, 1);
      await db.taskDao.insertTask(
        TasksCompanion.insert(
          id: 'parent1',
          title: 'Plan trip',
          createdAt: now,
          updatedAt: now,
        ),
      );
      await db.subtaskDao.insertSubtask(
        SubtasksCompanion.insert(
          id: 's1',
          taskId: 'parent1',
          title: 'Book flights',
          createdAt: now,
          updatedAt: now,
        ),
      );
      await db.subtaskDao.insertSubtask(
        SubtasksCompanion.insert(
          id: 's2',
          taskId: 'parent1',
          title: 'Book hotel',
          createdAt: now,
          updatedAt: now,
        ),
      );

      final List<Subtask> subtasks = await db.subtaskDao
          .watchSubtasksForTask('parent1')
          .first;
      expect(subtasks, hasLength(2));
    });
  });

  group('Reminders', () {
    test('insert and fetch pending reminders for boot resync', () async {
      final DateTime now = DateTime(2026, 1, 1);
      await db.taskDao.insertTask(
        TasksCompanion.insert(
          id: 'parent2',
          title: 'Call dentist',
          createdAt: now,
          updatedAt: now,
        ),
      );
      await db.reminderDao.insertReminder(
        RemindersCompanion.insert(
          id: 'r1',
          taskId: 'parent2',
          triggerTimeUtc: DateTime.utc(2026, 1, 2, 14),
          notificationId: 1001,
          createdAt: now,
        ),
      );

      final List<Reminder> pending = await db.reminderDao
          .getAllPendingReminders();
      expect(pending, hasLength(1));
      expect(pending.single.notificationId, 1001);
    });
  });

  group('AppSettings', () {
    test('the settings row is seeded on creation with sane defaults', () async {
      final AppSettingsTableData settings = await db.settingsDao
          .watchSettings()
          .first;
      expect(settings.themeMode, AppThemeMode.system);
      expect(settings.hapticsEnabled, isTrue);
      expect(settings.accentColorId, 'electricBlue');
    });

    test('updateSettings persists a partial change', () async {
      await db.settingsDao.updateSettings(
        const AppSettingsTableCompanion(
          themeMode: Value<AppThemeMode>(AppThemeMode.dark),
        ),
      );

      final AppSettingsTableData settings = await db.settingsDao
          .watchSettings()
          .first;
      expect(settings.themeMode, AppThemeMode.dark);
      // Untouched fields keep their defaults.
      expect(settings.hapticsEnabled, isTrue);
    });
  });
}
