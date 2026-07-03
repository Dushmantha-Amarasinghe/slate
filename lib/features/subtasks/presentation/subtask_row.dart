import 'package:flutter/material.dart';

import '../../../core/theme/tokens/spacing_tokens.dart';
import '../../../core/widgets/animated_checkbox.dart';

/// One checklist row: checkbox + title + delete. [onToggle] is null for
/// the not-yet-saved local list in the create-task sheet (a subtask can't
/// be marked complete before the task it belongs to even exists) — in that
/// case the checkbox renders dimmed and non-interactive rather than being
/// omitted, so the row still reads as "a checklist item" at a glance.
class SubtaskRow extends StatelessWidget {
  const SubtaskRow({
    super.key,
    required this.title,
    required this.checked,
    required this.onToggle,
    required this.onDelete,
  });

  final String title;
  final bool checked;
  final VoidCallback? onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: <Widget>[
          if (onToggle == null)
            Opacity(
              opacity: 0.4,
              child: IgnorePointer(
                child: AnimatedCheckbox(size: 20, checked: false, onTap: () {}),
              ),
            )
          else
            AnimatedCheckbox(size: 20, checked: checked, onTap: onToggle!),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                decoration: checked ? TextDecoration.lineThrough : TextDecoration.none,
                color: checked ? scheme.onSurface.withValues(alpha: 0.4) : scheme.onSurface,
              ),
              child: Text(title),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            visualDensity: VisualDensity.compact,
            color: scheme.onSurface.withValues(alpha: 0.4),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
