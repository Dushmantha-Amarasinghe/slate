import 'package:flutter/material.dart';

import 'tokens/color_tokens.dart';
import 'tokens/radius_tokens.dart' as radius;
import 'tokens/spacing_tokens.dart';
import 'tokens/type_tokens.dart';

/// Builds the app's light/dark [ThemeData] from the design tokens in
/// tokens/. Every feature widget should read colors/type from [Theme.of]
/// rather than referencing [AppColors]/[AppTypography] directly, so a
/// future accent-color change (Settings > Appearance) propagates for free.
///
/// Contrast has been spot-checked against WCAG AA (grayscale text exceeds
/// 15:1 in both themes; the accent blue is ~4.5:1 on light and ~6.7:1 on
/// dark, meeting the 3:1 UI-component / large-text threshold used for the
/// FAB, overdue markers, and reminder badges it's applied to).
class AppTheme {
  const AppTheme._();

  static ThemeData light({Color accent = AppColors.accentDefault}) {
    final ColorScheme scheme = ColorScheme.light(
      surface: AppColors.lightBackground,
      onSurface: const Color(0xFF161616),
      primary: accent,
      onPrimary: Colors.white,
      error: AppColors.destructive,
      onError: Colors.white,
    );

    return _base(scheme, AppColors.lightGraySteps, AppColors.lightBackground);
  }

  static ThemeData dark({Color accent = AppColors.accentDefaultOnDark}) {
    final ColorScheme scheme = ColorScheme.dark(
      surface: AppColors.darkBackground,
      onSurface: const Color(0xFFEDEDED),
      primary: accent,
      onPrimary: Colors.black,
      error: AppColors.destructiveOnDark,
      onError: Colors.black,
    );

    return _base(scheme, AppColors.darkGraySteps, AppColors.darkBackground);
  }

