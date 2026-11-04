import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_shell.dart';
import '../../features/exercises/presentation/exercise_form_screen.dart';
import '../../features/exercises/presentation/exercise_library_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/history/presentation/session_detail_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/intervals/presentation/interval_detail_screen.dart';
import '../../features/intervals/presentation/interval_editor_screen.dart';
import '../../features/intervals/presentation/session_summary_screen.dart';
import '../../features/intervals/presentation/timer_screen.dart';
import '../../features/progress/presentation/exercise_detail_screen.dart';
import '../../features/progress/presentation/progress_screen.dart';
import '../../features/routines/presentation/routine_editor_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/strength/presentation/strength_session_screen.dart';
import '../../features/strength/presentation/strength_summary_screen.dart';
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
                pageBuilder: (context, state) => NoTransitionPage(
                  child: TrainScreen(
                    showRoutines:
                        state.uri.queryParameters['kind'] == 'routines',
                  ),
                ),
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
        path: Routes.intervalNew,
        parentNavigatorKey: rootKey,
        builder: (context, state) => IntervalEditorScreen(
          templateKey: state.uri.queryParameters['template'],
        ),
      ),
      GoRoute(
        path: '/intervals/:id',
        parentNavigatorKey: rootKey,
        builder: (context, state) =>
            IntervalDetailScreen(workoutId: state.pathParameters['id']),
        routes: [
          GoRoute(
            path: 'edit',
            parentNavigatorKey: rootKey,
            builder: (context, state) =>
                IntervalEditorScreen(workoutId: state.pathParameters['id']),
          ),
        ],
      ),
      GoRoute(
        path: '/templates/:key',
        parentNavigatorKey: rootKey,
        builder: (context, state) =>
            IntervalDetailScreen(templateKey: state.pathParameters['key']),
      ),
      GoRoute(
        path: Routes.timer,
        parentNavigatorKey: rootKey,
        builder: (context, state) => const TimerScreen(),
      ),
      GoRoute(
        path: '/sessions/:id/summary',
        parentNavigatorKey: rootKey,
        builder: (context, state) =>
            SessionSummaryScreen(sessionId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.strength,
        parentNavigatorKey: rootKey,
        builder: (context, state) => const StrengthSessionScreen(),
      ),
      GoRoute(
        path: '/strength/:id/summary',
        parentNavigatorKey: rootKey,
        builder: (context, state) =>
            StrengthSummaryScreen(sessionId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/history/:id',
        parentNavigatorKey: rootKey,
        builder: (context, state) =>
            SessionDetailScreen(sessionId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/progress/exercises/:id',
        parentNavigatorKey: rootKey,
        builder: (context, state) =>
            ExerciseDetailScreen(exerciseId: state.pathParameters['id']!),
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
