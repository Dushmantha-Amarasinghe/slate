import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database.dart';

/// The single [AppDatabase] instance for the app's lifetime. Repositories
/// and DAO-level providers all read through this rather than constructing
/// their own connection.
final Provider<AppDatabase> appDatabaseProvider = Provider<AppDatabase>((
  Ref ref,
) {
  final AppDatabase db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
