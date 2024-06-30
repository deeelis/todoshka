import 'package:flutter/material.dart';
import 'package:todoshka/ui/widgets/home_page/task_card.dart';
import 'package:todoshka/utils/logger.dart';

import '../../../domain/models/task.dart';
import 'new_task_card.dart';

class TaskList extends StatefulWidget {
  const TaskList({required this.tasks, super.key, required this.isVisible, required this.add, required this.delete});

  final void Function(Task) add;
  final void Function(Task)? delete;
  final List<Task> tasks;
  final bool isVisible;

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  void initState() {
    super.initState();
  }

  void onChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 2,
      margin: const EdgeInsets.only(right: 16, left: 16),
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          for (int index = 0; index < widget.tasks.length; index++)
            TaskCard(
              task: widget.tasks[index],
              onDelete: (task) {
                setState(() {
                  widget.delete!(task);
                  AppLogger.debug(task.id);
                });
              },
              onEdit: (task) {
                setState(() {
                  widget.add(task);
                  AppLogger.debug(task.id);
                });
              },
              isVisible: widget.isVisible,
            ),
          NewTaskCard(
            onAdd: (task) {
              setState(() {
                widget.add(task);
              });
            },
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
