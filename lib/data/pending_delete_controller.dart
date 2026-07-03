import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'task_actions.dart';

/// Backs the undo-snackbar delete pattern: a swiped-away task is held here
/// (never touching the DB) for a few seconds so "Undo" is instant and free,
/// and only actually deleted once the window lapses. Shared across Today
/// and All Tasks via Riverpod so the same task reads as "pending delete"
/// on both screens rather than each keeping its own local state.
class PendingDeleteController extends StateNotifier<Set<String>> {
  PendingDeleteController(this._actions) : super(<String>{});

  final TaskActions _actions;
  final Map<String, Timer> _timers = <String, Timer>{};

  static const Duration undoWindow = Duration(seconds: 15);

  void scheduleDelete(String taskId) {
    state = <String>{...state, taskId};
    _timers[taskId]?.cancel();
    _timers[taskId] = Timer(undoWindow, () {
      _timers.remove(taskId);
      state = <String>{...state}..remove(taskId);
      _actions.deleteTask(taskId);
    });
  }

  void undo(String taskId) {
    _timers.remove(taskId)?.cancel();
    state = <String>{...state}..remove(taskId);
  }

  @override
  void dispose() {
    for (final Timer timer in _timers.values) {
      timer.cancel();
    }
    super.dispose();
  }
}

final StateNotifierProvider<PendingDeleteController, Set<String>> pendingDeleteProvider =
    StateNotifierProvider<PendingDeleteController, Set<String>>((Ref ref) {
      return PendingDeleteController(ref.watch(taskActionsProvider));
    });
