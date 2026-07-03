import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:home_widget/home_widget.dart';

import '../db/database.dart';
import '../notifications/alarm_scheduler.dart';
import '../../data/repositories/reminder_repository.dart';
import 'home_widget_service.dart';
import 'widget_tasks_provider.dart';

/// Handles a tap on a task row in the home screen widget when Settings >
/// Widget's tap action is "Mark complete" — fires via
/// `HomeWidgetBackgroundIntent` instead of opening the app, so this runs in
/// a separate background isolate (home_widget's contract for
/// [HomeWidget.registerInteractivityCallback], the same pattern
/// flutter_local_notifications uses for its Done/Snooze notification
/// actions — see core/notifications/notification_actions.dart). It opens
/// its own short-lived DB connection rather than reaching into the main
/// app's Riverpod ProviderScope, which doesn't exist in this isolate.
@pragma('vm:entry-point')
Future<void> widgetBackgroundCallback(Uri? uri) async {
  if (uri == null || uri.host != 'widget') return;
  final List<String> segments = uri.pathSegments;
  if (segments.length < 2 || segments.first != 'complete') return;
  final String taskId = segments[1];

  final File dbFile = await AppDatabase.resolveDatabaseFile();
  final AppDatabase db = AppDatabase(NativeDatabase.createInBackground(dbFile));
  try {
    final Task? task = await db.taskDao.getTaskById(taskId);
    if (task == null) return;

    final AlarmScheduler alarms = AlarmScheduler(ReminderRepository(db));
    await alarms.cancelForTask(taskId);
    await db.taskDao.updateTask(
      task
          .toCompanion(true)
          .copyWith(isCompleted: const Value<bool>(true), completedAt: Value<DateTime?>(DateTime.now())),
    );

    // Refresh the widget immediately so the just-completed task disappears
    // right away instead of waiting for the next natural data change (the
    // main isolate's app.dart listener won't fire — the app isn't running).
    final List<Task> pending = await db.taskDao.watchPendingTasks().first;
    final AppSettingsTableData settings = await db.settingsDao.watchSettings().first;
    final List<Subtask> subtasks = await db.subtaskDao.getAllSubtasks();
    await HomeWidgetService.push(
      buildWidgetRows(filterTasksForWidget(pending, settings), subtasks),
      tapAction: settings.widgetTapAction,
    );
  } finally {
    await db.close();
  }
}
