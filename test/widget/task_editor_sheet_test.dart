// Covers the add-task flow's core gating rule (spec 4: title is the only
// required field) plus the sheet-closes-after-save behavior that was the
// subject of a real bug fix earlier in the build (see task_editor_sheet.dart's
// _save() comment about capturing the Navigator before any awaits).

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slate/core/db/database.dart';
import 'package:slate/core/db/database_provider.dart';
import 'package:slate/features/task_editor/presentation/task_editor_sheet.dart';

void main() {
  testWidgets('Add task button stays disabled until a title is entered, then saves and closes', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      final AppDatabase db = AppDatabase.forTesting(NativeDatabase.memory());

      await tester.pumpWidget(
        ProviderScope(
          overrides: <Override>[appDatabaseProvider.overrideWithValue(db)],
          child: MaterialApp(
            home: Builder(
              builder: (BuildContext context) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () => TaskEditorSheet.show(context),
                    child: const Text('open'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      final Finder saveButton = find.widgetWithText(FilledButton, 'Add task');
      expect(tester.widget<FilledButton>(saveButton).onPressed, isNull);

      await tester.enterText(find.byType(TextField).first, 'Buy milk');
      await tester.pump();
      expect(tester.widget<FilledButton>(saveButton).onPressed, isNotNull);

      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.byType(TaskEditorSheet), findsNothing);

      final List<Task> tasks = await db.taskDao.watchAllTasks().first;
      expect(tasks, hasLength(1));
      expect(tasks.single.title, 'Buy milk');

      await tester.pumpWidget(const SizedBox.shrink());
      await db.close();
    });
  });
}
