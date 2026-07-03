import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/db/database.dart';
import '../../../core/theme/tokens/color_tokens.dart';
import '../../../core/theme/tokens/spacing_tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_label.dart';
import '../../../core/widgets/undo_delete_snackbar.dart';
import '../../../data/data_management_service.dart';
import '../../../data/repositories/task_repository.dart';
import 'widgets/settings_nav_row.dart';

class DataManagementSettingsScreen extends ConsumerStatefulWidget {
  const DataManagementSettingsScreen({super.key});

  @override
  ConsumerState<DataManagementSettingsScreen> createState() => _DataManagementSettingsScreenState();
}

class _DataManagementSettingsScreenState extends ConsumerState<DataManagementSettingsScreen> {
  String? _storageLabel;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _refreshStorageLabel();
  }

  Future<void> _refreshStorageLabel() async {
    final String label = await ref.read(dataManagementServiceProvider).storageUsedLabel();
    if (!mounted) return;
    setState(() => _storageLabel = label);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Management')),
      body: AbsorbPointer(
        absorbing: _busy,
        child: Opacity(
          opacity: _busy ? 0.5 : 1,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: <Widget>[
              const SectionLabel('Backup'),
              const SizedBox(height: AppSpacing.xs),
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  children: <Widget>[
                    SettingsNavRow(
                      icon: Icons.upload_outlined,
                      title: 'Export backup',
                      subtitle: 'Save all tasks, tags, and settings as JSON',
                      onTap: _exportBackup,
                    ),
                    const SettingsRowDivider(),
                    SettingsNavRow(
                      icon: Icons.download_outlined,
                      title: 'Import backup',
                      subtitle: 'Restore from a previously exported file',
                      onTap: _importBackup,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const SectionLabel('Storage'),
              const SizedBox(height: AppSpacing.xs),
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: SettingsNavRow(
                  icon: Icons.storage_outlined,
                  title: 'Storage used',
                  subtitle: _storageLabel ?? 'Calculating…',
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const SectionLabel('Danger zone'),
              const SizedBox(height: AppSpacing.xs),
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  children: <Widget>[
                    SettingsNavRow(
                      icon: Icons.playlist_remove,
                      title: 'Clear completed tasks',
                      subtitle: 'Removes finished tasks; undo for a few seconds',
                      onTap: _clearCompleted,
                    ),
                    const SettingsRowDivider(),
                    SettingsNavRow(
                      icon: Icons.delete_forever_outlined,
                      title: 'Delete all data',
                      subtitle: 'Tasks, tags, and voice notes — cannot be undone',
                      onTap: _confirmDeleteAll,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _exportBackup() async {
    setState(() => _busy = true);
    try {
      final File file = await ref.read(dataManagementServiceProvider).exportToFile();
      if (!mounted) return;
      await SharePlus.instance.share(
        ShareParams(files: <XFile>[XFile(file.path)], text: 'Slate backup'),
      );
    } catch (e) {
      _showMessage('Export failed: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _importBackup() async {
    final FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['json'],
    );
    final String? path = result?.files.single.path;
    if (path == null || !mounted) return;

    final bool? merge = await _askMergeOrReplace();
    if (merge == null || !mounted) return;

    setState(() => _busy = true);
    try {
      await ref.read(dataManagementServiceProvider).importFromFile(File(path), merge: merge);
      await _refreshStorageLabel();
      _showMessage('Backup imported');
    } on BackupValidationException catch (e) {
      _showMessage(e.message);
    } catch (e) {
      _showMessage('Import failed: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool?> _askMergeOrReplace() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Import backup'),
        content: const Text(
          'Merge adds the backup\'s tasks alongside what you have now. '
          'Replace deletes everything currently on this device first.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Replace'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Merge'),
          ),
        ],
      ),
    );
  }

  Future<void> _clearCompleted() async {
    final List<Task> all = await ref.read(taskRepositoryProvider).watchAll().first;
    final List<String> completedIds = all
        .where((Task t) => t.isCompleted)
        .map((Task t) => t.id)
        .toList();
    if (!mounted) return;
    showUndoClearCompletedSnackbar(context, ref, taskIds: completedIds);
  }

  Future<void> _confirmDeleteAll() async {
    final TextEditingController controller = TextEditingController();
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setDialogState) {
          final bool matches = controller.text.trim() == 'DELETE';
          return AlertDialog(
            title: const Text('Delete all data?'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'This permanently deletes every task, tag, and voice note on this '
                  'device. This cannot be undone.',
                ),
                const SizedBox(height: AppSpacing.md),
                Text('Type DELETE to confirm', style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(height: AppSpacing.xs),
                TextField(
                  controller: controller,
                  autofocus: true,
                  onChanged: (_) => setDialogState(() {}),
                  decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.destructiveOnDark
                      : AppColors.destructive,
                  foregroundColor: Colors.white,
                ),
                onPressed: matches ? () => Navigator.of(context).pop(true) : null,
                child: const Text('Delete everything'),
              ),
            ],
          );
        },
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _busy = true);
    try {
      await ref.read(dataManagementServiceProvider).deleteAllData();
      await _refreshStorageLabel();
      _showMessage('All data deleted');
    } catch (e) {
      _showMessage('Delete failed: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
