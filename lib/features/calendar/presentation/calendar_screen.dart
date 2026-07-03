import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/database.dart';
import '../../../core/db/tables/app_settings_table.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/theme/tokens/spacing_tokens.dart';
import '../../../core/widgets/app_fab.dart';
import '../../../core/widgets/icon_badge.dart';
import '../../../core/widgets/undo_delete_snackbar.dart';
import '../../../data/pending_delete_controller.dart';
import '../../../data/task_actions.dart';
import '../../settings/application/settings_controller.dart';
import '../../tags/application/tag_controller.dart';
import '../../task_editor/presentation/task_editor_sheet.dart';
import '../../today/presentation/widgets/task_card.dart';
import '../application/calendar_controller.dart';

const List<String> _monthNames = <String>[
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];
const List<String> _weekdayShort = <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

/// Days of the week ordered starting from [weekStart] — DateTime.weekday is
/// always Mon=1..Sun=7, so this just rotates that fixed list.
List<String> _orderedWeekdayLabels(WeekStartDay weekStart) {
  if (weekStart == WeekStartDay.monday) return _weekdayShort;
  return <String>[_weekdayShort.last, ..._weekdayShort.sublist(0, 6)];
}

int _weekdayOffset(DateTime date, WeekStartDay weekStart) {
  // DateTime.weekday: Mon=1..Sun=7. Offset from the configured week start.
  final int mondayBased = date.weekday - 1;
  if (weekStart == WeekStartDay.monday) return mondayBased;
  return (mondayBased + 1) % 7;
}

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime focused = ref.watch(calendarFocusedDateProvider);
    final DateTime selected = ref.watch(calendarSelectedDateProvider);
    final CalendarViewMode mode = ref.watch(calendarViewModeProvider);
    final Map<DateTime, List<Task>> byDate = ref.watch(tasksByDueDateProvider);
    final Map<String, Tag> tagsById = ref.watch(tagsByIdProvider);
    final Set<String> pendingDelete = ref.watch(pendingDeleteProvider);
    final WeekStartDay weekStart = ref.watch(
      settingsProvider.select(
        (AsyncValue<AppSettingsTableData> s) => s.value?.weekStartDay ?? WeekStartDay.sunday,
      ),
    );

    final List<Task> selectedDayTasks = (byDate[selected] ?? const <Task>[])
        .where((Task t) => !pendingDelete.contains(t.id))
        .toList()
      ..sort((Task a, Task b) => a.isCompleted == b.isCompleted ? 0 : (a.isCompleted ? 1 : -1));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
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
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
            child: _CalendarHeader(focused: focused, mode: mode, weekStart: weekStart),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: SegmentedButton<CalendarViewMode>(
              segments: const <ButtonSegment<CalendarViewMode>>[
                ButtonSegment<CalendarViewMode>(value: CalendarViewMode.week, label: Text('Week')),
                ButtonSegment<CalendarViewMode>(value: CalendarViewMode.month, label: Text('Month')),
              ],
              selected: <CalendarViewMode>{mode},
              onSelectionChanged: (Set<CalendarViewMode> selection) =>
                  ref.read(calendarViewModeProvider.notifier).state = selection.first,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: mode == CalendarViewMode.month
                ? _MonthGrid(
                    focused: focused,
                    selected: selected,
                    weekStart: weekStart,
                    byDate: byDate,
                    onSelect: (DateTime day) => ref.read(calendarSelectedDateProvider.notifier).state = day,
                  )
                : _WeekStrip(
                    focused: focused,
                    selected: selected,
                    weekStart: weekStart,
                    byDate: byDate,
                    onSelect: (DateTime day) => ref.read(calendarSelectedDateProvider.notifier).state = day,
                  ),
          ),
          const Divider(height: AppSpacing.lg),
          Expanded(
            child: selectedDayTasks.isEmpty
                ? _EmptyDay(date: selected)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      0,
                      AppSpacing.md,
                      AppSpacing.md,
                    ),
                    itemCount: selectedDayTasks.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Task task = selectedDayTasks[index];
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
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: AppFab(
        heroTag: _addTaskHeroTag,
        onPressed: () => TaskEditorSheet.show(context, heroTag: _addTaskHeroTag, initialDueDate: selected),
      ),
    );
  }
}

const String _addTaskHeroTag = 'calendar-add-fab';

class _CalendarHeader extends ConsumerWidget {
  const _CalendarHeader({required this.focused, required this.mode, required this.weekStart});

  final DateTime focused;
  final CalendarViewMode mode;
  final WeekStartDay weekStart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String label = mode == CalendarViewMode.month
        ? '${_monthNames[focused.month - 1]} ${focused.year}'
        : _weekRangeLabel(focused, weekStart);

