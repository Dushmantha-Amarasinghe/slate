/// A deliberately minimal recurrence model — spec 4 only asks for
/// "daily, weekly, custom (e.g. every Mon/Wed/Fri)", so a small hand-rolled
/// calculator is lower-risk than pulling in a full RFC 5545 RRULE parser
/// for three cases. Encoded as a plain string on `Task.recurrenceRule`
/// ("DAILY" / "WEEKLY" / "CUSTOM:1,3,5" using DateTime.weekday numbering)
/// so swapping in a real RRULE library later, if month-end/yearly patterns
/// are ever needed, doesn't require a schema migration.
enum RecurrenceFrequency { none, daily, weekly, custom }

class Recurrence {
  const Recurrence({required this.frequency, this.weekdays = const <int>{}});

  final RecurrenceFrequency frequency;

  /// Only meaningful when [frequency] is custom. Values are
  /// `DateTime.monday`..`DateTime.sunday` (1..7).
  final Set<int> weekdays;

  static const Recurrence none = Recurrence(
    frequency: RecurrenceFrequency.none,
  );

  bool get isRecurring => frequency != RecurrenceFrequency.none;

  String encode() {
    switch (frequency) {
      case RecurrenceFrequency.none:
        return '';
      case RecurrenceFrequency.daily:
        return 'DAILY';
      case RecurrenceFrequency.weekly:
        return 'WEEKLY';
      case RecurrenceFrequency.custom:
        final List<int> sorted = weekdays.toList()..sort();
        return 'CUSTOM:${sorted.join(',')}';
    }
  }

  static Recurrence decode(String? raw) {
    if (raw == null || raw.isEmpty) return none;
    if (raw == 'DAILY') {
      return const Recurrence(frequency: RecurrenceFrequency.daily);
    }
    if (raw == 'WEEKLY') {
      return const Recurrence(frequency: RecurrenceFrequency.weekly);
    }
    if (raw.startsWith('CUSTOM:')) {
      final Set<int> days = raw
          .substring('CUSTOM:'.length)
          .split(',')
          .where((String s) => s.isNotEmpty)
          .map(int.parse)
          .toSet();
      return Recurrence(frequency: RecurrenceFrequency.custom, weekdays: days);
    }
    return none;
  }

  /// The next due date strictly after [fromDueDate], or null if this
  /// recurrence can't produce one (e.g. custom with no weekdays selected).
  DateTime? nextOccurrence(DateTime fromDueDate) {
    switch (frequency) {
      case RecurrenceFrequency.none:
        return null;
      case RecurrenceFrequency.daily:
        return _addCalendarDays(fromDueDate, 1);
      case RecurrenceFrequency.weekly:
        return _addCalendarDays(fromDueDate, 7);
      case RecurrenceFrequency.custom:
        if (weekdays.isEmpty) return null;
        for (int i = 1; i <= 7; i++) {
          final DateTime candidate = _addCalendarDays(fromDueDate, i);
          if (weekdays.contains(candidate.weekday)) return candidate;
        }
        return null;
    }
  }

  static const Map<int, String> _weekdayShortNames = <int, String>{
    DateTime.monday: 'Mon',
    DateTime.tuesday: 'Tue',
    DateTime.wednesday: 'Wed',
    DateTime.thursday: 'Thu',
    DateTime.friday: 'Fri',
    DateTime.saturday: 'Sat',
    DateTime.sunday: 'Sun',
  };

  /// Adds [days] by calendar component (year/month/day), not as a
  /// `Duration` — `DateTime.add(Duration(days: n))` adds a fixed span of
  /// elapsed time, which is documented by Dart itself to shift the
  /// resulting wall-clock hour by an hour whenever the span crosses a DST
  /// transition. A weekly reminder set for 9:00 AM should still fire at
  /// 9:00 AM the following week even if the clocks changed in between;
  /// constructing the new `DateTime` from calendar fields (letting `DateTime`
  /// itself normalize an out-of-range day, e.g. day 32) preserves that.
  static DateTime _addCalendarDays(DateTime dt, int days) {
    return DateTime(dt.year, dt.month, dt.day + days, dt.hour, dt.minute, dt.second, dt.millisecond);
  }

  String get label {
    switch (frequency) {
      case RecurrenceFrequency.none:
        return 'Does not repeat';
      case RecurrenceFrequency.daily:
        return 'Daily';
      case RecurrenceFrequency.weekly:
        return 'Weekly';
      case RecurrenceFrequency.custom:
        if (weekdays.isEmpty) return 'Custom';
        final List<int> sorted = weekdays.toList()..sort();
        return sorted.map((int d) => _weekdayShortNames[d]).join('/');
    }
  }
}
