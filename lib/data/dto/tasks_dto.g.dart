// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TasksDto _$TasksDtoFromJson(Map<String, dynamic> json) => TasksDto(
      json['status'] as String? ?? '',
      (json['revision'] as num?)?.toInt() ?? 0,
      (json['list'] as List<dynamic>?)
              ?.map((e) => TaskDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$TasksDtoToJson(TasksDto instance) => <String, dynamic>{
      'status': instance.status,
      'revision': instance.revision,
      'list': instance.list.map((e) => e.toJson()).toList(),
    };
