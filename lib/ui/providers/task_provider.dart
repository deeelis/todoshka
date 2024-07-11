import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todoshka/core/providers.dart';
import 'package:todoshka/domain/models/task.dart';

part 'task_provider.g.dart';

@riverpod
class TaskState extends _$TaskState {
  @override
  Future<List<Task>> build() async {
    List<Task> list = await ref.read(taskRepositoryProvider).getAll();
    return list;
  }

  Future<String?> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id;
    } else if (Platform.isWindows) {
      var windowsDeviceInfo = await deviceInfo.windowsInfo;
      return windowsDeviceInfo.deviceId;
    }
    return null;
  }

  Future<void> addOrEditTask(Task task) async {
    List<Task> list;
    task
      ..createdAt = DateTime.now()
      ..lastUpdatedBy = await getId() ?? "";
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

  Future<void> synchronize() async {
    List<Task> list = await ref.read(taskRepositoryProvider).synchronizeList();
    state = AsyncValue.data(list);
  }

  int countDoneTasks() {
    List<Task> list = state.valueOrNull ?? [];
    int count = list.where((item) => item.isDone).length;
    return count;
  }
}
