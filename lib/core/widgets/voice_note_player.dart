import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../theme/tokens/radius_tokens.dart';
import '../theme/tokens/spacing_tokens.dart';

/// Compact play/pause + duration control for a saved voice note (spec
/// section 8: "a simple play/pause + duration label is enough for v1; a
/// waveform visual is a nice v2 polish item"). Owns its own [AudioPlayer]
/// instance scoped to this widget's lifetime, so multiple voice notes on
/// screen at once (e.g. in a task list) don't share playback state.
class VoiceNotePlayer extends StatefulWidget {
  const VoiceNotePlayer({super.key, required this.filePath});

  final String filePath;

  @override
  State<VoiceNotePlayer> createState() => _VoiceNotePlayerState();
}

class _VoiceNotePlayerState extends State<VoiceNotePlayer> {
  final AudioPlayer _player = AudioPlayer();
  Duration? _duration;
  bool _loadFailed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      _duration = await _player.setFilePath(widget.filePath);
      if (mounted) setState(() {});
    } catch (_) {
      if (mounted) setState(() => _loadFailed = true);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _format(Duration d) {
    final int minutes = d.inMinutes;
    final int seconds = d.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    if (_loadFailed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.error_outline, size: 16, color: scheme.onSurface.withValues(alpha: 0.5)),
          const SizedBox(width: 6),
          Text('Voice note unavailable', style: Theme.of(context).textTheme.labelSmall),
        ],
      );
    }

    return StreamBuilder<PlayerState>(
      stream: _player.playerStateStream,
      builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
        final bool playing = snapshot.data?.playing ?? false;
        final ProcessingState processingState =
            snapshot.data?.processingState ?? ProcessingState.idle;

        return InkWell(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          onTap: () async {
            if (processingState == ProcessingState.completed) {
              await _player.seek(Duration.zero);
            }
            playing ? await _player.pause() : await _player.play();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(color: scheme.onSurface.withValues(alpha: 0.16)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(playing ? Icons.pause : Icons.play_arrow, size: 16, color: scheme.onSurface),
                const SizedBox(width: 4),
                Text(
                  _duration == null ? 'Voice note' : _format(_duration!),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
