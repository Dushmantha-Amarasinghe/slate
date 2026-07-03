import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../data/repositories/settings_repository.dart';

/// The single settings row, watched reactively so every settings toggle
/// takes effect immediately across the app (theme, haptics, swipe
/// direction, etc.) without a restart.
final StreamProvider<AppSettingsTableData> settingsProvider =
    StreamProvider<AppSettingsTableData>((Ref ref) {
      return ref.watch(settingsRepositoryProvider).watch();
    });

/// Write-side handle for settings screens: each sub-screen calls
/// `ref.read(settingsControllerProvider).update(...)` with only the fields
/// it owns, leaving the rest of the row untouched via Drift's `Value.absent()`.
final Provider<SettingsController> settingsControllerProvider =
    Provider<SettingsController>((Ref ref) {
      return SettingsController(ref.watch(settingsRepositoryProvider));
    });

class SettingsController {
  SettingsController(this._repository);

  final SettingsRepository _repository;

  Future<void> update(AppSettingsTableCompanion companion) => _repository.update(companion);
}
