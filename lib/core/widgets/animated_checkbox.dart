import 'package:flutter/material.dart';

import '../animation/motion_utils.dart';
import '../haptics/haptic_service.dart';

/// The task-completion checkbox: fills solid and scales the check mark in
/// rather than a flat icon swap — this is the app's most-repeated
/// interaction (spec 3.3's "signature moment"). Fires a haptic on every
/// toggle per spec 3.4.
class AnimatedCheckbox extends StatelessWidget {
  const AnimatedCheckbox({super.key, required this.checked, required this.onTap, this.size = 26});

  final bool checked;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Duration duration = motionDuration(context, const Duration(milliseconds: 200));

    return GestureDetector(
      onTap: () {
        HapticService.completion();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: duration,
        curve: Curves.easeOutCubic,
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: checked ? scheme.onSurface : Colors.transparent,
          border: Border.all(
            color: checked ? scheme.onSurface : scheme.onSurface.withValues(alpha: 0.32),
            width: 1.6,
          ),
        ),
        child: AnimatedScale(
          duration: duration,
          curve: Curves.easeOutBack,
          scale: checked ? 1 : 0,
          child: Icon(Icons.check, size: size * 0.65, color: scheme.surface),
        ),
      ),
    );
  }
}
