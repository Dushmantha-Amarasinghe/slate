import 'package:flutter/material.dart';

import '../db/tables/tasks_table.dart';
import '../theme/tokens/radius_tokens.dart';

/// Three ascending-height bars (like a signal-strength icon), with
/// `priority` of them filled — a deliberately colorless way to signal
/// urgency. The spec calls for priority as "a subtle marker, not loud
/// colors", so this never reaches for red/amber/green: weight and fill
/// communicate the level, not hue.
class PriorityBars extends StatelessWidget {
  const PriorityBars({
    super.key,
    required this.priority,
    this.barWidth = 4,
    this.maxHeight = 14,
  });

  final TaskPriority priority;
  final double barWidth;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final Color onColor = Theme.of(context).colorScheme.onSurface;
    final int filled = priority.index; // none=0, low=1, medium=2, high=3
    final List<double> heights = <double>[
      maxHeight * 0.45,
      maxHeight * 0.72,
      maxHeight,
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List<Widget>.generate(3, (int i) {
        final bool isFilled = i < filled;
        return Padding(
          padding: EdgeInsets.only(left: i == 0 ? 0 : 2),
          child: Container(
            width: barWidth,
            height: heights[i],
            decoration: BoxDecoration(
              color: onColor.withValues(alpha: isFilled ? 0.85 : 0.16),
              borderRadius: BorderRadius.circular(AppRadius.sm / 4),
            ),
          ),
        );
      }),
    );
  }
}

String priorityLabel(TaskPriority priority) {
  switch (priority) {
    case TaskPriority.none:
      return 'No priority';
    case TaskPriority.low:
      return 'Low';
    case TaskPriority.medium:
      return 'Medium';
    case TaskPriority.high:
      return 'High';
  }
}
