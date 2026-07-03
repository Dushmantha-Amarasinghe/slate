// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtask_dao.dart';

// ignore_for_file: type=lint
mixin _$SubtaskDaoMixin on DatabaseAccessor<AppDatabase> {
  $TagsTable get tags => attachedDatabase.tags;
  $TasksTable get tasks => attachedDatabase.tasks;
  $SubtasksTable get subtasks => attachedDatabase.subtasks;
  SubtaskDaoManager get managers => SubtaskDaoManager(this);
}

class SubtaskDaoManager {
  final _$SubtaskDaoMixin _db;
  SubtaskDaoManager(this._db);
  $$TagsTableTableManager get tags =>
      $$TagsTableTableManager(_db.attachedDatabase, _db.tags);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db.attachedDatabase, _db.tasks);
  $$SubtasksTableTableManager get subtasks =>
      $$SubtasksTableTableManager(_db.attachedDatabase, _db.subtasks);
}
