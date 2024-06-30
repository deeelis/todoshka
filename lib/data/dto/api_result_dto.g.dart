// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResultDto _$ApiResultDtoFromJson(Map<String, dynamic> json) => ApiResultDto(
      TaskDto.fromJson(json['element'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApiResultDtoToJson(ApiResultDto instance) =>
    <String, dynamic>{
      'element': instance.element.toJson(),
    };
