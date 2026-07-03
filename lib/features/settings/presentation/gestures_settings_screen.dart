import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/db/tables/app_settings_table.dart';
import '../../../core/theme/tokens/spacing_tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_label.dart';
import '../application/settings_controller.dart';
import 'widgets/settings_nav_row.dart';

class GesturesSettingsScreen extends ConsumerWidget {
  const GesturesSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AppSettingsTableData> settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Gestures & Interaction')),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object e, StackTrace st) => Center(child: Text('Something went wrong: $e')),
        data: (AppSettingsTableData settings) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: <Widget>[
              const SectionLabel('Swipe'),
              const SizedBox(height: AppSpacing.xs),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Swipe direction', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    SegmentedButton<SwipeDirection>(
                      segments: const <ButtonSegment<SwipeDirection>>[
                        ButtonSegment<SwipeDirection>(
                          value: SwipeDirection.rightCompleteLeftDelete,
                          label: Text('Right = complete'),
                        ),
                        ButtonSegment<SwipeDirection>(
                          value: SwipeDirection.leftCompleteRightDelete,
                          label: Text('Left = complete'),
                        ),
                      ],
                      selected: <SwipeDirection>{settings.swipeDirection},
                      onSelectionChanged: (Set<SwipeDirection> selection) => ref
                          .read(settingsControllerProvider)
                          .update(
                            AppSettingsTableCompanion(
                              swipeDirection: Value<SwipeDirection>(selection.first),
                            ),
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const SectionLabel('Feedback'),
              const SizedBox(height: AppSpacing.xs),
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  children: <Widget>[
                    SettingsNavRow(
                      icon: Icons.vibration,
                      title: 'Haptics',
                      subtitle: 'Vibrate on complete and swipe-commit',
                      trailing: Switch(
                        value: settings.hapticsEnabled,
                        onChanged: (bool value) => ref
                            .read(settingsControllerProvider)
                            .update(AppSettingsTableCompanion(hapticsEnabled: Value<bool>(value))),
                      ),
                    ),
                    const SettingsRowDivider(),
                    SettingsNavRow(
                      icon: Icons.motion_photos_off_outlined,
                      title: 'Reduce motion',
                      subtitle: 'Skip decorative animations app-wide',
                      trailing: Switch(
                        value: settings.reduceMotion,
                        onChanged: (bool value) => ref
                            .read(settingsControllerProvider)
                            .update(AppSettingsTableCompanion(reduceMotion: Value<bool>(value))),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
