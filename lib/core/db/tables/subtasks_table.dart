import 'package:drift/drift.dart';

import 'tasks_table.dart';

/// Subtasks/checklist items within a Task. Modeled from Phase 1 even though
/// the checklist UI itself is a stretch feature (Phase 9), so the schema
/// never needs a breaking migration to add it later.
class Subtasks extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().references(Tasks, #id)();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => <Column>{id};
}
