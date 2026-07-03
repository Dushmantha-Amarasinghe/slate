import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'notification_actions.dart';

/// Wraps flutter_local_notifications: channel setup, timezone
/// initialization, and exact-time scheduling. Action-button taps (Done /
/// Snooze) are handled by top-level callbacks in notification_actions.dart
/// so they work even when the app isn't running (background isolate).
class NotificationService {
  const NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String channelId = 'task_reminders';
  static const String channelName = 'Task Reminders';
  static const String channelDescription =
      'Exact-time reminders for tasks with a due date.';

  static const String actionDone = 'done';
  static const String actionSnooze = 'snooze';

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    tzdata.initializeTimeZones();
    final String localTimezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimezone));

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_notification');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: handleNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          handleNotificationResponseBackground,
    );

    final AndroidFlutterLocalNotificationsPlugin? android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        channelId,
        channelName,
        description: channelDescription,
        importance: Importance.high,
      ),
    );

    _initialized = true;
  }

  /// Notification permission (Android 13+). Should only be called after an
  /// in-app primer explains why — never a cold OS prompt (see Settings >
  /// Notifications & Reminders, built in Phase 6).
  static Future<bool> requestNotificationPermission() async {
    if (!Platform.isAndroid) return true;
    final AndroidFlutterLocalNotificationsPlugin? android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    return await android?.requestNotificationsPermission() ?? false;
  }

  static Future<bool> areNotificationsEnabled() async {
    if (!Platform.isAndroid) return true;
    final AndroidFlutterLocalNotificationsPlugin? android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    return await android?.areNotificationsEnabled() ?? false;
  }

  static Future<bool> canScheduleExactAlarms() async {
    if (!Platform.isAndroid) return true;
    final AndroidFlutterLocalNotificationsPlugin? android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    return await android?.canScheduleExactNotifications() ?? false;
  }

  static Future<bool> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) return true;
    final AndroidFlutterLocalNotificationsPlugin? android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    return await android?.requestExactAlarmsPermission() ?? false;
  }

  /// Schedules (or reschedules — same [notificationId] replaces any
  /// existing alarm) an exact-time reminder. [triggerTimeUtc] is converted
  /// to the device's local [tz.Location] so DST transitions between now and
  /// the trigger time resolve correctly.
  static Future<void> scheduleReminder({
    required int notificationId,
    required String taskId,
    required String taskTitle,
    required DateTime triggerTimeUtc,
  }) async {
    final tz.TZDateTime scheduled = tz.TZDateTime.from(
      triggerTimeUtc,
      tz.local,
    );

    await _plugin.zonedSchedule(
      notificationId,
      taskTitle,
      'Due now',
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
          category: AndroidNotificationCategory.reminder,
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction(actionDone, 'Done'),
            AndroidNotificationAction(actionSnooze, 'Snooze 15m'),
          ],
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: encodeReminderPayload(
        taskId: taskId,
        notificationId: notificationId,
      ),
    );
  }

  static Future<void> cancelReminder(int notificationId) =>
      _plugin.cancel(notificationId);
}
