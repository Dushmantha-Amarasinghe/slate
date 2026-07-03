import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/tokens/motion_tokens.dart';

/// The streak's one deliberate use of the accent color (spec 3.1's "one
/// sparing accent" — overdue markers, reminders, and this: the single
/// daily-open reward moment) — everything else in Stats stays monochrome.
/// Fill is streak-days-out-of-[goal], capped at a full ring; the ring
/// itself is decorative motivation, not a literal countdown.
class StreakRing extends StatelessWidget {
  const StreakRing({super.key, required this.streak, this.goal = 30, this.size = 148});

  final int streak;
  final int goal;
  final double size;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final double progress = goal <= 0 ? 0 : (streak / goal).clamp(0.0, 1.0);

    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: progress),
        duration: AppMotionDurations.celebratory,
        curve: AppMotionCurves.standard,
        builder: (BuildContext context, double value, Widget? child) {
          return CustomPaint(
            painter: _RingPainter(
              progress: value,
              trackColor: scheme.onSurface.withValues(alpha: 0.08),
              fillColor: scheme.primary,
            ),
            child: child,
          );
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '$streak',
                style: Theme.of(
                  context,
                ).textTheme.displayLarge?.copyWith(fontSize: 40, height: 1),
              ),
              Text(
                streak == 1 ? 'day streak' : 'day streak',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.progress, required this.trackColor, required this.fillColor});

  final double progress;
  final Color trackColor;
  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    const double strokeWidth = 10;
    final Offset center = size.center(Offset.zero);
    final double radius = (size.shortestSide - strokeWidth) / 2;

    final Paint trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0) return;
    final Paint fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final double sweep = 2 * math.pi * progress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2, sweep, false, fillPaint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.fillColor != fillColor;
}
