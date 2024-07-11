import 'package:todoshka/data/dto/task_dto.dart';

abstract interface class TasksLocalDao {
  Future<void> addTask(TaskDto taskDto);
  Future<void> editTask(TaskDto taskDto);
  Future<void> deleteTask(TaskDto taskDto);
  Future<List<TaskDto>> getAll();
}
