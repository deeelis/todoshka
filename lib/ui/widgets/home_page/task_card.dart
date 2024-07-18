import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:todoshka/ui/providers/task_provider.dart';
import 'package:todoshka/ui/widgets/home_page/task_checkbox.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/models/importance.dart';
import '../../../domain/models/task.dart';
import '../../../utils/logger.dart';

class TaskCard extends ConsumerStatefulWidget {
  const TaskCard({
    required this.task,
    super.key,
    required this.isVisible,
  });
  final Task task;
  final bool isVisible;

  @override
  ConsumerState<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends ConsumerState<TaskCard> {
  ValueNotifier<double> startToEndNotifier = ValueNotifier<double>(1);
  ValueNotifier<double> endToStartNotifier = ValueNotifier<double>(1);

  void onUpdate(details) {
    if (details.direction == DismissDirection.startToEnd) {
      startToEndNotifier.value = details.progress;
    } else {
      endToStartNotifier.value = details.progress;
    }
  }

  void onDismissed(direction) {
    ref.read(taskStateProvider.notifier).deleteTask(widget.task);
  }

  Future<bool> confirmDismiss(direction) async {
    switch (direction) {
      case DismissDirection.endToStart:
        return true;

      case DismissDirection.startToEnd:
        await Future.delayed(const Duration(milliseconds: 200));
        ref.read(taskStateProvider.notifier).markDoneOrNot(widget.task, true);
    }
    return false;
  }

  void changeDone() {
    setState(() {
      ref
          .read(taskStateProvider.notifier)
          .markDoneOrNot(widget.task, !widget.task.isDone);
    });
  }

  void toDetailsPage() {
    AppLogger.debug("pushed to detailed page");
    context.push("/edit/${widget.task.id}");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toDetailsPage,
      child: Dismissible(
        key: UniqueKey(),
        dismissThresholds: const {DismissDirection.startToEnd: 0.3},
        onUpdate: onUpdate,
        onDismissed: onDismissed,
        confirmDismiss: confirmDismiss,
        background: const ColoredBox(
          color: Colors.green,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(Icons.done, color: Colors.white),
            ),
          ),
        ),
        secondaryBackground: const ColoredBox(
          color: Colors.red,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TaskCheckbox(
              isDone: widget.task.isDone,
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
                        style: widget.task.isDone
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
                  if (widget.task.deadlineON)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        DateFormat(
                          'dd MMMM yyyy',
                          AppLocalizations.of(context)?.locale,
                        ).format(widget.task.deadline!),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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
