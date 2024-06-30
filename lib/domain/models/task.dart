import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:todoshka/domain/models/importance.dart';

class Task {
  late String id;
  final String text;
  final Importance importance;
  final bool isDone;
  final DateTime? deadline;

  Task(
    this.id,
    this.text,
    this.importance,
    this.isDone,
    this.deadline,
  );

  // for the future
  //
  // factory Task.fromJson(Map<String, dynamic> json) =>
  //     _$TaskFromJson(json);
  //
  // Map<String, dynamic> toJson() => _$TaskToJson(this);

  Task editAndCopyWith({
    String? text,
    Importance? importance,
    bool? isDone,
    DateTime? deadline,
    Color? color,
    bool? deleteDeadline,
  }) {
    return Task(
      id,
      text ?? this.text,
      importance ?? this.importance,
      isDone ?? this.isDone,
      deleteDeadline ?? false ? null : deadline ?? this.deadline,
    );
  }

  Task.create({
    this.id = '',
    this.text = 'Новая задача',
    this.importance = Importance.basic,
    this.isDone = false,
    this.deadline,
  }) {
    var now = DateTime.now();
    id = '${now.millisecondsSinceEpoch}';
  }

  Task copyWith({
    String? id,
    String? text,
    Importance? importance,
    bool? isDone,
    DateTime? deadline,
    Color? color,
    DateTime? createdAt,
    DateTime? changedAt,
    String? lastUpdatedBy,
  }) {
    return Task(
      id ?? this.id,
      text ?? this.text,
      importance ?? this.importance,
      isDone ?? this.isDone,
      deadline ?? this.deadline,
    );
  }
}
