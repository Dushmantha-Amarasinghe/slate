import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import 'update_prefs.dart';

/// GitHub owner/repo the update checker polls. Release assets must include
/// exactly one APK named `slate-vX.Y.Z.apk` (see section 8 of the build
/// plan) so [UpdateCheckerService] can pick it out unambiguously.
const String kUpdateRepoOwner = 'reforatech';
const String kUpdateRepoName = 'slate';

const Duration kAutoCheckThrottle = Duration(hours: 1);

class UpdateInfo {
  const UpdateInfo({
    required this.version,
    required this.releaseNotes,
    required this.apkDownloadUrl,
    required this.apkAssetName,
    required this.htmlUrl,
  });

  final String version;
  final String releaseNotes;
  final String apkDownloadUrl;
  final String apkAssetName;
  final String htmlUrl;
}

class UpdateCheckResult {
  const UpdateCheckResult({this.updateInfo, this.error, this.throttled = false});

  final UpdateInfo? updateInfo;
  final String? error;
  final bool throttled;

  bool get hasUpdate => updateInfo != null;
}

/// Checks GitHub Releases for a newer version than the running app.
/// Distribution is GitHub Releases only (no Play Store), so this is the
/// app's entire update mechanism — see build plan section 8.
class UpdateCheckerService {
  UpdateCheckerService(this._client);

  final http.Client _client;

  /// [force] bypasses the once-per-hour throttle used for the automatic
  /// startup check; the manual "Check for updates" button always forces.
  Future<UpdateCheckResult> checkForUpdate({bool force = false}) async {
    if (!force) {
      final DateTime? lastChecked = await UpdatePrefs.lastCheckedAt();
      if (lastChecked != null && DateTime.now().difference(lastChecked) < kAutoCheckThrottle) {
        return const UpdateCheckResult(throttled: true);
      }
    }

    try {
      final Uri uri = Uri.https(
        'api.github.com',
        '/repos/$kUpdateRepoOwner/$kUpdateRepoName/releases/latest',
      );
      final http.Response response = await _client
          .get(uri, headers: <String, String>{'Accept': 'application/vnd.github+json'})
          .timeout(const Duration(seconds: 15));

      await UpdatePrefs.setLastCheckedAt(DateTime.now());

      if (response.statusCode != 200) {
        return UpdateCheckResult(error: 'GitHub returned ${response.statusCode}');
      }

      final Map<String, dynamic> json = jsonDecode(response.body) as Map<String, dynamic>;
      final String tagName = (json['tag_name'] as String?) ?? '';
      final String latestVersion = _stripLeadingV(tagName);
      if (latestVersion.isEmpty) {
        return const UpdateCheckResult(error: 'Release has no version tag');
      }

      await UpdatePrefs.setLastSeenVersion(latestVersion);

      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      if (!_isNewer(latestVersion, packageInfo.version)) {
        return const UpdateCheckResult();
      }

      final List<dynamic> assets = (json['assets'] as List<dynamic>?) ?? const <dynamic>[];
      final Map<String, dynamic>? apkAsset = assets
          .cast<Map<String, dynamic>>()
          .where((Map<String, dynamic> a) => (a['name'] as String? ?? '').endsWith('.apk'))
          .cast<Map<String, dynamic>?>()
          .firstWhere((_) => true, orElse: () => null);

      if (apkAsset == null) {
        return const UpdateCheckResult(error: 'Release has no APK asset');
      }

      return UpdateCheckResult(
        updateInfo: UpdateInfo(
          version: latestVersion,
          releaseNotes: (json['body'] as String?)?.trim().isNotEmpty == true
              ? (json['body'] as String).trim()
              : 'No release notes provided.',
          apkDownloadUrl: apkAsset['browser_download_url'] as String,
          apkAssetName: apkAsset['name'] as String,
          htmlUrl: (json['html_url'] as String?) ?? '',
        ),
      );
    } catch (e) {
      return UpdateCheckResult(error: 'Couldn\'t check for updates: $e');
    }
  }

  String _stripLeadingV(String tag) => tag.startsWith('v') ? tag.substring(1) : tag;

  /// Simple dotted-numeric semver compare — good enough for "1.2.0" vs
  /// "1.10.0" style tags; a trailing non-numeric suffix (e.g. "-beta") is
  /// ignored rather than causing a parse failure.
  bool _isNewer(String remote, String local) {
    List<int> parts(String v) => v
        .split('-')
        .first
        .split('.')
        .map((String p) => int.tryParse(p) ?? 0)
        .toList();

    final List<int> r = parts(remote);
    final List<int> l = parts(local);
    for (int i = 0; i < r.length || i < l.length; i++) {
      final int rv = i < r.length ? r[i] : 0;
      final int lv = i < l.length ? l[i] : 0;
      if (rv != lv) return rv > lv;
    }
    return false;
  }
}

final Provider<UpdateCheckerService> updateCheckerServiceProvider =
    Provider<UpdateCheckerService>((Ref ref) {
      final UpdateCheckerService service = UpdateCheckerService(http.Client());
      ref.onDispose(service._client.close);
      return service;
    });
