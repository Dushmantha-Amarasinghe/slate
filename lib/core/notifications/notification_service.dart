import 'dart:io';
import 'dart:typed_data';

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

  // Three channels, one per sound preference, rather than one channel whose
  // sound is switched at schedule time — Android locks a channel's sound
  // permanently once it's created, so "silent" / "standard" / "urgent" each
  // need their own channel id, and scheduleReminder just picks which one to
  // use per notification (see channelIdFor).
  static const String channelIdSilent = 'task_reminders_silent';
  static const String channelIdStandard = 'task_reminders';
  static const String channelIdUrgent = 'task_reminders_urgent';
  static const String channelName = 'Task Reminders';
  static const String channelDescription =
      'Exact-time reminders for tasks with a due date.';

  static const String actionDone = 'done';
  static const String actionSnooze = 'snooze';

  static bool _initialized = false;

  /// Which channel a reminder should be scheduled against for the current
  /// sound settings. Pure so it's directly testable without a plugin.
  static String channelIdFor({required bool soundEnabled, required bool urgentSound}) {
    if (!soundEnabled) return channelIdSilent;
    if (urgentSound) return channelIdUrgent;
    return channelIdStandard;
  }

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
        channelIdStandard,
        channelName,
        description: channelDescription,
        importance: Importance.high,
      ),
    );
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        channelIdSilent,
        channelName,
        description: channelDescription,
        importance: Importance.high,
        playSound: false,
      ),
    );
    await android?.createNotificationChannel(
      AndroidNotificationChannel(
        channelIdUrgent,
        '$channelName (Urgent)',
        description: 'Louder, alarm-style reminders — for tasks you really can\'t miss.',
        importance: Importance.max,
        // The device's default ALARM sound (not the notification sound) —
        // a well-known stable system URI, so this respects whatever the
        // user already picked as their alarm tone rather than shipping a
        // bundled sound file of our own.
        sound: const UriAndroidNotificationSound('content://settings/system/alarm_alert'),
        audioAttributesUsage: AudioAttributesUsage.alarm,
        vibrationPattern: _urgentVibrationPattern,
      ),
    );

    _initialized = true;
  }

  static Int64List get _urgentVibrationPattern =>
      Int64List.fromList(<int>[0, 800, 400, 800, 400, 800]);

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
  /// the trigger time resolve correctly. [channelId] should come from
  /// [channelIdFor] against the caller's current settings.
  static Future<void> scheduleReminder({
    required int notificationId,
    required String taskId,
    required String taskTitle,
    required DateTime triggerTimeUtc,
    String channelId = channelIdStandard,
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
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
          category: AndroidNotificationCategory.reminder,
          actions: const <AndroidNotificationAction>[
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
