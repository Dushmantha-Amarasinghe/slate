import 'package:record/record.dart';

import 'audio_file_store.dart';

/// Thin wrapper over [AudioRecorder] — capture only, no transcription, no
/// cloud upload (spec section 8). One recorder instance per recording
/// session; callers create a new [VoiceRecorderService] each time they
/// open the task editor and [dispose] it when done.
class VoiceRecorderService {
  final AudioRecorder _recorder = AudioRecorder();

  Future<bool> hasPermission() => _recorder.hasPermission();

  /// Starts recording to a fresh file path, returning that path so the
  /// caller can track it even before [stop] is called.
  Future<String> start() async {
    final String path = await AudioFileStore.newRecordingPath();
    await _recorder.start(const RecordConfig(), path: path);
    return path;
  }

  /// Stops recording and returns the final file path (or null if nothing
  /// was recorded).
  Future<String?> stop() => _recorder.stop();

  /// Stops and deletes the in-progress recording — used when the user
  /// cancels rather than keeps a recording.
  Future<void> cancel() => _recorder.cancel();

  Future<bool> isRecording() => _recorder.isRecording();

  Future<void> dispose() => _recorder.dispose();
}
