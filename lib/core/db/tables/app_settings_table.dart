import 'package:drift/drift.dart';

import 'tasks_table.dart';

enum AppThemeMode { system, light, dark }

/// Which side completes vs deletes on swipe (spec 4: "swipe right to
/// complete, swipe left to delete, or reverse, per settings").
enum SwipeDirection { rightCompleteLeftDelete, leftCompleteRightDelete }

enum TaskSortOption { dueDate, priority, createdDate, alphabetical }

enum TaskGroupingOption { none, byDate, byTag, byPriority }

enum WeekStartDay { sunday, monday }

enum WidgetFilterMode { todayOnly, todayPlusOverdue }

/// What tapping a task row in the home screen widget does — open that
/// task's detail screen, or mark it complete right there without opening
/// the app (see core/widget/widget_background_handler.dart).
enum WidgetTapAction { openDetail, markComplete }

/// Single-row settings table (row id is always 0) rather than
/// SharedPreferences, so Riverpod can watch settings the same reactive way
/// it watches tasks, and settings ride along automatically in the JSON
/// export/import backup. Install-local, non-backup-worthy flags (e.g. "has
/// completed onboarding") stay in shared_preferences instead — see
/// core/update/ and features/onboarding/ for those.
class AppSettingsTable extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();

  IntColumn get themeMode =>
      intEnum<AppThemeMode>().withDefault(const Constant(0))();
  TextColumn get accentColorId =>
      text().withDefault(const Constant('electricBlue'))();

  IntColumn get swipeDirection =>
      intEnum<SwipeDirection>().withDefault(const Constant(0))();
  BoolColumn get hapticsEnabled =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get soundEnabled => boolean().withDefault(const Constant(true))();
  // A distinct notification channel using the device's default ALARM sound
  // (louder/more insistent, typically bypasses the media volume slider)
  // instead of the default notification sound — see
  // core/notifications/notification_service.dart's channelIdFor.
  BoolColumn get urgentReminderSound =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get reduceMotion => boolean().withDefault(const Constant(false))();

  IntColumn get defaultSort =>
      intEnum<TaskSortOption>().withDefault(const Constant(0))();
  IntColumn get defaultGrouping =>
      intEnum<TaskGroupingOption>().withDefault(const Constant(0))();
  IntColumn get weekStartDay =>
      intEnum<WeekStartDay>().withDefault(const Constant(0))();
  IntColumn get defaultPriority =>
      intEnum<TaskPriority>().withDefault(const Constant(0))();
  IntColumn get defaultReminderLeadMinutes =>
      integer().withDefault(const Constant(0))();
  TextColumn get snoozeOptionsMinutesJson =>
      text().withDefault(const Constant('[15,60,1440]'))();

  IntColumn get widgetTaskCount => integer().withDefault(const Constant(5))();
  IntColumn get widgetFilterMode =>
      intEnum<WidgetFilterMode>().withDefault(const Constant(1))();
  IntColumn get widgetTapAction =>
      intEnum<WidgetTapAction>().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => <Column>{id};
}
