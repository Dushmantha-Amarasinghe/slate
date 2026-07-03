import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens/color_tokens.dart';
import '../../stats/application/stats_controller.dart';

/// Which accent ids are unlocked at a given best-ever streak. Based on
/// longest streak (not the current one) so an unlock is permanent once
/// earned — losing a streak later shouldn't re-lock a color the user
/// already reached.
Set<String> unlockedAccentIds(int longestStreak) {
  return AppAccentPalette.all
      .where((AppAccentColor a) => longestStreak >= a.unlockStreak)
      .map((AppAccentColor a) => a.id)
      .toSet();
}

final Provider<Set<String>> unlockedAccentIdsProvider = Provider<Set<String>>((Ref ref) {
  final int longestStreak = ref.watch(streakStatsProvider).longestStreak;
  return unlockedAccentIds(longestStreak);
});
