import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todoshka/data/dao/tasks_local_dao.dart';
import 'package:todoshka/data/dao/tasks_remote_dao.dart';
import 'package:todoshka/data/repository/tasks_repository.dart';
import 'package:todoshka/data/repository/tasks_runtime_repository.dart';
import 'package:todoshka/domain/mapper/task_mapper.dart';
import 'package:todoshka/domain/models/importance.dart';
import 'package:todoshka/domain/models/task.dart';
import 'package:uuid/uuid.dart';

class MockRemoteDao extends Mock implements TasksRemoteDao {}

class MockLocalDao extends Mock implements TasksLocalDao {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  late final MockLocalDao tasksLocalDao;
  late final MockRemoteDao tasksRemoteDao;
  late final TasksRepository tasksRepository;
  late final TaskMapper taskMapper;
  late final Uuid uuid;

  Task task1 = Task(
    "4306f480-757f-105b-9209-9f0f7e4e7b6c",
    "text",
    Importance.basic,
    true,
    true,
    DateTime.fromMillisecondsSinceEpoch(1720670181866),
    "",
    DateTime.fromMillisecondsSinceEpoch(1720670181866),
    DateTime.fromMillisecondsSinceEpoch(1720670181866),
    "UP1A.231005.007",
  );
  Task task2 = Task(
    "447ef5e0-61f4-105b-a1d7-7728ddd1ed8a",
    "text",
    Importance.basic,
    true,
    true,
    DateTime.fromMillisecondsSinceEpoch(1720670181866),
    "",
    DateTime.fromMillisecondsSinceEpoch(1720670181866),
    DateTime.fromMillisecondsSinceEpoch(1720670181866),
    "UP1A.231005.007",
  );

  setUpAll(() {
    uuid = const Uuid();
    tasksRemoteDao = MockRemoteDao();
    tasksLocalDao = MockLocalDao();
    taskMapper = TaskMapper();
    tasksRepository =
        TasksRuntimeRepository(uuid, tasksLocalDao, tasksRemoteDao, taskMapper);
    registerFallbackValue(taskMapper.mapTaskToTaskDto(task1));
    registerFallbackValue(taskMapper.mapTaskToTaskDto(task2));
  });

  setUp(() async {
    when(() => tasksRemoteDao.addTask(any())).thenAnswer((_) async => {});
    when(() => tasksRemoteDao.editTask(any())).thenAnswer((_) async => {});
    when(() => tasksRemoteDao.deleteTask(any())).thenAnswer((_) async => {});
    when(() => tasksLocalDao.addTask(any())).thenAnswer((_) async => {});
    when(() => tasksLocalDao.editTask(any())).thenAnswer((_) async => {});
    when(() => tasksLocalDao.deleteTask(any())).thenAnswer((_) async => {});
    when(() => tasksRemoteDao.getList()).thenAnswer(
      (_) async => [
        taskMapper.mapTaskToTaskDto(
          Task(
            "4306f480-757f-105b-9209-9f0f7e4e7b6c",
            "text",
            Importance.basic,
            true,
            true,
            DateTime.fromMillisecondsSinceEpoch(1720670181866),
            "",
            DateTime.fromMillisecondsSinceEpoch(1720670181866),
            DateTime.fromMillisecondsSinceEpoch(1720670181866),
            "UP1A.231005.007",
          ),
        ),
      ],
    );
    when(() => tasksRemoteDao.updateTasks(any())).thenAnswer(
      (_) async => [
        taskMapper.mapTaskToTaskDto(
          Task(
            "4306f480-757f-105b-9209-9f0f7e4e7b6c",
            "text",
            Importance.basic,
            true,
            true,
            DateTime.fromMillisecondsSinceEpoch(1720670181866),
            "",
            DateTime.fromMillisecondsSinceEpoch(1720670181866),
            DateTime.fromMillisecondsSinceEpoch(1720670181866),
            "UP1A.231005.007",
          ),
        ),
      ],
    );
    when(() => tasksLocalDao.getAll()).thenAnswer(
      (_) async => [
        taskMapper.mapTaskToTaskDto(
          Task(
            "4306f480-757f-105b-9209-9f0f7e4e7b6c",
            "text",
            Importance.basic,
            true,
            true,
            DateTime.fromMillisecondsSinceEpoch(1720670181866),
            "",
            DateTime.fromMillisecondsSinceEpoch(1720670181866),
            DateTime.fromMillisecondsSinceEpoch(1720670181866),
            "UP1A.231005.007",
          ),
        ),
      ],
    );
    when(() => tasksLocalDao.updateTasks(any())).thenAnswer(
      (_) async => [
        taskMapper.mapTaskToTaskDto(
          Task(
            "4306f480-757f-105b-9209-9f0f7e4e7b6c",
            "new text",
            Importance.basic,
            true,
            true,
            DateTime.fromMillisecondsSinceEpoch(1720670181866),
            "",
            DateTime.fromMillisecondsSinceEpoch(1720670181866),
            DateTime.fromMillisecondsSinceEpoch(1720670181866),
            "UP1A.231005.007",
          ),
        ),
      ],
    );
  });

