import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/settings/application/settings_controller.dart';
import '../db/database.dart';
import '../db/tables/app_settings_table.dart';

/// Theme mode for the app. Defaults to system-follows per spec 3.1, backed
/// by the persisted `AppSettings` Drift row so the choice survives restart.
final Provider<ThemeMode> themeModeProvider = Provider<ThemeMode>((Ref ref) {
  final AppThemeMode mode = ref.watch(
    settingsProvider.select(
      (AsyncValue<AppSettingsTableData> s) => s.value?.themeMode ?? AppThemeMode.system,
    ),
  );
  switch (mode) {
    case AppThemeMode.system:
      return ThemeMode.system;
    case AppThemeMode.light:
      return ThemeMode.light;
    case AppThemeMode.dark:
      return ThemeMode.dark;
  }
});

Future<void> setThemeMode(WidgetRef ref, AppThemeMode mode) {
  return ref
      .read(settingsControllerProvider)
      .update(AppSettingsTableCompanion(themeMode: Value<AppThemeMode>(mode)));
}
