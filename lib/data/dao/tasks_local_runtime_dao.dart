import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoshka/data/dto/task_dto.dart';
import 'package:todoshka/utils/logger.dart';

import 'tasks_local_dao.dart';

class TasksLocalRuntimeDao implements TasksLocalDao {
  TasksLocalRuntimeDao();

  static const String tableName = "Tasks";
  late final Database _db;


  Future<void> init() async {
    String path = await getDatabasesPath();
    _db = await openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute(
          """CREATE TABLE IF NOT EXIST $tableName (
            id TEXT PRIMARY KEY ,
            text TEXT NOT NULL ,
            done TEXT NOT NULL ,
            deadline INTEGER ,
            importance TEXT NOT NULL ,
            color TEXT NOT NULL ,
            created_at INTEGER NOT NULL ,
            changed_at INTEGER NOT NULL ,
            last_updated_by TEXT NOT NULL
            )
            """,
        );
      },
      version: 1,
    );
  }

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute(
          """CREATE TABLE Tasks(
            id TEXT PRIMARY KEY ,
            text TEXT NOT NULL ,
            done TEXT NOT NULL ,
            deadline INTEGER ,
            importance TEXT NOT NULL ,
            color TEXT NOT NULL ,
            created_at INTEGER NOT NULL ,
            changed_at INTEGER NOT NULL ,
            last_updated_by TEXT NOT NULL
            )
            """,
        );
      },
      version: 1,
    );
  }

  @override
  Future<void> addTask(TaskDto taskDto) async {
    final Database db = await initializeDB();
    try {
      final _ = await db.insert(
        'Tasks',
        taskDto.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      AppLogger.info("Successfully add task to local db");
    } catch (err) {
      AppLogger.error(err.toString());
    }
  }

  @override
  Future<void> deleteTask(TaskDto taskDto) async {
    final Database db = await initializeDB();
    try {
      await db.delete(
        "Tasks",
        where: """
      id = ?
      """,
        whereArgs: [
          taskDto.id,
        ],
      );
      AppLogger.info("Successfully delete task from local db");
    } catch (err) {
      AppLogger.error(err.toString());
    }
  }

  @override
  Future<void> editTask(TaskDto taskDto) async {
    final Database db = await initializeDB();
    try {
      await db.update(
        "Tasks",
        taskDto.toJson(),
        where: """
      id = ?
      """,
        whereArgs: [
          taskDto.id,
        ],
      );
      AppLogger.info("Successfully edit task in local db");
    } catch (err) {
      AppLogger.error(err.toString());
    }
  }

  @override
  Future<List<TaskDto>> getAll() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('Tasks');
    return queryResult.map((elem) {
      TaskDto taskDto = TaskDto.fromJson(elem);
      return taskDto;
    }).toList();
  }
}
