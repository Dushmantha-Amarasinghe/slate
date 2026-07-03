import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/db/tables/tasks_table.dart';
import '../../../core/notifications/alarm_scheduler.dart';
import '../../../core/notifications/notification_service.dart';
import '../../../core/theme/tokens/radius_tokens.dart';
import '../../../core/theme/tokens/spacing_tokens.dart';
import '../../../core/utils/recurrence_utils.dart';
import '../../../core/utils/timezone_utils.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/priority_bars.dart';
import '../../../core/widgets/section_label.dart';
import '../../../core/widgets/toolbar_chip.dart';
import '../../../data/repositories/subtask_repository.dart';
import '../../../data/repositories/task_repository.dart';
import '../../settings/application/settings_controller.dart';
import '../../subtasks/presentation/subtask_add_field.dart';
import '../../subtasks/presentation/subtask_checklist.dart';
import '../../subtasks/presentation/subtask_row.dart';
import '../../tags/presentation/tag_picker.dart';
import 'repeat_picker.dart';
import 'voice_note_recorder_widget.dart';

/// Add/Edit Task bottom sheet — shared between create and edit flows.
/// Title is the only required field; description and due date start
/// collapsed/unset so the add-flow stays fast (spec 4).
class TaskEditorSheet extends ConsumerStatefulWidget {
  const TaskEditorSheet({super.key, this.existingTask, this.heroTag, this.initialDueDate});

  final Task? existingTask;

  /// Matches the [AppFab] that opened this sheet, for the FAB-morph shared
  /// element transition (spec 3.3). Null for flows with no FAB source
  /// (e.g. editing from Task Detail's edit button).
  final Object? heroTag;

  /// Pre-fills the due date (day only, no time) — used when adding a task
  /// from a specific day on the Calendar screen.
  final DateTime? initialDueDate;

  static Future<void> show(
    BuildContext context, {
    Task? existingTask,
    Object? heroTag,
    DateTime? initialDueDate,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => TaskEditorSheet(
        existingTask: existingTask,
        heroTag: heroTag,
        initialDueDate: initialDueDate,
      ),
    );
  }

  @override
  ConsumerState<TaskEditorSheet> createState() => _TaskEditorSheetState();
}

