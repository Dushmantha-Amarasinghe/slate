import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../db/database_provider.dart';
import '../db/tables/app_settings_table.dart';
import '../../features/settings/application/settings_controller.dart';
import '../../features/today/application/today_controller.dart';

/// One row's worth of what the widget needs — [subtaskProgress] is a
/// pre-formatted "2/5" label (null when the task has no subtasks) rather
/// than raw counts, since the native RemoteViews layout just drops this
/// straight into a TextView with no formatting logic of its own.
class WidgetTaskRow {
  const WidgetTaskRow({required this.id, required this.title, this.subtaskProgress});

  final String id;
  final String title;
  final String? subtaskProgress;
}

/// Pure so it's directly unit-testable and so
/// core/widget/widget_background_handler.dart (a separate isolate with no
/// ProviderContainer) can build the same rows after a background
/// mark-complete tap.
List<WidgetTaskRow> buildWidgetRows(List<Task> tasks, List<Subtask> allSubtasks) {
  final Map<String, List<Subtask>> subtasksByTaskId = <String, List<Subtask>>{};
  for (final Subtask subtask in allSubtasks) {
    subtasksByTaskId.putIfAbsent(subtask.taskId, () => <Subtask>[]).add(subtask);
  }

  return <WidgetTaskRow>[
    for (final Task task in tasks)
      WidgetTaskRow(
        id: task.id,
        title: task.title,
        subtaskProgress: () {
          final List<Subtask>? subtasks = subtasksByTaskId[task.id];
          if (subtasks == null || subtasks.isEmpty) return null;
          final int completed = subtasks.where((Subtask s) => s.isCompleted).length;
          return '$completed/${subtasks.length}';
        }(),
      ),
  ];
}

/// Tasks the home screen widget should show — pending tasks due today, plus
/// overdue ones when Settings > Widget's filter mode is
/// [WidgetFilterMode.todayPlusOverdue] — sorted soonest-due first and capped
/// to the configured row count. Tasks with no due date are excluded: a
/// glance widget is about what's time-relevant right now, not the whole
/// backlog (that's what the app's Today tab is for).
///
/// A plain top-level function (not folded directly into the provider below)
/// so [core/widget/widget_background_handler.dart] — which runs in a
/// separate isolate with no ProviderContainer to watch — can recompute the
/// same list after a background mark-complete tap, without duplicating the
/// filter rules.
List<Task> filterTasksForWidget(List<Task> pending, AppSettingsTableData settings) {
  if (pending.isEmpty) return const <Task>[];

  final DateTime now = DateTime.now();
  final DateTime todayStart = DateTime(now.year, now.month, now.day);
  final DateTime todayEnd = todayStart.add(const Duration(days: 1));

  bool isDueToday(Task task) {
    final DateTime? due = task.dueDateTimeLocal;
    if (due == null) return false;
    return !due.isBefore(todayStart) && due.isBefore(todayEnd);
  }

  bool isOverdue(Task task) {
    final DateTime? due = task.dueDateTimeLocal;
    if (due == null) return false;
    return due.isBefore(todayStart);
  }

  final List<Task> filtered = pending.where((Task task) {
    if (isDueToday(task)) return true;
    return settings.widgetFilterMode == WidgetFilterMode.todayPlusOverdue && isOverdue(task);
  }).toList()..sort((Task a, Task b) => a.dueDateTimeLocal!.compareTo(b.dueDateTimeLocal!));

  final int rowCount = settings.widgetTaskCount.clamp(0, 5);
  return filtered.take(rowCount).toList();
}

final Provider<List<Task>> widgetVisibleTasksProvider = Provider<List<Task>>((Ref ref) {
  final List<Task> pending = ref.watch(pendingTasksProvider).value ?? const <Task>[];
  final AppSettingsTableData? settings = ref.watch(settingsProvider).value;
  if (settings == null) return const <Task>[];
  return filterTasksForWidget(pending, settings);
});

final StreamProvider<List<Subtask>> allSubtasksProvider = StreamProvider<List<Subtask>>((Ref ref) {
  return ref.watch(appDatabaseProvider).subtaskDao.watchAllSubtasks();
});

/// What the widget should currently show (list, with subtask progress)
/// plus how it should behave on tap — bundled into one provider so a
/// single listener (see app.dart) re-pushes to the native widget on any of
/// these changing, including a tap-action change with no task-list change
/// alongside it.
final Provider<(List<WidgetTaskRow>, WidgetTapAction)> widgetSyncDataProvider =
    Provider<(List<WidgetTaskRow>, WidgetTapAction)>((Ref ref) {
      final List<Task> tasks = ref.watch(widgetVisibleTasksProvider);
      final List<Subtask> subtasks = ref.watch(allSubtasksProvider).value ?? const <Subtask>[];
      final WidgetTapAction tapAction =
          ref.watch(settingsProvider).value?.widgetTapAction ?? WidgetTapAction.openDetail;
      return (buildWidgetRows(tasks, subtasks), tapAction);
    });
