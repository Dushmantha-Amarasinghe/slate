import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../data/repositories/task_repository.dart';

final StreamProvider<List<Task>> allTasksProvider = StreamProvider<List<Task>>((
  Ref ref,
) {
  return ref.watch(taskRepositoryProvider).watchAll();
});
