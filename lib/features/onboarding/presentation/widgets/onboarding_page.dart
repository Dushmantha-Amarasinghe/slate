import 'package:flutter/material.dart';

import '../../../../core/theme/tokens/spacing_tokens.dart';
import '../../../../core/widgets/icon_badge.dart';

/// One slide of the onboarding carousel — shared shape for both the plain
/// philosophy slides and the permission-primer slides, so the whole flow
/// reads as one continuous piece rather than two different UIs stitched
/// together.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.statusLabel,
  });

  final IconData icon;
  final String title;
  final String description;

  /// Optional small line under the description — used by permission
  /// primers to show live "Allowed" / "Not allowed" status.
  final String? statusLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconBadge(icon: icon, size: 72, iconSize: 32),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (statusLabel != null) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            Text(statusLabel!, style: Theme.of(context).textTheme.labelSmall),
          ],
        ],
      ),
    );
  }
}
