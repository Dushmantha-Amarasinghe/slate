import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/icons/tag_icons.dart';
import '../../../core/theme/tokens/radius_tokens.dart';
import '../../../core/theme/tokens/spacing_tokens.dart';
import '../../../core/widgets/dropdown_chip.dart';
import '../../../data/repositories/tag_repository.dart';
import '../application/tag_controller.dart';

/// Sentinel [PopupMenuItem] value for the dropdown variant's trailing
/// "New tag" action — distinct from any real tag id.
const String _createTagSentinel = '__create_tag__';

/// Single-select tag picker (a Task has at most one tag). Two shapes:
/// - A handful of real tags: every real tag as a selectable chip, PLUS
///   whichever premade category suggestions haven't been created yet (so
///   picking "Work" doesn't remove "Home"/"Shopping"/etc. from view — the
///   only thing that disappears from the suggestion list is the one that
///   just became a real tag), plus "Custom". Selecting or deselecting a
///   chip never hides any of the others.
/// - Many real tags: a single dropdown trigger, like Search's filter chips
///   — a chip row that long stops being scannable at a glance.
class TagPicker extends ConsumerWidget {
  const TagPicker({
    super.key,
    required this.selectedTagId,
    required this.onChanged,
  });

  final String? selectedTagId;
  final ValueChanged<String?> onChanged;

  /// Above this many real tags, a chip row stops being scannable at a
  /// glance and a dropdown reads better. Premade suggestions don't count
  /// toward this — once the user has this many tags of their own, they've
  /// outgrown the suggestion list anyway.
  static const int _dropdownThreshold = 6;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Tag>> tagsAsync = ref.watch(allTagsProvider);

    return tagsAsync.when(
      loading: () => const SizedBox(height: 40),
      error: (Object _, StackTrace _) => const SizedBox.shrink(),
      data: (List<Tag> tags) {
        if (tags.length > _dropdownThreshold) {
          return _TagDropdown(tags: tags, selectedTagId: selectedTagId, onChanged: onChanged);
        }
        return _TagChipRow(tags: tags, selectedTagId: selectedTagId, onChanged: onChanged);
      },
    );
  }
}

Future<void> _showCreateTagDialog(
  BuildContext context,
  WidgetRef ref,
  ValueChanged<String?> onChanged,
) async {
  final TextEditingController nameController = TextEditingController();
  String selectedIcon = kTagIcons.keys.first;

  final String? createdTagId = await showDialog<String>(
    context: context,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text('New tag'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: nameController,
                  autofocus: true,
                  decoration: const InputDecoration(hintText: 'e.g. Work'),
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: kTagIcons.entries.map((MapEntry<String, IconData> entry) {
                    final bool selected = entry.key == selectedIcon;
                    return InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      onTap: () => setState(() => selectedIcon = entry.key),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.xs),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          color: selected
                              ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1)
                              : null,
                        ),
                        child: Icon(entry.value),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () async {
                  final String name = nameController.text.trim();
                  if (name.isEmpty) return;
                  final String id = await ref
                      .read(tagRepositoryProvider)
                      .addTag(name: name, iconRef: selectedIcon);
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop(id);
                  }
                },
                child: const Text('Create'),
              ),
            ],
          );
        },
      );
    },
  );

  if (createdTagId != null) onChanged(createdTagId);
}

/// A handful of tags: every real tag as a selectable chip, plus whichever
/// premade suggestions haven't been created yet (by name, case-insensitive),
/// plus "Custom". Nothing here is ever hidden by selecting/deselecting a
/// chip — that only toggles which one is highlighted.
class _TagChipRow extends ConsumerWidget {
  const _TagChipRow({required this.tags, required this.selectedTagId, required this.onChanged});

  final List<Tag> tags;
  final String? selectedTagId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Set<String> existingNames = tags.map((Tag t) => t.name.toLowerCase()).toSet();
    final List<(String, String)> remainingSuggestions = kSuggestedTags
        .where(((String, String) s) => !existingNames.contains(s.$1.toLowerCase()))
        .toList();

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: <Widget>[
        for (final Tag tag in tags)
          _TagChip(
            label: tag.name,
            icon: tagIconFor(tag.iconRef),
            selected: tag.id == selectedTagId,
            onTap: () => onChanged(tag.id == selectedTagId ? null : tag.id),
          ),
        for (final (String, String) suggestion in remainingSuggestions)
          _TagChip(
            label: suggestion.$1,
            icon: tagIconFor(suggestion.$2),
            selected: false,
            onTap: () async {
              final String id = await ref
                  .read(tagRepositoryProvider)
                  .addTag(name: suggestion.$1, iconRef: suggestion.$2);
              onChanged(id);
            },
          ),
        _NewTagChip(
          label: 'Custom',
          onTap: () => _showCreateTagDialog(context, ref, onChanged),
        ),
      ],
    );
  }
}

/// Many tags: a single dropdown trigger rather than a chip row that would
/// otherwise wrap across several lines.
class _TagDropdown extends ConsumerWidget {
  const _TagDropdown({required this.tags, required this.selectedTagId, required this.onChanged});

  final List<Tag> tags;
  final String? selectedTagId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Tag? selectedTag;
    for (final Tag tag in tags) {
      if (tag.id == selectedTagId) {
        selectedTag = tag;
        break;
      }
    }

    return DropdownChip<String>(
      icon: Icon(selectedTag == null ? Icons.label_outline : tagIconFor(selectedTag.iconRef)),
      label: selectedTag?.name ?? 'Tag',
      selected: selectedTag != null,
      onClear: selectedTag == null ? null : () => onChanged(null),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        for (final Tag tag in tags)
          PopupMenuItem<String>(
            value: tag.id,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(tagIconFor(tag.iconRef), size: 18),
                const SizedBox(width: AppSpacing.xs),
                Text(tag.name),
              ],
            ),
          ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: _createTagSentinel,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[Icon(Icons.add, size: 18), SizedBox(width: AppSpacing.xs), Text('New tag')],
          ),
        ),
      ],
      onSelected: (String value) {
        if (value == _createTagSentinel) {
          _showCreateTagDialog(context, ref, onChanged);
        } else {
          onChanged(value == selectedTagId ? null : value);
        }
      },
    );
  }
}

class _NewTagChip extends StatelessWidget {
  const _NewTagChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: scheme.onSurface.withValues(alpha: 0.16)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.add, size: 16, color: scheme.onSurface.withValues(alpha: 0.7)),
            const SizedBox(width: 4),
            Text(label, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          color: selected
              ? scheme.onSurface.withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border.all(
            color: scheme.onSurface.withValues(alpha: selected ? 0.28 : 0.14),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: 16,
              color: scheme.onSurface.withValues(alpha: selected ? 1 : 0.7),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: selected ? FontWeight.w600 : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
