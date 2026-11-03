import '../../../data/db/enums.dart';

/// Nodo de un entrenamiento de intervalos (R-I1): un intervalo con duración
/// o una repetición que repite a sus hijos.
sealed class IntervalNode {
  const IntervalNode();
}

/// Intervalo: tipo, etiqueta opcional y duración (1 s a 99:59, R-I3).
class IntervalStep extends IntervalNode {
  const IntervalStep(this.type, this.seconds, {this.label});

  static const minSeconds = 1;
  static const maxSeconds = 99 * 60 + 59;

  /// Calentamiento, trabajo, descanso o vuelta a la calma (la preparación
  /// es un campo del entrenamiento).
  final PhaseType type;
  final int seconds;
  final String? label;

  IntervalStep copyWith({
    PhaseType? type,
    int? seconds,
    String? Function()? label,
  }) => IntervalStep(
    type ?? this.type,
    (seconds ?? this.seconds).clamp(minSeconds, maxSeconds),
    label: label != null ? label() : this.label,
  );

  @override
  bool operator ==(Object other) =>
      other is IntervalStep &&
      other.type == type &&
      other.seconds == seconds &&
      other.label == label;

  @override
  int get hashCode => Object.hash(type, seconds, label);
}

/// Repetición: 1–99 rondas de sus hijos. Puede omitir el descanso final de
/// la última ronda (activado por defecto, R-I4) y contener otra repetición
/// (máximo 2 niveles).
class IntervalRepeat extends IntervalNode {
  const IntervalRepeat(
    this.rounds,
    this.children, {
    this.skipLastRest = true,
    this.label,
  });

  static const minRounds = 1;
  static const maxRounds = 99;

  final int rounds;
  final List<IntervalNode> children;
  final bool skipLastRest;
  final String? label;

  IntervalRepeat copyWith({
    int? rounds,
    List<IntervalNode>? children,
    bool? skipLastRest,
  }) => IntervalRepeat(
    (rounds ?? this.rounds).clamp(minRounds, maxRounds),
    children ?? this.children,
    skipLastRest: skipLastRest ?? this.skipLastRest,
    label: label,
  );

  @override
  bool operator ==(Object other) =>
      other is IntervalRepeat &&
      other.rounds == rounds &&
      other.skipLastRest == skipLastRest &&
      other.label == label &&
      _listEquals(other.children, children);

  @override
  int get hashCode =>
      Object.hash(rounds, skipLastRest, label, Object.hashAll(children));
}

/// Problemas que impiden guardar o empezar (R-I3).
enum IntervalDraftError { noWork, emptyRepeat, tooLong, tooDeep }

/// Entrenamiento de intervalos en edición (S04). Inmutable: cada operación
/// devuelve una copia. Los nodos se ubican por su ruta de índices
/// (`[2]` = tercer bloque, `[2, 0]` = su primer hijo).
class IntervalWorkoutDraft {
  const IntervalWorkoutDraft({
    this.id,
    this.name = '',
    this.prepareSeconds = defaultPrepareSeconds,
    this.blocks = const [],
  });

  /// Bloques de un entrenamiento nuevo: trabajo + descanso × 8.
  factory IntervalWorkoutDraft.starter() => const IntervalWorkoutDraft(
    blocks: [
      IntervalRepeat(8, [
        IntervalStep(PhaseType.work, 20),
        IntervalStep(PhaseType.rest, 10),
      ]),
    ],
  );

  /// R-I5: preparación de 0 a 30 s, 10 por defecto.
  static const defaultPrepareSeconds = 10;
  static const maxPrepareSeconds = 30;

  /// R-I3: total ≤ 4 h; nombre de 1 a 40 caracteres.
  static const maxTotalSeconds = 4 * 3600;
  static const maxNameLength = 40;

  /// R-I1: una repetición puede contener otra, no más.
  static const maxDepth = 2;

  /// `null` mientras no se ha guardado.
  final String? id;
  final String name;
  final int prepareSeconds;
  final List<IntervalNode> blocks;

  IntervalWorkoutDraft rename(String name) => _copy(name: name);

  IntervalWorkoutDraft withPrepare(int seconds) =>
      _copy(prepareSeconds: seconds.clamp(0, maxPrepareSeconds));

  IntervalNode nodeAt(List<int> path) {
    var nodes = blocks;
    late IntervalNode node;
    for (final i in path) {
      node = nodes[i];
      if (node is IntervalRepeat) nodes = node.children;
    }
    return node;
  }

