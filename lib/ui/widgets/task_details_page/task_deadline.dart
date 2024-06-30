import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskDeadline extends StatefulWidget {
  const TaskDeadline({
    super.key,
    this.value,
    required this.onChanged,
  });

  final DateTime? value;

  final Function(DateTime?) onChanged;
  @override
  State<TaskDeadline> createState() => _TaskDeadlineState();
}

class _TaskDeadlineState extends State<TaskDeadline> {
  late DateTime? value = widget.value;

  late bool active = widget.value != null;
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: active
              ? () async {
                  var date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() {
                      value = date;
                      widget.onChanged(value);
                    });
                  }
                }
              : null,
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
                if (active)
                  Text(
                    value != null
                        ? DateFormat('dd.MM.yyyy').format(value!)
                        : '',
                    style: textTheme.bodyMedium!.copyWith(
                      color: value != null
                          ? Colors.blue
                          : textTheme.bodySmall!.color,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const Spacer(),
        Switch(
          value: active,
          onChanged: (value) {
            setState(() {
              active = value;
            });

            if (value) {
              widget.onChanged(this.value);
            } else {
              widget.onChanged(null);
            }
          },
        ),
      ],
    );
  }
}