  static ThemeData _base(
    ColorScheme scheme,
    List<Color> graySteps,
    Color background,
  ) {
    final TextTheme textTheme = TextTheme(
      displayLarge: AppTypography.displayLarge.copyWith(
        color: scheme.onSurface,
      ),
      titleLarge: AppTypography.taskTitle.copyWith(color: scheme.onSurface),
      titleMedium: AppTypography.titleMedium.copyWith(color: scheme.onSurface),
      bodyLarge: AppTypography.body.copyWith(color: scheme.onSurface),
      bodyMedium: AppTypography.body.copyWith(color: graySteps[1]),
      labelLarge: AppTypography.label.copyWith(color: scheme.onSurface),
      labelSmall: AppTypography.metadata.copyWith(color: graySteps[2]),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      fontFamily: AppTypography.fontFamily,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: scheme.onSurface,
        // Flutter's AppBar default (16px title inset, icon buttons flush to
        // the trailing edge) reads as cramped against this app's generally
        // roomier spacing scale — both edges get one more step of breathing
        // room (spacing_tokens.dart's `lg`/`sm`).
        titleSpacing: AppSpacing.lg,
        actionsPadding: const EdgeInsets.only(right: AppSpacing.sm),
      ),
      cardTheme: CardThemeData(
        color: graySteps[5],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.AppRadius.md),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      dividerTheme: DividerThemeData(color: graySteps[3], thickness: 0.6),
      splashFactory: InkSparkle.splashFactory,
      // Text fields (task title/description, tag names, the "type DELETE"
      // confirmation, etc.) default their focused border/cursor to
      // `colorScheme.primary` (accent blue) in stock Material 3 — same
      // off-brand-accent problem as every other themed control above.
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: scheme.onSurface,
        selectionColor: scheme.onSurface.withValues(alpha: 0.25),
        selectionHandleColor: scheme.onSurface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        focusColor: scheme.onSurface,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.AppRadius.md),
          borderSide: BorderSide(color: scheme.onSurface.withValues(alpha: 0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.AppRadius.md),
          borderSide: BorderSide(color: scheme.onSurface, width: 1.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.AppRadius.md),
          borderSide: BorderSide(color: scheme.onSurface.withValues(alpha: 0.12)),
        ),
        labelStyle: TextStyle(color: graySteps[2]),
        floatingLabelStyle: TextStyle(color: scheme.onSurface),
        hintStyle: TextStyle(color: graySteps[2]),
      ),
      // Switch defaults its "on" track to `colorScheme.primary` (accent
      // blue) in stock Material 3 — same off-brand-accent problem as the
      // buttons/nav bar/segmented buttons/chips above. Settings toggles
      // (haptics, reduce motion, sound, etc.) stay monochrome like every
      // other "on" affordance in the app.
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          return states.contains(WidgetState.selected) ? scheme.surface : scheme.onSurface;
        }),
        trackColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          return states.contains(WidgetState.selected)
              ? scheme.onSurface
              : scheme.onSurface.withValues(alpha: 0.12);
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          return states.contains(WidgetState.selected)
              ? Colors.transparent
              : scheme.onSurface.withValues(alpha: 0.3);
        }),
      ),
      // TextButton/FilledButton default to primary-colored text in stock
      // Material 3, which is how "Cancel"/"Create" ended up in accent blue
      // inside plain dialogs — every button surface should read monochrome
      // unless a screen deliberately opts into the accent (which none do
      // yet; the FAB uses its own explicit style above).
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: scheme.onSurface),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.onSurface,
          foregroundColor: scheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.AppRadius.md),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: graySteps[5],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.AppRadius.lg),
        ),
      ),
      // Same rationale as dialogTheme/bottomSheetTheme: left at Material 3's
      // default, a popup menu's surface tone in dark mode is nearly
      // indistinguishable from the true-black scaffold behind it, so it's
      // barely legible as a floating menu at all (Search's Date/Priority/Tag
      // dropdowns). One step lighter plus a visible border makes the menu
      // boundary legible in both themes.
      popupMenuTheme: PopupMenuThemeData(
        color: graySteps[5],
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.AppRadius.md),
          side: BorderSide(color: scheme.onSurface.withValues(alpha: 0.12)),
        ),
        textStyle: TextStyle(
          fontFamily: AppTypography.fontFamily,
          color: scheme.onSurface,
          fontSize: 15,
        ),
      ),
      // Same rationale as dialogTheme above: a bottom sheet left to
      // Material 3's default resolves to a surface tone that's nearly
      // identical to the scaffold background in dark mode, so it reads as
      // "the page" rather than a surface layered on top of it. One step
      // lighter, matching every AppCard, makes the sheet boundary legible.
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: graySteps[5],
        modalBackgroundColor: graySteps[5],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radius.AppRadius.lg)),
        ),
      ),
      // Undo snackbars (delete, clear completed) get their own custom
      // content row (see undo_delete_snackbar.dart) rather than relying on
      // contentTextStyle, but background/shape/inset still come from here
      // so any plain SnackBar elsewhere in the app stays consistent too —
      // stock Material 3 otherwise renders a light surface here regardless
      // of app theme, which is how the delete snackbar ended up looking
      // like a different app in dark mode.
      snackBarTheme: SnackBarThemeData(
        backgroundColor: graySteps[4],
        contentTextStyle: TextStyle(color: scheme.onSurface, fontFamily: AppTypography.fontFamily),
        actionTextColor: scheme.onSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.AppRadius.md),
        ),
      ),
      // Explicit nav-bar theme: without this, Material 3 auto-derives an
      // indicator color from the color scheme's `secondary`, which reads as
      // an off-brand teal. The selected-tab indicator stays neutral gray —
      // the accent color is reserved for overdue/reminders/the FAB only,
      // per the "one sparing accent" rule (spec 3.1).
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        indicatorColor: scheme.onSurface.withValues(alpha: 0.08),
        labelTextStyle: WidgetStateProperty.resolveWith((
          Set<WidgetState> states,
        ) {
          final bool selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? scheme.onSurface : graySteps[2],
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          final bool selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? scheme.onSurface : graySteps[2],
          );
        }),
      ),
      // Same rationale as segmentedButtonTheme below: stock Material 3
      // derives ChoiceChip/FilterChip's selected fill from `secondary`,
      // which reads as an off-brand muted purple. Selected chips stay
      // neutral gray, matching every other "selected" affordance in the app.
      // `color`/`elevation`/`surfaceTintColor` are all set explicitly
      // (rather than the older `backgroundColor`/`selectedColor` shorthand)
      // because M3's default elevation + surfaceTint overlay otherwise
      // darkens the "unselected" fill toward solid black in dark mode,
      // making selected vs. unselected read backwards.
      chipTheme: ChipThemeData(
        backgroundColor: graySteps[4],
        selectedColor: scheme.onSurface.withValues(alpha: 0.3),
        disabledColor: graySteps[4],
        side: BorderSide(color: scheme.onSurface.withValues(alpha: 0.12)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.AppRadius.pill),
        ),
        labelStyle: TextStyle(color: scheme.onSurface),
        secondaryLabelStyle: TextStyle(color: scheme.onSurface),
        checkmarkColor: scheme.onSurface,
        showCheckmark: true,
        elevation: 0,
        pressElevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius.AppRadius.pill),
            ),
          ),
          side: WidgetStatePropertyAll<BorderSide>(
            BorderSide(color: scheme.onSurface.withValues(alpha: 0.12)),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((
            Set<WidgetState> states,
          ) {
            return states.contains(WidgetState.selected)
                ? scheme.onSurface.withValues(alpha: 0.1)
                : Colors.transparent;
          }),
          foregroundColor: WidgetStatePropertyAll<Color>(scheme.onSurface),
        ),
      ),
    );
  }
}
