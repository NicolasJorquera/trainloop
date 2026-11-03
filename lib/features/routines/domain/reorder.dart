/// Mueve el elemento de [oldIndex] a [newIndex] con la convención de
/// `ReorderableListView` (al bajar, [newIndex] cuenta el hueco que deja el
/// elemento). Devuelve una lista nueva.
List<T> reorderList<T>(List<T> items, int oldIndex, int newIndex) {
  final out = [...items];
  final target = newIndex > oldIndex ? newIndex - 1 : newIndex;
  out.insert(target, out.removeAt(oldIndex));
  return out;
}
