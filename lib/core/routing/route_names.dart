/// Centralized route path constants — features reference these instead of
/// hardcoding path strings when navigating.
class AppRoutes {
  const AppRoutes._();

  static const String onboarding = '/onboarding';
  static const String today = '/today';
  static const String allTasks = '/all-tasks';
  static const String calendar = '/calendar';
  static const String stats = '/stats';
  static const String search = '/search';
  static const String settings = '/settings';
  static const String settingsAppearance = '/settings/appearance';
  static const String settingsNotifications = '/settings/notifications';
  static const String settingsGestures = '/settings/gestures';
  static const String settingsTaskDefaults = '/settings/task-defaults';
  static const String settingsDataManagement = '/settings/data-management';
  static const String settingsWidget = '/settings/widget';
  static const String settingsUpdates = '/settings/updates';
  static const String settingsAbout = '/settings/about';
  static const String taskDetail = '/task/:id';

  static String taskDetailPath(String id) => '/task/$id';
}