  test('Check api repository adding', () async {
    await tasksRepository.addTask(task1);
    List<Task> list = await tasksRepository.getAll();
    expect(list.length, 1);
    expect(list[0].id, task1.id);
  });

  test('Check api repository delete', () async {
    await tasksRepository.addTask(task1);
    await tasksRepository.addTask(task2);
    await tasksRepository.deleteTask(task2);
    List<Task> list = await tasksRepository.getAll();
    expect(list.length, 1);
    expect(list[0].id, task1.id);
    expect(list[0].text, task1.text);
  });

  test('Check api repository edit', () async {
    when(() => tasksRemoteDao.updateTasks(any())).thenAnswer(
      (_) async => [
        taskMapper.mapTaskToTaskDto(
          Task(
            "4306f480-757f-105b-9209-9f0f7e4e7b6c",
            "new text",
            Importance.basic,
            true,
            true,
            DateTime.fromMillisecondsSinceEpoch(1720670181866),
            "",
            DateTime.fromMillisecondsSinceEpoch(1720670181866),
            DateTime.fromMillisecondsSinceEpoch(1720670181866),
            "UP1A.231005.007",
          ),
        ),
      ],
    );
    await tasksRepository.addTask(task1);
    task1.text = "new text";
    await tasksRepository.editTask(task1);
    List<Task> list = await tasksRepository.getAll();
    expect(list.length, 1);
    expect(list[0].id, task1.id);
    expect(list[0].text, task1.text);
  });

  test('Check api repository synchronize', () async {
    when(() => tasksRemoteDao.updateTasks(any())).thenAnswer(
      (_) async => [
        taskMapper.mapTaskToTaskDto(
          Task(
            "4306f480-757f-105b-9209-9f0f7e4e7b6c",
            "text",
            Importance.basic,
            true,
            true,
            DateTime.fromMillisecondsSinceEpoch(1720670181866),
            "",
            DateTime.fromMillisecondsSinceEpoch(1720670181866),
            DateTime.fromMillisecondsSinceEpoch(1720670181866),
            "UP1A.231005.007",
          ),
        ),
        taskMapper.mapTaskToTaskDto(
          Task(
            "447ef5e0-61f4-105b-a1d7-7728ddd1ed8a",
            "text",
            Importance.basic,
            true,
            true,
            DateTime.fromMillisecondsSinceEpoch(1720670181866),
            "",
            DateTime.fromMillisecondsSinceEpoch(1720670181866),
            DateTime.fromMillisecondsSinceEpoch(1720670181866),
            "UP1A.231005.007",
          ),
        ),
      ],
    );
    await tasksRepository.addTask(task1);
    await tasksRepository.addTask(task2);
    List<Task> list = await tasksRepository.synchronizeList();
    expect(list.length, 2);
  });
}
