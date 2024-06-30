import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/models/importance.dart';
import '../../../domain/models/task.dart';

class NewTaskCard extends StatelessWidget {
  NewTaskCard({super.key, required this.onAdd});

  final Function(Task) onAdd;

  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  void onEditingComplete() {
    focusNode.unfocus();
    if (controller.text.isNotEmpty) {
      Task task = getEmpty();
      task.text = controller.text;
      task.importance = Importance.basic;
      task.isDone = false;
      onAdd(task);
    }
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return TextField(
      focusNode: focusNode,
      controller: controller,
      maxLines: null,
      textInputAction: TextInputAction.done,
      onEditingComplete: onEditingComplete,
      style: textTheme.bodyMedium,
      decoration: InputDecoration(
        contentPadding:
            EdgeInsets.only(top: 14, bottom: 14, left: 52, right: 16),
        hintText: AppLocalizations.of(context)?.newTask,
        border: InputBorder.none,
      ),
    );
  }
}
