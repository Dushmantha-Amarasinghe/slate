import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

import '../db/tables/app_settings_table.dart';
import 'widget_tasks_provider.dart';

/// Pushes today's top-N tasks to the native Android home screen widget
/// (see android/app/src/main/kotlin/.../TodayWidgetProvider.kt) — the
/// widget itself never touches the database, it only renders whatever was
/// last written here via [HomeWidget.saveWidgetData].
class HomeWidgetService {
  const HomeWidgetService._();

  static const int maxRows = 5;
  static const String androidQualifiedName = 'com.reforatech.slate.TodayWidgetProvider';

  /// [rows] should already be filtered/sorted/limited by the caller (see
  /// widget_tasks_provider.dart) — this only serializes and pushes.
  /// [tapAction] tells the native provider whether a row tap should open
  /// the task (the default) or mark it complete in place — see
  /// Settings > Widget. A row's subtask progress ("2/5") is shown as a
  /// glanceable label only — the widget can't practically offer a tap
  /// target for each individual subtask within a compact row, so
  /// checking them off still means opening the task.
  static Future<void> push(
    List<WidgetTaskRow> rows, {
    WidgetTapAction tapAction = WidgetTapAction.openDetail,
  }) async {
    if (!Platform.isAndroid) return;

    try {
      await HomeWidget.saveWidgetData<int>('widget_task_count', rows.length);
      await HomeWidget.saveWidgetData<int>('widget_tap_action', tapAction.index);
      for (int i = 0; i < maxRows; i++) {
        if (i < rows.length) {
          await HomeWidget.saveWidgetData<String>('widget_task_title_$i', rows[i].title);
          await HomeWidget.saveWidgetData<String>('widget_task_id_$i', rows[i].id);
          await HomeWidget.saveWidgetData<String>(
            'widget_task_subtasks_$i',
            rows[i].subtaskProgress,
          );
        } else {
          await HomeWidget.saveWidgetData<String>('widget_task_title_$i', null);
          await HomeWidget.saveWidgetData<String>('widget_task_id_$i', null);
          await HomeWidget.saveWidgetData<String>('widget_task_subtasks_$i', null);
        }
      }
      await HomeWidget.updateWidget(qualifiedAndroidName: androidQualifiedName);
    } catch (error) {
      // Best-effort: no widget may be pinned, or (in tests) no platform
      // channel implementation exists at all. Never let this break the app.
      debugPrint('HomeWidgetService.push failed: $error');
    }
  }
}
