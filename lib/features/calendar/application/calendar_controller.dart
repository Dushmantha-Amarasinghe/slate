import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../all_tasks/application/all_tasks_controller.dart';

enum CalendarViewMode { week, month }

DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

/// The month/week currently visible in the grid — changed by the prev/next
/// arrows or the "Today" button. Kept separate from [calendarSelectedDateProvider]
/// so navigating months doesn't clobber which day's tasks are shown below.
final StateProvider<DateTime> calendarFocusedDateProvider = StateProvider<DateTime>(
  (Ref ref) => _dateOnly(DateTime.now()),
);

/// The day whose tasks are listed below the grid.
final StateProvider<DateTime> calendarSelectedDateProvider = StateProvider<DateTime>(
  (Ref ref) => _dateOnly(DateTime.now()),
);

final StateProvider<CalendarViewMode> calendarViewModeProvider = StateProvider<CalendarViewMode>(
  (Ref ref) => CalendarViewMode.month,
);

/// Pure so it's independently testable — groups tasks with a due date by
/// calendar day (time-of-day stripped). Undated tasks have no day to
/// appear under, so they're excluded; All Tasks already covers those.
Map<DateTime, List<Task>> groupTasksByDueDate(List<Task> tasks) {
  final Map<DateTime, List<Task>> grouped = <DateTime, List<Task>>{};
  for (final Task task in tasks) {
    final DateTime? due = task.dueDateTimeLocal;
    if (due == null) continue;
    final DateTime day = _dateOnly(due);
    grouped.putIfAbsent(day, () => <Task>[]).add(task);
  }
  return grouped;
}

final Provider<Map<DateTime, List<Task>>> tasksByDueDateProvider = Provider<Map<DateTime, List<Task>>>(
  (Ref ref) {
    final List<Task> tasks = ref.watch(allTasksProvider).value ?? const <Task>[];
    return groupTasksByDueDate(tasks);
  },
);
