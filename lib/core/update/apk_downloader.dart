import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ApkDownloadCancelled implements Exception {}

/// Streams a release APK into the app's cache directory with real
/// byte-progress, rather than an indeterminate spinner — see build plan
/// section 8, step 4.
class ApkDownloader {
  ApkDownloader(this._client);

  final http.Client _client;

  /// [onProgress] receives (bytesReceived, totalBytes); totalBytes is -1 if
  /// the server didn't send a Content-Length. Call [cancel] to abort — the
  /// partial file is removed rather than left lying around.
  Future<File> download({
    required String url,
    required String fileName,
    required void Function(int received, int total) onProgress,
  }) async {
    final Directory cacheDir = await getTemporaryDirectory();
    final File destination = File(p.join(cacheDir.path, fileName));
    if (await destination.exists()) await destination.delete();

    final http.StreamedResponse response = await _client.send(http.Request('GET', Uri.parse(url)));
    if (response.statusCode != 200) {
      throw HttpException('Download failed with status ${response.statusCode}', uri: Uri.parse(url));
    }

    final int total = response.contentLength ?? -1;
    int received = 0;
    final IOSink sink = destination.openWrite();

    try {
      await for (final List<int> chunk in response.stream) {
        if (_cancelled) throw ApkDownloadCancelled();
        received += chunk.length;
        sink.add(chunk);
        onProgress(received, total);
      }
      await sink.flush();
    } finally {
      await sink.close();
    }

    if (_cancelled) {
      if (await destination.exists()) await destination.delete();
      throw ApkDownloadCancelled();
    }

    return destination;
  }

  bool _cancelled = false;

  void cancel() => _cancelled = true;
}

final Provider<ApkDownloader> apkDownloaderProvider = Provider<ApkDownloader>((Ref ref) {
  final ApkDownloader downloader = ApkDownloader(http.Client());
  ref.onDispose(downloader._client.close);
  return downloader;
});
