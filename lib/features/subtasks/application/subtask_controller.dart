import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../data/repositories/subtask_repository.dart';

final StreamProviderFamily<List<Subtask>, String> subtasksForTaskProvider =
    StreamProvider.family<List<Subtask>, String>((Ref ref, String taskId) {
      return ref.watch(subtaskRepositoryProvider).watchForTask(taskId);
    });
