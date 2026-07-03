import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/subtasks_table.dart';

part 'subtask_dao.g.dart';

@DriftAccessor(tables: <Type>[Subtasks])
class SubtaskDao extends DatabaseAccessor<AppDatabase> with _$SubtaskDaoMixin {
  SubtaskDao(super.db);

  Future<int> insertSubtask(SubtasksCompanion subtask) =>
      into(subtasks).insert(subtask);

  Future<bool> updateSubtask(SubtasksCompanion subtask) =>
      update(subtasks).replace(subtask);

  Future<int> deleteSubtask(String id) =>
      (delete(subtasks)..where((Subtasks s) => s.id.equals(id))).go();

  Stream<List<Subtask>> watchSubtasksForTask(String taskId) {
    final SimpleSelectStatement<Subtasks, Subtask> query = select(subtasks)
      ..where((Subtasks s) => s.taskId.equals(taskId))
      ..orderBy(<OrderClauseGenerator<Subtasks>>[
        (Subtasks s) => OrderingTerm.asc(s.sortOrder),
      ]);
    return query.watch();
  }

  /// Every subtask across every task — used to compute per-task progress
  /// (e.g. the home screen widget's "2/5" row label) without a query per
  /// task. Personal task/subtask counts are small enough that this is
  /// cheaper than N+1 per-task watches.
  Stream<List<Subtask>> watchAllSubtasks() => select(subtasks).watch();

  Future<List<Subtask>> getAllSubtasks() => select(subtasks).get();
}
