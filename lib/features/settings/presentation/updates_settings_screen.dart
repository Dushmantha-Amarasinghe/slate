import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/tokens/spacing_tokens.dart';
import '../../../core/update/apk_downloader.dart';
import '../../../core/update/install_handler.dart';
import '../../../core/update/update_checker_service.dart';
import '../../../core/update/update_prefs.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_label.dart';
import 'widgets/settings_nav_row.dart';

class UpdatesSettingsScreen extends ConsumerStatefulWidget {
  const UpdatesSettingsScreen({super.key});

  @override
  ConsumerState<UpdatesSettingsScreen> createState() => _UpdatesSettingsScreenState();
}

class _UpdatesSettingsScreenState extends ConsumerState<UpdatesSettingsScreen> {
  String _currentVersion = '—';
  DateTime? _lastChecked;
  bool _checking = false;
  UpdateInfo? _updateInfo;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    final DateTime? lastChecked = await UpdatePrefs.lastCheckedAt();
    if (!mounted) return;
    setState(() {
      _currentVersion = info.version;
      _lastChecked = lastChecked;
    });
  }

  Future<void> _checkNow() async {
    setState(() {
      _checking = true;
      _error = null;
    });
    final UpdateCheckResult result = await ref
        .read(updateCheckerServiceProvider)
        .checkForUpdate(force: true);
    final DateTime? lastChecked = await UpdatePrefs.lastCheckedAt();
    if (!mounted) return;
    setState(() {
      _checking = false;
      _updateInfo = result.updateInfo;
      _error = result.error;
      _lastChecked = lastChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Updates')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: <Widget>[
          const SectionLabel('This install'),
          const SizedBox(height: AppSpacing.xs),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              children: <Widget>[
                SettingsNavRow(icon: Icons.tag, title: 'Current version', subtitle: _currentVersion),
                const SettingsRowDivider(),
                SettingsNavRow(
                  icon: Icons.history,
                  title: 'Last checked',
                  subtitle: _lastChecked == null ? 'Never' : _formatDateTime(_lastChecked!),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          FilledButton.icon(
            onPressed: _checking ? null : _checkNow,
            icon: _checking
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            label: Text(_checking ? 'Checking…' : 'Check for updates'),
          ),
          if (_error != null) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Text(_error!, style: Theme.of(context).textTheme.labelSmall),
          ],
          if (_updateInfo == null && !_checking && _error == null) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Text('You\'re up to date.', style: Theme.of(context).textTheme.bodyMedium),
          ],
          if (_updateInfo != null) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            const SectionLabel('Update available'),
            const SizedBox(height: AppSpacing.xs),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Version ${_updateInfo!.version}', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(_updateInfo!.releaseNotes, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => _startUpdate(_updateInfo!),
                      child: const Text('Update Now'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _startUpdate(UpdateInfo info) async {
    final bool canInstall = await InstallHandler.canRequestInstall();
    if (!canInstall) {
      if (!mounted) return;
      final bool proceed = await _showInstallPermissionDialog();
      if (!proceed) return;
      final bool granted = await InstallHandler.requestInstallPermission();
      if (!granted) return;
    }
    if (!mounted) return;
    await _downloadAndInstall(info);
  }

  Future<bool> _showInstallPermissionDialog() async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Allow installing updates'),
        content: const Text(
          'Slate isn\'t on the Play Store, so Android needs your permission to '
          'install an update you\'ve downloaded from GitHub. You\'ll be taken to '
          'a system settings screen — turn on "Allow from this source" for Slate.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _downloadAndInstall(UpdateInfo info) async {
    final ApkDownloader downloader = ref.read(apkDownloaderProvider);
    final ValueNotifier<double?> progress = ValueNotifier<double?>(0);
    bool cancelled = false;

    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isDismissible: false,
        enableDrag: false,
        builder: (BuildContext sheetContext) {
          return _DownloadProgressSheet(
            progress: progress,
            onCancel: () {
              cancelled = true;
              downloader.cancel();
              Navigator.of(sheetContext).pop();
            },
          );
        },
      ),
    );

    File? apkFile;
    try {
      apkFile = await downloader.download(
        url: info.apkDownloadUrl,
        fileName: info.apkAssetName,
        onProgress: (int received, int total) {
          progress.value = total > 0 ? received / total : null;
        },
      );
    } catch (e) {
      if (!cancelled && mounted) {
        Navigator.of(context).pop();
        _showMessage('Download failed: $e');
      }
      return;
    }

    if (!mounted) return;
    Navigator.of(context).pop();

    final bool installed = await InstallHandler.installApk(apkFile);
    if (installed || !mounted) return;

    // Fallback per build plan section 8, step 7: don't dead-end if the
    // install intent can't launch — offer the file's location instead.
    _showFallback(apkFile);
  }

  void _showFallback(File apkFile) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Couldn\'t open installer'),
        content: Text('The update downloaded to:\n\n${apkFile.path}\n\nOpen it manually to install.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              SharePlus.instance.share(ShareParams(files: <XFile>[XFile(apkFile.path)]));
            },
            child: const Text('Share file'),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatDateTime(DateTime dt) {
    final DateTime local = dt.toLocal();
    final String hour = (local.hour % 12 == 0 ? 12 : local.hour % 12).toString();
    final String minute = local.minute.toString().padLeft(2, '0');
    final String period = local.hour >= 12 ? 'PM' : 'AM';
    return '${local.month}/${local.day}/${local.year} · $hour:$minute $period';
  }
}

class _DownloadProgressSheet extends StatelessWidget {
  const _DownloadProgressSheet({required this.progress, required this.onCancel});

  final ValueNotifier<double?> progress;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Downloading update', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            ValueListenableBuilder<double?>(
              valueListenable: progress,
              builder: (BuildContext context, double? value, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    LinearProgressIndicator(value: value),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      value == null ? 'Downloading…' : '${(value * 100).toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: TextButton(onPressed: onCancel, child: const Text('Cancel')),
            ),
          ],
        ),
      ),
    );
  }
}
