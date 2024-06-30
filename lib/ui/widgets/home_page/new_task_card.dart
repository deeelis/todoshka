import 'package:flutter/material.dart';

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
      Task task = Task.create(
        text: controller.text,
        importance: Importance.basic,
        isDone: false,
      );
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
      decoration: const InputDecoration(
        contentPadding:
            EdgeInsets.only(top: 14, bottom: 14, left: 52, right: 16),
        hintText: 'Новое',
        border: InputBorder.none,
      ),
    );
  }
}