class _TaskEditorSheetState extends ConsumerState<TaskEditorSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  final TextEditingController _newSubtaskController = TextEditingController();
  final FocusNode _newSubtaskFocusNode = FocusNode();

  bool _descriptionExpanded = false;
  DateTime? _dueDateTime;
  bool _dueDateHasTime = true;
  TaskPriority _priority = TaskPriority.none;
  String? _tagId;
  Recurrence _recurrence = Recurrence.none;
  String? _voiceNotePath;
  bool _saving = false;

  // Not persisted until the task itself is saved (a new task has no id to
  // hang subtask rows off yet) — see _save()'s bulk-insert after addTask().
  final List<String> _pendingSubtasks = <String>[];

  bool get _isEditing => widget.existingTask != null;

  @override
  void initState() {
    super.initState();
    final Task? task = widget.existingTask;
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController = TextEditingController(
      text: task?.description ?? '',
    );
    _descriptionExpanded = (task?.description ?? '').isNotEmpty;
    _dueDateTime = task?.dueDateTimeLocal ?? widget.initialDueDate;
    _dueDateHasTime = task?.dueDateHasTime ?? (widget.initialDueDate != null ? false : true);
    _priority =
        task?.priority ?? ref.read(settingsProvider).value?.defaultPriority ?? TaskPriority.none;
    _tagId = task?.tagId;
    _recurrence = Recurrence.decode(task?.recurrenceRule);
    _voiceNotePath = task?.voiceNotePath;
    // Rebuilds the Save button's enabled state as the title field changes.
    _titleController.addListener(_onTitleChanged);
  }

  void _onTitleChanged() => setState(() {});

  @override
  void dispose() {
    _titleController.removeListener(_onTitleChanged);
    _titleController.dispose();
    _descriptionController.dispose();
    _newSubtaskController.dispose();
    _newSubtaskFocusNode.dispose();
    super.dispose();
  }

  void _addPendingSubtask(String title) {
    final String trimmed = title.trim();
    if (trimmed.isEmpty) return;
    _newSubtaskController.clear();
    setState(() => _pendingSubtasks.add(trimmed));
    _newSubtaskFocusNode.requestFocus();
  }

  Future<void> _pickDueDateTime() async {
    final DateTime now = DateTime.now();
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _dueDateTime ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (date == null || !mounted) return;

    // A due date can be just a day (no reminder, no specific moment) or a
    // day + time — asked as its own step rather than always forcing a time
    // picker, since plenty of tasks ("pay rent", "mom's birthday") don't
    // have a meaningful time of day.
    final bool? wantsTime = await _askIncludeTime();
    if (wantsTime == null || !mounted) return;

    if (!wantsTime) {
      setState(() {
        _dueDateTime = DateTime(date.year, date.month, date.day);
        _dueDateHasTime = false;
      });
      return;
    }

    await _pickTimeFor(date);
  }

  /// Loops back into the time picker (rather than silently clamping) when
  /// the chosen time is earlier than now on today's date — a due date in
  /// the past isn't meaningful, and re-prompting makes that obvious instead
  /// of just accepting it.
  Future<void> _pickTimeFor(DateTime date) async {
    final DateTime now = DateTime.now();
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _dueDateTime != null && _dueDateHasTime
          ? TimeOfDay.fromDateTime(_dueDateTime!)
          : TimeOfDay.fromDateTime(now),
    );
    if (time == null || !mounted) return;

    final DateTime combined = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    final bool isToday = date.year == now.year && date.month == now.month && date.day == now.day;
    if (isToday && combined.isBefore(now)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Pick a time later than now')));
      await _pickTimeFor(date);
      return;
    }

    setState(() {
      _dueDateTime = combined;
      _dueDateHasTime = true;
    });
  }

  Future<bool?> _askIncludeTime() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Add a time?'),
        content: const Text(
          'Set a specific time to get a reminder, or leave this due date as just a day.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No time'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Set time'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickPriority() async {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TaskPriority? picked = await showDialog<TaskPriority>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: const Text('Priority'),
        children: TaskPriority.values.map((TaskPriority p) {
          final bool selected = p == _priority;
          return SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(p),
            child: Row(
              children: <Widget>[
                PriorityBars(priority: p),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  priorityLabel(p),
                  style: TextStyle(fontWeight: selected ? FontWeight.w700 : FontWeight.w400),
                ),
                if (selected) ...<Widget>[
                  const Spacer(),
                  Icon(Icons.check, size: 18, color: scheme.onSurface),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
    if (picked != null) setState(() => _priority = picked);
  }

  Future<void> _save() async {
    final String title = _titleController.text.trim();
    if (title.isEmpty || _saving) return;
    setState(() => _saving = true);

    // Captured before any `await`s: re-resolving `Navigator.of(context)`
    // after several async gaps (permission dialogs, DB writes) risked
    // silently popping nothing if the element tree had shifted underneath
    // by the time we got there, leaving the sheet stuck open even though
    // the task had already saved.
    final NavigatorState navigator = Navigator.of(context);

    final String? description = _descriptionController.text.trim().isEmpty
        ? null
        : _descriptionController.text.trim();

    // A date-only due date (no time of day) has no specific moment to
    // remind at, so it never needs the reminder permissions or an alarm.
    final bool wantsReminder = _dueDateTime != null && _dueDateHasTime;

    final String? timezoneId = _dueDateTime == null
        ? null
        : await currentTimezoneId();

    if (wantsReminder) {
      // Contextual ask, not a cold launch prompt: this is the first moment
      // the app actually needs the permission. The full soft-ask primer
      // screen (explaining why, before this OS dialog fires) lands in
      // Phase 6's onboarding flow; this is the pragmatic interim.
      await NotificationService.requestNotificationPermission();
      await NotificationService.requestExactAlarmPermission();
    }

    final TaskRepository repo = ref.read(taskRepositoryProvider);
    final AlarmScheduler alarms = ref.read(alarmSchedulerProvider);
    final String taskId;
    if (_isEditing) {
      taskId = widget.existingTask!.id;
      await repo.editTask(
        id: taskId,
        title: title,
        description: description,
        dueDateTimeLocal: _dueDateTime,
        dueDateHasTime: _dueDateHasTime,
        timezoneId: timezoneId,
        priority: _priority,
        tagId: _tagId,
        isRecurring: _recurrence.isRecurring,
        recurrenceRule: _recurrence.isRecurring ? _recurrence.encode() : null,
        voiceNotePath: _voiceNotePath,
      );
    } else {
      taskId = await repo.addTask(
        title: title,
        description: description,
        dueDateTimeLocal: _dueDateTime,
        dueDateHasTime: _dueDateHasTime,
        timezoneId: timezoneId,
        priority: _priority,
        tagId: _tagId,
        isRecurring: _recurrence.isRecurring,
        recurrenceRule: _recurrence.isRecurring ? _recurrence.encode() : null,
        voiceNotePath: _voiceNotePath,
      );
      if (_pendingSubtasks.isNotEmpty) {
        final SubtaskRepository subtasks = ref.read(subtaskRepositoryProvider);
        for (final (int index, String subtaskTitle) in _pendingSubtasks.indexed) {
          await subtasks.addSubtask(taskId: taskId, title: subtaskTitle, sortOrder: index);
        }
      }
    }

    // The task is saved at this point — that's the part the user is
    // waiting on, so the sheet closes now rather than after the alarm call
    // below. Scheduling/cancelling the OS-level alarm is a fire-and-forget
    // side effect from here: it talks to a native plugin outside our
    // control, and if that call ever hangs (seen in testing with
    // AlarmManager on some devices/emulators), it must never leave the
    // sheet stuck open with a saved-but-inaccessible task behind it.
    if (navigator.mounted) navigator.pop();

    unawaited(_syncAlarm(alarms, wantsReminder, taskId, title, timezoneId));
  }

  Future<void> _syncAlarm(
    AlarmScheduler alarms,
    bool wantsReminder,
    String taskId,
    String title,
    String? timezoneId,
  ) async {
    try {
      if (wantsReminder && timezoneId != null) {
        await alarms.scheduleForTask(
          taskId: taskId,
          taskTitle: title,
          triggerTimeUtc: localWallTimeToUtc(_dueDateTime!, timezoneId),
        );
      } else {
        await alarms.cancelForTask(taskId);
      }
    } catch (error) {
      debugPrint('Failed to sync alarm for task $taskId: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final double bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final Widget sheet = AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: BoxDecoration(
          // One step lighter than the page background (the same
          // `cardTheme.color` every AppCard uses) rather than matching the
          // scaffold exactly — in dark mode the two are otherwise
          // indistinguishable and the sheet reads as "the page" instead of
          // a surface layered on top of it.
          color: Theme.of(context).cardTheme.color,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.lg),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.lg,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: scheme.onSurface.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
              ),
              TextField(
                controller: _titleController,
                autofocus: !_isEditing,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
                decoration: InputDecoration(
                  hintText: 'What do you need to do?',
                  hintStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    color: scheme.onSurface.withValues(alpha: 0.28),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                textCapitalization: TextCapitalization.sentences,
              ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                alignment: Alignment.topLeft,
                child: _descriptionExpanded
                    ? Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.xxs),
                        child: TextField(
                          controller: _descriptionController,
                          maxLines: 3,
                          minLines: 1,
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: const InputDecoration(
                            hintText: 'Add a description',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.xxs),
                        child: TextButton.icon(
                          onPressed: () =>
                              setState(() => _descriptionExpanded = true),
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Add description'),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            foregroundColor: scheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ),
              ).animate().fadeIn(duration: 220.ms, delay: 40.ms),
              // A voice note is an attachment to the task's write-up, not
              // a scheduling attribute — it sits with the description
              // rather than in the Details toolbar alongside due
              // date/priority, which are a different kind of thing.
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: VoiceNoteRecorderWidget(
                  initialPath: _voiceNotePath,
                  onChanged: (String? path) => setState(() => _voiceNotePath = path),
                ),
              ).animate().fadeIn(duration: 220.ms, delay: 60.ms),
              const SizedBox(height: AppSpacing.lg),
              const SectionLabel('Details'),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  ToolbarChip(
                    icon: const Icon(Icons.event_outlined),
                    label: _dueDateTime == null
                        ? 'Due date'
                        : _formatDueDateTime(_dueDateTime!, _dueDateHasTime),
                    selected: _dueDateTime != null,
                    onTap: _pickDueDateTime,
                    onClear: _dueDateTime == null
                        ? null
                        : () => setState(() {
                            _dueDateTime = null;
                            _dueDateHasTime = true;
                            _recurrence = Recurrence.none;
                          }),
                  ),
                  if (_dueDateTime != null)
                    RepeatPicker(
                      value: _recurrence,
                      onChanged: (Recurrence r) => setState(() => _recurrence = r),
                    ),
                  ToolbarChip(
                    icon: PriorityBars(priority: _priority, maxHeight: 12),
                    label: priorityLabel(_priority),
                    selected: _priority != TaskPriority.none,
                    onTap: _pickPriority,
                  ),
                ],
              ).animate().fadeIn(duration: 220.ms, delay: 80.ms).slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic),
              const SizedBox(height: AppSpacing.lg),
              const SectionLabel('Tags'),
              const SizedBox(height: AppSpacing.xs),
              TagPicker(
                selectedTagId: _tagId,
                onChanged: (String? id) => setState(() => _tagId = id),
              ).animate().fadeIn(duration: 220.ms, delay: 120.ms).slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic),
              const SizedBox(height: AppSpacing.lg),
              (_isEditing
                      ? SubtaskChecklist(taskId: widget.existingTask!.id)
                      : _NewTaskChecklist(
                          items: _pendingSubtasks,
                          controller: _newSubtaskController,
                          focusNode: _newSubtaskFocusNode,
                          onAdd: _addPendingSubtask,
                          onRemove: (int index) => setState(() => _pendingSubtasks.removeAt(index)),
                        ))
                  .animate()
                  .fadeIn(duration: 220.ms, delay: 140.ms)
                  .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _titleController.text.trim().isEmpty || _saving
                      ? null
                      : _save,
                  icon: Icon(_isEditing ? Icons.check : Icons.add, size: 18),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                  ),
                  label: Text(_isEditing ? 'Save changes' : 'Add task'),
                ),
              ).animate().fadeIn(duration: 220.ms, delay: 160.ms),
            ],
          ),
        ),
      ),
    );

    if (widget.heroTag == null) return sheet;

    return Hero(
      tag: widget.heroTag!,
      flightShuttleBuilder:
          (
            BuildContext flightContext,
            Animation<double> animation,
            HeroFlightDirection flightDirection,
            BuildContext fromHeroContext,
            BuildContext toHeroContext,
          ) {
            final Widget fromChild = (fromHeroContext.widget as Hero).child;
            final Widget toChild = (toHeroContext.widget as Hero).child;
            return AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? _) {
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Opacity(opacity: (1 - animation.value).clamp(0.0, 1.0), child: fromChild),
                    Opacity(opacity: animation.value.clamp(0.0, 1.0), child: toChild),
                  ],
                );
              },
            );
          },
      child: Material(type: MaterialType.transparency, child: sheet),
    );
  }
}

