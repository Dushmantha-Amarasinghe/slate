import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/db/tables/app_settings_table.dart';
import '../../../core/db/tables/tasks_table.dart';
import '../../../core/theme/tokens/spacing_tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/priority_bars.dart';
import '../../../core/widgets/section_label.dart';
import '../application/settings_controller.dart';

class TaskDefaultsSettingsScreen extends ConsumerWidget {
  const TaskDefaultsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AppSettingsTableData> settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Task Defaults')),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object e, StackTrace st) => Center(child: Text('Something went wrong: $e')),
        data: (AppSettingsTableData settings) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: <Widget>[
              const SectionLabel('All Tasks list'),
              const SizedBox(height: AppSpacing.xs),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Default sort', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: TaskSortOption.values.map((TaskSortOption option) {
                        return ChoiceChip(
                          label: Text(_sortLabel(option)),
                          selected: settings.defaultSort == option,
                          onSelected: (_) => ref
                              .read(settingsControllerProvider)
                              .update(
                                AppSettingsTableCompanion(defaultSort: Value<TaskSortOption>(option)),
                              ),
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
                    Text('Default grouping', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: TaskGroupingOption.values.map((TaskGroupingOption option) {
                        return ChoiceChip(
                          label: Text(_groupingLabel(option)),
                          selected: settings.defaultGrouping == option,
                          onSelected: (_) => ref
                              .read(settingsControllerProvider)
                              .update(
                                AppSettingsTableCompanion(
                                  defaultGrouping: Value<TaskGroupingOption>(option),
                                ),
                              ),
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
                    Text('Week starts on', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    SegmentedButton<WeekStartDay>(
                      segments: const <ButtonSegment<WeekStartDay>>[
                        ButtonSegment<WeekStartDay>(value: WeekStartDay.sunday, label: Text('Sunday')),
                        ButtonSegment<WeekStartDay>(value: WeekStartDay.monday, label: Text('Monday')),
                      ],
                      selected: <WeekStartDay>{settings.weekStartDay},
                      onSelectionChanged: (Set<WeekStartDay> selection) => ref
                          .read(settingsControllerProvider)
                          .update(
                            AppSettingsTableCompanion(
                              weekStartDay: Value<WeekStartDay>(selection.first),
                            ),
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const SectionLabel('New tasks'),
              const SizedBox(height: AppSpacing.xs),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Default priority', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      children: TaskPriority.values.map((TaskPriority priority) {
                        final bool selected = settings.defaultPriority == priority;
                        return ChoiceChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              PriorityBars(priority: priority, maxHeight: 10),
                              const SizedBox(width: AppSpacing.xxs),
                              Text(priorityLabel(priority)),
                            ],
                          ),
                          selected: selected,
                          onSelected: (_) => ref
                              .read(settingsControllerProvider)
                              .update(
                                AppSettingsTableCompanion(
                                  defaultPriority: Value<TaskPriority>(priority),
                                ),
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

  String _sortLabel(TaskSortOption option) => switch (option) {
    TaskSortOption.dueDate => 'Due date',
    TaskSortOption.priority => 'Priority',
    TaskSortOption.createdDate => 'Date created',
    TaskSortOption.alphabetical => 'Alphabetical',
  };

  String _groupingLabel(TaskGroupingOption option) => switch (option) {
    TaskGroupingOption.none => 'None',
    TaskGroupingOption.byDate => 'By date',
    TaskGroupingOption.byTag => 'By tag',
    TaskGroupingOption.byPriority => 'By priority',
  };
}
