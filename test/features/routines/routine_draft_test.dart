import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/data/db/app_database.dart';
import 'package:trainloop/data/db/enums.dart';
import 'package:trainloop/features/routines/domain/reorder.dart';
import 'package:trainloop/features/routines/domain/routine_draft.dart';

Exercise _exercise(String id, ExerciseLogType type, {int? rest}) => Exercise(
  id: id,
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
  name: id,
  normalizedName: id,
  logType: type,
  primaryMuscle: Muscle.chest,
  defaultRestSeconds: rest,
  isCustom: true,
);

void main() {
  test('reorderList sigue la convención de ReorderableListView', () {
    const list = ['a', 'b', 'c', 'd'];
    expect(reorderList(list, 0, 3), ['b', 'c', 'a', 'd']);
    expect(reorderList(list, 0, 4), ['b', 'c', 'd', 'a']);
    expect(reorderList(list, 3, 0), ['d', 'a', 'b', 'c']);
    expect(reorderList(list, 1, 1), list);
    expect(list, ['a', 'b', 'c', 'd'], reason: 'no muta la original');
  });

  test('agregar usa los valores por defecto del ejercicio', () {
    final draft = const RoutineDraft().addAll([
      _exercise('bench', ExerciseLogType.weightReps, rest: 150),
      _exercise('plank', ExerciseLogType.time),
      _exercise('sled', ExerciseLogType.distance),
    ]);
    final [bench, plank, sled] = draft.entries;
    expect((bench.sets, bench.reps, bench.restSeconds), (3, 10, 150));
    expect(bench.durationSeconds, isNull);
    expect(
      (plank.reps, plank.durationSeconds, plank.restSeconds),
      (null, 45, 90),
    );
    expect((sled.reps, sled.durationSeconds), (null, null));
    expect(draft.canSave, isTrue);
    expect(const RoutineDraft().canSave, isFalse);
  });

  test(
    'mover, quitar y reemplazar devuelven copias; los límites se respetan',
    () {
      final draft = const RoutineDraft().addAll([
        for (final id in ['a', 'b', 'c']) _exercise(id, ExerciseLogType.reps),
      ]);
      final moved = draft.move(2, 0);
      expect(moved.entries.map((e) => e.exercise.id), ['c', 'a', 'b']);
      expect(draft.entries.map((e) => e.exercise.id), ['a', 'b', 'c']);
      expect(moved.removeAt(0).entries, hasLength(2));
      final edited = moved.replaceAt(
        1,
        moved.entries[1].copyWith(sets: 99, reps: 0, restSeconds: -15),
      );
      expect(edited.entries[1].sets, RoutineEntryDraft.maxSets);
      expect(edited.entries[1].reps, 1);
      expect(edited.entries[1].restSeconds, 0);
    },
  );
}
