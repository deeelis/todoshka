import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoshka/ui/screens/task_details_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/home_page/task_list.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  static const collapsedBarHeight = 60.0;
  static const expandedBarHeight = 400.0;
  late List<Task> tasks;

  @override
  void initState() {
    super.initState();
  }


  int countDone(List<Task> list) {
    int count = list.where((item) => item.isDone).length;
    return count;
  }

  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    List<Task> items = ref.watch(taskStateProvider).valueOrNull ?? [];
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            floating: true,
            pinned: true,
            delegate: _AppHeader(
                completedTaskCount: countDone(items),
                isVisible: isVisible ? true : false,
                onChangeVisibility: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                }),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                TaskList(
                  key: const Key('taskList'),
                  tasks: tasks,
                  isVisible: isVisible,
                  add: (task) {
                    setState(() {
                      ref.read(taskStateProvider.notifier).addOrEditAction(task);
                    });
                  },
                  delete: (task) {
                    setState(() {
                      ref.read(taskStateProvider.notifier).deleteAction(task);
                    });
                  },

                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailsPage(
                task: null,
                onSave: (task) {
                  setState(() {
                    ref.read(taskStateProvider.notifier).addOrEditAction(task);
                  });
                },
                onDelete: (task) {
                  setState(() {
                    ref.read(taskStateProvider.notifier).deleteAction(task);
                  });
                },
              ),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          size: 35,
        ),
      ),
    );
  }
}

class _AppHeader extends SliverPersistentHeaderDelegate {
  _AppHeader({
    required this.completedTaskCount,
    required this.isVisible,
    required this.onChangeVisibility,
  });

  final int completedTaskCount;
  bool isVisible;
  final Function() onChangeVisibility;

  final double expandedElevation = 0;
  final double collapsedElevation = 8;

  final double statusBarHeight = 0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final offset = min(shrinkOffset, maxExtent - minExtent);
    final progress = offset / (maxExtent - minExtent);


    return Material(

      color: Colors.transparent,
      elevation: progress < 1 ? expandedElevation : collapsedElevation,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.fromLTRB(
          16,
          0,
          16,
          8,
        ),
        alignment: Alignment.bottomLeft,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.lerp(
                const EdgeInsets.symmetric(horizontal: 44),
                EdgeInsets.zero,
                progress,
              )!,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.myTasks,
                      style: TextStyle.lerp(
                        Theme.of(context).textTheme.headlineSmall,
                        Theme.of(context).textTheme.titleLarge,
                        progress,
                      ),
                    ),
                    SizedBox(
                      height: (28 * (1 - progress)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: progress < 0.2 ? 1 : 0,
                          child: Text(
                            '${AppLocalizations.of(context)!.completed} - $completedTaskCount',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.grey,
                                    ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onChangeVisibility,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    isVisible ? Icons.visibility_off : Icons.visibility,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 184;

  @override
  double get minExtent => 85;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
