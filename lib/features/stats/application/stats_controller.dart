import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../today/application/today_controller.dart';
import 'streak_calculator.dart';

final Provider<StreakStats> streakStatsProvider = Provider<StreakStats>((Ref ref) {
  final List<Task> completed = ref.watch(completedTasksProvider).value ?? const <Task>[];
  return computeStreakStats(completed);
});

final Provider<double> completionRateProvider = Provider<double>((Ref ref) {
  final int completed = (ref.watch(completedTasksProvider).value ?? const <Task>[]).length;
  final int pending = (ref.watch(pendingTasksProvider).value ?? const <Task>[]).length;
  return completionRate(completedCount: completed, pendingCount: pending);
});
