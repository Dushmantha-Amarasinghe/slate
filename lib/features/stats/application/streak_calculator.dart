import '../../../core/db/database.dart';

/// Day-grouped streak/completion stats, computed purely from each task's
/// [Task.completedAt] — grouped by the calendar day it already carries
/// (that timestamp is set via `DateTime.now()` at the moment of
/// completion, i.e. already "local when it happened"; grouping by its own
/// year/month/day is what makes a streak mean "I did something on this
/// calendar day," which stays correct even if the user later travels
/// across timezones — no separate zone conversion needed here, unlike
/// reminder scheduling which schedules for the *future* and does need one).
class StreakStats {
  const StreakStats({
    required this.currentStreak,
    required this.longestStreak,
    required this.dailyCompletions,
  });

  /// Consecutive days up to and including today with at least one
  /// completion — or, if nothing is completed yet today, up to yesterday
  /// (a streak isn't broken until the day actually ends with nothing done).
  final int currentStreak;

  /// The longest run of consecutive completion-days ever recorded.
  final int longestStreak;

  /// One entry per day in the requested range, oldest first, value = number
  /// of tasks completed that day (0 for days with none) — feeds the bar
  /// chart.
  final Map<DateTime, int> dailyCompletions;
}

DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

/// [now] is injectable for tests; defaults to the real current time.
StreakStats computeStreakStats(
  List<Task> completedTasks, {
  int chartDays = 30,
  DateTime? now,
}) {
  final DateTime today = _dateOnly(now ?? DateTime.now());

  final Map<DateTime, int> countsByDay = <DateTime, int>{};
  for (final Task task in completedTasks) {
    final DateTime? completedAt = task.completedAt;
    if (completedAt == null) continue;
    final DateTime day = _dateOnly(completedAt);
    countsByDay[day] = (countsByDay[day] ?? 0) + 1;
  }

  int currentStreak = 0;
  DateTime cursor = today;
  if (!countsByDay.containsKey(cursor)) {
    cursor = cursor.subtract(const Duration(days: 1));
  }
  while (countsByDay.containsKey(cursor)) {
    currentStreak++;
    cursor = cursor.subtract(const Duration(days: 1));
  }

  final List<DateTime> sortedDays = countsByDay.keys.toList()..sort();
  int longestStreak = 0;
  int run = 0;
  DateTime? previousDay;
  for (final DateTime day in sortedDays) {
    if (previousDay != null && day.difference(previousDay).inDays == 1) {
      run++;
    } else {
      run = 1;
    }
    if (run > longestStreak) longestStreak = run;
    previousDay = day;
  }

  final Map<DateTime, int> dailyCompletions = <DateTime, int>{};
  for (int i = chartDays - 1; i >= 0; i--) {
    final DateTime day = today.subtract(Duration(days: i));
    dailyCompletions[day] = countsByDay[day] ?? 0;
  }

  return StreakStats(
    currentStreak: currentStreak,
    longestStreak: longestStreak,
    dailyCompletions: dailyCompletions,
  );
}

/// Share of all tasks (pending + completed) that are done — a simple,
/// always-available "how much of my list is done" figure rather than
/// anything due-date-dependent (undated tasks have no due window to be
/// "on time" against).
double completionRate({required int completedCount, required int pendingCount}) {
  final int total = completedCount + pendingCount;
  if (total == 0) return 0;
  return completedCount / total;
}
