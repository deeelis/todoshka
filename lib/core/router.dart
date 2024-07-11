import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:todoshka/ui/screens/home_page.dart';
import 'package:todoshka/ui/screens/task_details_page.dart';

abstract class AppRouter {
  static final _goRouter = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: 'edit/:id',
            builder: (context, state) => TaskDetailsPage(
              id: state.pathParameters["id"],
              key: const Key("task_details_page"),
            ),
          ),
          GoRoute(
            path: 'add',
            builder: (context, state) => const TaskDetailsPage(
              key: Key("task_details_page"),
            ),
          ),
        ],
      ),
    ],
    onException: (context, state, router) => const HomePage(),
  );

  static GoRouter get goRouter => _goRouter;
}
