import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoshka/data/dao/task_runtime_dao.dart';
import 'package:todoshka/data/dao/tasks_runtime_dao.dart';
import 'package:todoshka/domain/repository/tasks_runtime_repository.dart';
import 'package:uuid/uuid.dart';

import '../data/dao/task_dao.dart';
import '../data/dao/tasks_dao.dart';
import '../domain/mapper/task_mapper.dart';
import '../domain/repository/tasks_repository.dart';

final uuidProvider = Provider((ref) => const Uuid());

final taskMapperProvider = Provider<TaskMapper>(
      (ref) => TaskMapper(),
);

final taskDaoProvider = Provider<TaskDao>(
      (ref) => TaskRuntimeDao(),
);
final tasksDaoProvider = Provider<TasksDao>(
      (ref) => TasksRuntimeDao(),
);

final taskRepositoryProvider = Provider<TasksRepository>(
      (ref) => TasksRuntimeRepository(
    ref.read(uuidProvider),
    ref.read(taskDaoProvider),
    ref.read(tasksDaoProvider),
    ref.read(taskMapperProvider),
  ),
);