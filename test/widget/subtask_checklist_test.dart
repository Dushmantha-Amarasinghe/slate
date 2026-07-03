// Covers the checklist add/toggle/delete flow end-to-end against a real
// (in-memory) database, the same harness pattern as test/widget_test.dart —
// this is the interactive flow the on-device verification pass exercised
// manually while building Phase 9's subtasks feature.

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slate/core/db/database.dart';
import 'package:slate/core/db/database_provider.dart';
import 'package:slate/core/widgets/animated_checkbox.dart';
import 'package:slate/features/subtasks/presentation/subtask_checklist.dart';

void main() {
  testWidgets('add, complete, and delete a checklist item', (WidgetTester tester) async {
    await tester.runAsync(() async {
      final AppDatabase db = AppDatabase.forTesting(NativeDatabase.memory());
      final DateTime now = DateTime(2026, 1, 1);
      await db.taskDao.insertTask(
        TasksCompanion.insert(id: 'task1', title: 'Plan trip', createdAt: now, updatedAt: now),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: <Override>[appDatabaseProvider.overrideWithValue(db)],
          child: const MaterialApp(
            home: Scaffold(body: SubtaskChecklist(taskId: 'task1')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Add an item via the "Add item" field.
      await tester.enterText(find.byType(TextField), 'Book flights');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.text('Book flights'), findsOneWidget);
      expect(find.text('0/1'), findsOneWidget);

      // Toggle it complete.
      await tester.tap(find.byType(AnimatedCheckbox));
      await tester.pumpAndSettle();
      expect(find.text('1/1'), findsOneWidget);

      // Delete it.
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.text('Book flights'), findsNothing);

      await tester.pumpWidget(const SizedBox.shrink());
      await db.close();
    });
  });
}
