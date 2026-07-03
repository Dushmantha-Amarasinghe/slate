import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/tags_table.dart';

part 'tag_dao.g.dart';

@DriftAccessor(tables: <Type>[Tags])
class TagDao extends DatabaseAccessor<AppDatabase> with _$TagDaoMixin {
  TagDao(super.db);

  Future<int> insertTag(TagsCompanion tag) => into(tags).insert(tag);

  Future<bool> updateTag(TagsCompanion tag) => update(tags).replace(tag);

  Future<int> deleteTag(String id) =>
      (delete(tags)..where((Tags t) => t.id.equals(id))).go();

  Stream<List<Tag>> watchAllTags() {
    final SimpleSelectStatement<Tags, Tag> query = select(tags)
      ..orderBy(<OrderClauseGenerator<Tags>>[
        (Tags t) => OrderingTerm.asc(t.name),
      ]);
    return query.watch();
  }
}
