import 'package:flutter/material.dart';

import '../../../core/theme/tokens/radius_tokens.dart';
import '../../../core/theme/tokens/spacing_tokens.dart';

/// The "Add item" row shared by the real (DB-backed) checklist on Task
/// Detail and the local pending-subtask list in the create-task sheet.
/// Given its own subtle fill/border so it reads as a distinct input
/// affordance rather than a bare, borderless [TextField] floating in the
/// card — the app-wide [InputDecorationTheme] otherwise leaks its
/// `focusedBorder` through unless every border variant is overridden here.
class SubtaskAddField extends StatelessWidget {
  const SubtaskAddField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(
        color: scheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.add, size: 18, color: scheme.onSurface.withValues(alpha: 0.5)),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: const InputDecoration(
                hintText: 'Add item',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: onSubmitted,
            ),
          ),
        ],
      ),
    );
  }
}
