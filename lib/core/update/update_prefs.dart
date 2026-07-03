import 'package:shared_preferences/shared_preferences.dart';

/// Install-local update-checker state (last check time, last seen version,
/// which "update available" banner the user already dismissed) — never
/// backed up, since it's meaningless on a different device/install.
class UpdatePrefs {
  const UpdatePrefs._();

  static const String _kLastCheckedAt = 'update_last_checked_at';
  static const String _kLastSeenVersion = 'update_last_seen_version';
  static const String _kDismissedBannerVersion = 'update_dismissed_banner_version';

  static Future<DateTime?> lastCheckedAt() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? iso = prefs.getString(_kLastCheckedAt);
    return iso == null ? null : DateTime.tryParse(iso);
  }

  static Future<void> setLastCheckedAt(DateTime time) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLastCheckedAt, time.toIso8601String());
  }

  static Future<String?> lastSeenVersion() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kLastSeenVersion);
  }

  static Future<void> setLastSeenVersion(String version) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLastSeenVersion, version);
  }

  static Future<String?> dismissedBannerVersion() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kDismissedBannerVersion);
  }

  static Future<void> dismissBanner(String version) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kDismissedBannerVersion, version);
  }
}
