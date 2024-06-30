import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoshka/ui/providers/task_provider.dart';

import '../../../domain/models/importance.dart';
import '../../../domain/models/task.dart';

class NewTaskCard extends ConsumerWidget {
  NewTaskCard({
    super.key,
  });
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onEditingComplete() {
      focusNode.unfocus();
      if (controller.text.isNotEmpty) {
        Task task = getEmpty()
          ..text = controller.text
          ..importance = Importance.basic
          ..isDone = false;
        ref.read(taskStateProvider.notifier).addOrEditTask(task);
      }
    }

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
            const EdgeInsets.only(top: 14, bottom: 14, left: 52, right: 16),
        hintText: AppLocalizations.of(context)?.newTask,
        border: InputBorder.none,
      ),
    );
  }
}
