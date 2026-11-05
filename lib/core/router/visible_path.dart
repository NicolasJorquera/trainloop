import 'package:go_router/go_router.dart';

/// Ruta de la pantalla de arriba de [list].
///
/// Con `push`, go_router deja `RouteMatchList.uri` en la ruta de abajo: la
/// visible es la de la última ruta apilada.
String visiblePath(RouteMatchList list) {
  if (list.isEmpty) return '';
  final last = list.last;
  if (last is ImperativeRouteMatch) return visiblePath(last.matches);
  return list.uri.path;
}

/// Ruta de la pantalla visible de [router].
String visiblePathOf(GoRouter router) =>
    visiblePath(router.routerDelegate.currentConfiguration);
