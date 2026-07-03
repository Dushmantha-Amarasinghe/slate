import 'package:flutter/material.dart';

import '../../../../core/theme/tokens/spacing_tokens.dart';

const List<String> _weekdayShort = <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

/// Monochrome bar chart of completions per day — [data] must already be
/// trimmed to the range to display (7 or 30 entries), oldest first.
/// Weekday labels only render for the 7-day view; 30 bars is too tight for
/// per-bar labels, so that view shows a date-range caption instead (see
/// the caller in stats_screen.dart).
class CompletionBarChart extends StatelessWidget {
  const CompletionBarChart({super.key, required this.data, required this.showLabels});

  final Map<DateTime, int> data;
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final List<MapEntry<DateTime, int>> entries = data.entries.toList();
    final int maxValue = entries.fold(0, (int acc, MapEntry<DateTime, int> e) => e.value > acc ? e.value : acc);

    return SizedBox(
      height: showLabels ? 140 : 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: entries.map((MapEntry<DateTime, int> entry) {
          final double heightFactor = maxValue == 0 ? 0.0 : entry.value / maxValue;
          final bool hasCompletions = entry.value > 0;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: entries.length > 14 ? 1 : AppSpacing.xxs),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: heightFactor.clamp(0.04, 1.0)),
                        duration: const Duration(milliseconds: 320),
                        curve: Curves.easeOutCubic,
                        builder: (BuildContext context, double value, Widget? child) {
                          return FractionallySizedBox(
                            heightFactor: value,
                            child: Container(
                              decoration: BoxDecoration(
                                color: hasCompletions
                                    ? scheme.onSurface.withValues(alpha: 0.75)
                                    : scheme.onSurface.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  if (showLabels) ...<Widget>[
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      _weekdayShort[entry.key.weekday - 1],
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
