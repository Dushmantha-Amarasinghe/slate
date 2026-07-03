import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/database.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/theme/tokens/spacing_tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_fab.dart';
import '../../../core/widgets/icon_badge.dart';
import '../../../core/widgets/undo_delete_snackbar.dart';
import '../../../data/pending_delete_controller.dart';
import '../../../data/task_actions.dart';
import '../../tags/application/tag_controller.dart';
import '../../task_editor/presentation/task_editor_sheet.dart';
import '../application/today_controller.dart';
import 'widgets/task_card.dart';

class TodayScreen extends ConsumerStatefulWidget {
  const TodayScreen({super.key});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  bool _completedExpanded = false;

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Task>> pendingAsync = ref.watch(pendingTasksProvider);
    final AsyncValue<List<Task>> completedAsync = ref.watch(completedTasksProvider);
    final Map<String, Tag> tagsById = ref.watch(tagsByIdProvider);
    final Set<String> pendingDelete = ref.watch(pendingDeleteProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today'),
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
      body: pendingAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stackTrace) =>
            Center(child: Text('Something went wrong: $error')),
        data: (List<Task> pendingAll) {
          final List<Task> pending = pendingAll
              .where((Task t) => !pendingDelete.contains(t.id))
              .toList();
          final List<Task> completed = (completedAsync.value ?? const <Task>[])
              .where((Task t) => !pendingDelete.contains(t.id))
              .toList();

          if (pending.isEmpty && completed.isEmpty) {
            return _EmptyToday(onAddTask: () => TaskEditorSheet.show(context));
          }

          if (pending.isEmpty) {
            // Every task for today is done — this is the "celebratory
            // moment" the spec calls out (3.3), the strongest daily-open
            // hook alongside the streak indicator.
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: <Widget>[
                const _AllDoneBanner(),
                const SizedBox(height: AppSpacing.lg),
                _CompletedSection(
                  completed: completed,
                  expanded: _completedExpanded,
                  onToggle: () => setState(() => _completedExpanded = !_completedExpanded),
                  tagsById: tagsById,
                ),
              ],
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: <Widget>[
              for (final (int index, Task task) in pending.indexed)
                TaskCard(
                      key: ValueKey<String>(task.id),
                      task: task,
                      tag: task.tagId == null ? null : tagsById[task.tagId],
                      onToggleComplete: () => ref.read(taskActionsProvider).completeTask(task.id),
                      onTap: () => context.push(AppRoutes.taskDetailPath(task.id)),
                      onDelete: () =>
                          showUndoDeleteSnackbar(context, ref, taskId: task.id, taskTitle: task.title),
                    )
                    .animate()
                    .fadeIn(duration: 220.ms, delay: (index * 25).ms)
                    .slideY(begin: 0.04, end: 0, duration: 220.ms, curve: Curves.easeOutCubic),
              if (completed.isNotEmpty) ...<Widget>[
                const SizedBox(height: AppSpacing.xs),
                _CompletedSection(
                  completed: completed,
                  expanded: _completedExpanded,
                  onToggle: () => setState(() => _completedExpanded = !_completedExpanded),
                  tagsById: tagsById,
                ),
              ],
            ],
          );
        },
      ),
      floatingActionButton: AppFab(
        heroTag: _addTaskHeroTag,
        onPressed: () => TaskEditorSheet.show(context, heroTag: _addTaskHeroTag),
      ),
    );
  }
}

const String _addTaskHeroTag = 'today-add-fab';

class _CompletedSection extends StatelessWidget {
  const _CompletedSection({
    required this.completed,
    required this.expanded,
    required this.onToggle,
    required this.tagsById,
  });

  final List<Task> completed;
  final bool expanded;
  final VoidCallback onToggle;
  final Map<String, Tag> tagsById;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Row(
              children: <Widget>[
                AnimatedRotation(
                  duration: const Duration(milliseconds: 180),
                  turns: expanded ? 0.25 : 0,
                  child: const Icon(Icons.chevron_right, size: 18),
                ),
                const SizedBox(width: AppSpacing.xxs),
                Text('Completed (${completed.length})', style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: expanded
              ? Consumer(
                  builder: (BuildContext context, WidgetRef ref, _) {
                    return Column(
                      children: <Widget>[
                        for (final Task task in completed)
                          TaskCard(
                            key: ValueKey<String>(task.id),
                            task: task,
                            tag: task.tagId == null ? null : tagsById[task.tagId],
                            onToggleComplete: () => ref.read(taskActionsProvider).uncompleteTask(task.id),
                            onTap: () => context.push(AppRoutes.taskDetailPath(task.id)),
                            onDelete: () =>
                                showUndoDeleteSnackbar(context, ref, taskId: task.id, taskTitle: task.title),
                          ),
                      ],
                    );
                  },
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _AllDoneBanner extends StatelessWidget {
  const _AllDoneBanner();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl, horizontal: AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const IconBadge(icon: Icons.check_circle_outline, size: 56, iconSize: 26)
              .animate(onPlay: (AnimationController c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.08, 1.08),
                duration: 900.ms,
                curve: Curves.easeInOut,
              ),
          const SizedBox(height: AppSpacing.md),
          Text('All done for today', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Nice work — nothing left on today\'s list.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).scaleXY(begin: 0.95, end: 1, duration: 400.ms, curve: Curves.easeOutBack);
  }
}

class _EmptyToday extends StatelessWidget {
  const _EmptyToday({required this.onAddTask});

  final VoidCallback onAddTask;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: AppCard(
          onTap: onAddTask,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl, horizontal: AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const IconBadge(icon: Icons.checklist_outlined, size: 56, iconSize: 26)
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
                'Tap here or the + button to add your first task.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
