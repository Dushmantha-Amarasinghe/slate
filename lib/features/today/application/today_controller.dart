import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../data/repositories/task_repository.dart';

/// Today's pending/completed split. Not yet filtered to "due today"
/// specifically — that's calendar-day-boundary logic that depends on the
/// timezone handling Phase 3 wires up properly; for now Today shows every
/// pending task, and All Tasks (same data, different screen) is where a
/// user browses the full backlog regardless of date.
final StreamProvider<List<Task>> pendingTasksProvider =
    StreamProvider<List<Task>>((Ref ref) {
      return ref.watch(taskRepositoryProvider).watchPending();
    });

final StreamProvider<List<Task>> completedTasksProvider =
    StreamProvider<List<Task>>((Ref ref) {
      return ref.watch(taskRepositoryProvider).watchCompleted();
    });
