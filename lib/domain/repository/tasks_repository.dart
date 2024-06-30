import 'package:todoshka/domain/models/task.dart';

abstract interface class TasksRepository {
  Future<void> addAction(Task task);
  Future<void> deleteAction(Task task);
  Future<void> editAction(Task task);
  Future<List<Task>> synchronizeList();
  Future<List<Task>> getAll();
}