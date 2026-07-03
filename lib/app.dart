import 'package:drift/drift.dart' show TableInfo;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/animation/motion_utils.dart';
import 'core/db/database.dart';
import 'core/db/database_provider.dart';
import 'core/db/tables/app_settings_table.dart';
import 'core/haptics/haptic_service.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/theme/tokens/color_tokens.dart';
import 'core/widget/home_widget_service.dart';
import 'core/widget/widget_tasks_provider.dart';
import 'features/settings/application/settings_controller.dart';
import 'l10n/app_localizations.dart';

class SlateApp extends ConsumerStatefulWidget {
  const SlateApp({super.key});

  @override
  ConsumerState<SlateApp> createState() => _SlateAppState();
}

class _SlateAppState extends ConsumerState<SlateApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Keeps the home screen widget in sync with the live task list and the
    // tap-action setting. listenManual (rather than ref.listen in build) is
    // what supports fireImmediately, so a fresh install/launch pushes the
    // current state right away instead of waiting for the first change.
    ref.listenManual<(List<WidgetTaskRow>, WidgetTapAction)>(
      widgetSyncDataProvider,
      (
        (List<WidgetTaskRow>, WidgetTapAction)? previous,
        (List<WidgetTaskRow>, WidgetTapAction) next,
      ) => HomeWidgetService.push(next.$1, tapAction: next.$2),
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // The home-screen widget's "mark complete" tap and a notification's
    // Done/Snooze action each run in their own background Flutter engine
    // with its own separate database connection (see
    // widget_background_handler.dart / notification_actions.dart) — Drift's
    // stream queries only know about writes made through *this* app's own
    // connection, so a change made while this app was backgrounded is
    // invisible to its already-open screens until forced. Resuming is the
    // one moment such an external write is likely to have just happened,
    // so every watched table is marked updated here to force a re-query.
    if (state == AppLifecycleState.resumed) {
      final AppDatabase db = ref.read(appDatabaseProvider);
      db.markTablesUpdated(<TableInfo>{
        db.tasks,
        db.tags,
        db.subtasks,
        db.reminders,
        db.appSettingsTable,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeMode themeMode = ref.watch(themeModeProvider);
    final AppAccentColor accent = AppAccentPalette.byId(
      ref.watch(settingsProvider.select((AsyncValue<AppSettingsTableData> s) => s.value?.accentColorId)) ??
          'electricBlue',
    );

    ref.listen<AsyncValue<AppSettingsTableData>>(settingsProvider, (
      AsyncValue<AppSettingsTableData>? previous,
      AsyncValue<AppSettingsTableData> next,
    ) {
      final AppSettingsTableData? settings = next.value;
      if (settings == null) return;
      HapticService.enabled = settings.hapticsEnabled;
      MotionSettings.reduceMotionOverride = settings.reduceMotion;
    });

    return MaterialApp.router(
      title: 'Slate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(accent: accent.light),
      darkTheme: AppTheme.dark(accent: accent.dark),
      themeMode: themeMode,
      routerConfig: AppRouter.router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
