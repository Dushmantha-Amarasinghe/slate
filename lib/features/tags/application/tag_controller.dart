import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../data/repositories/tag_repository.dart';

final StreamProvider<List<Tag>> allTagsProvider = StreamProvider<List<Tag>>((
  Ref ref,
) {
  return ref.watch(tagRepositoryProvider).watchAll();
});

/// Derived id->Tag lookup so task cards/lists don't each do an O(n) scan.
final Provider<Map<String, Tag>> tagsByIdProvider = Provider<Map<String, Tag>>((
  Ref ref,
) {
  final List<Tag> tags = ref.watch(allTagsProvider).value ?? const <Tag>[];
  return <String, Tag>{for (final Tag tag in tags) tag.id: tag};
});
