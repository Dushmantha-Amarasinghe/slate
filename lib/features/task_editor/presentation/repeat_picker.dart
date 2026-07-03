import 'package:flutter/material.dart';

import '../../../core/theme/tokens/radius_tokens.dart';
import '../../../core/theme/tokens/spacing_tokens.dart';
import '../../../core/utils/recurrence_utils.dart';

/// Chip + dialog for picking None/Daily/Weekly/Custom-weekdays recurrence.
/// Only meaningful once a due date is set (recurrence needs an anchor
/// date), so the caller is expected to only show this when that's true.
class RepeatPicker extends StatelessWidget {
  const RepeatPicker({super.key, required this.value, required this.onChanged});

  final Recurrence value;
  final ValueChanged<Recurrence> onChanged;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: () async {
        final Recurrence? picked = await showDialog<Recurrence>(
          context: context,
          builder: (BuildContext context) => _RepeatDialog(initial: value),
        );
        if (picked != null) onChanged(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: scheme.onSurface.withValues(alpha: 0.14)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.repeat,
              size: 18,
              color: scheme.onSurface.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 6),
            Text(value.label, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}

class _RepeatDialog extends StatefulWidget {
  const _RepeatDialog({required this.initial});

  final Recurrence initial;

  @override
  State<_RepeatDialog> createState() => _RepeatDialogState();
}

class _RepeatDialogState extends State<_RepeatDialog> {
  late RecurrenceFrequency _frequency;
  late Set<int> _weekdays;

  static const Map<int, String> _dayLabels = <int, String>{
    DateTime.monday: 'M',
    DateTime.tuesday: 'T',
    DateTime.wednesday: 'W',
    DateTime.thursday: 'T',
    DateTime.friday: 'F',
    DateTime.saturday: 'S',
    DateTime.sunday: 'S',
  };

  @override
  void initState() {
    super.initState();
    _frequency = widget.initial.frequency;
    _weekdays = Set<int>.of(widget.initial.weekdays);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Repeat'),
      content: RadioGroup<RecurrenceFrequency>(
        groupValue: _frequency,
        onChanged: (RecurrenceFrequency? v) => setState(() => _frequency = v!),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (final RecurrenceFrequency freq in RecurrenceFrequency.values)
              RadioListTile<RecurrenceFrequency>(
                contentPadding: EdgeInsets.zero,
                title: Text(_frequencyLabel(freq)),
                value: freq,
              ),
            if (_frequency == RecurrenceFrequency.custom) ...<Widget>[
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.xs,
                children: _dayLabels.entries.map((MapEntry<int, String> entry) {
                  final bool selected = _weekdays.contains(entry.key);
                  return ChoiceChip(
                    label: Text(entry.value),
                    selected: selected,
                    onSelected: (bool value) => setState(() {
                      if (value) {
                        _weekdays.add(entry.key);
                      } else {
                        _weekdays.remove(entry.key);
                      }
                    }),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(
            context,
          ).pop(Recurrence(frequency: _frequency, weekdays: _weekdays)),
          child: const Text('Done'),
        ),
      ],
    );
  }

  String _frequencyLabel(RecurrenceFrequency freq) {
    switch (freq) {
      case RecurrenceFrequency.none:
        return 'Does not repeat';
      case RecurrenceFrequency.daily:
        return 'Daily';
      case RecurrenceFrequency.weekly:
        return 'Weekly';
      case RecurrenceFrequency.custom:
        return 'Custom days';
    }
  }
}
