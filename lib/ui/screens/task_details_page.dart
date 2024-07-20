import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
    this.id,
  });

  final String? id;
  @override
  ConsumerState<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends ConsumerState<TaskDetailsPage> {
  late Task task;
  late bool first;
  @override
  void initState() {
    first = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Task> list = ref.watch(taskStateProvider).value ?? [];
    if (first) {
      task = list.firstWhere(
        (item) => item.id == widget.id,
        orElse: () => getEmpty(),
      );
      first = false;
    }
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
              FirebaseAnalytics.instance.logEvent(
                name: 'pop',
                parameters: {
                  'pageFrom': 'detailsPage',
                  'pageTo': 'home',
                },
              );
              context.pop();
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
              key: const Key("save_button"),
              onPressed: () {
                AppLogger.debug("task saved");
                ref.read(taskStateProvider.notifier).addOrEditTask(task);
                FirebaseAnalytics.instance.logEvent(
                  name: 'add',
                  parameters: {
                    'taskId': task.id,
                  },
                );
                FirebaseAnalytics.instance.logEvent(
                  name: 'pop',
                  parameters: {
                    'pageFrom': 'detailsPage',
                    'pageTo': 'home',
                  },
                );
                context.pop();
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
        child: ListView(
          children: [
            TaskTextField(
              text: task.text,
              onChanged: (text) {
                task.text = text;
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
                    ),
                  ),
                  SizedBox(
                    width: 164,
                    child: ButtonTheme(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Importance>(
                          value: task.importance,
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
                                task.importance = value;
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
                      lastDate:
                          DateTime.now().add(const Duration(days: 365 * 1000)),
                    );
                    if (date != null) {
                      setState(() {
                        task
                          ..deadline = date
                          ..deadlineON = true;
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
                        if (task.deadlineON)
                          Text(
                            task.deadlineON
                                ? DateFormat(
                                    'dd MMMM yyyy',
                                    AppLocalizations.of(context)?.locale,
                                  ).format(task.deadline!)
                                : '',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: task.deadlineON
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
                  value: task.deadlineON,
                  onChanged: (value) {
                    setState(() {
                      task.deadlineON = !task.deadlineON;
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
                  color: task.id.isNotEmpty
                      ? Colors.red
                      : Colors.grey.withOpacity(0.5),
                ),
                label: Text(
                  AppLocalizations.of(context)!.delete,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: task.id.isNotEmpty
                        ? Colors.red
                        : Colors.grey.withOpacity(0.5),
                  ),
                ),
                onPressed: task.id.isNotEmpty
                    ? () {
                        ref.read(taskStateProvider.notifier).deleteTask(task);
                        FirebaseAnalytics.instance.logEvent(
                          name: 'delete',
                          parameters: {
                            'taskId': task.id,
                          },
                        );
                        FirebaseAnalytics.instance.logEvent(
                          name: 'pop',
                          parameters: {
                            'pageFrom': 'detailsPage',
                            'pageTo': 'home',
                          },
                        );
                        context.pop();
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
