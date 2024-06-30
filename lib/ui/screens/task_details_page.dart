import 'package:flutter/material.dart';
import 'package:todoshka/utils/logger.dart';

import '../../domain/models/task.dart';
import '../widgets/task_details_page/importance_dropdown.dart';
import '../widgets/task_details_page/task_deadline.dart';
import '../widgets/task_details_page/task_text_filed.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskDetailsPage extends StatefulWidget {
  const TaskDetailsPage({
    super.key,
    this.task,
    required this.onSave,
    this.onDelete,
  });

  final Task? task;

  final void Function(Task) onSave;
  final void Function(Task)? onDelete;
  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  late Task task =
      widget.task ?? getEmpty();

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
                widget.onSave(task);
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
              text: task.text,
              onChanged: (text) {
                task = task.editAndCopyWith(text: text);
              },
            ),
            const SizedBox(
              height: 28,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: ImportanceDropdown(
                value: task.importance,
                onChanged: (value) {
                  task = task.editAndCopyWith(importance: value);
                },
              ),
            ),
            const Divider(),
            TaskDeadline(
              value: task.deadline,
              onChanged: (deadline) {
                if (deadline == null) {
                  task = task.editAndCopyWith(deleteDeadline: true);
                } else {
                  task = task.editAndCopyWith(deadline: deadline);
                }
              },
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
                onPressed: widget.task != null
                    ? () {
                        widget.onDelete?.call(widget.task!);
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
