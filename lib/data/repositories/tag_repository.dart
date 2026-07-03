import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';

const Uuid _uuid = Uuid();

class TagRepository {
  TagRepository(this._db);

  final AppDatabase _db;

  Stream<List<Tag>> watchAll() => _db.tagDao.watchAllTags();

  Future<String> addTag({required String name, required String iconRef}) async {
    final String id = _uuid.v4();
    await _db.tagDao.insertTag(
      TagsCompanion.insert(
        id: id,
        name: name,
        iconRef: iconRef,
        createdAt: DateTime.now(),
      ),
    );
    return id;
  }

  Future<void> deleteTag(String id) => _db.tagDao.deleteTag(id);
}

final Provider<TagRepository> tagRepositoryProvider = Provider<TagRepository>((
  Ref ref,
) {
  return TagRepository(ref.watch(appDatabaseProvider));
});
