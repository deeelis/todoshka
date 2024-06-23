import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:todoshka/ui/widgets/home_page/task_checkbox.dart';

import '../../../domain/models/importance.dart';
import '../../../domain/models/task.dart';
import '../../../utils/logger.dart';
import '../../screens/task_details_page.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    required this.task,
    required this.onDelete,
    required this.onEdit(task),
    super.key,
    required this.isVisible,
  });
  final Task task;
  final Function(Task) onDelete;
  final Function(Task) onEdit;
  final bool isVisible;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late bool isDone = widget.task.isDone;

  ValueNotifier<double> startToEndNotifier = ValueNotifier<double>(0);
  ValueNotifier<double> endToStartNotifier = ValueNotifier<double>(0);

  void onUpdate(details) {
    if (details.direction == DismissDirection.startToEnd) {
      startToEndNotifier.value = details.progress;
    } else {
      endToStartNotifier.value = details.progress;
    }
  }

  void onDismissed(_) => widget.onDelete(widget.task);

  Future<bool> confirmDismiss(direction) async {
    switch (direction) {
      case DismissDirection.endToStart:
        return true;

      case DismissDirection.startToEnd:
        await Future.delayed(const Duration(milliseconds: 200));
        changeDone(true);
    }
    return false;
  }

  void changeDone(bool value) {
    setState(() {
      isDone = value;
      widget.onEdit(widget.task.editAndCopyWith(isDone: value));
    });
  }

  void toDetailsPage() {
    AppLogger.debug("pushed to detailed page");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsPage(
          task: widget.task,
          onSave: widget.onEdit,
          onDelete: widget.onDelete,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isVisible && widget.task.isDone) {
      return const SizedBox();
    } else {
      return GestureDetector(
        onTap: toDetailsPage,
        child: Dismissible(
          key: ValueKey(widget.task.id),
          onUpdate: onUpdate,
          onDismissed: onDismissed,
          confirmDismiss: confirmDismiss,
          background: Container(
            color: Colors.green,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ValueListenableBuilder(
                  valueListenable: startToEndNotifier,
                  builder: (BuildContext context, double value, Widget? child) {
                    return DismissIcon(
                      direction: DismissDirection.startToEnd,
                      progress: value,
                      icon: const Icon(Icons.check, color: Colors.white),
                    );
                  },
                ),
              ],
            ),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ValueListenableBuilder(
                  valueListenable: endToStartNotifier,
                  builder: (BuildContext context, double value, Widget? child) {
                    return DismissIcon(
                      direction: DismissDirection.endToStart,
                      progress: value,
                      icon: const Icon(Icons.delete, color: Colors.white),
                    );
                  },
                ),
              ],
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TaskCheckbox(
                isDone: isDone,
                task: widget.task,
                onChanged: changeDone,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: RichText(
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: isDone
                              ? const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.lineThrough,
                                )
                              : Theme.of(context).textTheme.bodyLarge,
                          children: [
                            if (widget.task.importance != Importance.basic)
                              WidgetSpan(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 3),
                                  child: widget.task.importance ==
                                          Importance.important
                                      ? SvgPicture.asset('assets/important.svg')
                                      : SvgPicture.asset('assets/low.svg'),
                                ),
                              ),
                            TextSpan(
                              text: widget.task.text,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (widget.task.deadline != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          DateFormat('dd.MM.yyyy')
                              .format(widget.task.deadline!),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 14, right: 18),
                child: IconButton(
                  onPressed: toDetailsPage,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.info_outline,
                    color: Color(0x4d000000),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class DismissIcon extends StatefulWidget {
  const DismissIcon({
    super.key,
    required this.direction,
    required this.progress,
    required this.icon,
  });

  final DismissDirection direction;
  final double progress;
  final Widget icon;
  @override
  State<DismissIcon> createState() => DismissIconState();
}

class DismissIconState extends State<DismissIcon> {
  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).size.width * widget.progress - 47;
    return Padding(
      padding: EdgeInsets.only(
        left: widget.direction == DismissDirection.startToEnd
            ? padding > 33
                ? padding - 9
                : 24
            : 0,
        right: widget.direction == DismissDirection.endToStart
            ? padding > 33
                ? padding - 9
                : 24
            : 0,
      ),
      child: widget.icon,
    );
  }
}
