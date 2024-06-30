import 'package:json_annotation/json_annotation.dart';

part 'task_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class TaskDto {
  String id;
  String text;
  String importance;
  @JsonKey(fromJson: _boolFromString,)
  bool done;
  @JsonKey(fromJson: _intFromNullable,)
  int? deadline;
  String color;
  @JsonKey(name: "created_at")
  int createdAt;
  @JsonKey(name: "changed_at")
  int changedAt;
  @JsonKey(name: "last_updated_by")
  String lastUpdatedBy;

  static bool _boolFromString(Object done) {
    if (done is String) {
      return done == "1";
    }
    if (done is int) {
      return done == 1;
    }
    if (done is bool) {
      return done;
    }
    return false;
  }

  static int? _intFromNullable(Object? deadline) {
    if (deadline != null) {
      if (deadline is int) {
        return deadline;
      }
    }
    return null;
  }

  TaskDto(
      this.id,
      this.text,
      this.importance,
      this.done,
      this.deadline,
      this.color,
      this.createdAt,
      this.changedAt,
      this.lastUpdatedBy,
      );

  factory TaskDto.fromJson(Map<String, dynamic> json) =>
      _$TaskDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TaskDtoToJson(this);

  @override
  bool operator ==(Object other) {
    if (other is! TaskDto) return false;
    if (id != other.id) return false;
    if (text != other.text) return false;
    if (done != other.done) return false;
    if (deadline != other.deadline) return false;
    if (color != other.color) return false;
    if (changedAt != other.changedAt) return false;
    if (createdAt != other.createdAt) return false;
    if (lastUpdatedBy != other.lastUpdatedBy) return false;
    return true;
  }

  @override
  int get hashCode => text.hashCode;
}