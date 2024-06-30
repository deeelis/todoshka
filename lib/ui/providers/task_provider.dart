import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todoshka/core/providers.dart';
import 'package:todoshka/domain/models/task.dart';
import 'package:todoshka/utils/logger.dart';

part 'task_provider.g.dart';

@riverpod
class TaskState extends _$TaskState {
  @override
  Future<List<Task>> build() async {
    List<Task> list = await ref.read(taskRepositoryProvider).getAll();
    return list;
  }

  Future<void> addOrEditTask(Task task) async {
    List<Task> list;

    if (task.id.isEmpty) {
      await ref.read(taskRepositoryProvider).addTask(task);
      list = await ref.read(taskRepositoryProvider).getAll();
    } else {
      await ref.read(taskRepositoryProvider).editTask(task);
      list = await ref.read(taskRepositoryProvider).getAll();
    }
    state = AsyncValue.data(list);
  }

  Future<void> deleteTask(Task task) async {
    if (task.id.isNotEmpty) {
      await ref.read(taskRepositoryProvider).deleteTask(task);
      List<Task> list = await ref.read(taskRepositoryProvider).getAll();
      AppLogger.debug(list.toString());
      state = AsyncValue.data(list);
    }
  }

  Future<void> getAllTasks() async {
    List<Task> list = await ref.read(taskRepositoryProvider).getAll();
    state = AsyncValue.data(list);
  }

  Future<void> markDoneOrNot(Task task, bool done) async {
    task.isDone = done;
    addOrEditTask(task);
  }

  int countDoneTasks() {
    List<Task> list = state.valueOrNull ?? [];
    int count = list.where((item) => item.isDone).length;
    return count;
  }
}