import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/db/database.dart';
import '../core/notifications/alarm_scheduler.dart';
import '../core/utils/recurrence_utils.dart';
import '../core/voice/audio_file_store.dart';
import 'repositories/task_repository.dart';

/// Composes [TaskRepository] with [AlarmScheduler] so every call site
/// (Today, All Tasks, Task Detail) deletes/completes a task through one
/// place instead of each remembering to also cancel its OS-level alarm —
/// a plain `taskRepository.deleteTask()` would leave a stale notification
/// scheduled for a task that no longer exists.
class TaskActions {
  TaskActions(this._tasks, this._alarms);

  final TaskRepository _tasks;
  final AlarmScheduler _alarms;

  Future<void> deleteTask(String id) async {
    final Task? task = await _tasks.getById(id);
    await _alarms.cancelForTask(id);
    await _tasks.deleteTask(id);
    // Deleting the DB row doesn't touch the recording on disk — without
    // this it'd be orphaned forever, since nothing else references it.
    await AudioFileStore.deleteIfExists(task?.voiceNotePath);
  }

  /// Marks a task complete. If it's recurring, generates the next
  /// occurrence as a new pending task (with its own reminder scheduled)
  /// so completion history on the current row stays intact for future
  /// streak/stats calculations.
  Future<void> completeTask(String id) async {
    final Task? task = await _tasks.getById(id);
    if (task == null) return;

    await _alarms.cancelForTask(id);
    await _tasks.setCompleted(id, true);

    if (!task.isRecurring || task.dueDateTimeLocal == null) return;

    final Recurrence recurrence = Recurrence.decode(task.recurrenceRule);
    final DateTime? next = recurrence.nextOccurrence(task.dueDateTimeLocal!);
    if (next == null) return;

    final String newId = await _tasks.addTask(
      title: task.title,
      description: task.description,
      dueDateTimeLocal: next,
      dueDateHasTime: task.dueDateHasTime,
      timezoneId: task.timezoneId,
      priority: task.priority,
      tagId: task.tagId,
      isRecurring: true,
      recurrenceRule: task.recurrenceRule,
    );

    // A date-only due date has no specific moment to fire an exact alarm
    // at, so it never gets a reminder scheduled — same rule the task
    // editor applies when the task is first created (see
    // task_editor_sheet.dart's _save).
    if (task.timezoneId != null && task.dueDateHasTime) {
      await _alarms.scheduleForTask(
        taskId: newId,
        taskTitle: task.title,
        triggerTimeUtc: next.toUtc(),
      );
    }
  }

  Future<void> uncompleteTask(String id) => _tasks.setCompleted(id, false);
}

final Provider<TaskActions> taskActionsProvider = Provider<TaskActions>((
  Ref ref,
) {
  return TaskActions(
    ref.watch(taskRepositoryProvider),
    ref.watch(alarmSchedulerProvider),
  );
});
