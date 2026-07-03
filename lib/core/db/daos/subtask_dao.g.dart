// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtask_dao.dart';

// ignore_for_file: type=lint
mixin _$SubtaskDaoMixin on DatabaseAccessor<AppDatabase> {
  $SubtasksTable get subtasks => attachedDatabase.subtasks;
  SubtaskDaoManager get managers => SubtaskDaoManager(this);
}

class SubtaskDaoManager {
  final _$SubtaskDaoMixin _db;
  SubtaskDaoManager(this._db);
  $$SubtasksTableTableManager get subtasks =>
      $$SubtasksTableTableManager(_db.attachedDatabase, _db.subtasks);
}
