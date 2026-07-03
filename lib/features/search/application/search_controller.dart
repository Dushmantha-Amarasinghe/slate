import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/db/tables/tasks_table.dart';
import '../../all_tasks/application/all_tasks_controller.dart';

enum SearchDateFilter { any, overdue, dueToday, dueThisWeek, noDueDate }

final StateProvider<String> searchQueryProvider = StateProvider<String>((Ref ref) => '');
final StateProvider<String?> searchTagFilterProvider = StateProvider<String?>((Ref ref) => null);
final StateProvider<TaskPriority?> searchPriorityFilterProvider = StateProvider<TaskPriority?>(
  (Ref ref) => null,
);
final StateProvider<SearchDateFilter> searchDateFilterProvider = StateProvider<SearchDateFilter>(
  (Ref ref) => SearchDateFilter.any,
);

/// Pure so it's directly unit-testable without standing up providers.
List<Task> filterTasksForSearch(
  List<Task> tasks, {
  required String query,
  String? tagId,
  TaskPriority? priority,
  SearchDateFilter dateFilter = SearchDateFilter.any,
  DateTime? now,
}) {
  final DateTime effectiveNow = now ?? DateTime.now();
  final DateTime todayStart = DateTime(effectiveNow.year, effectiveNow.month, effectiveNow.day);
  final DateTime todayEnd = todayStart.add(const Duration(days: 1));
  final DateTime weekEnd = todayStart.add(const Duration(days: 7));
  final String needle = query.trim().toLowerCase();

  return tasks.where((Task task) {
    if (needle.isNotEmpty) {
      final bool titleMatches = task.title.toLowerCase().contains(needle);
      final bool descriptionMatches = task.description?.toLowerCase().contains(needle) ?? false;
      if (!titleMatches && !descriptionMatches) return false;
    }

    if (tagId != null && task.tagId != tagId) return false;
    if (priority != null && task.priority != priority) return false;

    switch (dateFilter) {
      case SearchDateFilter.any:
        break;
      case SearchDateFilter.noDueDate:
        if (task.dueDateTimeLocal != null) return false;
      case SearchDateFilter.overdue:
        final DateTime? due = task.dueDateTimeLocal;
        if (due == null || !due.isBefore(effectiveNow) || task.isCompleted) return false;
      case SearchDateFilter.dueToday:
        final DateTime? due = task.dueDateTimeLocal;
        if (due == null || due.isBefore(todayStart) || !due.isBefore(todayEnd)) return false;
      case SearchDateFilter.dueThisWeek:
        final DateTime? due = task.dueDateTimeLocal;
        if (due == null || due.isBefore(todayStart) || !due.isBefore(weekEnd)) return false;
    }

    return true;
  }).toList();
}

final Provider<List<Task>> searchResultsProvider = Provider<List<Task>>((Ref ref) {
  final String query = ref.watch(searchQueryProvider);
  final String? tagId = ref.watch(searchTagFilterProvider);
  final TaskPriority? priority = ref.watch(searchPriorityFilterProvider);
  final SearchDateFilter dateFilter = ref.watch(searchDateFilterProvider);
  final List<Task> tasks = ref.watch(allTasksProvider).value ?? const <Task>[];

  final bool hasAnyFilter =
      query.trim().isNotEmpty || tagId != null || priority != null || dateFilter != SearchDateFilter.any;
  if (!hasAnyFilter) return const <Task>[];

  return filterTasksForSearch(
    tasks,
    query: query,
    tagId: tagId,
    priority: priority,
    dateFilter: dateFilter,
  );
});
