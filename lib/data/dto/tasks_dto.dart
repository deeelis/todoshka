import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

import 'task_dto.dart';

part 'tasks_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class TasksDto {
  @JsonKey(defaultValue: '')
  final String status;
  @JsonKey(defaultValue: 0)
  final int revision;
  @JsonKey(defaultValue: [])
  final List<TaskDto> list;

  const TasksDto(this.status, this.revision, this.list);

  factory TasksDto.fromJson(Map<String, dynamic> json) =>
      _$TasksDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TasksDtoToJson(this);
}