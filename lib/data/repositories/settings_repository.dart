import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';

class SettingsRepository {
  SettingsRepository(this._db);

  final AppDatabase _db;

  Stream<AppSettingsTableData> watch() => _db.settingsDao.watchSettings();

  Future<void> update(AppSettingsTableCompanion companion) => _db.settingsDao.updateSettings(companion);
}

final Provider<SettingsRepository> settingsRepositoryProvider = Provider<SettingsRepository>((Ref ref) {
  return SettingsRepository(ref.watch(appDatabaseProvider));
});
