import 'package:flutter/material.dart';

/// Type scale built on the self-hosted Plus Jakarta Sans variable font (see
/// assets/fonts/ — bundled rather than fetched at runtime, so the app never
/// depends on a network call for its own typography).
///
/// Task titles are the dominant type on screen per spec 3.1; metadata
/// (due time, tags) stays small. Weights reference named instances of the
/// Plus Jakarta Sans variable font (Flutter/Skia selects the correct
/// instance from the single variable-font asset based on the requested
/// [FontWeight]).
class AppTypography {
  const AppTypography._();

  static const String fontFamily = 'Plus Jakarta Sans';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 34,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  /// Task title in list/detail views — visually dominant per spec.
  static const TextStyle taskTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    height: 1.3,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 1.3,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    height: 1.4,
    fontWeight: FontWeight.w400,
  );

  /// Due time, tags, priority markers — small and gray, never competes
  /// visually with the task title.
  static const TextStyle metadata = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    height: 1.3,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    height: 1.3,
    fontWeight: FontWeight.w500,
  );
}
