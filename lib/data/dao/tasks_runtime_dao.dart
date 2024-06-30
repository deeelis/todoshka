import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:todoshka/data/dto/tasks_dto.dart';
import 'package:todoshka/data/dto/api_result_dto.dart';

import '../../utils/constants.dart';
import '../../utils/logger.dart';
import '../dto/task_dto.dart';
import 'tasks_dao.dart';

class TasksRuntimeDao implements TasksDao {
  TasksRuntimeDao();

  @override
  Future<void> addAction(TaskDto actionDto) async {
    final url = Uri.parse(Constants.baseUrlList);
    int revision = await Constants.getRevision();
    ApiResultDto apiResultDto = ApiResultDto(actionDto);
    final response = await http.post(
      url,
      headers: {
        Constants.headerRevision: revision.toString(),
        HttpHeaders.authorizationHeader: "Bearer ${Constants.token}",
      },
      body: json.encode(apiResultDto.toJson()),
    );
    if (response.statusCode != 200) {
      AppLogger.debug(response.statusCode.toString());
      if (response.statusCode == 400) {
        throw FormatException('NotValidRevision: $revision');
      }
    }
    Constants.setRevision(jsonDecode(response.body)["revision"]);
  }

  @override
  Future<void> deleteAction(TaskDto actionDto) async {
    final url = Uri.parse('${Constants.baseUrlList}/${actionDto.id}');
    int revision = await Constants.getRevision();
    final response = await http.delete(
      url,
      headers: {
        Constants.headerRevision: revision.toString(),
        HttpHeaders.authorizationHeader: "Bearer ${Constants.token}",
      },
    );
    if (response.statusCode != 200) {
      AppLogger.debug(response.statusCode.toString());
      if (response.statusCode == 400) {
        throw FormatException('NotValidRevision: $revision');
      }
    }
    Constants.setRevision(jsonDecode(response.body)["revision"]);
  }

  @override
  Future<void> editAction(TaskDto actionDto) async {
    final url = Uri.parse('${Constants.baseUrlList}/${actionDto.id}');
    int revision = await Constants.getRevision();
    ApiResultDto apiResultDto = ApiResultDto(actionDto);
    final response = await http.put(
      url,
      headers: {
        Constants.headerRevision: revision.toString(),
        HttpHeaders.authorizationHeader: "Bearer ${Constants.token}",
      },
      body: json.encode(apiResultDto.toJson()),
    );
    if (response.statusCode != 200) {
      AppLogger.debug(response.statusCode.toString());
      if (response.statusCode == 400) {
        throw FormatException('NotValidRevision: $revision');
      }
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
      AppLogger.debug(response.statusCode.toString());
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
      AppLogger.debug(response.statusCode.toString());
      if (response.statusCode == 400) {
        throw FormatException('NotValidRevision: $revision');
      }
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
      AppLogger.debug(response.statusCode.toString());
    }
    TasksDto tasks = TasksDto.fromJson(jsonDecode(response.body));
    return tasks.revision;
  }
}