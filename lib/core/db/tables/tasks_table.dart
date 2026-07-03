import 'package:drift/drift.dart';

import 'tags_table.dart';

/// Priority as a stored int enum: none=0, low=1, medium=2, high=3.
enum TaskPriority { none, low, medium, high }

/// Tasks — the core entity. Due-date fields store both the user's intended
/// local wall-clock time and the timezone it was set in (rather than a
/// single naive DateTime) so recurrence and reminder rescheduling stay
/// correct across DST transitions; see AGENTS notes in reminders_table.dart
/// for how this pairs with Reminder.triggerTimeUtc.
class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();

  DateTimeColumn get dueDateTimeLocal => dateTime().nullable()();
  TextColumn get timezoneId => text().nullable()();

  /// False for a date-only due date (no specific time of day) — the task
  /// editor lets a due date be "just a day" as well as a precise moment.
  /// [dueDateTimeLocal] still stores a full DateTime either way (midnight
  /// local time when this is false); this flag is what the UI/reminder
  /// scheduler use to decide whether to show/treat it as a time. Defaults
  /// true so every pre-existing row (all of which had an explicit time
  /// before this column existed) keeps its current display behavior.
  BoolColumn get dueDateHasTime => boolean().withDefault(const Constant(true))();

  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
  TextColumn get recurrenceRule => text().nullable()();

  IntColumn get priority =>
      intEnum<TaskPriority>().withDefault(const Constant(0))();

  TextColumn get tagId => text().nullable().references(Tags, #id)();
  TextColumn get voiceNotePath => text().nullable()();

  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => <Column>{id};
}
