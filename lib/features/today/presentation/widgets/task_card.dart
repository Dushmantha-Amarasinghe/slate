import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/animation/motion_utils.dart';
import '../../../../core/db/database.dart';
import '../../../../core/db/tables/app_settings_table.dart';
import '../../../../core/db/tables/tasks_table.dart';
import '../../../../core/haptics/haptic_service.dart';
import '../../../../core/icons/tag_icons.dart';
import '../../../../core/theme/tokens/color_tokens.dart';
import '../../../../core/theme/tokens/radius_tokens.dart';
import '../../../../core/theme/tokens/spacing_tokens.dart';
import '../../../../core/widgets/animated_checkbox.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/priority_bars.dart';
import '../../../../core/widgets/voice_note_player.dart';
import '../../../settings/application/settings_controller.dart';
import '../../../subtasks/application/subtask_controller.dart';

/// The task row shared by Today and All Tasks. Swipe right to complete,
/// left to delete (spec 4/3.3): both directions reveal an icon that scales
/// in with drag progress and fire a haptic exactly at the commit
/// threshold, rather than a static background — this is what makes the
/// gesture read as "considered" instead of a bare [Dismissible] default.
class TaskCard extends ConsumerStatefulWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.tag,
    required this.onToggleComplete,
    required this.onTap,
    required this.onDelete,
  });

  final Task task;
  final Tag? tag;
  final VoidCallback onToggleComplete;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  ConsumerState<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends ConsumerState<TaskCard> {
  double _progress = 0;
  DismissDirection? _direction;
  bool _pastThreshold = false;

  void _onUpdate(DismissUpdateDetails details) {
    setState(() {
      _progress = details.progress;
      _direction = details.direction;
    });
    if (details.reached && !_pastThreshold) {
      HapticService.swipeCommit();
    }
    _pastThreshold = details.reached;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color destructive = isDark ? AppColors.destructiveOnDark : AppColors.destructive;
    final Duration duration = motionDuration(context, const Duration(milliseconds: 200));

    final List<Subtask> subtasks =
        ref.watch(subtasksForTaskProvider(widget.task.id)).value ?? const <Subtask>[];
    final int completedSubtasks = subtasks.where((Subtask s) => s.isCompleted).length;

    final SwipeDirection swipeDirection = ref.watch(
      settingsProvider.select(
        (AsyncValue<AppSettingsTableData> s) =>
            s.value?.swipeDirection ?? SwipeDirection.rightCompleteLeftDelete,
      ),
    );
    // startToEnd = swipe right, endToStart = swipe left, in LTR locales.
    final bool startToEndCompletes = swipeDirection == SwipeDirection.rightCompleteLeftDelete;

    return Dismissible(
      key: ValueKey<String>(widget.task.id),
      direction: DismissDirection.horizontal,
      onUpdate: _onUpdate,
      dismissThresholds: const <DismissDirection, double>{
        DismissDirection.startToEnd: 0.4,
        DismissDirection.endToStart: 0.4,
      },
      background: _SwipeBackground(
        alignment: Alignment.centerLeft,
        color: startToEndCompletes
            ? scheme.onSurface.withValues(alpha: 0.1)
            : destructive.withValues(alpha: 0.16),
        icon: startToEndCompletes ? Icons.check_circle_outline : Icons.delete_outline,
        iconColor: startToEndCompletes ? scheme.onSurface : destructive,
        progress: _direction == DismissDirection.startToEnd ? _progress : 0,
      ),
      secondaryBackground: _SwipeBackground(
        alignment: Alignment.centerRight,
        color: startToEndCompletes
            ? destructive.withValues(alpha: 0.16)
            : scheme.onSurface.withValues(alpha: 0.1),
        icon: startToEndCompletes ? Icons.delete_outline : Icons.check_circle_outline,
        iconColor: startToEndCompletes ? destructive : scheme.onSurface,
        progress: _direction == DismissDirection.endToStart ? _progress : 0,
      ),
      onDismissed: (DismissDirection direction) {
        final bool completes = direction == DismissDirection.startToEnd
            ? startToEndCompletes
            : !startToEndCompletes;
        if (completes) {
          widget.onToggleComplete();
        } else {
          widget.onDelete();
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
        child: AppCard(
          onTap: widget.onTap,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: AnimatedCheckbox(checked: widget.task.isCompleted, onTap: widget.onToggleComplete),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AnimatedDefaultTextStyle(
                      duration: duration,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        decoration: widget.task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: scheme.onSurface.withValues(alpha: 0.4),
                        color: widget.task.isCompleted
                            ? scheme.onSurface.withValues(alpha: 0.4)
                            : scheme.onSurface,
                      ),
                      child: Text(widget.task.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                    if (widget.task.dueDateTimeLocal != null ||
                        widget.task.priority != TaskPriority.none ||
                        widget.tag != null ||
                        subtasks.isNotEmpty) ...<Widget>[
                      const SizedBox(height: AppSpacing.xxs),
                      Row(
                        children: <Widget>[
                          if (widget.task.priority != TaskPriority.none) ...<Widget>[
                            PriorityBars(priority: widget.task.priority, maxHeight: 10),
                            const SizedBox(width: AppSpacing.xs),
                          ],
                          if (widget.task.dueDateTimeLocal != null) ...<Widget>[
                            Icon(Icons.schedule, size: 12, color: scheme.onSurface.withValues(alpha: 0.45)),
                            const SizedBox(width: 3),
                            Text(
                              _formatDue(widget.task.dueDateTimeLocal!, widget.task.dueDateHasTime),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                          ],
                          if (widget.tag != null) ...<Widget>[
                            Icon(
                              tagIconFor(widget.tag!.iconRef),
                              size: 12,
                              color: scheme.onSurface.withValues(alpha: 0.45),
                            ),
                            const SizedBox(width: 3),
                            Text(widget.tag!.name, style: Theme.of(context).textTheme.labelSmall),
                            const SizedBox(width: AppSpacing.xs),
                          ],
                          if (subtasks.isNotEmpty) ...<Widget>[
                            Icon(
                              Icons.checklist_outlined,
                              size: 12,
                              color: scheme.onSurface.withValues(alpha: 0.45),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '$completedSubtasks/${subtasks.length}',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ],
                      ),
                    ],
                    if (widget.task.voiceNotePath != null) ...<Widget>[
                      const SizedBox(height: AppSpacing.xxs),
                      VoiceNotePlayer(filePath: widget.task.voiceNotePath!),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground({
    required this.alignment,
    required this.color,
    required this.icon,
    required this.iconColor,
    required this.progress,
  });

  final Alignment alignment;
  final Color color;
  final IconData icon;
  final Color iconColor;
  final double progress;

  @override
  Widget build(BuildContext context) {
    // Icon scales in from 0.6x to 1.15x then settles at 1x past the commit
    // threshold, rather than appearing at full size immediately — this is
    // the "reveal scales in as you swipe" moment from spec 3.3.
    final double scale = progress >= 0.4 ? 1.0 : 0.6 + (progress / 0.4) * 0.4;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      alignment: alignment,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Opacity(
        opacity: progress.clamp(0.0, 1.0),
        child: Transform.scale(scale: scale, child: Icon(icon, color: iconColor)),
      ),
    );
  }
}

String _formatDue(DateTime dt, bool hasTime) {
  final DateTime now = DateTime.now();
  final bool sameDay = dt.year == now.year && dt.month == now.month && dt.day == now.day;
  if (!hasTime) return sameDay ? 'Today' : '${dt.month}/${dt.day}';
  final String hour = (dt.hour % 12 == 0 ? 12 : dt.hour % 12).toString();
  final String minute = dt.minute.toString().padLeft(2, '0');
  final String period = dt.hour >= 12 ? 'PM' : 'AM';
  final String time = '$hour:$minute $period';
  return sameDay ? time : '${dt.month}/${dt.day} · $time';
}
