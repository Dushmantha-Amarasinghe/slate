import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/route_names.dart';
import '../../../core/theme/tokens/spacing_tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_label.dart';
import 'widgets/settings_nav_row.dart';

/// Settings home — a directory of sub-screens per the content spec
/// (Appearance, Notifications & Reminders, Gestures & Interaction, Task
/// Defaults, Data Management, Updates, About). Each row is a single tap
/// away from its dedicated screen; nothing is edited inline here.
class SettingsHomeScreen extends StatelessWidget {
  const SettingsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: <Widget>[
          const SectionLabel('General'),
          const SizedBox(height: AppSpacing.xs),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              children: <Widget>[
                SettingsNavRow(
                  icon: Icons.palette_outlined,
                  title: 'Appearance',
                  subtitle: 'Theme and accent color',
                  onTap: () => context.push(AppRoutes.settingsAppearance),
                ),
                const SettingsRowDivider(),
                SettingsNavRow(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications & Reminders',
                  subtitle: 'Permissions, lead time, snooze',
                  onTap: () => context.push(AppRoutes.settingsNotifications),
                ),
                const SettingsRowDivider(),
                SettingsNavRow(
                  icon: Icons.touch_app_outlined,
                  title: 'Gestures & Interaction',
                  subtitle: 'Swipe direction, haptics, motion',
                  onTap: () => context.push(AppRoutes.settingsGestures),
                ),
                const SettingsRowDivider(),
                SettingsNavRow(
                  icon: Icons.tune,
                  title: 'Task Defaults',
                  subtitle: 'Sort, grouping, priority',
                  onTap: () => context.push(AppRoutes.settingsTaskDefaults),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionLabel('Data'),
          const SizedBox(height: AppSpacing.xs),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: SettingsNavRow(
              icon: Icons.storage_outlined,
              title: 'Data Management',
              subtitle: 'Export, import, clear, delete',
              onTap: () => context.push(AppRoutes.settingsDataManagement),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionLabel('Home Screen'),
          const SizedBox(height: AppSpacing.xs),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: SettingsNavRow(
              icon: Icons.widgets_outlined,
              title: 'Widget',
              subtitle: 'Task count and filter',
              onTap: () => context.push(AppRoutes.settingsWidget),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionLabel('About'),
          const SizedBox(height: AppSpacing.xs),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              children: <Widget>[
                SettingsNavRow(
                  icon: Icons.system_update_outlined,
                  title: 'Updates',
                  subtitle: 'Check for the latest version',
                  onTap: () => context.push(AppRoutes.settingsUpdates),
                ),
                const SettingsRowDivider(),
                SettingsNavRow(
                  icon: Icons.info_outline,
                  title: 'About',
                  subtitle: 'Slate by Refora Technologies',
                  onTap: () => context.push(AppRoutes.settingsAbout),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
