import 'package:flutter/material.dart';

/// App-level "reduce motion" override from Settings > Gestures, synced from
/// the settings row by a `ref.listen` in [SlateApp] — kept as a static so
/// [motionDuration] call sites don't each need a Riverpod read.
class MotionSettings {
  const MotionSettings._();

  static bool reduceMotionOverride = false;
}

/// Respects the OS "reduce motion" accessibility setting
/// ([MediaQuery.disableAnimations]) and the in-app Settings > Gestures
/// override by collapsing a duration to zero — functional feedback (a
/// checkbox flipping state) still happens instantly, but decorative motion
/// doesn't play.
Duration motionDuration(BuildContext context, Duration normal) {
  final bool reduceMotion =
      MediaQuery.of(context).disableAnimations || MotionSettings.reduceMotionOverride;
  return reduceMotion ? Duration.zero : normal;
}