    void shift(int direction) {
      final DateTime current = ref.read(calendarFocusedDateProvider);
      final DateTime next = mode == CalendarViewMode.month
          ? DateTime(current.year, current.month + direction, 1)
          : current.add(Duration(days: 7 * direction));
      ref.read(calendarFocusedDateProvider.notifier).state = next;
    }

    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => shift(-1),
        ),
        Expanded(
          child: Center(
            child: Text(label, style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () => shift(1),
        ),
        TextButton(
          onPressed: () {
            final DateTime today = DateTime.now();
            final DateTime todayOnly = DateTime(today.year, today.month, today.day);
            ref.read(calendarFocusedDateProvider.notifier).state = todayOnly;
            ref.read(calendarSelectedDateProvider.notifier).state = todayOnly;
          },
          child: const Text('Today'),
        ),
      ],
    );
  }

  String _weekRangeLabel(DateTime focused, WeekStartDay weekStart) {
    final DateTime start = focused.subtract(Duration(days: _weekdayOffset(focused, weekStart)));
    final DateTime end = start.add(const Duration(days: 6));
    final String startLabel = '${_monthNames[start.month - 1].substring(0, 3)} ${start.day}';
    final String endLabel = start.month == end.month
        ? '${end.day}'
        : '${_monthNames[end.month - 1].substring(0, 3)} ${end.day}';
    return '$startLabel – $endLabel';
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.focused,
    required this.selected,
    required this.weekStart,
    required this.byDate,
    required this.onSelect,
  });

  final DateTime focused;
  final DateTime selected;
  final WeekStartDay weekStart;
  final Map<DateTime, List<Task>> byDate;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final DateTime firstOfMonth = DateTime(focused.year, focused.month, 1);
    final int daysInMonth = DateTime(focused.year, focused.month + 1, 0).day;
    final int leadingBlanks = _weekdayOffset(firstOfMonth, weekStart);
    final DateTime today = DateTime.now();
    final DateTime todayOnly = DateTime(today.year, today.month, today.day);

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            for (final String label in _orderedWeekdayLabels(weekStart))
              Expanded(
                child: Center(
                  child: Text(label, style: Theme.of(context).textTheme.labelSmall),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
          itemCount: leadingBlanks + daysInMonth,
          itemBuilder: (BuildContext context, int index) {
            if (index < leadingBlanks) return const SizedBox.shrink();
            final int day = index - leadingBlanks + 1;
            final DateTime date = DateTime(focused.year, focused.month, day);
            return _DayCell(
              date: date,
              label: '$day',
              isToday: _isSameDay(date, todayOnly),
              isSelected: _isSameDay(date, selected),
              taskCount: byDate[date]?.length ?? 0,
              onTap: () => onSelect(date),
            );
          },
        ),
      ],
    );
  }
}

class _WeekStrip extends StatelessWidget {
  const _WeekStrip({
    required this.focused,
    required this.selected,
    required this.weekStart,
    required this.byDate,
    required this.onSelect,
  });

  final DateTime focused;
  final DateTime selected;
  final WeekStartDay weekStart;
  final Map<DateTime, List<Task>> byDate;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final DateTime start = focused.subtract(Duration(days: _weekdayOffset(focused, weekStart)));
    final DateTime today = DateTime.now();
    final DateTime todayOnly = DateTime(today.year, today.month, today.day);
    final List<String> labels = _orderedWeekdayLabels(weekStart);

    return Row(
      children: <Widget>[
        for (int i = 0; i < 7; i++)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                children: <Widget>[
                  Text(labels[i], style: Theme.of(context).textTheme.labelSmall),
                  const SizedBox(height: AppSpacing.xs),
                  Builder(
                    builder: (BuildContext context) {
                      final DateTime date = start.add(Duration(days: i));
                      return _DayCell(
                        date: date,
                        label: '${date.day}',
                        isToday: _isSameDay(date, todayOnly),
                        isSelected: _isSameDay(date, selected),
                        taskCount: byDate[date]?.length ?? 0,
                        onTap: () => onSelect(date),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.label,
    required this.isToday,
    required this.isSelected,
    required this.taskCount,
    required this.onTap,
  });

  final DateTime date;
  final String label;
  final bool isToday;
  final bool isSelected;
  final int taskCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? scheme.primary : Colors.transparent,
                border: isToday && !isSelected
                    ? Border.all(color: scheme.primary, width: 1.4)
                    : null,
              ),
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? scheme.onPrimary
                      : isToday
                          ? scheme.primary
                          : scheme.onSurface,
                  fontWeight: isSelected || isToday ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 3),
            if (taskCount == 0)
              const SizedBox(height: 4)
            else
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? scheme.primary : scheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyDay extends StatelessWidget {
  const _EmptyDay({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    final bool isToday = _isSameDay(date, DateTime(today.year, today.month, today.day));

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const IconBadge(icon: Icons.event_available_outlined, size: 48, iconSize: 22),
            const SizedBox(height: AppSpacing.sm),
            Text(
              isToday ? 'Nothing due today' : 'Nothing due this day',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
