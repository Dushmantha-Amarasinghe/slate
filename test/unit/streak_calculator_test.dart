import 'package:flutter_test/flutter_test.dart';
import 'package:slate/core/db/database.dart';
import 'package:slate/core/db/tables/tasks_table.dart';
import 'package:slate/features/stats/application/streak_calculator.dart';

Task _completedTask(String id, DateTime completedAt) {
  return Task(
    id: id,
    title: id,
    priority: TaskPriority.none,
    dueDateTimeLocal: null,
    dueDateHasTime: true,
    isRecurring: false,
    isCompleted: true,
    completedAt: completedAt,
    sortOrder: 0,
    createdAt: completedAt,
    updatedAt: completedAt,
  );
}

void main() {
  group('computeStreakStats', () {
    final DateTime today = DateTime(2026, 3, 10);

    test('current streak counts consecutive days ending today', () {
      final List<Task> tasks = <Task>[
        _completedTask('a', DateTime(2026, 3, 10, 9)),
        _completedTask('b', DateTime(2026, 3, 9, 20)),
        _completedTask('c', DateTime(2026, 3, 8, 8)),
        _completedTask('d', DateTime(2026, 3, 6, 8)), // gap on the 7th
      ];
      final StreakStats stats = computeStreakStats(tasks, now: today);
      expect(stats.currentStreak, 3);
    });

    test('streak continues counting from yesterday when nothing is done yet today', () {
      final List<Task> tasks = <Task>[
        _completedTask('a', DateTime(2026, 3, 9, 20)),
        _completedTask('b', DateTime(2026, 3, 8, 8)),
      ];
      final StreakStats stats = computeStreakStats(tasks, now: today);
      expect(stats.currentStreak, 2);
    });

    test('streak is zero once a day is fully missed', () {
      final List<Task> tasks = <Task>[_completedTask('a', DateTime(2026, 3, 7, 9))];
      final StreakStats stats = computeStreakStats(tasks, now: today);
      expect(stats.currentStreak, 0);
    });

    test('longest streak finds the best run even if it isn\'t the current one', () {
      final List<Task> tasks = <Task>[
        _completedTask('a', DateTime(2026, 3, 1, 9)),
        _completedTask('b', DateTime(2026, 3, 2, 9)),
        _completedTask('c', DateTime(2026, 3, 3, 9)),
        _completedTask('d', DateTime(2026, 3, 4, 9)),
        _completedTask('e', DateTime(2026, 3, 10, 9)), // today, isolated
      ];
      final StreakStats stats = computeStreakStats(tasks, now: today);
      expect(stats.longestStreak, 4);
      expect(stats.currentStreak, 1);
    });

    test('multiple completions on the same day only count once toward the streak', () {
      final List<Task> tasks = <Task>[
        _completedTask('a', DateTime(2026, 3, 10, 8)),
        _completedTask('b', DateTime(2026, 3, 10, 20)),
      ];
      final StreakStats stats = computeStreakStats(tasks, now: today);
      expect(stats.currentStreak, 1);
      expect(stats.dailyCompletions[DateTime(2026, 3, 10)], 2);
    });

    test('dailyCompletions covers exactly chartDays entries ending today', () {
      final StreakStats stats = computeStreakStats(const <Task>[], chartDays: 7, now: today);
      expect(stats.dailyCompletions.length, 7);
      expect(stats.dailyCompletions.keys.first, DateTime(2026, 3, 4));
      expect(stats.dailyCompletions.keys.last, DateTime(2026, 3, 10));
      expect(stats.dailyCompletions.values.every((int v) => v == 0), isTrue);
    });

    test('empty history has no streak', () {
      final StreakStats stats = computeStreakStats(const <Task>[], now: today);
      expect(stats.currentStreak, 0);
      expect(stats.longestStreak, 0);
    });
  });

  group('completionRate', () {
    test('splits completed vs pending', () {
      expect(completionRate(completedCount: 3, pendingCount: 1), closeTo(0.75, 0.0001));
    });

    test('is zero when there are no tasks at all', () {
      expect(completionRate(completedCount: 0, pendingCount: 0), 0);
    });

    test('is 1.0 when everything is completed', () {
      expect(completionRate(completedCount: 5, pendingCount: 0), 1.0);
    });
  });
}
