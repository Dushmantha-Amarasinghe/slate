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

  // The only genuinely blocking step: GoRouter reads this once, synchronously,
  // to pick the initial route, so it has to be resolved before runApp(). It's
  // a plain SharedPreferences read (fast, and already exercised on every
  // launch throughout development) rather than a plugin platform call, so it
  // isn't the kind of thing that hangs on a specific device.
  OnboardingGate.needsOnboarding = !(await OnboardingPrefs.hasCompleted());

  runApp(const ProviderScope(child: SlateApp()));

  // Everything below runs after the first frame is already on screen. None
  // of it is needed to render the UI, and every one of these touches a
  // platform plugin (notifications, timezone lookup, the widget/shortcut
  // plugins, a network call) — exactly the kind of call that can behave
  // differently, or take much longer, on a specific real device than it did
  // in development. Blocking runApp() on any of them risks the splash
  // screen hanging forever if one misbehaves; deferring means a slow or
  // failing step degrades that one feature instead of freezing the app.
  unawaited(_initializeNotificationsAndResync());
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
  // rationale as the reminder resync below.
  final http.Client updateClient = http.Client();
  UpdateCheckerService(updateClient).checkForUpdate().whenComplete(updateClient.close);
}

/// Sets up notification channels/handlers, then re-applies every stored
/// reminder to the OS alarm scheduler (exact alarms don't survive a reboot
/// on their own — see reminder_resync.dart). Both best-effort: a failure or
/// hang here means reminders might not fire until the next launch, which is
/// recoverable, rather than the whole app never becoming usable.
Future<void> _initializeNotificationsAndResync() async {
  try {
    await NotificationService.initialize();
    final AppDatabase resyncDb = AppDatabase();
    await resyncAllReminders(resyncDb);
    await resyncDb.close();
  } catch (error, stackTrace) {
    debugPrint('Notification setup / reminder resync failed: $error\n$stackTrace');
  }
}
