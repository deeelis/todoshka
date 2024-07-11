// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskDto _$TaskDtoFromJson(Map<String, dynamic> json) => TaskDto(
      json['id'] as String,
      json['text'] as String,
      json['importance'] as String,
      TaskDto._boolFromString(json['done'] as Object),
      TaskDto._intFromNullable(json['deadline']),
      json['color'] as String,
      (json['created_at'] as num).toInt(),
      (json['changed_at'] as num).toInt(),
      json['last_updated_by'] as String,
    );

Map<String, dynamic> _$TaskDtoToJson(TaskDto instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'importance': instance.importance,
      'done': instance.done,
      'deadline': instance.deadline,
      'color': instance.color,
      'created_at': instance.createdAt,
      'changed_at': instance.changedAt,
      'last_updated_by': instance.lastUpdatedBy,
    };
