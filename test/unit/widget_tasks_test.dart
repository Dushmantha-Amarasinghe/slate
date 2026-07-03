import 'package:flutter_test/flutter_test.dart';
import 'package:slate/core/db/database.dart';
import 'package:slate/core/db/tables/tasks_table.dart';
import 'package:slate/core/widget/widget_tasks_provider.dart';

Task _task(String id, String title, {bool noDueDate = false, DateTime? dueDateTimeLocal}) {
  final DateTime now = DateTime(2026, 1, 1);
  return Task(
    id: id,
    title: title,
    priority: TaskPriority.none,
    dueDateTimeLocal: noDueDate ? null : (dueDateTimeLocal ?? now),
    dueDateHasTime: true,
    isRecurring: false,
    isCompleted: false,
    completedAt: null,
    sortOrder: 0,
    createdAt: now,
    updatedAt: now,
  );
}

int _nextSubtaskId = 0;

Subtask _subtask(String taskId, {required bool isCompleted}) {
  final DateTime now = DateTime(2026, 1, 1);
  return Subtask(
    id: 'sub${_nextSubtaskId++}',
    taskId: taskId,
    title: 'item',
    isCompleted: isCompleted,
    sortOrder: 0,
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  group('buildWidgetRows', () {
    test('a task with no subtasks has a null progress label', () {
      final List<WidgetTaskRow> rows = buildWidgetRows(<Task>[_task('t1', 'Buy milk')], const <Subtask>[]);
      expect(rows.single.subtaskProgress, isNull);
    });

    test('formats completed/total for a task with subtasks', () {
      final List<Subtask> subtasks = <Subtask>[
        _subtask('t1', isCompleted: true),
        _subtask('t1', isCompleted: true),
        _subtask('t1', isCompleted: false),
      ];
      final List<WidgetTaskRow> rows = buildWidgetRows(<Task>[_task('t1', 'Plan trip')], subtasks);
      expect(rows.single.subtaskProgress, '2/3');
    });

    test('only counts subtasks belonging to that task', () {
      final List<Subtask> subtasks = <Subtask>[
        _subtask('t1', isCompleted: true),
        _subtask('t2', isCompleted: false),
        _subtask('t2', isCompleted: false),
      ];
      final List<WidgetTaskRow> rows = buildWidgetRows(
        <Task>[_task('t1', 'A'), _task('t2', 'B')],
        subtasks,
      );
      expect(rows[0].subtaskProgress, '1/1');
      expect(rows[1].subtaskProgress, '0/2');
    });

    test('preserves task order and title/id', () {
      final List<WidgetTaskRow> rows = buildWidgetRows(
        <Task>[_task('t1', 'First'), _task('t2', 'Second')],
        const <Subtask>[],
      );
      expect(rows.map((WidgetTaskRow r) => r.id), <String>['t1', 't2']);
      expect(rows.map((WidgetTaskRow r) => r.title), <String>['First', 'Second']);
    });

    test('a task due before today is overdue', () {
      final DateTime today = DateTime(2026, 1, 10);
      final List<WidgetTaskRow> rows = buildWidgetRows(
        <Task>[_task('t1', 'Late', dueDateTimeLocal: DateTime(2026, 1, 9, 23, 59))],
        const <Subtask>[],
        now: today,
      );
      expect(rows.single.isOverdue, isTrue);
    });

    test('a task due later today is not overdue', () {
      final DateTime today = DateTime(2026, 1, 10, 8);
      final List<WidgetTaskRow> rows = buildWidgetRows(
        <Task>[_task('t1', 'On time', dueDateTimeLocal: DateTime(2026, 1, 10, 20))],
        const <Subtask>[],
        now: today,
      );
      expect(rows.single.isOverdue, isFalse);
    });

    test('a task with no due date is not overdue', () {
      final List<WidgetTaskRow> rows = buildWidgetRows(
        <Task>[_task('t1', 'No due date', noDueDate: true)],
        const <Subtask>[],
      );
      expect(rows.single.isOverdue, isFalse);
    });
  });
}
