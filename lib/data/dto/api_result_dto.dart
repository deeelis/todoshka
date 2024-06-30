import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

import 'task_dto.dart';

part 'api_result_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ApiResultDto {
  final TaskDto element;

  const ApiResultDto(this.element);

  factory ApiResultDto.fromJson(Map<String, dynamic> json) =>
      _$ApiResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResultDtoToJson(this);
}