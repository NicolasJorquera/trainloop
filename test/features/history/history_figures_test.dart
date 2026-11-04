import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/core/l10n/l10n.dart';
import 'package:trainloop/core/units/weight_unit.dart';
import 'package:trainloop/data/db/app_database.dart';
import 'package:trainloop/data/db/enums.dart';
import 'package:trainloop/features/history/application/history_texts.dart';
import 'package:trainloop/features/history/data/history_repository.dart';
import 'package:trainloop/features/history/domain/week.dart';
import 'package:trainloop/features/settings/domain/app_settings.dart';
import 'package:trainloop/features/strength/domain/strength_rules.dart';

import '../../fixtures/history_fixture.dart';
import '../../helpers/test_database.dart';

// Cifras de la app frente a las calculadas a mano en
// docs/pruebas-historial.md (conjunto de test/fixtures/history_fixture.dart).
void main() {
  late AppDatabase db;
  late FixtureIds ids;
  late HistoryRepository history;

  setUp(() async {
    db = openTestDatabase();
    ids = await buildHistoryFixture(db);
    history = HistoryRepository(db);
  });
  tearDown(() => db.close());

  Future<WeekStats> week() async => statsForWeek(
    await history.loadEntries(),
    weekStartOf(HistoryFixture.today, WeekStart.monday),
  );

  Future<PersonalRecord> squat(RecordType type) async =>
      (await db.recordsDao.forExercise(
        ids.squat,
      )).singleWhere((r) => r.type == type);

  test('cifras 1–6: semana, volumen, intervalos y récords', () async {
    final w = await week();
    final byId = {for (final e in w.entries) e.id: e};
    // 1. Sesiones de la semana: A, B, C y D.
    expect(w.sessions, 4);
    // 2. Minutos activos: (3000 + 240 + 85 + 1200) s = 4525 s → 75 min.
    expect(w.activeSeconds, 4525);
    expect(w.activeMinutes, 75);
    // 3. Volumen de A sin calentamiento: 80×8 + 85×8 + 60×8 = 1.800 kg.
    expect(byId[ids['A']]!.volumeGrams, 1800000);
    // 4. Volumen semanal: 1.800 + 270 = 2.070 kg.
    expect(w.volumeGrams, 2070000);
    // 5. Tabata incompleto: 2 de 8 rondas, 55 s de trabajo.
    final c = byId[ids['C']]!;
    expect((c.roundsDone, c.roundsPlanned, c.workSeconds), (2, 8, 55));
    // 6a. Récord de peso: 90 × 3 en D, supera los 85 kg de A.
    final max = await squat(RecordType.maxWeight);
    expect((max.value, max.reps, max.sessionId), (90000, 3, ids['D']));
    expect(max.previousValue, 85000);
    // 6b. 1RM estimado: 85 × (1 + 8/30) = 107,67 kg en A (primera marca).
    final rm = await squat(RecordType.estimatedOneRm);
    expect(rm.value.toStringAsFixed(2), '107666.67');
    expect(rm.sessionId, ids['A']);
    final es = lookupAppLocalizations(const Locale('es', '419'));
    expect(gramsText(es, rm.value, WeightUnit.kg), '107,7 kg');
    expect(volumeText(es, w.volumeGrams, WeightUnit.kg), '2.070 kg');
  });

  test(
    'cifra 7: recálculo al editar (antes y después de la corrección)',
    () async {
      // Antes de la edición A tenía 80 × 6: su 1RM era 80 × (1 + 8/30) =
      // 101,33 kg. Se vuelve a 80 × 6 y luego otra vez a 85 × 8.
      await history.updateSet(
        ids.editedSet,
        const SetValues(weight: 80, unit: WeightUnit.kg, reps: 6),
      );
      final rm = await squat(RecordType.estimatedOneRm);
      expect(rm.value.toStringAsFixed(2), '101333.33');
      expect((await squat(RecordType.maxWeight)).previousValue, 80000);
      // 80×8 + 80×6 + 60×8 + 90×3 = 640 + 480 + 480 + 270 = 1.870 kg.
      expect((await week()).volumeGrams, 1870000);
    },
  );

  test('cifra 8: recálculo al borrar y al deshacer', () async {
    await history.delete(ids['D']);
    var max = await squat(RecordType.maxWeight);
    // Sin D, el máximo vuelve a 85 kg de A (primera marca: no "nuevo").
    expect(
      (max.value, max.sessionId, max.previousValue),
      (85000, ids['A'], null),
    );
    expect((await week()).sessions, 3);

    await history.restore(ids['D']);
    max = await squat(RecordType.maxWeight);
    expect((max.value, max.sessionId), (90000, ids['D']));
    expect((await week()).sessions, 4);
  });
}
