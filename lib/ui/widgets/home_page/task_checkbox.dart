import 'package:flutter/material.dart';

import '../../../domain/models/importance.dart';
import '../../../domain/models/task.dart';

class TaskCheckbox extends StatefulWidget {
  const TaskCheckbox({
    super.key,
    required this.task,
    required this.onChanged,
    required this.isDone,
  });

  final Task task;
  final bool isDone;
  final void Function() onChanged;
  @override
  State<TaskCheckbox> createState() => _TaskCheckboxState();
}

class _TaskCheckboxState extends State<TaskCheckbox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged();
      },
      child: Container(
        height: 48,
        width: 48,
        color: Colors.transparent,
        padding: const EdgeInsets.all(17),
        child: ColoredBox(
          color:
              !widget.isDone && widget.task.importance == Importance.important
                  ? Colors.red.withOpacity(0.16)
                  : Colors.transparent,
          child: Checkbox(
            side: BorderSide(
              color: !widget.isDone &&
                      widget.task.importance == Importance.important
                  ? Colors.red
                  : Colors.grey,
              width: 2,
            ),
            value: widget.isDone,
            activeColor: Colors.green,
            fillColor:
                !widget.isDone && widget.task.importance == Importance.important
                    ? MaterialStateProperty.all(Colors.red.withOpacity(0.16))
                    : null,
            onChanged: (_) {
              widget.onChanged();
            },
          ),
        ),
      ),
    );
  }
}
