import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/theme/tokens/spacing_tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_label.dart';
import '../../../data/repositories/subtask_repository.dart';
import '../application/subtask_controller.dart';
import 'subtask_add_field.dart';
import 'subtask_row.dart';

/// Checklist section shown on Task Detail, backed by the real (persisted)
/// subtasks for [taskId]. The create-task sheet has its own local,
/// not-yet-persisted equivalent (see task_editor_sheet.dart) since a new
/// task doesn't have a taskId to hang subtask rows off until it's saved.
class SubtaskChecklist extends ConsumerStatefulWidget {
  const SubtaskChecklist({super.key, required this.taskId});

  final String taskId;

  @override
  ConsumerState<SubtaskChecklist> createState() => _SubtaskChecklistState();
}

class _SubtaskChecklistState extends ConsumerState<SubtaskChecklist> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _addSubtask(int nextSortOrder) async {
    final String title = _controller.text.trim();
    if (title.isEmpty) return;
    _controller.clear();
    await ref
        .read(subtaskRepositoryProvider)
        .addSubtask(taskId: widget.taskId, title: title, sortOrder: nextSortOrder);
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Subtask>> subtasksAsync = ref.watch(subtasksForTaskProvider(widget.taskId));
    final List<Subtask> subtasks = subtasksAsync.value ?? const <Subtask>[];
    final int completedCount = subtasks.where((Subtask s) => s.isCompleted).length;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SectionLabel(
            'Subtasks',
            trailing: subtasks.isEmpty ? null : Text('$completedCount/${subtasks.length}'),
          ),
          if (subtasks.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            for (final Subtask subtask in subtasks)
              SubtaskRow(
                title: subtask.title,
                checked: subtask.isCompleted,
                onToggle: () =>
                    ref.read(subtaskRepositoryProvider).setCompleted(subtask, !subtask.isCompleted),
                onDelete: () => ref.read(subtaskRepositoryProvider).deleteSubtask(subtask.id),
              ),
            const SizedBox(height: AppSpacing.xxs),
          ] else
            const SizedBox(height: AppSpacing.sm),
          SubtaskAddField(
            controller: _controller,
            focusNode: _focusNode,
            onSubmitted: (_) => _addSubtask(subtasks.length),
          ),
        ],
      ),
    );
  }
}
