import 'package:flutter_test/flutter_test.dart';
import 'package:slate/features/settings/application/accent_unlock.dart';

void main() {
  group('unlockedAccentIds', () {
    test('electric blue is always unlocked, even at zero streak', () {
      expect(unlockedAccentIds(0), <String>{'electricBlue'});
    });

    test('forest unlocks at a 7-day streak', () {
      expect(unlockedAccentIds(6), <String>{'electricBlue'});
      expect(unlockedAccentIds(7), <String>{'electricBlue', 'forest'});
    });

    test('ember unlocks at a 14-day streak', () {
      expect(unlockedAccentIds(14), <String>{'electricBlue', 'forest', 'ember'});
    });

    test('violet unlocks at a 30-day streak, unlocking everything', () {
      expect(unlockedAccentIds(30), <String>{'electricBlue', 'forest', 'ember', 'violet'});
    });
  });
}
