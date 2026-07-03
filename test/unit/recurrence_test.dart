import 'package:flutter_test/flutter_test.dart';
import 'package:slate/core/utils/recurrence_utils.dart';

void main() {
  group('Recurrence', () {
    test('daily advances by exactly one day', () {
      const Recurrence r = Recurrence(frequency: RecurrenceFrequency.daily);
      final DateTime next = r.nextOccurrence(DateTime(2026, 3, 1, 9))!;
      expect(next, DateTime(2026, 3, 2, 9));
    });

    test('weekly advances by seven days', () {
      const Recurrence r = Recurrence(frequency: RecurrenceFrequency.weekly);
      final DateTime next = r.nextOccurrence(DateTime(2026, 3, 1, 9))!;
      expect(next, DateTime(2026, 3, 8, 9));
    });

    test('custom Mon/Wed/Fri finds the next matching weekday', () {
      final Recurrence r = Recurrence(
        frequency: RecurrenceFrequency.custom,
        weekdays: <int>{DateTime.monday, DateTime.wednesday, DateTime.friday},
      );
      // 2026-03-02 is a Monday.
      final DateTime fromMonday = DateTime(2026, 3, 2, 9);
      final DateTime next = r.nextOccurrence(fromMonday)!;
      expect(next.weekday, DateTime.wednesday);
      expect(next, DateTime(2026, 3, 4, 9));
    });

    test('custom with no weekdays selected has no next occurrence', () {
      const Recurrence r = Recurrence(frequency: RecurrenceFrequency.custom);
      expect(r.nextOccurrence(DateTime(2026, 3, 1)), isNull);
    });

    test('daily preserves wall-clock hour and minute across a month rollover', () {
      const Recurrence r = Recurrence(frequency: RecurrenceFrequency.daily);
      final DateTime next = r.nextOccurrence(DateTime(2026, 1, 31, 23, 45))!;
      expect(next, DateTime(2026, 2, 1, 23, 45));
    });

    test('weekly preserves wall-clock hour and minute (Duration-based day '
        'arithmetic would shift the hour across a DST transition — see '
        'recurrence_utils.dart\'s _addCalendarDays doc comment)', () {
      const Recurrence r = Recurrence(frequency: RecurrenceFrequency.weekly);
      final DateTime next = r.nextOccurrence(DateTime(2026, 3, 1, 9, 30))!;
      expect(next.hour, 9);
      expect(next.minute, 30);
      expect(next, DateTime(2026, 3, 8, 9, 30));
    });

    test('custom weekday recurrence preserves wall-clock hour and minute and '
        'rolls over a year boundary', () {
      final Recurrence r = Recurrence(
        frequency: RecurrenceFrequency.custom,
        weekdays: <int>{DateTime.friday},
      );
      // 2026-12-28 is a Monday; the next Friday crosses into January 2027.
      final DateTime next = r.nextOccurrence(DateTime(2026, 12, 28, 18, 15))!;
      expect(next.weekday, DateTime.friday);
      expect(next.hour, 18);
      expect(next.minute, 15);
      expect(next, DateTime(2027, 1, 1, 18, 15));
    });

    test('none never produces a next occurrence', () {
      expect(Recurrence.none.nextOccurrence(DateTime(2026, 3, 1)), isNull);
      expect(Recurrence.none.isRecurring, isFalse);
    });

    test('encode/decode round-trips for all frequencies', () {
      final List<Recurrence> cases = <Recurrence>[
        Recurrence.none,
        const Recurrence(frequency: RecurrenceFrequency.daily),
        const Recurrence(frequency: RecurrenceFrequency.weekly),
        const Recurrence(
          frequency: RecurrenceFrequency.custom,
          weekdays: <int>{DateTime.tuesday, DateTime.thursday},
        ),
      ];
      for (final Recurrence r in cases) {
        final Recurrence decoded = Recurrence.decode(r.encode());
        expect(decoded.frequency, r.frequency);
        expect(decoded.weekdays, r.weekdays);
      }
    });
  });
}
