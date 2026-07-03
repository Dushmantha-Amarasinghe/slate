import 'dart:async';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:http/http.dart' as http;

import 'app.dart';
import 'core/db/database.dart';
import 'core/notifications/notification_service.dart';
import 'core/notifications/reminder_resync.dart';
import 'core/shortcuts/app_shortcuts_service.dart';
import 'core/update/update_checker_service.dart';
import 'core/widget/widget_background_handler.dart';
import 'core/widget/widget_launch_handler.dart';
import 'features/onboarding/onboarding_gate.dart';
import 'features/onboarding/onboarding_prefs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  OnboardingGate.needsOnboarding = !(await OnboardingPrefs.hasCompleted());

  await NotificationService.initialize();

  // Belt-and-suspenders resync (see reminder_resync.dart) — uses its own
  // short-lived connection so it doesn't need to wait for the widget tree
  // (and the ProviderScope's AppDatabase) to exist. Best-effort: a bug or
  // platform quirk here should never block the app from launching.
  try {
    final AppDatabase resyncDb = AppDatabase();
    await resyncAllReminders(resyncDb);
    await resyncDb.close();
  } catch (error, stackTrace) {
    debugPrint('Reminder resync failed: $error\n$stackTrace');
  }

  runApp(const ProviderScope(child: SlateApp()));

  // Non-blocking: detects a cold start from the home widget and starts
  // listening for taps while the app runs (see widget_launch_handler.dart).
  unawaited(WidgetLaunchHandler.initialize());
  unawaited(AppShortcutsService.initialize());

  // Registers the "mark complete from the widget" background isolate
  // entry point (see widget_background_handler.dart). Must run every
  // startup — the plugin persists the callback handle for the widget's
  // background broadcasts to find later, including while the app isn't
  // running at all.
  if (Platform.isAndroid) {
    unawaited(HomeWidget.registerInteractivityCallback(widgetBackgroundCallback));
  }

  // Non-blocking startup update check (throttled to at most once/hour —
  // see UpdateCheckerService), fired after the UI is already interactive.
  // Own short-lived http.Client, same "don't depend on the widget tree"
  // rationale as the reminder resync above.
  final http.Client updateClient = http.Client();
  UpdateCheckerService(updateClient).checkForUpdate().whenComplete(updateClient.close);
}
