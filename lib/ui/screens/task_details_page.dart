import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todoshka/ui/providers/task_provider.dart';
import 'package:todoshka/utils/logger.dart';

import '../../domain/models/importance.dart';
import '../../domain/models/task.dart';
import '../widgets/task_details_page/task_text_filed.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String mapStringToImportance(Importance importance) {
  switch (importance) {
    case Importance.basic:
      return "base";
    case Importance.low:
      return "low";
    case Importance.important:
      return "high";
  }
}

class TaskDetailsPage extends ConsumerStatefulWidget {
  const TaskDetailsPage({
    super.key,
    required this.task,
  });

  final Task task;
  @override
  ConsumerState<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends ConsumerState<TaskDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 4,
        elevation: 0,
        leading: SizedBox(
          height: 14,
          width: 14,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: () {
                AppLogger.debug("task saved");
                ref.read(taskStateProvider.notifier).addOrEditTask(widget.task);
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: Text(
                AppLocalizations.of(context)!.save,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
        child: Column(
          children: [
            TaskTextField(
              text: widget.task.text,
              onChanged: (text) {
                widget.task.text = text;
              },
            ),
            const SizedBox(
              height: 28,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.importance,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 164,
                    child: ButtonTheme(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Importance>(
                          value: widget.task.importance,
                          icon: const SizedBox(),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(2)),
                          elevation: 3,
                          items: [
                            DropdownMenuItem<Importance>(
                              value: Importance.basic,
                              child: Text(
                                AppLocalizations.of(context)!.importanceBasic,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            DropdownMenuItem<Importance>(
                              value: Importance.low,
                              child: Text(
                                AppLocalizations.of(context)!.importanceLow,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            DropdownMenuItem<Importance>(
                              value: Importance.important,
                              child: Text(
                                AppLocalizations.of(context)!.importanceHigh,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                          onChanged: (Importance? value) {
                            if (value != null) {
                              setState(() {
                                AppLogger.info(mapStringToImportance(value));
                                widget.task.importance = value;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () async {
                    var date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      setState(() {
                        widget.task.deadline = date;
                        widget.task.deadlineON = true;
                      });
                    }
                  },
                  child: SizedBox(
                    height: 72,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.doUntil,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        if (widget.task.deadlineON)
                          Text(
                            widget.task.deadlineON
                                ? DateFormat('dd.MM.yyyy')
                                    .format(widget.task.deadline!)
                                : '',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: widget.task.deadlineON
                                      ? Colors.blue
                                      : Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .color,
                                ),
                          ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Switch(
                  value: widget.task.deadlineON,
                  onChanged: (value) {
                    setState(() {
                      widget.task.deadlineON = !widget.task.deadlineON;
                    });
                  },
                ),
              ],
            ),
            const Divider(),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: Icon(
                  Icons.delete,
                  color: Colors.grey.withOpacity(0.5),
                ),
                label: Text(
                  AppLocalizations.of(context)!.delete,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
                onPressed: widget.task.id.isNotEmpty
                    ? () {
                        ref
                            .read(taskStateProvider.notifier)
                            .deleteTask(widget.task);
                        Navigator.pop(context);
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
