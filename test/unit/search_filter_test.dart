import 'package:flutter_test/flutter_test.dart';
import 'package:slate/core/db/database.dart';
import 'package:slate/core/db/tables/tasks_table.dart';
import 'package:slate/features/search/application/search_controller.dart';

Task _task({
  required String id,
  required String title,
  String? description,
  DateTime? dueDateTimeLocal,
  TaskPriority priority = TaskPriority.none,
  String? tagId,
  bool isCompleted = false,
}) {
  final DateTime now = DateTime(2026, 3, 10, 9);
  return Task(
    id: id,
    title: title,
    description: description,
    priority: priority,
    dueDateTimeLocal: dueDateTimeLocal,
    dueDateHasTime: true,
    tagId: tagId,
    isRecurring: false,
    isCompleted: isCompleted,
    completedAt: isCompleted ? now : null,
    sortOrder: 0,
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  final DateTime now = DateTime(2026, 3, 10, 12);

  group('filterTasksForSearch', () {
    test('matches title case-insensitively', () {
      final List<Task> tasks = <Task>[_task(id: '1', title: 'Buy Milk'), _task(id: '2', title: 'Walk dog')];
      final List<Task> result = filterTasksForSearch(tasks, query: 'milk', now: now);
      expect(result.map((Task t) => t.id), <String>['1']);
    });

    test('matches description when title doesn\'t match', () {
      final List<Task> tasks = <Task>[
        _task(id: '1', title: 'Groceries', description: 'Need eggs and milk'),
      ];
      final List<Task> result = filterTasksForSearch(tasks, query: 'eggs', now: now);
      expect(result.map((Task t) => t.id), <String>['1']);
    });

    test('filters by priority', () {
      final List<Task> tasks = <Task>[
        _task(id: '1', title: 'A', priority: TaskPriority.high),
        _task(id: '2', title: 'B', priority: TaskPriority.low),
      ];
      final List<Task> result = filterTasksForSearch(
        tasks,
        query: '',
        priority: TaskPriority.high,
        now: now,
      );
      expect(result.map((Task t) => t.id), <String>['1']);
    });

    test('filters by tag', () {
      final List<Task> tasks = <Task>[
        _task(id: '1', title: 'A', tagId: 'work'),
        _task(id: '2', title: 'B', tagId: 'home'),
      ];
      final List<Task> result = filterTasksForSearch(tasks, query: '', tagId: 'work', now: now);
      expect(result.map((Task t) => t.id), <String>['1']);
    });

    test('overdue excludes completed tasks and future due dates', () {
      final List<Task> tasks = <Task>[
        _task(id: '1', title: 'A', dueDateTimeLocal: DateTime(2026, 3, 9)),
        _task(id: '2', title: 'B', dueDateTimeLocal: DateTime(2026, 3, 9), isCompleted: true),
        _task(id: '3', title: 'C', dueDateTimeLocal: DateTime(2026, 3, 20)),
        _task(id: '4', title: 'D'),
      ];
      final List<Task> result = filterTasksForSearch(
        tasks,
        query: '',
        dateFilter: SearchDateFilter.overdue,
        now: now,
      );
      expect(result.map((Task t) => t.id), <String>['1']);
    });

    test('dueToday matches only today\'s calendar day', () {
      final List<Task> tasks = <Task>[
        _task(id: '1', title: 'A', dueDateTimeLocal: DateTime(2026, 3, 10, 23)),
        _task(id: '2', title: 'B', dueDateTimeLocal: DateTime(2026, 3, 11, 1)),
        _task(id: '3', title: 'C', dueDateTimeLocal: DateTime(2026, 3, 9, 23)),
      ];
      final List<Task> result = filterTasksForSearch(
        tasks,
        query: '',
        dateFilter: SearchDateFilter.dueToday,
        now: now,
      );
      expect(result.map((Task t) => t.id), <String>['1']);
    });

    test('dueThisWeek covers the next 7 days from today', () {
      final List<Task> tasks = <Task>[
        _task(id: '1', title: 'A', dueDateTimeLocal: DateTime(2026, 3, 12)),
        _task(id: '2', title: 'B', dueDateTimeLocal: DateTime(2026, 3, 20)),
        _task(id: '3', title: 'C', dueDateTimeLocal: DateTime(2026, 3, 8)),
      ];
      final List<Task> result = filterTasksForSearch(
        tasks,
        query: '',
        dateFilter: SearchDateFilter.dueThisWeek,
        now: now,
      );
      expect(result.map((Task t) => t.id), <String>['1']);
    });

    test('noDueDate matches only undated tasks', () {
      final List<Task> tasks = <Task>[
        _task(id: '1', title: 'A'),
        _task(id: '2', title: 'B', dueDateTimeLocal: DateTime(2026, 3, 12)),
      ];
      final List<Task> result = filterTasksForSearch(
        tasks,
        query: '',
        dateFilter: SearchDateFilter.noDueDate,
        now: now,
      );
      expect(result.map((Task t) => t.id), <String>['1']);
    });

    test('combines query, priority, tag, and date filters together', () {
      final List<Task> tasks = <Task>[
        _task(
          id: '1',
          title: 'Finish report',
          priority: TaskPriority.high,
          tagId: 'work',
          dueDateTimeLocal: DateTime(2026, 3, 10, 18),
        ),
        _task(
          id: '2',
          title: 'Finish laundry',
          priority: TaskPriority.high,
          tagId: 'work',
          dueDateTimeLocal: DateTime(2026, 3, 10, 18),
        ),
      ];
      final List<Task> result = filterTasksForSearch(
        tasks,
        query: 'report',
        priority: TaskPriority.high,
        tagId: 'work',
        dateFilter: SearchDateFilter.dueToday,
        now: now,
      );
      expect(result.map((Task t) => t.id), <String>['1']);
    });
  });
}
