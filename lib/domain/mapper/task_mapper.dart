import '../../data/dto/task_dto.dart';
import '../models/importance.dart';
import '../models/task.dart';

class TaskMapper {
  TaskDto mapTaskToTaskDto(Task task) => TaskDto(
        task.id,
        task.text,
        mapImportanceToString(task.importance),
        task.isDone,
        task.deadlineON ? task.deadline?.millisecondsSinceEpoch : null,
        task.color,
        task.createdAt.millisecondsSinceEpoch,
        task.changedAt.millisecondsSinceEpoch,
        task.lastUpdatedBy,
      );

  Task mapTaskDtoToTask(TaskDto taskDto) => Task(
        taskDto.id,
        taskDto.text,
        mapStringToImportance(taskDto.importance),
        taskDto.done,
        (taskDto.deadline == null) ? false : true,
        (taskDto.deadline == null)
            ? DateTime.now()
            : DateTime.fromMillisecondsSinceEpoch(taskDto.deadline as int),
        taskDto.color,
        DateTime.fromMillisecondsSinceEpoch(taskDto.createdAt),
        DateTime.fromMillisecondsSinceEpoch(taskDto.changedAt),
        taskDto.lastUpdatedBy,
      );

  Importance mapStringToImportance(String importance) {
    switch (importance) {
      case "basic":
        return Importance.basic;
      case "low":
        return Importance.low;
      case "important":
        return Importance.important;
    }
    return Importance.basic;
  }

  String mapImportanceToString(Importance importance) {
    switch (importance) {
      case Importance.basic:
        return "basic";
      case Importance.low:
        return "low";
      case Importance.important:
        return "important";
    }
  }
}
