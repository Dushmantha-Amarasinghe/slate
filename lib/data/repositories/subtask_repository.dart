import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';

const Uuid _uuid = Uuid();

class SubtaskRepository {
  SubtaskRepository(this._db);

  final AppDatabase _db;

  Stream<List<Subtask>> watchForTask(String taskId) =>
      _db.subtaskDao.watchSubtasksForTask(taskId);

  Future<String> addSubtask({
    required String taskId,
    required String title,
    int sortOrder = 0,
  }) async {
    final String id = _uuid.v4();
    final DateTime now = DateTime.now();
    await _db.subtaskDao.insertSubtask(
      SubtasksCompanion.insert(
        id: id,
        taskId: taskId,
        title: title,
        sortOrder: Value<int>(sortOrder),
        createdAt: now,
        updatedAt: now,
      ),
    );
    return id;
  }

  Future<void> setCompleted(Subtask subtask, bool isCompleted) {
    return _db.subtaskDao.updateSubtask(
      subtask
          .toCompanion(true)
          .copyWith(
            isCompleted: Value<bool>(isCompleted),
            updatedAt: Value<DateTime>(DateTime.now()),
          ),
    );
  }

  Future<void> deleteSubtask(String id) => _db.subtaskDao.deleteSubtask(id);
}

final Provider<SubtaskRepository> subtaskRepositoryProvider =
    Provider<SubtaskRepository>((Ref ref) {
      return SubtaskRepository(ref.watch(appDatabaseProvider));
    });
