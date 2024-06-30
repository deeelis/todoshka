import '../../data/dto/task_dto.dart';
import '../models/importance.dart';
import '../models/task.dart';

class TaskMapper {
  TaskDto mapTaskToTaskDto(Task task) => TaskDto(
    task.id,
    task.text,
    task.importance.toString(),
    task.isDone,
    task.deadlineON
        ? task.deadline?.millisecondsSinceEpoch
        : null,
    task.color,
    task.createdAt.millisecondsSinceEpoch,
    task.changedAt.millisecondsSinceEpoch,
    task.lastUpdatedBy,
  );

  Task mapTaskDtoToTask(TaskDto taskDto) => Task(
    taskDto.id,
    taskDto.text,
    taskDto.importance as Importance,
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
}