import 'package:flutter/material.dart';

/// Placeholder tag icon set — Material icons standing in for the custom
/// 24x24 SVG set built in Phase 4. `iconRef` is already the stable string
/// key stored on `Tag.iconRef`, so swapping this lookup for real SVG
/// assets later is a one-file change, not a data migration.
const Map<String, IconData> kTagIcons = <String, IconData>{
  'label': Icons.label_outline,
  'work': Icons.work_outline,
  'home': Icons.home_outlined,
  'shopping': Icons.shopping_bag_outlined,
  'health': Icons.favorite_outline,
  'study': Icons.school_outlined,
  'finance': Icons.attach_money,
  'travel': Icons.flight_outlined,
  'entertainment': Icons.movie_outlined,
};

IconData tagIconFor(String iconRef) =>
    kTagIcons[iconRef] ?? Icons.label_outline;

/// Common categories offered as one-tap picks in the task editor's tag
/// section — mirrors names/icons a first-time user would otherwise have to
/// type and pick by hand via "New tag" every time.
const List<(String name, String iconRef)> kSuggestedTags = <(String, String)>[
  ('Work', 'work'),
  ('Home', 'home'),
  ('Shopping', 'shopping'),
  ('Health', 'health'),
  ('Entertainment', 'entertainment'),
  ('Study', 'study'),
];
