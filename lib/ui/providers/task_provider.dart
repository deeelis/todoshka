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

  Future<void> addOrEditAction(Task action) async {
    List<Task> list;

    if (action.id.isEmpty) {
      await ref.read(taskRepositoryProvider).addAction(action);
      list = await ref.read(taskRepositoryProvider).getAll();
    } else {
      await ref.read(taskRepositoryProvider).editAction(action);
      list = await ref.read(taskRepositoryProvider).getAll();
    }
    state = AsyncValue.data(list);
  }

  Future<void> deleteAction(Task action) async {
    if (action.id.isNotEmpty) {
      await ref.read(taskRepositoryProvider).deleteAction(action);
      List<Task> list = await ref.read(taskRepositoryProvider).getAll();
      AppLogger.debug(list.toString());
      state = AsyncValue.data(list);
    }
  }

  Future<void> getAllActions() async {
    List<Task> list = await ref.read(taskRepositoryProvider).getAll();
    state = AsyncValue.data(list);
  }

  Future<void> markDoneOrNot(Task action, bool done) async {
    action.isDone = done;
    addOrEditAction(action);
  }

  int countDoneActions() {
    List<Task> list = state.valueOrNull ?? [];
    int count = list.where((item) => item.isDone).length;
    return count;
  }
}