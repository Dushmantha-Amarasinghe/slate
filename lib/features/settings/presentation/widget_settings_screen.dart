import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/db/tables/app_settings_table.dart';
import '../../../core/theme/tokens/spacing_tokens.dart';
import '../../../core/widget/widget_tasks_provider.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_label.dart';
import '../application/settings_controller.dart';

/// Task count + filter mode for the home screen widget (Phase 7). The
/// widget itself has no UI of its own to configure this from — it's a
/// RemoteViews surface outside the Flutter engine — so this screen and its
/// live preview are the only place these settings are visible.
class WidgetSettingsScreen extends ConsumerWidget {
  const WidgetSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AppSettingsTableData> settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Widget')),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object e, StackTrace st) => Center(child: Text('Something went wrong: $e')),
        data: (AppSettingsTableData settings) {
          final List<WidgetTaskRow> realTasks = ref.watch(widgetSyncDataProvider).$1;
          // An empty "No tasks today" preview doesn't actually demonstrate
          // what the widget looks like — example rows do, as long as
          // they're clearly called out as examples in the caption below.
          final bool isExample = realTasks.isEmpty;
          final List<WidgetTaskRow> preview = isExample ? _exampleWidgetRows : realTasks;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: <Widget>[
              const SectionLabel('Preview'),
              const SizedBox(height: AppSpacing.xs),
              _WidgetPreview(tasks: preview, tapAction: settings.widgetTapAction),
              const SizedBox(height: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Text(
                  isExample
                      ? 'Showing example tasks — long-press your home screen and add the Slate widget to see your real tasks live.'
                      : 'Long-press your home screen and add the Slate widget to see it live.',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const SectionLabel('Interaction'),
              const SizedBox(height: AppSpacing.xs),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Tapping a task', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      settings.widgetTapAction == WidgetTapAction.markComplete
                          ? 'Marks it done right from the widget, no need to open the app.'
                          : 'Opens that task\'s details in the app.',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: WidgetTapAction.values.map((WidgetTapAction action) {
                        return ChoiceChip(
                          label: Text(_tapActionLabel(action)),
                          selected: settings.widgetTapAction == action,
                          onSelected: (_) => ref
                              .read(settingsControllerProvider)
                              .update(
                                AppSettingsTableCompanion(widgetTapAction: Value<WidgetTapAction>(action)),
                              ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const SectionLabel('Content'),
              const SizedBox(height: AppSpacing.xs),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Task count', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      children: List<int>.generate(5, (int i) => i + 1).map((int count) {
                        return ChoiceChip(
                          label: Text('$count'),
                          selected: settings.widgetTaskCount == count,
                          onSelected: (_) => ref
                              .read(settingsControllerProvider)
                              .update(AppSettingsTableCompanion(widgetTaskCount: Value<int>(count))),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Which tasks show', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: WidgetFilterMode.values.map((WidgetFilterMode mode) {
                        return ChoiceChip(
                          label: Text(_filterLabel(mode)),
                          selected: settings.widgetFilterMode == mode,
                          onSelected: (_) => ref
                              .read(settingsControllerProvider)
                              .update(
                                AppSettingsTableCompanion(widgetFilterMode: Value<WidgetFilterMode>(mode)),
                              ),
                        );
                      }).toList(),
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

  static const List<WidgetTaskRow> _exampleWidgetRows = <WidgetTaskRow>[
    WidgetTaskRow(id: '_example_1', title: 'Buy groceries'),
    WidgetTaskRow(id: '_example_2', title: 'Finish the report', subtaskProgress: '2/4'),
    WidgetTaskRow(id: '_example_3', title: 'Call the dentist'),
  ];

  String _filterLabel(WidgetFilterMode mode) => switch (mode) {
    WidgetFilterMode.todayOnly => 'Due today only',
    WidgetFilterMode.todayPlusOverdue => 'Due today + overdue',
  };

  String _tapActionLabel(WidgetTapAction action) => switch (action) {
    WidgetTapAction.openDetail => 'Open task',
    WidgetTapAction.markComplete => 'Mark complete',
  };
}

/// Mirrors android/app/src/main/res/layout/today_widget_layout.xml (and its
/// values/colors.xml + values-night/colors.xml) as closely as Flutter
/// widgets can — same corner radius, spacing, text sizes, and colors —
/// rather than reusing [AppCard]'s look, so this genuinely previews what
/// the native RemoteViews widget renders instead of just resembling it.
/// Uses the OS's actual brightness (not this app's own theme setting): the
/// widget is a system surface and always follows system dark mode, even if
/// the user has forced Slate itself to Light or Dark.
class _WidgetPreview extends StatelessWidget {
  const _WidgetPreview({required this.tasks, required this.tapAction});

  final List<WidgetTaskRow> tasks;
  final WidgetTapAction tapAction;

  @override
  Widget build(BuildContext context) {
    final bool isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final Color background = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFFFFFFF);
    final Color textPrimary = isDark ? const Color(0xFFEDEDED) : const Color(0xFF161616);
    final Color textSecondary = isDark ? const Color(0xFF8A8A8A) : const Color(0xFF6E6E6E);
    final Color divider = isDark ? const Color(0x1AFFFFFF) : const Color(0x14000000);
    final Color addButtonBg = isDark ? const Color(0xFFEDEDED) : const Color(0xFF161616);
    final Color addButtonFg = isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
    const String fontFamily = 'Plus Jakarta Sans';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  'Today',
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
              ),
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: addButtonBg, shape: BoxShape.circle),
                // An Icon centers on its true visual bounding box; a "+"
                // text glyph doesn't (most fonts' glyph metrics sit a
                // little off the geometric center of their em-box), which
                // is why this read as off-center against the circle.
                child: Icon(Icons.add, size: 16, color: addButtonFg),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(height: 1, color: divider),
          const SizedBox(height: 4),
          if (tasks.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'No tasks today',
                style: TextStyle(fontFamily: fontFamily, fontSize: 13, color: textSecondary),
              ),
            )
          else
            for (final WidgetTaskRow task in tasks)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(fontFamily: fontFamily, fontSize: 14, color: textPrimary),
                    children: <InlineSpan>[
                      // The mark-complete checkbox reads as a real tap
                      // target at a bigger size than a plain bullet needs
                      // to be — sized as its own span rather than bumping
                      // the whole row's font size.
                      TextSpan(
                        text: tapAction == WidgetTapAction.markComplete ? '○' : '•',
                        style: tapAction == WidgetTapAction.markComplete
                            ? const TextStyle(fontSize: 20)
                            : null,
                      ),
                      const TextSpan(text: '  '),
                      TextSpan(text: task.title),
                      if (task.subtaskProgress != null)
                        TextSpan(
                          text: '   ${task.subtaskProgress}',
                          style: TextStyle(fontSize: 12, color: textSecondary),
                        ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
        ],
      ),
    );
  }
}
