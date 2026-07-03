import 'package:shared_preferences/shared_preferences.dart';

/// "Has completed onboarding" is install-local and not worth backing up —
/// re-showing onboarding after a restore is harmless — so it lives in
/// SharedPreferences rather than the AppSettings Drift row (see
/// core/db/tables/app_settings_table.dart's doc comment).
class OnboardingPrefs {
  const OnboardingPrefs._();

  static const String _kCompletedKey = 'onboarding_completed';

  static Future<bool> hasCompleted() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kCompletedKey) ?? false;
  }

  static Future<void> markCompleted() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kCompletedKey, true);
  }

  /// Used by Settings > About > "Replay onboarding".
  static Future<void> reset() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kCompletedKey, false);
  }
}
