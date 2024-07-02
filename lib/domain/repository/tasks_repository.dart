import 'package:todoshka/domain/models/task.dart';

abstract interface class TasksRepository {
  Future<void> addTask(Task task);
  Future<void> deleteTask(Task task);
  Future<void> editTask(Task task);
  Future<List<Task>> synchronizeList();
  Future<List<Task>> getAll();
}
