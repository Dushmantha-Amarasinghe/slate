// Golden coverage for the app's most-repeated widget (Phase 4 exit
// criteria). Deliberately minimal — a few representative states, not
// exhaustive — full golden coverage across light/dark/text-scale lands in
// the Phase 10 testing-hardening pass.

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slate/core/db/database.dart';
import 'package:slate/core/db/database_provider.dart';
import 'package:slate/core/db/tables/tasks_table.dart';
import 'package:slate/core/theme/app_theme.dart';
import 'package:slate/features/today/presentation/widgets/task_card.dart';

Task _buildTask({
  required String id,
  required String title,
  TaskPriority priority = TaskPriority.none,
  DateTime? dueDateTimeLocal,
  bool isCompleted = false,
}) {
  final DateTime now = DateTime(2026, 1, 1, 9);
  return Task(
    id: id,
    title: title,
    priority: priority,
    dueDateTimeLocal: dueDateTimeLocal,
    dueDateHasTime: true,
    isRecurring: false,
    isCompleted: isCompleted,
    completedAt: isCompleted ? now : null,
    sortOrder: 0,
    createdAt: now,
    updatedAt: now,
  );
}

Widget _wrap(Widget child, AppDatabase testDb) {
  return ProviderScope(
    overrides: <Override>[appDatabaseProvider.overrideWithValue(testDb)],
    child: MaterialApp(
      theme: AppTheme.dark(),
      home: Scaffold(body: Padding(padding: const EdgeInsets.all(16), child: child)),
    ),
  );
}

/// TaskCard reads Settings > Gestures' swipe-direction override, so every
/// golden test needs a database in the widget tree — an isolated in-memory
/// one, per the project's testing convention (see test/widget_test.dart).
/// The teardown pump is wrapped in `runAsync` for the same Drift-stream-
/// disposal-Timer reason noted there; `matchesGoldenFile` does its own
/// internal `runAsync`, so it must stay outside that wrapper to avoid a
/// "reentrant call to runAsync" failure.
Future<void> _expectGolden(
  WidgetTester tester,
  Widget widget,
  AppDatabase testDb,
  String goldenPath,
) async {
  await tester.pumpWidget(widget);
  await tester.pumpAndSettle();
  await expectLater(find.byType(TaskCard), matchesGoldenFile(goldenPath));
  await tester.runAsync(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    await testDb.close();
  });
}

void main() {
  testWidgets('pending task, no metadata', (WidgetTester tester) async {
    final AppDatabase testDb = AppDatabase.forTesting(NativeDatabase.memory());
    await _expectGolden(
      tester,
      _wrap(
        TaskCard(
          task: _buildTask(id: 't1', title: 'Buy milk'),
          tag: null,
          onToggleComplete: () {},
          onTap: () {},
          onDelete: () {},
        ),
        testDb,
      ),
      testDb,
      'goldens/task_card_pending_plain.png',
    );
  });

  testWidgets('pending task with priority and due date', (WidgetTester tester) async {
    final AppDatabase testDb = AppDatabase.forTesting(NativeDatabase.memory());
    await _expectGolden(
      tester,
      _wrap(
        TaskCard(
          task: _buildTask(
            id: 't2',
            title: 'Finish project proposal',
            priority: TaskPriority.high,
            dueDateTimeLocal: DateTime(2026, 1, 1, 17, 30),
          ),
          tag: null,
          onToggleComplete: () {},
          onTap: () {},
          onDelete: () {},
        ),
        testDb,
      ),
      testDb,
      'goldens/task_card_pending_with_metadata.png',
    );
  });

  testWidgets('completed task shows strikethrough', (WidgetTester tester) async {
    final AppDatabase testDb = AppDatabase.forTesting(NativeDatabase.memory());
    await _expectGolden(
      tester,
      _wrap(
        TaskCard(
          task: _buildTask(id: 't3', title: 'Walk the dog', isCompleted: true),
          tag: null,
          onToggleComplete: () {},
          onTap: () {},
          onDelete: () {},
        ),
        testDb,
      ),
      testDb,
      'goldens/task_card_completed.png',
    );
  });
}
