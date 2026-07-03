import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/all_tasks/presentation/all_tasks_screen.dart';
import '../../features/calendar/presentation/calendar_screen.dart';
import '../../features/onboarding/onboarding_gate.dart';
import '../../features/onboarding/presentation/onboarding_flow_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/settings/presentation/about_settings_screen.dart';
import '../../features/settings/presentation/appearance_settings_screen.dart';
import '../../features/settings/presentation/data_management_settings_screen.dart';
import '../../features/settings/presentation/gestures_settings_screen.dart';
import '../../features/settings/presentation/notifications_settings_screen.dart';
import '../../features/settings/presentation/settings_home_screen.dart';
import '../../features/settings/presentation/task_defaults_settings_screen.dart';
import '../../features/settings/presentation/updates_settings_screen.dart';
import '../../features/settings/presentation/widget_settings_screen.dart';
import '../../features/stats/presentation/stats_screen.dart';
import '../../features/task_detail/presentation/task_detail_screen.dart';
import '../../features/today/presentation/today_screen.dart';
import 'route_names.dart';

/// Bottom-nav shell: Today / All Tasks / Calendar / Stats (spec's nav
/// decision — Search and Settings are app-bar icons, not tabs).
class AppRouter {
  const AppRouter._();

  /// Exposed so code outside the widget tree (the home-widget launch
  /// handler) can both navigate (`router.go`) and, for actions with no
  /// route of their own like "open the Add Task sheet", grab a
  /// [BuildContext] via `navigatorKey.currentContext` after navigating.
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: OnboardingGate.needsOnboarding ? AppRoutes.onboarding : AppRoutes.today,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (BuildContext context, GoRouterState state) =>
            const OnboardingFlowScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder:
            (
              BuildContext context,
              GoRouterState state,
              StatefulNavigationShell shell,
            ) {
              return _NavShell(shell: shell);
            },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.today,
                builder: (BuildContext context, GoRouterState state) =>
                    const TodayScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.allTasks,
                builder: (BuildContext context, GoRouterState state) =>
                    const AllTasksScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.calendar,
                builder: (BuildContext context, GoRouterState state) =>
                    const CalendarScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.stats,
                builder: (BuildContext context, GoRouterState state) =>
                    const StatsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.search,
        builder: (BuildContext context, GoRouterState state) =>
            const SearchScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (BuildContext context, GoRouterState state) =>
            const SettingsHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.settingsAppearance,
        builder: (BuildContext context, GoRouterState state) =>
            const AppearanceSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.settingsNotifications,
        builder: (BuildContext context, GoRouterState state) =>
            const NotificationsSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.settingsGestures,
        builder: (BuildContext context, GoRouterState state) =>
            const GesturesSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.settingsTaskDefaults,
        builder: (BuildContext context, GoRouterState state) =>
            const TaskDefaultsSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.settingsDataManagement,
        builder: (BuildContext context, GoRouterState state) =>
            const DataManagementSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.settingsWidget,
        builder: (BuildContext context, GoRouterState state) =>
            const WidgetSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.settingsUpdates,
        builder: (BuildContext context, GoRouterState state) =>
            const UpdatesSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.settingsAbout,
        builder: (BuildContext context, GoRouterState state) =>
            const AboutSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.taskDetail,
        builder: (BuildContext context, GoRouterState state) =>
            TaskDetailScreen(taskId: state.pathParameters['id']!),
      ),
    ],
  );
}

class _NavShell extends StatelessWidget {
  const _NavShell({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (int index) =>
            shell.goBranch(index, initialLocation: index == shell.currentIndex),
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(Icons.checklist),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'All Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: 'Stats',
          ),
        ],
      ),
    );
  }
}
