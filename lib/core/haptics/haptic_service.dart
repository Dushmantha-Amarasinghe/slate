import 'package:flutter/services.dart';

/// Thin wrapper over [HapticFeedback] — the spec calls for haptics at
/// exactly three moments (task completion, swipe-commit, reminder snooze),
/// and centralizing the calls here means a future Settings > Haptics
/// on/off toggle (Phase 6) only needs to gate this one file.
class HapticService {
  const HapticService._();

  static bool enabled = true;

  /// Task completion checkbox toggle.
  static void completion() {
    if (!enabled) return;
    HapticFeedback.mediumImpact();
  }

  /// The moment a swipe gesture crosses its commit threshold.
  static void swipeCommit() {
    if (!enabled) return;
    HapticFeedback.lightImpact();
  }

  /// Snoozing a reminder from the notification or in-app.
  static void snooze() {
    if (!enabled) return;
    HapticFeedback.lightImpact();
  }
}
