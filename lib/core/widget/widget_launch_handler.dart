import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

import '../routing/app_router.dart';
import '../routing/route_names.dart';
import '../../features/task_editor/presentation/task_editor_sheet.dart';

/// Routes a tap on the home screen widget (`slate://widget/...`, fired by
/// TodayWidgetProvider's PendingIntents) to the right place in the app —
/// Today, a specific task, or straight into the Add Task sheet.
class WidgetLaunchHandler {
  const WidgetLaunchHandler._();

  static StreamSubscription<Uri?>? _subscription;

  /// Call once at startup: handles a cold-start launch from the widget and
  /// starts listening for taps while the app keeps running.
  static Future<void> initialize() async {
    if (!Platform.isAndroid) return;

    try {
      final Uri? initial = await HomeWidget.initiallyLaunchedFromHomeWidget();
      _handle(initial);
      unawaited(_subscription?.cancel());
      _subscription = HomeWidget.widgetClicked.listen(_handle);
    } catch (error) {
      debugPrint('WidgetLaunchHandler.initialize failed: $error');
    }
  }

  static void _handle(Uri? uri) {
    if (uri == null || uri.host != 'widget') return;
    final List<String> segments = uri.pathSegments;
    if (segments.isEmpty) return;

    switch (segments.first) {
      case 'today':
        AppRouter.router.go(AppRoutes.today);
      case 'add-task':
        AppRouter.router.go(AppRoutes.today);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final BuildContext? context = AppRouter.navigatorKey.currentContext;
          if (context != null) TaskEditorSheet.show(context);
        });
      case 'task':
        if (segments.length > 1) {
          AppRouter.router.go(AppRoutes.taskDetailPath(segments[1]));
        }
    }
  }
}
