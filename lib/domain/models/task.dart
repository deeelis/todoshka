import 'dart:ui';

import 'package:todoshka/domain/models/importance.dart';

class Task {
  String id;
  String text;
  bool isDone;
  bool deadlineON;
  DateTime? deadline;
  Importance importance;
  String color;
  DateTime createdAt;
  DateTime changedAt;
  String lastUpdatedBy;

  Task(
    this.id,
    this.text,
    this.importance,
    this.isDone,
    this.deadlineON,
    this.deadline,
    this.color,
    this.createdAt,
    this.changedAt,
    this.lastUpdatedBy,
  );

  Task editAndCopyWith({
    String? text,
    Importance? importance,
    bool? isDone,
    bool? deadlineON,
    DateTime? deadline,
    Color? color,
    bool? deleteDeadline,
  }) {
    return Task(
      id,
      text ?? this.text,
      importance ?? this.importance,
      isDone ?? this.isDone,
      deleteDeadline ?? false ? false : deadlineON ?? this.deadlineON,
      deleteDeadline ?? false ? null : deadline ?? this.deadline,
      this.color,
      createdAt,
      DateTime.now(),
      lastUpdatedBy,
    );
  }
}

Task getEmpty() {
  return Task(
    "",
    "",
    Importance.basic,
    false,
    false,
    DateTime.now(),
    "",
    DateTime.now(),
    DateTime.now(),
    "1",
  );
}
