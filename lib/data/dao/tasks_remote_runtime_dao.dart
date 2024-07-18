import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:todoshka/data/dto/tasks_dto.dart';
import 'package:todoshka/data/dto/element_dto.dart';

import '../../utils/constants.dart';
import '../../utils/logger.dart';
import '../dto/task_dto.dart';
import 'tasks_remote_dao.dart';

class TasksRemoteRuntimeDao implements TasksRemoteDao {
  TasksRemoteRuntimeDao();

  void processException(Response response, int revision) {
    AppLogger.debug(response.statusCode.toString());
    switch (response.statusCode) {
      case 400:
        {
          AppLogger.error(response.body.toString());
          throw FormatException("NotValidRevision: $revision");
        }
      case 401:
        {
          AppLogger.error(response.body.toString());
          throw const FormatException("NotValidAuth");
        }
      case 404:
        {
          AppLogger.error(response.body.toString());
          throw const FormatException("NotExistAction");
        }
      case 500:
        {
          AppLogger.error(response.body.toString());
          throw FormatException("ServerError: ${response.body.toString()}");
        }
      default:
        {
          if (response.statusCode >= 300) {
            AppLogger.error("Status code:${response.statusCode}");
            throw Exception();
          }
        }
    }
  }

  @override
  Future<void> addTask(TaskDto taskDto) async {
    final url = Uri.parse(Constants.baseUrlList);
    int revision = await Constants.getRevision();
    ElementDto elementDto = ElementDto(taskDto);
    final response = await http.post(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${Constants.token}",
        Constants.headerRevision: revision.toString(),
      },
      body: json.encode(elementDto.toJson()),
    );
    if (response.statusCode != 200) {
      processException(response, revision);
    } else {
      AppLogger.info("Success add task to remote db");
    }
    Constants.setRevision(jsonDecode(response.body)["revision"]);
  }

  @override
  Future<void> deleteTask(TaskDto taskDto) async {
    final url = Uri.parse('${Constants.baseUrlList}/${taskDto.id}');
    int revision = await Constants.getRevision();

    final response = await http.delete(
      url,
      headers: {
        Constants.headerRevision: revision.toString(),
        HttpHeaders.authorizationHeader: "Bearer ${Constants.token}",
      },
    );
    if (response.statusCode != 200) {
      processException(response, revision);
    } else {
      AppLogger.info("Success delete task from remote db");
    }
    Constants.setRevision(jsonDecode(response.body)["revision"]);
  }

  @override
  Future<void> editTask(TaskDto taskDto) async {
    final url = Uri.parse('${Constants.baseUrlList}/${taskDto.id}');
    int revision = await Constants.getRevision();
    ElementDto elementDto = ElementDto(taskDto);
    final response = await http.put(
      url,
      headers: {
        Constants.headerRevision: revision.toString(),
        HttpHeaders.authorizationHeader: "Bearer ${Constants.token}",
      },
      body: json.encode(elementDto.toJson()),
    );
    if (response.statusCode != 200) {
      processException(response, revision);
    } else {
      AppLogger.info("Success edit task in remote db");
    }
    Constants.setRevision(jsonDecode(response.body)["revision"]);
  }

  @override
  Future<List<TaskDto>> getList() async {
    final url = Uri.parse(Constants.baseUrlList);
    final response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${Constants.token}",
      },
    );
    if (response.statusCode != 200) {
      int revision = await Constants.getRevision();
      processException(response, revision);
    }
    TasksDto tasks = TasksDto.fromJson(jsonDecode(response.body));
    Constants.setRevision(tasks.revision);
    return tasks.list;
  }

  @override
  Future<List<TaskDto>> updateTasks(List<TaskDto> list) async {
    final url = Uri.parse(Constants.baseUrlList);
    int revision = await Constants.getRevision();
    final response = await http.patch(
      url,
      headers: {
        Constants.headerRevision: revision.toString(),
        HttpHeaders.authorizationHeader: "Bearer ${Constants.token}",
      },
      body: '{"list":${json.encode(list.map((e) => e.toJson()).toList())}}',
    );
    if (response.statusCode != 200) {
      processException(response, revision);
    } else {
      AppLogger.info("Success upddate tasks");
    }
    TasksDto tasks = TasksDto.fromJson(jsonDecode(response.body));
    Constants.setRevision(tasks.revision);
    return tasks.list;
  }

  Future<int> getRevision() async {
    final url = Uri.parse(Constants.baseUrlList);
    final response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${Constants.token}",
      },
    );
    if (response.statusCode != 200) {
      int revision = await Constants.getRevision();
      processException(response, revision);
    }
    TasksDto tasks = TasksDto.fromJson(jsonDecode(response.body));
    Constants.setRevision(tasks.revision);
    AppLogger.info(tasks.revision.toString());
    return tasks.revision;
  }
}
