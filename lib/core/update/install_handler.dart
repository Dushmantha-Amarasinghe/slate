import 'dart:io';

import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

/// Hands a downloaded APK off to the system installer. The actual "Install"
/// confirmation screen belongs to Android, not this app — see build plan
/// section 8, step 6: this only fires the intent and reports whether that
/// launch succeeded.
class InstallHandler {
  const InstallHandler._();

  static Future<bool> canRequestInstall() async {
    return await ph.Permission.requestInstallPackages.isGranted;
  }

  /// Deep-links to the OS's "install unknown apps" grant screen for this
  /// app — same status-row + deep-link pattern used elsewhere in Settings
  /// for notification/exact-alarm/battery permissions.
  static Future<bool> requestInstallPermission() async {
    final ph.PermissionStatus status = await ph.Permission.requestInstallPackages.request();
    return status.isGranted;
  }

  /// Returns true if the install intent was handed off successfully. false
  /// means the caller should fall back to showing the file's location (see
  /// build plan section 8, step 7).
  static Future<bool> installApk(File apkFile) async {
    final OpenResult result = await OpenFilex.open(
      apkFile.path,
      type: 'application/vnd.android.package-archive',
    );
    return result.type == ResultType.done;
  }
}
