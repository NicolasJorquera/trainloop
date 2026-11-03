import 'package:drift/drift.dart';

import '../../../core/units/weight_unit.dart';
import '../app_database.dart';
import '../converters.dart';
import '../enums.dart';
import '../tables.dart';

part 'exercises_dao.g.dart';

/// Biblioteca de ejercicios.
@DriftAccessor(tables: [Exercises])
class ExercisesDao extends DatabaseAccessor<AppDatabase>
    with _$ExercisesDaoMixin {
  ExercisesDao(super.attachedDatabase);

  /// Inserta y devuelve el id. Calcula el nombre normalizado y los gramos
  /// del incremento.
  Future<String> create({
    required String name,
    required ExerciseLogType logType,
    required Muscle primaryMuscle,
    Equipment? equipment,
    double? incrementValue,
    WeightUnit? incrementUnit,
    int? defaultRestSeconds,
    bool isCustom = true,
    String? catalogKey,
  }) async {
    final row = await into(exercises).insertReturning(
      _derive(
        ExercisesCompanion.insert(
          name: name,
          normalizedName: normalizeName(name),
          logType: logType,
          primaryMuscle: primaryMuscle,
          equipment: Value(equipment),
          incrementValue: Value(incrementValue),
          incrementUnit: Value(incrementUnit),
          defaultRestSeconds: Value(defaultRestSeconds),
          isCustom: Value(isCustom),
          catalogKey: Value(catalogKey),
        ),
      ),
    );
    return row.id;
  }

  Future<void> edit(String id, ExercisesCompanion changes) =>
      (update(exercises)..where((t) => t.id.equals(id))).write(
        _derive(changes).copyWith(updatedAt: Value(nowUtc())),
      );

  Future<void> archive(String id) =>
      (update(exercises)..where((t) => t.id.equals(id))).write(
        ExercisesCompanion(
          archivedAt: Value(nowUtc()),
          updatedAt: Value(nowUtc()),
        ),
      );

  /// Inserta varios de una vez; omite los que repiten una clave de catálogo.
  Future<void> insertAllOrIgnore(List<ExercisesCompanion> rows) => batch(
    (b) => b.insertAll(
      exercises,
      rows.map(_derive),
      mode: InsertMode.insertOrIgnore,
    ),
  );

  /// Claves de catálogo ya presentes, incluidas las archivadas.
  Future<Set<String>> catalogKeys() async {
    final query = selectOnly(exercises)
      ..addColumns([exercises.catalogKey])
      ..where(exercises.catalogKey.isNotNull());
    return {
      for (final row in await query.get()) row.read(exercises.catalogKey)!,
    };
  }

  Future<Exercise?> findByCatalogKey(String key) => (select(
    exercises,
  )..where((t) => t.catalogKey.equals(key))).getSingleOrNull();

  Future<Exercise?> findById(String id) =>
      (select(exercises)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Ejercicios activos con el mismo nombre normalizado (duplicados).
  Future<List<Exercise>> findByName(String name) =>
      (select(exercises)..where(
            (t) =>
                t.normalizedName.equals(normalizeName(name)) &
                t.archivedAt.isNull(),
          ))
          .get();

  /// Ejercicios activos por nombre, opcionalmente de un músculo.
  Stream<List<Exercise>> watchActive({Muscle? muscle}) {
    final query = select(exercises)
      ..where((t) {
        final active = t.archivedAt.isNull();
        return muscle == null
            ? active
            : active & t.primaryMuscle.equalsValue(muscle);
      })
      ..orderBy([(t) => OrderingTerm.asc(t.normalizedName)]);
    return query.watch();
  }

  ExercisesCompanion _derive(ExercisesCompanion c) {
    var out = c;
    if (c.name.present) {
      out = out.copyWith(normalizedName: Value(normalizeName(c.name.value)));
    }
    if (c.incrementValue.present || c.incrementUnit.present) {
      final value = c.incrementValue.present ? c.incrementValue.value : null;
      final unit = c.incrementUnit.present ? c.incrementUnit.value : null;
      out = out.copyWith(
        incrementGrams: Value(
          value != null && unit != null ? unit.toGrams(value) : null,
        ),
      );
    }
    return out;
  }
}

const _folding = {
  'á': 'a', 'à': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', //
  'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e', //
  'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i', //
  'ó': 'o', 'ò': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o', //
  'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u', //
  'ñ': 'n', 'ç': 'c',
};

/// Minúsculas, sin tildes y con un solo espacio entre palabras.
String normalizeName(String name) => name
    .trim()
    .toLowerCase()
    .split('')
    .map((ch) => _folding[ch] ?? ch)
    .join()
    .replaceAll(RegExp(r'\s+'), ' ');
