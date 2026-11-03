import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_shell.dart';
import '../../features/exercises/presentation/exercise_form_screen.dart';
import '../../features/exercises/presentation/exercise_library_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/progress/presentation/progress_screen.dart';
import '../../features/routines/presentation/routine_editor_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/train/presentation/train_screen.dart';
import 'routes.dart';

/// Router único de la app. No depende de las preferencias: cambiar tema,
/// acento o idioma repinta sin perder la pila de navegación.
final routerProvider = Provider<GoRouter>((ref) {
  final rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  final router = GoRouter(
    navigatorKey: rootKey,
    initialLocation: Routes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: HomeScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.train,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: TrainScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.history,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: HistoryScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.progress,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ProgressScreen()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: Routes.settings,
        parentNavigatorKey: rootKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: Routes.routineNew,
        parentNavigatorKey: rootKey,
        builder: (context, state) => const RoutineEditorScreen(),
      ),
      GoRoute(
        path: '/routines/:id',
        parentNavigatorKey: rootKey,
        builder: (context, state) =>
            RoutineEditorScreen(routineId: state.pathParameters['id']),
      ),
      GoRoute(
        path: Routes.exercises,
        parentNavigatorKey: rootKey,
        builder: (context, state) => ExerciseLibraryScreen(
          pick: state.uri.queryParameters['pick'] == '1',
        ),
        routes: [
          GoRoute(
            path: 'new',
            parentNavigatorKey: rootKey,
            builder: (context, state) => ExerciseFormScreen(
              initialName: state.uri.queryParameters['name'] ?? '',
            ),
          ),
          GoRoute(
            path: ':id',
            parentNavigatorKey: rootKey,
            builder: (context, state) =>
                ExerciseFormScreen(exerciseId: state.pathParameters['id']),
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
