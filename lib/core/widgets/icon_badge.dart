import 'package:flutter/material.dart';

import '../theme/tokens/radius_tokens.dart';

/// Wraps an icon in a soft rounded-square badge — icons never sit bare on
/// a screen. Consistent size/shape here is what makes the custom icon set
/// (Phase 4+) read as one system instead of a grab-bag of glyphs.
class IconBadge extends StatelessWidget {
  const IconBadge({
    super.key,
    required this.icon,
    this.size = 44,
    this.iconSize = 22,
    this.accent = false,
  });

  final IconData icon;
  final double size;
  final double iconSize;

  /// True only for the rare accent-colored badge (e.g. an overdue marker).
  /// Defaults to false — most badges stay neutral gray per the "one
  /// sparing accent" rule.
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color background = accent
        ? scheme.primary.withValues(alpha: 0.14)
        : scheme.onSurface.withValues(alpha: 0.06);
    final Color foreground = accent ? scheme.primary : scheme.onSurface;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Icon(icon, size: iconSize, color: foreground),
    );
  }
}
