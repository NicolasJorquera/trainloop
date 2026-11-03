/// Rutas de la app. Las 4 pestañas viven en un StatefulShellRoute; el resto
/// se abre sobre ellas (sin barra inferior).
abstract final class Routes {
  static const home = '/home';
  static const train = '/train';
  static const history = '/history';
  static const progress = '/progress';
  static const settings = '/settings';

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
}
