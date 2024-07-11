import 'package:go_router/go_router.dart';
import 'package:todoshka/domain/models/task.dart';
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
            builder: (context, state) => TaskDetailsPage(id: state.pathParameters["id"]),
            ),
          GoRoute(
            path: 'add',
            builder: (context, state) => const TaskDetailsPage(),
          ),
        ],
      ),
    ],
    onException: (context, state, router) => const HomePage(),
  );

  static GoRouter get goRouter => _goRouter;
}