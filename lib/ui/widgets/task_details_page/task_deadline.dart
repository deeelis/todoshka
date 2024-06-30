import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                const Text(
                  'Сделать до',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (active)
                  Text(
                    value != null
                        ? DateFormat('dd.MM.yyyy').format(value!)
                        : 'Не задано',
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
