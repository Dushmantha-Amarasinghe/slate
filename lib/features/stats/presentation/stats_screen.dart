import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens/spacing_tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_label.dart';
import '../application/stats_controller.dart';
import '../application/streak_calculator.dart';
import 'widgets/completion_bar_chart.dart';
import 'widgets/streak_ring.dart';

/// Streak ring + completion-rate + a 7/30-day bar chart — the spec calls
/// the streak "a daily-open hook," which is why it gets its own bottom-nav
/// destination rather than being buried in a settings screen.
class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  bool _showThirtyDays = false;

  @override
  Widget build(BuildContext context) {
    final StreakStats streak = ref.watch(streakStatsProvider);
    final double rate = ref.watch(completionRateProvider);

    final List<MapEntry<DateTime, int>> allDays = streak.dailyCompletions.entries.toList();
    final List<MapEntry<DateTime, int>> chartDays = _showThirtyDays
        ? allDays
        : allDays.sublist(allDays.length - 7);
    final Map<DateTime, int> chartData = Map<DateTime, int>.fromEntries(chartDays);

    return Scaffold(
      appBar: AppBar(title: const Text('Stats')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: <Widget>[
          Center(child: StreakRing(streak: streak.currentStreak)),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: <Widget>[
              Expanded(
                child: _StatCard(
                  label: 'Longest streak',
                  value: '${streak.longestStreak}',
                  suffix: streak.longestStreak == 1 ? 'day' : 'days',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _StatCard(
                  label: 'Completion rate',
                  value: '${(rate * 100).round()}',
                  suffix: '%',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SectionLabel(
            'Activity',
            trailing: SegmentedButton<bool>(
              segments: const <ButtonSegment<bool>>[
                ButtonSegment<bool>(value: false, label: Text('7d')),
                ButtonSegment<bool>(value: true, label: Text('30d')),
              ],
              selected: <bool>{_showThirtyDays},
              onSelectionChanged: (Set<bool> selection) =>
                  setState(() => _showThirtyDays = selection.first),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: CompletionBarChart(data: chartData, showLabels: !_showThirtyDays),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, required this.suffix});

  final String label;
  final String value;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: AppSpacing.xxs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text(value, style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 26)),
              const SizedBox(width: 3),
              Text(suffix, style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}
