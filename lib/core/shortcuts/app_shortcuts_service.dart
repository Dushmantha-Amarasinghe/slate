import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quick_actions/quick_actions.dart';

import '../routing/app_router.dart';
import '../routing/route_names.dart';
import '../../features/task_editor/presentation/task_editor_sheet.dart';

/// Long-press launcher shortcuts (build plan Phase 7): "Add Task" and
/// "Today". Registered once at startup — Android shortcuts are static
/// until re-registered, so this doesn't need to run on every launch, but
/// doing so is cheap and keeps them in sync if icons/labels ever change.
class AppShortcutsService {
  const AppShortcutsService._();

  static const String actionAddTask = 'action_add_task';
  static const String actionToday = 'action_today';

  static final QuickActions _quickActions = QuickActions();

  static Future<void> initialize() async {
    if (!Platform.isAndroid) return;

    try {
      _quickActions.initialize(_handleAction);
      await _quickActions.setShortcutItems(const <ShortcutItem>[
        ShortcutItem(type: actionAddTask, localizedTitle: 'Add Task', icon: 'ic_shortcut_add'),
        ShortcutItem(type: actionToday, localizedTitle: 'Today', icon: 'ic_shortcut_today'),
      ]);
    } catch (error) {
      debugPrint('AppShortcutsService.initialize failed: $error');
    }
  }

  static void _handleAction(String type) {
    switch (type) {
      case actionToday:
        AppRouter.router.go(AppRoutes.today);
      case actionAddTask:
        AppRouter.router.go(AppRoutes.today);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final BuildContext? context = AppRouter.navigatorKey.currentContext;
          if (context != null) TaskEditorSheet.show(context);
        });
    }
  }
}
