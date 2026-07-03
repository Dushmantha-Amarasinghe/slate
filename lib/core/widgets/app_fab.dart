import 'package:flutter/material.dart';

import '../theme/tokens/radius_tokens.dart';

/// The app's one FAB treatment: a rounded-square (not a bare circle) so it
/// shares the same corner language as [AppCard]/[IconBadge], lifted with a
/// soft neutral glow instead of Material's flat default shadow.
///
/// Kept monochrome (inverted surface color — white-on-dark / near-black-on-
/// light) rather than the accent color: on a screen with this much empty
/// black space, the FAB is the single largest, most-frequently-tapped shape
/// on screen, and a fully saturated accent fill there read as a mismatched
/// sticker rather than a considered accent. The accent stays reserved for
/// small, sparse signals (overdue markers, reminder badges) per spec 3.1;
/// the FAB communicates "primary action" through contrast and shape instead.
///
/// [heroTag] wires this FAB into the shared-element morph into
/// [TaskEditorSheet] (spec 3.3: "FAB morphs into the input sheet") — pass a
/// tag unique to the screen it's on (StatefulShellRoute keeps every branch's
/// FAB mounted simultaneously, so a shared tag across screens would collide)
/// and pass the same tag to `TaskEditorSheet.show`. Leave null to fall back
/// to a plain (non-morphing) FAB, e.g. where there's no sensible source.
class AppFab extends StatelessWidget {
  const AppFab({super.key, required this.onPressed, this.icon = Icons.add, this.heroTag});

  final VoidCallback onPressed;
  final IconData icon;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    final Widget fab = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: scheme.onSurface.withValues(alpha: 0.22),
            blurRadius: 20,
            spreadRadius: -6,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        // Explicit null disables the FAB's own automatic Hero wrapping in
        // both cases: when heroTag is null we want no Hero at all, and
        // when it's set we provide our own outer Hero below instead (a
        // nested pair of Heroes on the same widget would collide).
        heroTag: null,
        onPressed: onPressed,
        elevation: 0,
        highlightElevation: 0,
        backgroundColor: scheme.onSurface,
        foregroundColor: scheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        child: Icon(icon),
      ),
    );

    if (heroTag == null) return fab;
    return Hero(tag: heroTag!, child: Material(type: MaterialType.transparency, child: fab));
  }
}
