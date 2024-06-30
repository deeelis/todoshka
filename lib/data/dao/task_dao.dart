import 'package:todoshka/data/dto/task_dto.dart';

abstract interface class TaskDao {
  Future<void> addAction(TaskDto actionDto);
  Future<void> editAction(TaskDto actionDto);

  Future<void> deleteAction(TaskDto actionDto);

  Future<List<TaskDto>> getAll();
}