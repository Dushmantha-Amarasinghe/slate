import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';
import '../../core/db/tables/tasks_table.dart';

const Uuid _uuid = Uuid();

/// Thin domain-facing layer over [TaskDao] — features depend on this, never
/// on the DAO directly, so query-shape changes stay isolated to one file.
class TaskRepository {
  TaskRepository(this._db);

  final AppDatabase _db;

  Stream<List<Task>> watchPending() => _db.taskDao.watchPendingTasks();

  Stream<List<Task>> watchCompleted() => _db.taskDao.watchCompletedTasks();

  Stream<List<Task>> watchAll() => _db.taskDao.watchAllTasks();

  Stream<List<Task>> watchDueBetween(DateTime start, DateTime end) =>
      _db.taskDao.watchTasksDueBetween(start, end);

  Future<Task?> getById(String id) => _db.taskDao.getTaskById(id);

  Stream<Task?> watchById(String id) => _db.taskDao.watchTaskById(id);

  Future<String> addTask({
    required String title,
    String? description,
    DateTime? dueDateTimeLocal,
    bool dueDateHasTime = true,
    String? timezoneId,
    TaskPriority priority = TaskPriority.none,
    String? tagId,
    bool isRecurring = false,
    String? recurrenceRule,
    String? voiceNotePath,
  }) async {
    final String id = _uuid.v4();
    final DateTime now = DateTime.now();
    await _db.taskDao.insertTask(
      TasksCompanion.insert(
        id: id,
        title: title,
        description: Value<String?>(description),
        dueDateTimeLocal: Value<DateTime?>(dueDateTimeLocal),
        dueDateHasTime: Value<bool>(dueDateHasTime),
        timezoneId: Value<String?>(timezoneId),
        priority: Value<TaskPriority>(priority),
        tagId: Value<String?>(tagId),
        isRecurring: Value<bool>(isRecurring),
        recurrenceRule: Value<String?>(recurrenceRule),
        voiceNotePath: Value<String?>(voiceNotePath),
        createdAt: now,
        updatedAt: now,
      ),
    );
    return id;
  }

  Future<void> editTask({
    required String id,
    required String title,
    String? description,
    DateTime? dueDateTimeLocal,
    bool dueDateHasTime = true,
    String? timezoneId,
    TaskPriority priority = TaskPriority.none,
    String? tagId,
    bool isRecurring = false,
    String? recurrenceRule,
    String? voiceNotePath,
  }) async {
    final Task? existing = await getById(id);
    if (existing == null) return;
    await _db.taskDao.updateTask(
      existing
          .toCompanion(true)
          .copyWith(
            title: Value<String>(title),
            description: Value<String?>(description),
            dueDateTimeLocal: Value<DateTime?>(dueDateTimeLocal),
            dueDateHasTime: Value<bool>(dueDateHasTime),
            timezoneId: Value<String?>(timezoneId),
            priority: Value<TaskPriority>(priority),
            tagId: Value<String?>(tagId),
            isRecurring: Value<bool>(isRecurring),
            recurrenceRule: Value<String?>(recurrenceRule),
            voiceNotePath: Value<String?>(voiceNotePath),
            updatedAt: Value<DateTime>(DateTime.now()),
          ),
    );
  }

  Future<void> setCompleted(String id, bool isCompleted) async {
    final Task? task = await getById(id);
    if (task == null) return;
    await _db.taskDao.updateTask(
      task
          .toCompanion(true)
          .copyWith(
            isCompleted: Value<bool>(isCompleted),
            completedAt: Value<DateTime?>(isCompleted ? DateTime.now() : null),
            updatedAt: Value<DateTime>(DateTime.now()),
          ),
    );
  }

  Future<void> deleteTask(String id) => _db.taskDao.deleteTask(id);
}

final Provider<TaskRepository> taskRepositoryProvider =
    Provider<TaskRepository>((Ref ref) {
      return TaskRepository(ref.watch(appDatabaseProvider));
    });
