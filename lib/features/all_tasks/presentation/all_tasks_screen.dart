import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/database.dart';
import '../../../core/db/tables/app_settings_table.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/theme/tokens/spacing_tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_fab.dart';
import '../../../core/widgets/icon_badge.dart';
import '../../../core/widgets/undo_delete_snackbar.dart';
import '../../../data/pending_delete_controller.dart';
import '../../../data/task_actions.dart';
import '../../settings/application/settings_controller.dart';
import '../../tags/application/tag_controller.dart';
import '../../task_editor/presentation/task_editor_sheet.dart';
import '../../today/presentation/widgets/task_card.dart';
import '../application/all_tasks_controller.dart';

/// Every task regardless of due date — Today is the daily-focus view, this
/// is the full backlog. Sort order follows Settings > Task Defaults
/// (defaults to due date, soonest first, undated last); grouping by
/// tag/priority lands in Phase 8.
class AllTasksScreen extends ConsumerWidget {
  const AllTasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Task>> tasksAsync = ref.watch(allTasksProvider);
    final Map<String, Tag> tagsById = ref.watch(tagsByIdProvider);
    final Set<String> pendingDelete = ref.watch(pendingDeleteProvider);
    final TaskSortOption sortOption = ref.watch(
      settingsProvider.select(
        (AsyncValue<AppSettingsTableData> s) => s.value?.defaultSort ?? TaskSortOption.dueDate,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Tasks'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search_outlined),
            onPressed: () => context.push(AppRoutes.search),
          ),
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stackTrace) =>
            Center(child: Text('Something went wrong: $error')),
        data: (List<Task> tasksAll) {
          final List<Task> tasks = tasksAll.where((Task t) => !pendingDelete.contains(t.id)).toList();

          if (tasks.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: AppCard(
                  onTap: () => TaskEditorSheet.show(context),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl, horizontal: AppSpacing.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const IconBadge(icon: Icons.list_alt_outlined, size: 56, iconSize: 26)
                          .animate(onPlay: (AnimationController c) => c.repeat(reverse: true))
                          .scale(
                            begin: const Offset(1, 1),
                            end: const Offset(1.06, 1.06),
                            duration: 1200.ms,
                            curve: Curves.easeInOut,
                          ),
                      const SizedBox(height: AppSpacing.md),
                      Text('No tasks yet', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        'Everything you add shows up here.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final List<Task> sorted = _sorted(tasks, sortOption);

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: sorted.length,
            itemBuilder: (BuildContext context, int index) {
              final Task task = sorted[index];
              return TaskCard(
                    key: ValueKey<String>(task.id),
                    task: task,
                    tag: task.tagId == null ? null : tagsById[task.tagId],
                    onToggleComplete: () => task.isCompleted
                        ? ref.read(taskActionsProvider).uncompleteTask(task.id)
                        : ref.read(taskActionsProvider).completeTask(task.id),
                    onTap: () => context.push(AppRoutes.taskDetailPath(task.id)),
                    onDelete: () =>
                        showUndoDeleteSnackbar(context, ref, taskId: task.id, taskTitle: task.title),
                  )
                  .animate()
                  .fadeIn(duration: 200.ms, delay: (index.clamp(0, 12) * 20).ms)
                  .slideY(begin: 0.03, end: 0, duration: 200.ms, curve: Curves.easeOutCubic);
            },
          );
        },
      ),
      floatingActionButton: AppFab(
        heroTag: _addTaskHeroTag,
        onPressed: () => TaskEditorSheet.show(context, heroTag: _addTaskHeroTag),
      ),
    );
  }

  List<Task> _sorted(List<Task> tasks, TaskSortOption option) {
    final List<Task> copy = List<Task>.of(tasks);
    copy.sort((Task a, Task b) {
      if (a.isCompleted != b.isCompleted) return a.isCompleted ? 1 : -1;
      switch (option) {
        case TaskSortOption.dueDate:
          if (a.dueDateTimeLocal == null && b.dueDateTimeLocal == null) return 0;
          if (a.dueDateTimeLocal == null) return 1;
          if (b.dueDateTimeLocal == null) return -1;
          return a.dueDateTimeLocal!.compareTo(b.dueDateTimeLocal!);
        case TaskSortOption.priority:
          return b.priority.index.compareTo(a.priority.index);
        case TaskSortOption.createdDate:
          return b.createdAt.compareTo(a.createdAt);
        case TaskSortOption.alphabetical:
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      }
    });
    return copy;
  }
}

const String _addTaskHeroTag = 'all-tasks-add-fab';
