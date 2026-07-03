import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/app_settings_table.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: <Type>[AppSettingsTable])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.db);

  /// The settings row always exists (seeded in AppDatabase.migration's
  /// onCreate), so callers can watch this without a null case for "settings
  /// not created yet".
  Stream<AppSettingsTableData> watchSettings() {
    final SimpleSelectStatement<AppSettingsTable, AppSettingsTableData> query =
        select(appSettingsTable)..where((AppSettingsTable s) => s.id.equals(0));
    return query.watchSingle();
  }

  Future<void> updateSettings(AppSettingsTableCompanion companion) {
    return (update(
      appSettingsTable,
    )..where((AppSettingsTable s) => s.id.equals(0))).write(companion);
  }
}
