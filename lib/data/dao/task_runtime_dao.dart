import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoshka/data/dto/task_dto.dart';
import 'package:todoshka/utils/logger.dart';

import 'task_dao.dart';

class TaskRuntimeDao implements TaskDao {
  TaskRuntimeDao();

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
      AppLogger.info("Success add action to db");
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
      AppLogger.info("Success delete action from db");
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
      AppLogger.info("Success edit action to db");
    } catch (err) {
      AppLogger.error(err.toString());
    }
  }

  @override
  Future<List<TaskDto>> getAll() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('Tasks');
    return queryResult.map((e) {
      TaskDto taskDto = TaskDto.fromJson(e);
      return taskDto;
    }).toList();
  }
}