  /// Reemplaza el nodo de [path].
  IntervalWorkoutDraft replaceAt(List<int> path, IntervalNode node) =>
      _copy(blocks: _edit(blocks, path, (list, i) => list..[i] = node));

  IntervalWorkoutDraft removeAt(List<int> path) =>
      _copy(blocks: _edit(blocks, path, (list, i) => list..removeAt(i)));

  /// Agrega [node] al final de la repetición [parent] (`null` = primer nivel).
  IntervalWorkoutDraft append(List<int>? parent, IntervalNode node) {
    if (parent == null) return _copy(blocks: [...blocks, node]);
    final repeat = nodeAt(parent) as IntervalRepeat;
    return replaceAt(
      parent,
      repeat.copyWith(children: [...repeat.children, node]),
    );
  }

  /// Mueve el nodo de [path] una posición hacia arriba (-1) o abajo (+1)
  /// dentro de su lista.
  IntervalWorkoutDraft move(List<int> path, int delta) => _copy(
    blocks: _edit(blocks, path, (list, i) {
      final j = i + delta;
      if (j < 0 || j >= list.length) return list;
      final node = list.removeAt(i);
      return list..insert(j, node);
    }),
  );

  /// Profundidad de repeticiones en [path] (0 = primer nivel).
  int depthOf(List<int>? parent) => parent?.length ?? 0;

  List<IntervalDraftError> get errors {
    final errors = <IntervalDraftError>[];
    var work = false;
    var empty = false;
    var deep = false;
    void walk(List<IntervalNode> nodes, int depth) {
      for (final n in nodes) {
        switch (n) {
          case IntervalStep(:final type):
            if (type == PhaseType.work) work = true;
          case IntervalRepeat(:final children):
            if (children.isEmpty) empty = true;
            if (depth + 1 > maxDepth) deep = true;
            walk(children, depth + 1);
        }
      }
    }

    walk(blocks, 0);
    if (!work) errors.add(IntervalDraftError.noWork);
    if (empty) errors.add(IntervalDraftError.emptyRepeat);
    if (deep) errors.add(IntervalDraftError.tooDeep);
    if (_totalSeconds(this) > maxTotalSeconds) {
      errors.add(IntervalDraftError.tooLong);
    }
    return errors;
  }

  bool get canSave => errors.isEmpty;

  IntervalWorkoutDraft _copy({
    String? name,
    int? prepareSeconds,
    List<IntervalNode>? blocks,
  }) => IntervalWorkoutDraft(
    id: id,
    name: name ?? this.name,
    prepareSeconds: prepareSeconds ?? this.prepareSeconds,
    blocks: blocks ?? this.blocks,
  );

  /// Aplica [op] a la lista que contiene el último índice de [path].
  static List<IntervalNode> _edit(
    List<IntervalNode> nodes,
    List<int> path,
    List<IntervalNode> Function(List<IntervalNode> list, int index) op,
  ) {
    final list = [...nodes];
    if (path.length == 1) return op(list, path.first);
    final repeat = list[path.first] as IntervalRepeat;
    list[path.first] = repeat.copyWith(
      children: _edit(repeat.children, path.sublist(1), op),
    );
    return list;
  }
}

/// Total en segundos sin expandir (para validar sin crear las fases).
int _totalSeconds(IntervalWorkoutDraft d) => d.prepareSeconds + _sum(d.blocks);

int _sum(List<IntervalNode> nodes) => nodes.fold(
  0,
  (t, n) =>
      t +
      switch (n) {
        IntervalStep(:final seconds) => seconds,
        IntervalRepeat() => repeatSeconds(n),
      },
);

/// Duración de una repetición, con el descanso final omitido si corresponde.
int repeatSeconds(IntervalRepeat r) =>
    _sum(r.children) * (r.rounds - 1) + _sum(lastRoundChildren(r));

/// Hijos de la última ronda: sin los descansos finales si la repetición
/// omite el último descanso (R-I4).
List<IntervalNode> lastRoundChildren(IntervalRepeat r) {
  if (!r.skipLastRest) return r.children;
  final list = [...r.children];
  while (list.isNotEmpty &&
      list.last is IntervalStep &&
      (list.last as IntervalStep).type == PhaseType.rest) {
    list.removeLast();
  }
  return list;
}

bool _listEquals(List<IntervalNode> a, List<IntervalNode> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
