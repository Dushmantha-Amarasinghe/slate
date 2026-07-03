import 'package:flutter/material.dart';

/// Grayscale + accent palette. This is the single source of truth for every
/// color used in the app — features must never hardcode a hex value, they
/// consume [AppColors] (light) / [AppColors.dark] (dark) via the theme.
class AppColors {
  const AppColors._();

  // Dark theme surfaces — true black, not just "dark gray", per spec 3.1.
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkSurface = Color(0xFF0A0A0A);

  // Light theme surfaces — off-white, not stark white, to avoid glare.
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);

  // Six-step grayscale used for hierarchy in dark mode (light-on-dark).
  static const List<Color> darkGraySteps = <Color>[
    Color(0xFFEDEDED), // gray50 — primary text
    Color(0xFFB8B8B8), // gray100 — secondary text
    Color(0xFF8A8A8A), // gray200 — tertiary text / metadata
    Color(0xFF5C5C5C), // gray300 — disabled / dividers
    Color(0xFF2E2E2E), // gray400 — subtle surface elevation
    Color(0xFF1A1A1A), // gray500 — card surface on true black
  ];

  // Six-step grayscale used for hierarchy in light mode (dark-on-light).
  static const List<Color> lightGraySteps = <Color>[
    Color(0xFF161616), // gray50 — primary text
    Color(0xFF444444), // gray100 — secondary text
    Color(0xFF6E6E6E), // gray200 — tertiary text / metadata
    Color(0xFF9C9C9C), // gray300 — disabled / dividers
    Color(0xFFD8D8D8), // gray400 — subtle surface elevation
    Color(0xFFEFEFEF), // gray500 — card surface on off-white
  ];

  /// The single sparing accent (spec 3.1): overdue tasks, active reminders,
  /// the add-task FAB. Electric blue — deliberately not red, so it never
  /// collides visually with destructive affordances (swipe-to-delete,
  /// validation errors), which use [destructive] below.
  static const Color accentDefault = Color(0xFF2F6FED);
  static const Color accentDefaultOnDark = Color(0xFF5B8DFF);

  /// Reserved for destructive affordances only (swipe-to-delete reveal,
  /// error states) — never used as a brand/accent color.
  static const Color destructive = Color(0xFFE5484D);
  static const Color destructiveOnDark = Color(0xFFFF6B70);
}

/// One selectable accent, with its light/dark variants and the longest-streak
/// (in days) required to unlock it. Electric Blue ships unlocked; the rest
/// are a streak-reward stretch feature (Settings > Appearance) — still "one
/// sparing accent" at a time, just user-chosen once earned.
class AppAccentColor {
  const AppAccentColor({
    required this.id,
    required this.label,
    required this.light,
    required this.dark,
    required this.unlockStreak,
  });

  final String id;
  final String label;
  final Color light;
  final Color dark;
  final int unlockStreak;
}

class AppAccentPalette {
  const AppAccentPalette._();

  static const List<AppAccentColor> all = <AppAccentColor>[
    AppAccentColor(
      id: 'electricBlue',
      label: 'Electric Blue',
      light: AppColors.accentDefault,
      dark: AppColors.accentDefaultOnDark,
      unlockStreak: 0,
    ),
    AppAccentColor(
      id: 'forest',
      label: 'Forest',
      light: Color(0xFF2A8C50),
      dark: Color(0xFF4CC97F),
      unlockStreak: 7,
    ),
    AppAccentColor(
      id: 'ember',
      label: 'Ember',
      light: Color(0xFFB5482F),
      dark: Color(0xFFE8785A),
      unlockStreak: 14,
    ),
    AppAccentColor(
      id: 'violet',
      label: 'Violet',
      light: Color(0xFF7B4FE0),
      dark: Color(0xFFA98BFF),
      unlockStreak: 30,
    ),
  ];

  static AppAccentColor byId(String id) =>
      all.firstWhere((AppAccentColor a) => a.id == id, orElse: () => all.first);
}
