import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../data/repositories/task_repository.dart';

final StreamProviderFamily<Task?, String> taskByIdProvider =
    StreamProvider.family<Task?, String>((Ref ref, String id) {
      return ref.watch(taskRepositoryProvider).watchById(id);
    });
