import 'dart:io';
import 'package:todoshka/data/dao/tasks_dao.dart';
import 'package:todoshka/domain/repository/tasks_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../../data/dao/task_dao.dart';
import '../../data/dto/task_dto.dart';
import '../../utils/logger.dart';
import '../mapper/task_mapper.dart';
import '../models/task.dart';

class TasksRuntimeRepository implements TasksRepository {
  final Uuid uuid;
  final TaskDao taskDao;
  final TasksDao listDao;
  final TaskMapper taskMapper;

  TasksRuntimeRepository(
    this.uuid,
    this.taskDao,
    this.listDao,
    this.taskMapper,
  );

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

  @override
  Future<void> addTask(Task task) async {
    if (task.id.isEmpty) {
      task.id = uuid.v1();
    }
    task
      ..createdAt = DateTime.now()
      ..lastUpdatedBy = await getId() ?? "";
    TaskDto taskDto = taskMapper.mapTaskToTaskDto(task);
    await taskDao.addTask(taskDto);
    try {
      await listDao.addTask(taskDto);
    } catch (e) {
      AppLogger.error(e.toString());
      synchronizeList();
    }
  }

  @override
  Future<void> deleteTask(Task task) async {
    TaskDto taskDto = taskMapper.mapTaskToTaskDto(task);
    await taskDao.deleteTask(taskDto);
    try {
      await listDao.deleteTask(taskDto);
    } catch (e) {
      AppLogger.error(e.toString());
      synchronizeList();
    }
  }

  @override
  Future<void> editTask(Task task) async {
    task
      ..changedAt = DateTime.now()
      ..lastUpdatedBy = await getId() ?? "";
    TaskDto taskDto = taskMapper.mapTaskToTaskDto(task);
    await taskDao.editTask(taskDto);
    try {
      await listDao.editTask(taskDto);
    } catch (e) {
      AppLogger.error(e.toString());
      synchronizeList();
    }
  }

  @override
  Future<List<Task>> getAll() async {
    List<Task> list = await synchronizeList();
    return list;
  }

  @override
  Future<List<Task>> synchronizeList() async {
    List<TaskDto> listDb = await taskDao.getAll();
    try {
      List<TaskDto> listFromServer = await listDao.getList();
      listDb.addAll(listFromServer);
      listFromServer = await listDao.updateTasks(listDb.toSet().toList());
      return listFromServer.map((e) => taskMapper.mapTaskDtoToTask(e)).toList();
    } on Exception catch (e) {
      AppLogger.error(e.toString());
    }
    return listDb.map((e) => taskMapper.mapTaskDtoToTask(e)).toList();
  }
}
