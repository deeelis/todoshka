import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todoshka/utils/logger.dart';

import '../../domain/models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/home_page/new_task_card.dart';
import '../widgets/home_page/task_card.dart';

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
  final scrollController = ScrollController();
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  late ConfettiController _controllerDelete;
  late ConfettiController _controllerAdd;
  late ConfettiController _controllerDone;

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      AppLogger.error(e.toString());
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    if (_connectionStatus[0] == ConnectivityResult.none &&
        result[0] != ConnectivityResult.none) {
      await ref.read(taskStateProvider.notifier).synchronize();
    }
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  dispose() {
    _connectivitySubscription.cancel();
    _controllerAdd.dispose();
    _controllerDelete.dispose();
    _controllerDone.dispose();
    super.dispose();
  }

  @override
  void initState() {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _controllerDone = ConfettiController(duration: const Duration(seconds: 3));
    _controllerAdd = ConfettiController(duration: const Duration(seconds: 3));
    _controllerDelete =
        ConfettiController(duration: const Duration(seconds: 3));
    super.initState();
  }

  bool isVisible = false;

  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path
        ..lineTo(
          halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step),
        )
        ..lineTo(
          halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep),
        );
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    List<Task> items = ref.watch(taskStateProvider).valueOrNull ?? [];
    return Stack(
      children: [
        Scaffold(
          body: CustomScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                floating: true,
                pinned: true,
                delegate: _AppHeader(
                  completedTaskCount:
                      ref.read(taskStateProvider.notifier).countDoneTasks(),
                  isConnected: _connectionStatus[0] == ConnectivityResult.none
                      ? true
                      : false,
                  isVisible: isVisible ? true : false,
                  onChangeVisibility: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Card(
                  color: Theme.of(context).cardColor,
                  elevation: 2,
                  margin: const EdgeInsets.only(right: 16, left: 16),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      ListView.builder(
                        itemCount: items.length,
                        controller: scrollController,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          if ((isVisible && items[index].isDone)) {
                            return const SizedBox();
                          }
                          return TaskCard(
                            task: items[index],
                            controllerDone: _controllerDone,
                            controllerDelete: _controllerDelete,
                          );
                        },
                      ),
                      SingleChildScrollView(
                        child: NewTaskCard(
                          controllerAdd: _controllerAdd,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            key: const Key("add_task_floating_button"),
            shape: const CircleBorder(),
            onPressed: () {
              context.push("/add");
              FirebaseAnalytics.instance.logEvent(
                name: 'push',
                parameters: {
                  'pageFrom': 'home',
                  'pageTo': 'detailsPage',
                },
              );
  },
            child: const Icon(
              Icons.add,
              size: 35,
            ),
          ),
        ),
        ConfettiWidget(
          confettiController: _controllerAdd,
          blastDirectionality: BlastDirectionality.explosive,
          colors: const [
            Colors.yellow,
            Colors.pink,
            Colors.orange,
          ],
          createParticlePath: drawStar,
        ),
        ConfettiWidget(
          confettiController: _controllerDelete,
          blastDirectionality: BlastDirectionality.explosive,
          colors: const [
            Colors.red,
            Colors.purple,
          ],
          createParticlePath: drawStar,
        ),
        ConfettiWidget(
          confettiController: _controllerDone,
          blastDirectionality: BlastDirectionality.explosive,
          colors: const [
            Colors.green,
            Colors.orange,
          ],
          createParticlePath: drawStar,
        ),
      ],
    );
  }
}

class _AppHeader extends SliverPersistentHeaderDelegate {
  _AppHeader({
    required this.completedTaskCount,
    required this.isVisible,
    required this.onChangeVisibility,
    required this.isConnected,
  });

  final int completedTaskCount;
  bool isVisible;
  bool isConnected;
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
      color: Theme.of(context).scaffoldBackgroundColor,
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
                    Row(
                      children: [
                        isConnected
                            ? const Icon(Icons.wifi_off)
                            : const SizedBox(),
                        isConnected
                            ? const SizedBox(
                                width: 10,
                              )
                            : const SizedBox(),
                        Text(
                          AppLocalizations.of(context)!.myTasks,
                          style: TextStyle.lerp(
                            Theme.of(context).textTheme.headlineSmall,
                            Theme.of(context).textTheme.titleLarge,
                            progress,
                          ),
                        ),
                      ],
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
                    ),
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
