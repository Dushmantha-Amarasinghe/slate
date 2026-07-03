import 'package:shared_preferences/shared_preferences.dart';

/// Recent search queries — install-local (not worth backing up, and
/// meaningless restored on a different device), same rationale as
/// OnboardingPrefs/UpdatePrefs.
class SearchHistoryPrefs {
  const SearchHistoryPrefs._();

  static const String _key = 'search_recent_queries';
  static const int maxEntries = 8;

  static Future<List<String>> recent() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? const <String>[];
  }

  /// Moves [query] to the front, de-duplicated, capped at [maxEntries].
  static Future<List<String>> add(String query) async {
    final String trimmed = query.trim();
    if (trimmed.isEmpty) return recent();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> updated = <String>[
      trimmed,
      ...(prefs.getStringList(_key) ?? const <String>[]).where(
        (String q) => q.toLowerCase() != trimmed.toLowerCase(),
      ),
    ].take(maxEntries).toList();
    await prefs.setStringList(_key, updated);
    return updated;
  }

  static Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
