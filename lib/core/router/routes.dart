/// Rutas de la app. Las 4 pestañas viven en un StatefulShellRoute; el resto
/// se abre sobre ellas (sin barra inferior).
abstract final class Routes {
  static const home = '/home';
  static const train = '/train';
  static const history = '/history';
  static const progress = '/progress';
  static const settings = '/settings';

  /// S17 Respaldo y exportación.
  static const backup = '/settings/backup';

  static const routineNew = '/routines/new';
  static String routineEdit(String id) => '/routines/$id';

  /// Biblioteca. Con [pick] permite elegir varios y los devuelve al cerrar.
  static const exercises = '/exercises';
  static const exercisesPick = '/exercises?pick=1';

  /// Ejercicio propio nuevo, opcionalmente con un nombre inicial.
  static String exerciseNew([String name = '']) => name.isEmpty
      ? '/exercises/new'
      : '/exercises/new?name=${Uri.encodeQueryComponent(name)}';
  static String exerciseEdit(String id) => '/exercises/$id';

  /// Intervalos (D4). Editor nuevo, opcionalmente a partir de una plantilla.
  static const intervalNew = '/intervals/new';
  static String intervalNewFromTemplate(String key) =>
      '/intervals/new?template=$key';
  static String intervalDetail(String id) => '/intervals/$id';
  static String intervalEdit(String id) => '/intervals/$id/edit';
  static String templateDetail(String key) => '/templates/$key';

  /// Sesión en curso (S05) y su resumen (S06).
  static const timer = '/timer';
  static String sessionSummary(String id) => '/sessions/$id/summary';

  /// Sesión de fuerza en curso (S10) y su resumen (S06, variante fuerza).
  static const strength = '/strength';
  static String strengthSummary(String id) => '/strength/$id/summary';

  /// Detalle de una sesión del historial (S13).
  static String sessionDetail(String id) => '/history/$id';

  /// Detalle de un ejercicio en Progreso (S15).
  static String exerciseProgress(String id) => '/progress/exercises/$id';

  /// Entrenar con la vista de fuerza (rutinas).
  static const trainRoutines = '/train?kind=routines';

  /// Entrenar con la vista de intervalos (temporizadores).
  static const trainIntervals = '/train?kind=intervals';
}
