import 'package:flutter/material.dart';

import '../theme/tokens/radius_tokens.dart';
import '../theme/tokens/spacing_tokens.dart';

/// The app's one card treatment: subtle fill one step lighter than the page
/// background, a hairline border rather than a shadow, and generous inner
/// padding. Every bordered content panel in the app should be this widget,
/// not an ad hoc Container, so card styling never drifts between screens.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color borderColor = scheme.onSurface.withValues(alpha: 0.08);

    final Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: child,
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: content,
      ),
    );
  }
}
