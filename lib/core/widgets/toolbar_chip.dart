import 'package:flutter/material.dart';

import '../theme/tokens/radius_tokens.dart';
import '../theme/tokens/spacing_tokens.dart';

/// A pill-shaped filter/picker trigger: filled+bold when a value is
/// selected, ghost otherwise, with an optional inline clear (×). Used for
/// any "tap to open a picker" affordance (task editor's due date/priority
/// toolbar, search's filter dropdowns) so that language stays consistent
/// instead of falling back to a wall of [ChoiceChip]s.
class ToolbarChip extends StatelessWidget {
  const ToolbarChip({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.onClear,
  });

  final Widget icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          color: selected ? scheme.onSurface.withValues(alpha: 0.1) : Colors.transparent,
          border: Border.all(color: scheme.onSurface.withValues(alpha: selected ? 0.28 : 0.14)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconTheme(
              data: IconThemeData(size: 16, color: scheme.onSurface.withValues(alpha: selected ? 1 : 0.7)),
              child: icon,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: selected ? FontWeight.w600 : null,
              ),
            ),
            if (selected && onClear != null) ...<Widget>[
              const SizedBox(width: 4),
              InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: onClear,
                child: Icon(Icons.close, size: 14, color: scheme.onSurface.withValues(alpha: 0.5)),
              ),
            ] else ...<Widget>[
              const SizedBox(width: 2),
              Icon(Icons.expand_more, size: 15, color: scheme.onSurface.withValues(alpha: selected ? 0.8 : 0.5)),
            ],
          ],
        ),
      ),
    );
  }
}
