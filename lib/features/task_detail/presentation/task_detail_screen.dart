import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/icons/tag_icons.dart';
import '../../../core/theme/tokens/spacing_tokens.dart';
import '../../../core/widgets/animated_checkbox.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/priority_bars.dart';
import '../../../core/widgets/voice_note_player.dart';
import '../../../data/task_actions.dart';
import '../../subtasks/presentation/subtask_checklist.dart';
import '../../tags/application/tag_controller.dart';
import '../../task_editor/presentation/task_editor_sheet.dart';
import '../application/task_detail_controller.dart';

class TaskDetailScreen extends ConsumerWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Task?> taskAsync = ref.watch(taskByIdProvider(taskId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task'),
        actions: <Widget>[
          taskAsync.maybeWhen(
            data: (Task? task) => task == null
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip: 'Edit',
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () =>
                        TaskEditorSheet.show(context, existingTask: task),
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
          taskAsync.maybeWhen(
            data: (Task? task) => task == null
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip: 'Delete',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _confirmDelete(context, ref, task.id),
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: taskAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stackTrace) =>
            Center(child: Text('Something went wrong: $error')),
        data: (Task? task) {
          if (task == null) {
            return const Center(child: Text('This task no longer exists.'));
          }
          return _TaskDetailBody(task: task);
        },
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete this task?'),
        content: const Text('This cannot be undone.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(taskActionsProvider).deleteTask(id);
      if (context.mounted) Navigator.of(context).pop();
    }
  }
}

class _TaskDetailBody extends ConsumerWidget {
  const _TaskDetailBody({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, Tag> tagsById = ref.watch(tagsByIdProvider);
    final Tag? tag = task.tagId == null ? null : tagsById[task.tagId];
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: <Widget>[
        AppCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: AnimatedCheckbox(
                  checked: task.isCompleted,
                  onTap: () => task.isCompleted
                      ? ref.read(taskActionsProvider).uncompleteTask(task.id)
                      : ref.read(taskActionsProvider).completeTask(task.id),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: task.isCompleted
                        ? scheme.onSurface.withValues(alpha: 0.4)
                        : scheme.onSurface,
                  ),
                  child: Text(task.title),
                ),
              ),
            ],
          ),
        ),
        if (task.description != null) ...<Widget>[
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: Text(
              task.description!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
        if (task.voiceNotePath != null) ...<Widget>[
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: Row(
              children: <Widget>[
                Icon(Icons.mic_none, size: 18, color: scheme.onSurface.withValues(alpha: 0.6)),
                const SizedBox(width: AppSpacing.xs),
                Text('Voice note', style: Theme.of(context).textTheme.labelSmall),
                const Spacer(),
                VoiceNotePlayer(filePath: task.voiceNotePath!),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        SubtaskChecklist(taskId: task.id),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _DetailRow(
                icon: Icons.event_outlined,
                label: 'Due',
                value: task.dueDateTimeLocal == null
                    ? 'No due date'
                    : _formatFull(task.dueDateTimeLocal!, task.dueDateHasTime),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.flag_outlined,
                    size: 18,
                    color: scheme.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Priority',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const Spacer(),
                  PriorityBars(priority: task.priority),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    priorityLabel(task.priority),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
              if (tag != null) ...<Widget>[
                const SizedBox(height: AppSpacing.sm),
                _DetailRow(
                  icon: tagIconFor(tag.iconRef),
                  label: 'Tag',
                  value: tag.name,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final Color muted = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.6);
    return Row(
      children: <Widget>[
        Icon(icon, size: 18, color: muted),
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const Spacer(),
        Text(value, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

String _formatFull(DateTime dt, bool hasTime) {
  final String datePart = '${dt.month}/${dt.day}/${dt.year}';
  if (!hasTime) return datePart;
  final String hour = (dt.hour % 12 == 0 ? 12 : dt.hour % 12).toString();
  final String minute = dt.minute.toString().padLeft(2, '0');
  final String period = dt.hour >= 12 ? 'PM' : 'AM';
  return '$datePart · $hour:$minute $period';
}
