import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoshka/data/dao/tasks_remote_dao.dart';
import 'package:todoshka/data/dao/tasks_remote_runtime_dao.dart';
import 'package:todoshka/data/dto/task_dto.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  late final TasksRemoteDao tasksRemoteDao;
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
    tasksRemoteDao = TasksRemoteRuntimeDao();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPreferences.getInstance();

    await tasksRemoteDao.getList();
    await tasksRemoteDao.updateTasks([]);
  });

  test('Remote adding task test', () async {
    await tasksRemoteDao.addTask(taskDto1);
    List<TaskDto> list = await tasksRemoteDao.getList();
    expect(list.length, 1);
    expect(list[0], taskDto1);
  });

  test('Remote editing task test', () async {
    await tasksRemoteDao.addTask(taskDto1);
    taskDto1.text = "woyeeter";
    await tasksRemoteDao.editTask(taskDto1);
    List<TaskDto> list = await tasksRemoteDao.getList();
    expect(list.length, 1);
    expect(list[0], taskDto1);
  });

  test('Remote deleting task test', () async {
    await tasksRemoteDao.addTask(taskDto1);
    await tasksRemoteDao.deleteTask(taskDto1);
    List<TaskDto> list = await tasksRemoteDao.getList();
    expect(list, isEmpty);
  });

  test('Remote updating list test', () async {
    await tasksRemoteDao.addTask(taskDto1);
    await tasksRemoteDao.addTask(taskDto2);
    List<TaskDto> list = await tasksRemoteDao.updateTasks([taskDto3]);
    expect(list.length, 1);
    expect(list[0], taskDto3);
  });
}