String _formatDueDateTime(DateTime dt, bool hasTime) {
  final String datePart = '${dt.month}/${dt.day}/${dt.year}';
  if (!hasTime) return datePart;
  final String hour = (dt.hour % 12 == 0 ? 12 : dt.hour % 12).toString();
  final String minute = dt.minute.toString().padLeft(2, '0');
  final String period = dt.hour >= 12 ? 'PM' : 'AM';
  return '$datePart · $hour:$minute $period';
}

/// A checklist for a task that doesn't exist yet — [items] live only in
/// this sheet's state and get bulk-inserted once the task itself is saved
/// (see _save()). Same [SubtaskRow]/[SubtaskAddField] as the real,
/// DB-backed checklist on Task Detail so the two feel like one feature.
class _NewTaskChecklist extends StatelessWidget {
  const _NewTaskChecklist({
    required this.items,
    required this.controller,
    required this.focusNode,
    required this.onAdd,
    required this.onRemove,
  });

  final List<String> items;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onAdd;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SectionLabel('Subtasks', trailing: items.isEmpty ? null : Text('0/${items.length}')),
          const SizedBox(height: AppSpacing.sm),
          if (items.isNotEmpty) ...<Widget>[
            for (final (int index, String title) in items.indexed)
              SubtaskRow(
                title: title,
                checked: false,
                onToggle: null,
                onDelete: () => onRemove(index),
              ),
            const SizedBox(height: AppSpacing.xxs),
          ],
          SubtaskAddField(controller: controller, focusNode: focusNode, onSubmitted: onAdd),
        ],
      ),
    );
  }
}

