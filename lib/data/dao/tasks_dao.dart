import 'package:todoshka/data/dto/task_dto.dart';

abstract interface class TasksDao {
  Future<List<TaskDto>> updateTasks(List<TaskDto> list);
  Future<void> addAction(TaskDto taskDto);
  Future<void> editAction(TaskDto taskDto);

  Future<void> deleteAction(TaskDto taskDto);

  Future<List<TaskDto>> getList();
}