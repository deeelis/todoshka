import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todoshka/data/dao/tasks_local_dao.dart';
import 'package:todoshka/data/dao/tasks_local_runtime_dao.dart';
import 'package:todoshka/data/dto/task_dto.dart';

void main() {
  late final TasksLocalDao tasksLocalDao;
  TaskDto taskDto1 = TaskDto(
    "4306f480-757f-105b-9209-9f0f7e4e7b6c",
    "text",
    "basic",
    true,
    1720670181866,
    "",
    1720670181866,
    1720670181866,
    "UP1A.231005.007",
  );
  TaskDto taskDto2 = TaskDto(
    "447ef5e0-61f4-105b-a1d7-7728ddd1ed8a",
    "text",
    "basic",
    true,
    1720670181866,
    "",
    1720670181866,
    1720670181866,
    "UP1A.231005.007",
  );
  TaskDto taskDto3 = TaskDto(
    "d41fdbc0-612b-105b-a1d7-7728ddd1ed8a",
    "text",
    "basic",
    false,
    1720670181866,
    "",
    1720670181866,
    1720670181866,
    "UP1A.231005.007",
  );

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    tasksLocalDao = TasksLocalRuntimeDao()..updateTasks([]);
  });

  test('Local adding task test', () async {
    List<TaskDto> list = [];
    await tasksLocalDao.addTask(taskDto1);
    list = await tasksLocalDao.getAll();
    expect(list.length, 1);
    // expect(list[0], taskDto1);
  });

  test('Local deleting task test', () async {
    List<TaskDto> list = [];
    await tasksLocalDao.addTask(taskDto1);
    await tasksLocalDao.deleteTask(taskDto1);
    list = await tasksLocalDao.getAll();
    expect(list, isEmpty);
  });

  test('Local editing task test', () async {
    List<TaskDto> list = [];
    await tasksLocalDao.addTask(taskDto1);
    taskDto1.done = false;
    await tasksLocalDao.editTask(taskDto1);
    list = await tasksLocalDao.getAll();
    expect(list.length, 1);
    expect(list[0].done, isFalse);
  });

  test('Local updating list test', () async {
    await tasksLocalDao.addTask(taskDto1);
    await tasksLocalDao.addTask(taskDto2);
    List<TaskDto> list = await tasksLocalDao.updateTasks([taskDto3]);
    expect(list.length, 1);
    expect(list[0], taskDto3);
  });
}
