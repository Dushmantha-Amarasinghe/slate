// Phase 0 smoke test: the app boots into the Today tab with the bottom nav
// shell in place. Deeper widget/golden tests for each feature are added as
// those features are built (see the phased roadmap's Phase 10 testing pass).

import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slate/app.dart';
import 'package:slate/core/db/database.dart';
import 'package:slate/core/db/database_provider.dart';

void main() {
  testWidgets('App boots to Today tab with bottom nav shell', (
    WidgetTester tester,
  ) async {
    // Runs in a real (non-fake) async zone: Drift schedules a real
    // zero-duration Timer when a watch() stream is cancelled on dispose,
    // and flutter_test's default FakeAsync zone flags that as "a timer
    // still pending" even though it's not a leak — runAsync sidesteps that
    // by letting real timers resolve normally instead of needing to be
    // manually pumped.
    await tester.runAsync(() async {
      final AppDatabase testDb = AppDatabase.forTesting(
        NativeDatabase.memory(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: <Override>[appDatabaseProvider.overrideWithValue(testDb)],
          child: const SlateApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Today'), findsWidgets);
      expect(find.text('All Tasks'), findsOneWidget);
      expect(find.text('Stats'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await testDb.close();
    });
  });
}
