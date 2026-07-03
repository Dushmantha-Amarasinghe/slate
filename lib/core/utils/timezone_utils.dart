import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;

/// The device's current IANA timezone id (e.g. "Asia/Colombo"), stored on
/// Task.timezoneId at creation time so recurrence/reminder recomputation
/// stays correct even if the device's timezone changes later.
Future<String> currentTimezoneId() => FlutterTimezone.getLocalTimezone();

/// Converts a naive local wall-clock DateTime (as picked in the due-date
/// UI) plus the IANA zone it was set in, into the correct UTC instant —
/// the value actually needed to schedule an exact alarm.
DateTime localWallTimeToUtc(DateTime wallTime, String timezoneId) {
  final tz.Location location = tz.getLocation(timezoneId);
  final tz.TZDateTime zoned = tz.TZDateTime(
    location,
    wallTime.year,
    wallTime.month,
    wallTime.day,
    wallTime.hour,
    wallTime.minute,
  );
  return zoned.toUtc();
}
