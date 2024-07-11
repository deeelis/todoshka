import 'dart:io';
import 'package:todoshka/data/dao/tasks_remote_dao.dart';
import 'package:todoshka/data/repository/tasks_repository.dart';
import 'package:todoshka/domain/mapper/task_mapper.dart';
import 'package:todoshka/domain/models/task.dart';
import 'package:uuid/uuid.dart';

import '../../data/dao/tasks_local_dao.dart';
import '../../data/dto/task_dto.dart';
import '../../utils/logger.dart';

class TasksRuntimeRepository implements TasksRepository {
  final Uuid uuid;
  final TasksLocalDao tasksLocalDao;
  final TasksRemoteDao tasksRemoteDao;
  final TaskMapper taskMapper;

  TasksRuntimeRepository(
    this.uuid,
    this.tasksLocalDao,
    this.tasksRemoteDao,
    this.taskMapper,
  );

  @override
  Future<void> addTask(Task task) async {
    if (task.id.isEmpty) {
      task.id = uuid.v1();
    }
    TaskDto taskDto = taskMapper.mapTaskToTaskDto(task);
    await tasksLocalDao.addTask(taskDto);
    try {
      await tasksRemoteDao.addTask(taskDto);
    } on SocketException {
      AppLogger.info("NoConnection");
    } catch (e) {
      AppLogger.error(e.toString());
      synchronizeList();
    }
  }

  @override
  Future<void> deleteTask(Task task) async {
    TaskDto taskDto = taskMapper.mapTaskToTaskDto(task);
    await tasksLocalDao.deleteTask(taskDto);
    try {
      await tasksRemoteDao.deleteTask(taskDto);
    } on SocketException {
      AppLogger.info("No Connection");
    } catch (e) {
      AppLogger.error(e.toString());
      synchronizeList();
    }
  }

  @override
  Future<void> editTask(Task task) async {
    TaskDto taskDto = taskMapper.mapTaskToTaskDto(task);
    await tasksLocalDao.editTask(taskDto);
    try {
      await tasksRemoteDao.editTask(taskDto);
    } on SocketException {
      AppLogger.info("No Connection");
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
    AppLogger.debug("synchronize");
    List<TaskDto> listDb = await tasksLocalDao.getAll();
    try {
      List<TaskDto> listFromServer = await tasksRemoteDao.getList();
      listDb.addAll(listFromServer);
      listFromServer =
          await tasksRemoteDao.updateTasks(listDb.toSet().toList());
      await tasksLocalDao.updateTasks(listFromServer);
      return listFromServer.map((e) => taskMapper.mapTaskDtoToTask(e)).toList();
    } on SocketException {
      AppLogger.info("No Connection");
    } on Exception catch (e) {
      AppLogger.error(e.toString());
    }
    return listDb.map((e) => taskMapper.mapTaskDtoToTask(e)).toList();
  }
}
