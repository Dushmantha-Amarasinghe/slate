/// 4pt spacing grid — every padding/gap/margin in the app should be one of
/// these values so spacing stays visually consistent across features.
class AppSpacing {
  const AppSpacing._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

/// Responsive breakpoints, reserved from Phase 0 even though the two-pane
/// tablet layout itself is deferred — retrofitting breakpoints into
/// hardcoded phone layouts later is painful.
class AppBreakpoints {
  const AppBreakpoints._();

  static const double phone = 600;
  static const double tabletPortrait = 900;
}
