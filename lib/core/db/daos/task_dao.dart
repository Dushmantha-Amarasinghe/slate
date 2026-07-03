import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/tasks_table.dart';

part 'task_dao.g.dart';

@DriftAccessor(tables: <Type>[Tasks])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  TaskDao(super.db);

  Future<int> insertTask(TasksCompanion task) => into(tasks).insert(task);

  Future<bool> updateTask(TasksCompanion task) => update(tasks).replace(task);

  Future<int> deleteTask(String id) =>
      (delete(tasks)..where((Tasks t) => t.id.equals(id))).go();

  Future<Task?> getTaskById(String id) =>
      (select(tasks)..where((Tasks t) => t.id.equals(id))).getSingleOrNull();

  Stream<Task?> watchTaskById(String id) =>
      (select(tasks)..where((Tasks t) => t.id.equals(id))).watchSingleOrNull();

  Stream<List<Task>> watchAllTasks() => select(tasks).watch();

  Stream<List<Task>> watchPendingTasks() {
    final SimpleSelectStatement<Tasks, Task> query = select(tasks)
      ..where((Tasks t) => t.isCompleted.equals(false))
      ..orderBy(<OrderClauseGenerator<Tasks>>[
        (Tasks t) => OrderingTerm.asc(t.dueDateTimeLocal),
      ]);
    return query.watch();
  }

  Stream<List<Task>> watchCompletedTasks() {
    final SimpleSelectStatement<Tasks, Task> query = select(tasks)
      ..where((Tasks t) => t.isCompleted.equals(true))
      ..orderBy(<OrderClauseGenerator<Tasks>>[
        (Tasks t) => OrderingTerm.desc(t.completedAt),
      ]);
    return query.watch();
  }

  /// Tasks due within [start, end) — used for the Today view.
  Stream<List<Task>> watchTasksDueBetween(DateTime start, DateTime end) {
    final SimpleSelectStatement<Tasks, Task> query = select(tasks)
      ..where(
        (Tasks t) =>
            t.dueDateTimeLocal.isBiggerOrEqualValue(start) &
            t.dueDateTimeLocal.isSmallerThanValue(end),
      );
    return query.watch();
  }
}
