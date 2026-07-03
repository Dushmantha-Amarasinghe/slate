import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

const Uuid _uuid = Uuid();

/// Where voice note recordings live on disk. Only the returned path is
/// ever stored in the DB (`Task.voiceNotePath`) — never the audio blob
/// itself (spec section 8).
class AudioFileStore {
  const AudioFileStore._();

  static Future<String> newRecordingPath() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final Directory voiceNotesDir = Directory(p.join(dir.path, 'voice_notes'));
    if (!await voiceNotesDir.exists()) {
      await voiceNotesDir.create(recursive: true);
    }
    return p.join(voiceNotesDir.path, '${_uuid.v4()}.m4a');
  }

  /// Deletes a voice note file if it exists — used when a task is deleted
  /// or its voice note is replaced/removed, so recordings don't silently
  /// accumulate as orphaned files.
  static Future<void> deleteIfExists(String? path) async {
    if (path == null) return;
    final File file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
