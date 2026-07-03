import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../core/db/daos/backup_dao.dart';
import '../core/db/database.dart';
import '../core/db/database_provider.dart';
import '../core/notifications/notification_service.dart';
import '../core/notifications/reminder_resync.dart';

/// Current export/import schema version — bump this (and add a migration
/// branch in [DataManagementService.importFromFile]) if the backup shape
/// ever changes, independent of the Drift DB schema version.
const int kBackupFormatVersion = 1;

class BackupValidationException implements Exception {
  BackupValidationException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Whole-database JSON export/import, "clear completed", "delete all data",
/// and a storage-used indicator — everything under Settings > Data
/// Management. Everyday per-task CRUD stays in [TaskRepository]/[TaskActions];
/// this service is only for operations that touch the entire dataset at once.
class DataManagementService {
  DataManagementService(this._db);

  final AppDatabase _db;

  BackupDao get _backup => _db.backupDao;

  /// Serializes every table to a JSON file under the app's documents
  /// directory and returns it, ready to hand to `share_plus`.
  Future<File> exportToFile() async {
    final List<Tag> tags = await _backup.getAllTagsOnce();
    final List<Task> tasks = await _backup.getAllTasksOnce();
    final List<Subtask> subtasks = await _backup.getAllSubtasksOnce();
    final List<Reminder> reminders = await _backup.getAllRemindersOnce();
    final AppSettingsTableData settings = await _backup.getSettingsOnce();

    final Map<String, dynamic> payload = <String, dynamic>{
      'backupFormatVersion': kBackupFormatVersion,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'tags': tags.map((Tag t) => t.toJson()).toList(),
      'tasks': tasks.map((Task t) => t.toJson()).toList(),
      'subtasks': subtasks.map((Subtask s) => s.toJson()).toList(),
      'reminders': reminders.map((Reminder r) => r.toJson()).toList(),
      'settings': settings.toJson(),
    };

    final Directory dir = await getApplicationDocumentsDirectory();
    final Directory backupsDir = Directory(p.join(dir.path, 'backups'));
    if (!await backupsDir.exists()) {
      await backupsDir.create(recursive: true);
    }
    final String timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .split('.')
        .first;
    final File file = File(p.join(backupsDir.path, 'slate-backup-$timestamp.json'));
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(payload));
    return file;
  }

  /// Parses and applies a backup file. [merge] upserts on top of existing
  /// data (matched by id); replace wipes everything first. Reminders are
  /// re-synced to the OS alarm scheduler afterward either way, since writing
  /// the Reminders table directly bypasses [AlarmScheduler].
  Future<void> importFromFile(File file, {required bool merge}) async {
    final Map<String, dynamic> json;
    try {
      json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    } catch (_) {
      throw BackupValidationException('This file isn\'t a valid Slate backup.');
    }

    final int? formatVersion = json['backupFormatVersion'] as int?;
    if (formatVersion == null || formatVersion > kBackupFormatVersion) {
      throw BackupValidationException(
        'This backup was made by a newer version of Slate and can\'t be imported here.',
      );
    }

    final List<dynamic> tagsJson = (json['tags'] as List<dynamic>?) ?? const <dynamic>[];
    final List<dynamic> tasksJson = (json['tasks'] as List<dynamic>?) ?? const <dynamic>[];
    final List<dynamic> subtasksJson = (json['subtasks'] as List<dynamic>?) ?? const <dynamic>[];
    final List<dynamic> remindersJson = (json['reminders'] as List<dynamic>?) ?? const <dynamic>[];
    final Map<String, dynamic>? settingsJson = json['settings'] as Map<String, dynamic>?;

    final List<TagsCompanion> tags;
    final List<TasksCompanion> tasks;
    final List<SubtasksCompanion> subtasks;
    final List<RemindersCompanion> reminders;
    try {
      tags = tagsJson
          .map((dynamic j) => Tag.fromJson(j as Map<String, dynamic>).toCompanion(true))
          .toList();
      tasks = tasksJson
          .map((dynamic j) => Task.fromJson(j as Map<String, dynamic>).toCompanion(true))
          .toList();
      subtasks = subtasksJson
          .map((dynamic j) => Subtask.fromJson(j as Map<String, dynamic>).toCompanion(true))
          .toList();
      reminders = remindersJson
          .map((dynamic j) => Reminder.fromJson(j as Map<String, dynamic>).toCompanion(true))
          .toList();
    } catch (_) {
      throw BackupValidationException('This backup file is corrupted or malformed.');
    }

    if (merge) {
      await _backup.mergeAll(
        tagsData: tags,
        tasksData: tasks,
        subtasksData: subtasks,
        remindersData: reminders,
      );
    } else {
      // Cancel every currently-scheduled alarm before the reminders table
      // underneath them is wiped, so nothing fires for a task that's about
      // to no longer exist.
      final List<Reminder> existingReminders = await _backup.getAllRemindersOnce();
      for (final Reminder reminder in existingReminders) {
        await NotificationService.cancelReminder(reminder.notificationId);
      }
      await _backup.replaceAll(
        tagsData: tags,
        tasksData: tasks,
        subtasksData: subtasks,
        remindersData: reminders,
        settingsData: settingsJson == null
            ? null
            : AppSettingsTableData.fromJson(settingsJson).toCompanion(true),
      );
    }

    await resyncAllReminders(_db);
  }

  /// Deletes every task/tag/subtask/reminder, cancels every scheduled alarm,
  /// and removes every voice note file — the one destructive action in
  /// Settings that intentionally skips the undo-snackbar pattern used
  /// elsewhere, since it also touches disk. Settings (theme, defaults, etc.)
  /// are left untouched.
  Future<void> deleteAllData() async {
    final List<Reminder> reminders = await _backup.getAllRemindersOnce();
    for (final Reminder reminder in reminders) {
      await NotificationService.cancelReminder(reminder.notificationId);
    }

    final List<Task> tasks = await _backup.getAllTasksOnce();
    await _backup.deleteAllRows();

    for (final Task task in tasks) {
      if (task.voiceNotePath == null) continue;
      final File file = File(task.voiceNotePath!);
      if (await file.exists()) await file.delete();
    }
  }

  /// Approximate on-disk footprint (DB file + voice notes) shown as a
  /// human-readable string, e.g. "3.2 MB".
  Future<String> storageUsedLabel() async {
    int totalBytes = 0;

    final File dbFile = await AppDatabase.resolveDatabaseFile();
    if (await dbFile.exists()) totalBytes += await dbFile.length();

    final Directory docsDir = await getApplicationDocumentsDirectory();
    final Directory voiceNotesDir = Directory(p.join(docsDir.path, 'voice_notes'));
    if (await voiceNotesDir.exists()) {
      await for (final FileSystemEntity entity in voiceNotesDir.list()) {
        if (entity is File) totalBytes += await entity.length();
      }
    }

    return _formatBytes(totalBytes);
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

final Provider<DataManagementService> dataManagementServiceProvider =
    Provider<DataManagementService>((Ref ref) {
      return DataManagementService(ref.watch(appDatabaseProvider));
    });
