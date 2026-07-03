import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/pending_delete_controller.dart';
import '../theme/tokens/spacing_tokens.dart';

/// Swiping a task away schedules its delete (see [PendingDeleteController])
/// and shows this snackbar rather than deleting immediately — matches the
/// "no jump cuts, nothing is unrecoverable without warning" motion
/// philosophy (spec 3.3) better than a blocking confirm dialog would.
void showUndoDeleteSnackbar(BuildContext context, WidgetRef ref, {required String taskId, required String taskTitle}) {
  ref.read(pendingDeleteProvider.notifier).scheduleDelete(taskId);
  _showUndoSnackbar(
    context,
    message: '"$taskTitle" deleted',
    onUndo: () => ref.read(pendingDeleteProvider.notifier).undo(taskId),
  );
}

/// "Clear completed" (Settings > Data Management) reuses the same
/// per-task pending-delete/undo machinery, just scheduled for every
/// completed task at once behind one snackbar.
void showUndoClearCompletedSnackbar(
  BuildContext context,
  WidgetRef ref, {
  required List<String> taskIds,
}) {
  if (taskIds.isEmpty) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('No completed tasks to clear')));
    return;
  }

  for (final String id in taskIds) {
    ref.read(pendingDeleteProvider.notifier).scheduleDelete(id);
  }

  _showUndoSnackbar(
    context,
    message: '${taskIds.length} completed ${taskIds.length == 1 ? 'task' : 'tasks'} cleared',
    onUndo: () {
      for (final String id in taskIds) {
        ref.read(pendingDeleteProvider.notifier).undo(id);
      }
    },
  );
}

void _showUndoSnackbar(BuildContext context, {required String message, required VoidCallback onUndo}) {
  final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: PendingDeleteController.undoWindow,
        content: _UndoSnackbarContent(
          message: message,
          duration: PendingDeleteController.undoWindow,
          onUndo: () {
            onUndo();
            messenger.hideCurrentSnackBar();
          },
          onClose: () => messenger.hideCurrentSnackBar(),
        ),
      ),
    );
}

/// The whole snackbar row (message, live countdown, Undo, close) is built
/// here rather than using [SnackBar.action] — that slot only fits one
/// button, and this needs both Undo and an explicit close alongside a
/// ticking countdown.
class _UndoSnackbarContent extends StatefulWidget {
  const _UndoSnackbarContent({
    required this.message,
    required this.duration,
    required this.onUndo,
    required this.onClose,
  });

  final String message;
  final Duration duration;
  final VoidCallback onUndo;
  final VoidCallback onClose;

  @override
  State<_UndoSnackbarContent> createState() => _UndoSnackbarContentState();
}

class _UndoSnackbarContentState extends State<_UndoSnackbarContent> {
  late int _secondsLeft = widget.duration.inSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!mounted) return;
      final int next = _secondsLeft - 1;
      if (next <= 0) {
        timer.cancel();
      }
      setState(() => _secondsLeft = next.clamp(0, widget.duration.inSeconds));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color muted = scheme.onSurface.withValues(alpha: 0.55);

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(widget.message, maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text('${_secondsLeft}s', style: TextStyle(color: muted, fontSize: 12)),
        const SizedBox(width: AppSpacing.xs),
        TextButton(
          onPressed: widget.onUndo,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('Undo'),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: widget.onClose,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxs),
            child: Icon(Icons.close, size: 16, color: muted),
          ),
        ),
      ],
    );
  }
}
