import 'package:flutter/material.dart';

/// All-caps, letter-spaced micro-label used for section headers and small
/// metadata ("OUTPUT", "TODAY · 5 TASKS", etc.) — a small, cheap detail that
/// reads as considered/technical rather than default-Material.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.5);
    final TextStyle style = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.1,
      color: color,
    );

    if (trailing == null) return Text(text.toUpperCase(), style: style);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(text.toUpperCase(), style: style),
        DefaultTextStyle(style: style, child: trailing!),
      ],
    );
  }
}
