import 'package:drift/drift.dart';

import 'tasks_table.dart';

/// Reminders — one or more scheduled notifications for a Task.
///
/// `triggerTimeUtc`/`snoozeUntilUtc` store the actual instant AlarmManager
/// schedules against, in UTC — never a naive local `DateTime` — so a DST
/// transition between "when the reminder was created" and "when it fires"
/// can't silently shift it by an hour. `notificationId` is the Android
/// notification/alarm request code, needed to cancel/reschedule a specific
/// reminder via flutter_local_notifications (Phase 3).
class Reminders extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().references(Tasks, #id)();

  DateTimeColumn get triggerTimeUtc => dateTime()();
  BoolColumn get isSnoozed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get snoozeUntilUtc => dateTime().nullable()();

  IntColumn get notificationId => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => <Column>{id};
}
