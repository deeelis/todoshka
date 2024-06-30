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
  final TaskDao actionsDao;
  final TasksDao listDao;
  final TaskMapper actionMapper;

  TasksRuntimeRepository(
      this.uuid,
      this.actionsDao,
      this.listDao,
      this.actionMapper,
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
  Future<void> addAction(Task action) async {
    if (action.id.isEmpty) {
      action.id = uuid.v1();
    }
    action
      ..createdAt = DateTime.now()
      ..lastUpdatedBy = await getId() ?? "";
    TaskDto actionDto = actionMapper.mapTaskToTaskDto(action);
    await actionsDao.addAction(actionDto);
    try {
      await listDao.addAction(actionDto);
    } catch (e) {
      AppLogger.error(e.toString());
      synchronizeList();
    }
  }

  @override
  Future<void> deleteAction(Task action) async {
    TaskDto actionDto = actionMapper.mapTaskToTaskDto(action);
    await actionsDao.deleteAction(actionDto);
    try {
      await listDao.deleteAction(actionDto);
    } catch (e) {
      AppLogger.error(e.toString());
      synchronizeList();
    }
  }

  @override
  Future<void> editAction(Task action) async {
    action
      ..changedAt = DateTime.now()
      ..lastUpdatedBy = await getId() ?? "";
    TaskDto actionDto = actionMapper.mapTaskToTaskDto(action);
    await actionsDao.editAction(actionDto);
    try {
      await listDao.editAction(actionDto);
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
    List<TaskDto> listDb = await actionsDao.getAll();
    try {
      List<TaskDto> listFromServer = await listDao.getList();
      listDb.addAll(listFromServer);
      listFromServer = await listDao.updateTasks(listDb.toSet().toList());
      return listFromServer
          .map((e) => actionMapper.mapTaskDtoToTask(e))
          .toList();
    } on Exception catch (e) {
      AppLogger.error(e.toString());
    }
    return listDb.map((e) => actionMapper.mapTaskDtoToTask(e)).toList();
  }
}