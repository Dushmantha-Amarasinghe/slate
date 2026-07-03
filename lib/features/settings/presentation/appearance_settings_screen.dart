import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/db/tables/app_settings_table.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/theme/tokens/color_tokens.dart';
import '../../../core/theme/tokens/spacing_tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_label.dart';
import '../../stats/application/stats_controller.dart';
import '../application/accent_unlock.dart';
import '../application/settings_controller.dart';

/// Theme mode + accent color. Electric Blue ships unlocked; the rest unlock
/// permanently once the user's longest completion streak reaches each
/// color's threshold (spec section 3, "Appearance" stretch feature) — shown
/// grayed out with a lock badge and a streak-progress hint until then.
class AppearanceSettingsScreen extends ConsumerWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AppSettingsTableData> settingsAsync = ref.watch(settingsProvider);
    final ThemeMode mode = ref.watch(themeModeProvider);
    final Set<String> unlocked = ref.watch(unlockedAccentIdsProvider);
    final int longestStreak = ref.watch(streakStatsProvider).longestStreak;

    return Scaffold(
      appBar: AppBar(title: const Text('Appearance')),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object e, StackTrace st) => Center(child: Text('Something went wrong: $e')),
        data: (AppSettingsTableData settings) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: <Widget>[
              const SectionLabel('Theme'),
              const SizedBox(height: AppSpacing.xs),
              AppCard(
                child: SegmentedButton<ThemeMode>(
                  segments: const <ButtonSegment<ThemeMode>>[
                    ButtonSegment<ThemeMode>(value: ThemeMode.system, label: Text('System')),
                    ButtonSegment<ThemeMode>(value: ThemeMode.light, label: Text('Light')),
                    ButtonSegment<ThemeMode>(value: ThemeMode.dark, label: Text('Dark')),
                  ],
                  selected: <ThemeMode>{mode},
                  onSelectionChanged: (Set<ThemeMode> selection) {
                    final AppThemeMode appMode = switch (selection.first) {
                      ThemeMode.system => AppThemeMode.system,
                      ThemeMode.light => AppThemeMode.light,
                      ThemeMode.dark => AppThemeMode.dark,
                    };
                    setThemeMode(ref, appMode);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const SectionLabel('Accent color'),
              const SizedBox(height: AppSpacing.xs),
              AppCard(
                child: Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: <Widget>[
                    for (final AppAccentColor accent in AppAccentPalette.all)
                      _AccentSwatch(
                        color: accent.light,
                        label: accent.label,
                        selected: settings.accentColorId == accent.id,
                        locked: !unlocked.contains(accent.id),
                        onTap: () => unlocked.contains(accent.id)
                            ? ref
                                .read(settingsControllerProvider)
                                .update(
                                  AppSettingsTableCompanion(
                                    accentColorId: Value<String>(accent.id),
                                  ),
                                )
                            : _showLockedMessage(context, accent, longestStreak),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Text(
                  'More accent colors unlock permanently as you build a longer completion streak.',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showLockedMessage(BuildContext context, AppAccentColor accent, int longestStreak) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${accent.label} unlocks at a ${accent.unlockStreak}-day streak '
          '(your best is $longestStreak).',
        ),
      ),
    );
  }
}

class _AccentSwatch extends StatelessWidget {
  const _AccentSwatch({
    required this.color,
    required this.label,
    required this.selected,
    required this.locked,
    required this.onTap,
  });

  final Color color;
  final String label;
  final bool selected;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: locked ? color.withValues(alpha: 0.25) : color,
                  border: selected
                      ? Border.all(color: scheme.onSurface, width: 2)
                      : Border.all(color: scheme.onSurface.withValues(alpha: 0.08)),
                ),
              ),
              if (locked) Icon(Icons.lock_outline, size: 16, color: scheme.onSurface.withValues(alpha: 0.5)),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}
