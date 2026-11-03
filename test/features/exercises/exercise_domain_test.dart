import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/data/catalog/exercise_catalog.dart';
import 'package:trainloop/data/catalog/exercise_catalog_seeder.dart';
import 'package:trainloop/data/db/app_database.dart';
import 'package:trainloop/data/db/daos/exercises_dao.dart';
import 'package:trainloop/data/db/enums.dart';
import 'package:trainloop/features/exercises/domain/exercise_filter.dart';
import 'package:trainloop/features/exercises/domain/exercise_names.dart';

import '../../helpers/test_database.dart';

const _es = Locale('es', '419');
const _en = Locale('en');

void main() {
  late AppDatabase db;
  late List<Exercise> library;

  setUp(() async {
    db = openTestDatabase();
    await seedExerciseCatalog(db.exercisesDao);
    await db.exercisesDao.create(
      name: 'Sentadilla Búlgara',
      logType: ExerciseLogType.weightReps,
      primaryMuscle: Muscle.quads,
      equipment: Equipment.dumbbell,
    );
    library = await db.exercisesDao.watchActive().first;
  });
  tearDown(() => db.close());

  Exercise byKey(String key) => library.firstWhere((e) => e.catalogKey == key);

  group('catálogo', () {
    test('unas 100 entradas con clave única y nombres en los 3 idiomas', () {
      expect(exerciseCatalog.length, inInclusiveRange(95, 130));
      expect(exerciseCatalogByKey, hasLength(exerciseCatalog.length));
      for (final e in exerciseCatalog) {
        expect(e.key, matches(RegExp(r'^[a-z0-9_]+$')));
        expect(e.allNames.every((n) => n.trim().isNotEmpty), isTrue);
      }
      // Hay cardio y ejercicios por tiempo, no solo peso + reps.
      expect(
        exerciseCatalog.map((e) => e.logType).toSet(),
        containsAll(ExerciseLogType.values),
      );
    });

    test('la siembra es idempotente y agrega solo las claves nuevas', () async {
      expect(await seedExerciseCatalog(db.exercisesDao), 0);
      const extra = CatalogExercise(
        'zz_new_move',
        Muscle.core,
        Equipment.bodyweight,
        'Nuevo',
        'New',
        'Novo',
      );
      final updated = [...exerciseCatalog, extra];
      expect(await seedExerciseCatalog(db.exercisesDao, catalog: updated), 1);
      expect(await seedExerciseCatalog(db.exercisesDao, catalog: updated), 0);
      final rows = await db.exercisesDao.watchActive().first;
      expect(rows.where((e) => !e.isCustom), hasLength(updated.length));
    });

    test('no revive un ejercicio incluido archivado', () async {
      await db.exercisesDao.archive(byKey('plank').id);
      expect(await seedExerciseCatalog(db.exercisesDao), 0);
    });
  });

  group('nombres', () {
    test('los incluidos se nombran según el idioma; los propios, literal', () {
      final bench = byKey('bench_press_barbell');
      expect(exerciseName(bench, _es), 'Press de banca con barra');
      expect(exerciseName(bench, _en), 'Barbell bench press');
      expect(
        exerciseName(bench, const Locale('pt', 'BR')),
        'Supino reto com barra',
      );
      expect(exerciseName(bench, const Locale('en', 'XA')), startsWith('['));
      final custom = library.firstWhere((e) => e.isCustom);
      expect(exerciseName(custom, _en), 'Sentadilla Búlgara');
    });

    test('normaliza mayúsculas, tildes y espacios', () {
      expect(normalizeName('  SENTADILLA   búlgara '), 'sentadilla bulgara');
    });
  });

  group('duplicados', () {
    test('detecta un propio con otra escritura', () {
      final dup = findDuplicateExercise('sentadilla  bulgara', library);
      expect(dup?.name, 'Sentadilla Búlgara');
    });

    test('detecta un incluido por su nombre en cualquier idioma', () {
      expect(findDuplicateExercise('plank', library)?.catalogKey, 'plank');
      expect(findDuplicateExercise('PLANCHA', library)?.catalogKey, 'plank');
      expect(
        findDuplicateExercise('Supino reto com barra', library)?.catalogKey,
        'bench_press_barbell',
      );
    });

    test('ignora el que se edita, los archivados y los nombres nuevos', () {
      final custom = library.firstWhere((e) => e.isCustom);
      expect(
        findDuplicateExercise(
          'Sentadilla búlgara',
          library,
          ignoreId: custom.id,
        ),
        isNull,
      );
      expect(findDuplicateExercise('Remo pendlay', library), isNull);
      expect(findDuplicateExercise('   ', library), isNull);
    });
  });

  group('filtro', () {
    List<String> names(ExerciseFilter f, Locale l) => [
      for (final e in filterExercises(library, f, (e) => exerciseName(e, l)))
        exerciseName(e, l),
    ];

    test('busca por el nombre visible y sin tildes', () {
      expect(names(const ExerciseFilter(query: 'cuadriceps'), _es), [
        'Extensión de cuádriceps',
      ]);
      // En inglés el mismo ejercicio se encuentra por su nombre en inglés.
      expect(names(const ExerciseFilter(query: 'leg ext'), _en), [
        'Leg extension',
      ]);
      expect(names(const ExerciseFilter(query: 'leg ext'), _es), isEmpty);
    });

    test('combina músculo, equipo y tipo de registro', () {
      final legsDb = filterExercises(
        library,
        const ExerciseFilter(
          group: MuscleGroup.legs,
          equipment: Equipment.dumbbell,
        ),
        (e) => exerciseName(e, _es),
      );
      expect(legsDb, isNotEmpty);
      expect(
        legsDb.every(
          (e) =>
              MuscleGroup.of(e.primaryMuscle) == MuscleGroup.legs &&
              e.equipment == Equipment.dumbbell,
        ),
        isTrue,
      );
      final timed = names(
        const ExerciseFilter(
          group: MuscleGroup.core,
          logType: ExerciseLogType.time,
        ),
        _es,
      );
      expect(timed, containsAll(['Plancha', 'Plancha lateral']));
      expect(timed, isNot(contains('Abdominales')));
    });

    test('ordena por el nombre visible del idioma', () {
      final all = names(const ExerciseFilter(), _es);
      expect(all, hasLength(library.length));
      expect(all.first, 'Abdominales');
    });
  });
}
