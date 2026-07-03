import 'package:flutter/animation.dart';

/// Duration + curve constants for every animated state change in the app
/// (spec 3.3: "every state change animates"). Phase 4's motion pass consumes
/// these exclusively — no feature should hand-roll a duration or curve.
class AppMotionDurations {
  const AppMotionDurations._();

  /// Checkbox toggle, swipe-icon reveal, small taps.
  static const Duration microFast = Duration(milliseconds: 150);
  static const Duration microSlow = Duration(milliseconds: 250);

  /// Screen transitions, sheet open/close.
  static const Duration transitionFast = Duration(milliseconds: 300);
  static const Duration transitionSlow = Duration(milliseconds: 400);

  /// Streak milestones, "inbox zero" celebration.
  static const Duration celebratory = Duration(milliseconds: 600);
}

/// "Snappy but soft" easing — never the linear/default curves.
class AppMotionCurves {
  const AppMotionCurves._();

  static const Curve standard = Curves.easeOutCubic;
  static const Curve emphasized = Curves.easeOutBack;
  static const Curve enter = Curves.easeOut;
  static const Curve exit = Curves.easeIn;
}
