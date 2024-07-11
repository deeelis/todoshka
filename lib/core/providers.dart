import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoshka/data/dao/tasks_local_runtime_dao.dart';
import 'package:todoshka/data/dao/tasks_remote_runtime_dao.dart';
import 'package:todoshka/domain/repository/tasks_runtime_repository.dart';
import 'package:uuid/uuid.dart';

import '../data/dao/tasks_local_dao.dart';
import '../data/dao/tasks_remote_dao.dart';
import '../domain/mapper/task_mapper.dart';
import '../domain/repository/tasks_repository.dart';

final uuidProvider = Provider((ref) => const Uuid());

final taskMapperProvider = Provider<TaskMapper>(
  (ref) => TaskMapper(),
);

final tasksLocalDaoProvider = Provider<TasksLocalDao>(
  (ref) => TasksLocalRuntimeDao(),
);
final tasksRemoteDaoProvider = Provider<TasksRemoteDao>(
  (ref) => TasksRemoteRuntimeDao(),
);

final taskRepositoryProvider = Provider<TasksRepository>(
  (ref) => TasksRuntimeRepository(
    ref.read(uuidProvider),
    ref.read(tasksLocalDaoProvider),
    ref.read(tasksRemoteDaoProvider),
    ref.read(taskMapperProvider),
  ),
);
