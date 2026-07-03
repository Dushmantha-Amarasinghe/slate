import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/tokens/radius_tokens.dart';
import '../../../core/theme/tokens/spacing_tokens.dart';
import '../../../core/voice/audio_file_store.dart';
import '../../../core/voice/voice_recorder_service.dart';
import '../../../core/widgets/voice_note_player.dart';

/// Tap-to-record mic control for the task editor (spec section 4/8). No
/// waveform, no transcription — just record, stop, play back, or discard.
/// Reports the saved file path (or null) back to the parent form via
/// [onChanged]; the parent is responsible for persisting it on save and
/// for deleting the previous file if a re-recording replaces it.
class VoiceNoteRecorderWidget extends StatefulWidget {
  const VoiceNoteRecorderWidget({super.key, required this.initialPath, required this.onChanged});

  final String? initialPath;
  final ValueChanged<String?> onChanged;

  @override
  State<VoiceNoteRecorderWidget> createState() => _VoiceNoteRecorderWidgetState();
}

class _VoiceNoteRecorderWidgetState extends State<VoiceNoteRecorderWidget> {
  final VoiceRecorderService _service = VoiceRecorderService();
  Timer? _ticker;

  String? _path;
  bool _isRecording = false;
  bool _permissionDenied = false;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _path = widget.initialPath;
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _service.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    final bool granted = await _service.hasPermission();
    if (!granted) {
      setState(() => _permissionDenied = true);
      return;
    }

    setState(() {
      _permissionDenied = false;
      _isRecording = true;
      _elapsed = Duration.zero;
    });

    await _service.start();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsed += const Duration(seconds: 1));
    });
  }

  Future<void> _stopRecording() async {
    _ticker?.cancel();
    final String? newPath = await _service.stop();
    // A re-recording replaces the previous take — the old file is now
    // orphaned, so it's deleted rather than left on disk indefinitely.
    if (_path != null && _path != newPath) {
      await AudioFileStore.deleteIfExists(_path);
    }
    setState(() {
      _isRecording = false;
      _path = newPath;
    });
    widget.onChanged(_path);
  }

  Future<void> _removeVoiceNote() async {
    await AudioFileStore.deleteIfExists(_path);
    setState(() => _path = null);
    widget.onChanged(null);
  }

  String _format(Duration d) {
    final int minutes = d.inMinutes;
    final int seconds = d.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    if (_isRecording) {
      return InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        onTap: _stopRecording,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            color: scheme.onSurface.withValues(alpha: 0.08),
            border: Border.all(color: scheme.onSurface.withValues(alpha: 0.24)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.stop_circle_outlined, size: 18, color: scheme.onSurface),
              const SizedBox(width: 6),
              Text('Recording · ${_format(_elapsed)}', style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ),
      );
    }

    if (_path != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          VoiceNotePlayer(filePath: _path!),
          const SizedBox(width: AppSpacing.xs),
          InkWell(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            onTap: _removeVoiceNote,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxs),
              child: Icon(Icons.close, size: 16, color: scheme.onSurface.withValues(alpha: 0.5)),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InkWell(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          onTap: _startRecording,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(color: scheme.onSurface.withValues(alpha: 0.14)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.mic_none, size: 18, color: scheme.onSurface.withValues(alpha: 0.7)),
                const SizedBox(width: 6),
                Text('Record voice note', style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
        ),
        if (_permissionDenied) ...<Widget>[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Microphone access is needed to record — check your device settings.',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: scheme.onSurface.withValues(alpha: 0.5)),
          ),
        ],
      ],
    );
  }
}
