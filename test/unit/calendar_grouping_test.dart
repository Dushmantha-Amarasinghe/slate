import 'package:flutter_test/flutter_test.dart';
import 'package:slate/core/db/database.dart';
import 'package:slate/core/db/tables/tasks_table.dart';
import 'package:slate/features/calendar/application/calendar_controller.dart';

Task _task({required String id, DateTime? dueDateTimeLocal}) {
  final DateTime now = DateTime(2026, 3, 10, 9);
  return Task(
    id: id,
    title: id,
    priority: TaskPriority.none,
    dueDateTimeLocal: dueDateTimeLocal,
    dueDateHasTime: true,
    isRecurring: false,
    isCompleted: false,
    completedAt: null,
    sortOrder: 0,
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  group('groupTasksByDueDate', () {
    test('groups tasks by calendar day, stripping time-of-day', () {
      final List<Task> tasks = <Task>[
        _task(id: 'a', dueDateTimeLocal: DateTime(2026, 3, 10, 8)),
        _task(id: 'b', dueDateTimeLocal: DateTime(2026, 3, 10, 20)),
        _task(id: 'c', dueDateTimeLocal: DateTime(2026, 3, 11, 9)),
      ];
      final Map<DateTime, List<Task>> grouped = groupTasksByDueDate(tasks);
      expect(grouped[DateTime(2026, 3, 10)]?.map((Task t) => t.id), <String>['a', 'b']);
      expect(grouped[DateTime(2026, 3, 11)]?.map((Task t) => t.id), <String>['c']);
    });

    test('excludes tasks with no due date', () {
      final List<Task> tasks = <Task>[
        _task(id: 'a'),
        _task(id: 'b', dueDateTimeLocal: DateTime(2026, 3, 10)),
      ];
      final Map<DateTime, List<Task>> grouped = groupTasksByDueDate(tasks);
      expect(grouped.length, 1);
      expect(grouped[DateTime(2026, 3, 10)]?.single.id, 'b');
    });

    test('empty task list produces an empty map', () {
      expect(groupTasksByDueDate(const <Task>[]), isEmpty);
    });
  });
}
