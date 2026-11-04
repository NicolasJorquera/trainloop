import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/core/l10n/formatters.dart';
import 'package:trainloop/core/l10n/l10n.dart';
import 'package:trainloop/core/units/weight_unit.dart';
import 'package:trainloop/data/db/app_database.dart';
import 'package:trainloop/data/db/enums.dart';
import 'package:trainloop/features/strength/domain/strength_rules.dart';

SetLog _log(
  int order, {
  double? kg,
  int? reps,
  SetType type = SetType.normal,
  bool completed = true,
}) => SetLog(
  id: 'l$order',
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
  sessionExerciseId: 'se',
  sessionId: 's',
  exerciseId: 'e',
  sortOrder: order,
  setType: type,
  weightValue: kg,
  weightUnit: kg == null ? null : WeightUnit.kg,
  weightGrams: kg == null ? null : WeightUnit.kg.toGrams(kg),
  reps: reps,
  completed: completed,
);

Exercise _exercise({double? increment, WeightUnit? unit, int? rest}) =>
    Exercise(
      id: 'e',
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
      name: 'Squat',
      normalizedName: 'squat',
      logType: ExerciseLogType.weightReps,
      primaryMuscle: Muscle.quads,
      incrementValue: increment,
      incrementUnit: unit,
      defaultRestSeconds: rest,
      isCustom: false,
    );

void main() {
  group('valores propuestos (R-G2)', () {
    const target = SetValues(weight: 80, unit: WeightUnit.kg, reps: 8);
    final previous = [_log(0, kg: 82.5, reps: 7), _log(1, kg: 80, reps: 6)];

    test('la misma serie de la vez anterior → objetivo → vacío', () {
      expect(
        proposeSet(index: 0, previous: previous, target: target).weight,
        82.5,
      );
      expect(proposeSet(index: 1, previous: previous, target: target).reps, 6);
      expect(proposeSet(index: 2, previous: previous, target: target), target);
      expect(
        proposeSet(
          index: 0,
          previous: const [],
          target: const SetValues(),
        ).isEmpty,
        isTrue,
      );
    });

    test('el tipo de serie es el de la sesión y el RPE no se copia', () {
      final p = proposeSet(
        index: 0,
        previous: [_log(0, kg: 40, reps: 10)],
        target: const SetValues(type: SetType.warmup),
      );
      expect(p.type, SetType.warmup);
      expect(p.rpe, isNull);
    });

    test('1 toque solo si están los campos del tipo de ejercicio', () {
      expect(canLogDirectly(ExerciseLogType.weightReps, target), isTrue);
      expect(
        canLogDirectly(ExerciseLogType.weightReps, const SetValues(reps: 8)),
        isFalse,
      );
      expect(
        canLogDirectly(ExerciseLogType.reps, const SetValues(reps: 8)),
        isTrue,
      );
      expect(
        canLogDirectly(
          ExerciseLogType.time,
          const SetValues(durationSeconds: 45),
        ),
        isTrue,
      );
      // Peso 0 = peso corporal.
      expect(
        canLogDirectly(
          ExerciseLogType.weightReps,
          const SetValues(weight: 0, unit: WeightUnit.kg, reps: 12),
        ),
        isTrue,
      );
    });
  });

  group('validaciones (R-G4)', () {
    List<SetError> v(SetValues s) => validateSet(ExerciseLogType.weightReps, s);

    test('peso 0–1.000 kg en pasos de 0,25', () {
      expect(
        v(const SetValues(weight: 1000, unit: WeightUnit.kg, reps: 1)),
        isEmpty,
      );
      expect(
        v(const SetValues(weight: 1000.25, unit: WeightUnit.kg, reps: 1)),
        [SetError.weightRange],
      );
      expect(v(const SetValues(weight: -1, unit: WeightUnit.kg, reps: 1)), [
        SetError.weightRange,
      ]);
      expect(v(const SetValues(weight: 82.6, unit: WeightUnit.kg, reps: 1)), [
        SetError.weightStep,
      ]);
      // 2.200 lb son 997,9 kg: válido; 2.210 lb no.
      expect(
        v(const SetValues(weight: 2200, unit: WeightUnit.lb, reps: 1)),
        isEmpty,
      );
      expect(v(const SetValues(weight: 2210, unit: WeightUnit.lb, reps: 1)), [
        SetError.weightRange,
      ]);
    });

    test('reps 0–999 y RPE 6–10 en pasos de 0,5', () {
      expect(v(const SetValues(reps: 1000)), [SetError.repsRange]);
      expect(v(const SetValues(reps: 0)), isEmpty);
      expect(v(const SetValues(reps: 5, rpe: 7.5)), isEmpty);
      expect(v(const SetValues(reps: 5, rpe: 5.5)), [SetError.rpeRange]);
      expect(v(const SetValues(reps: 5, rpe: 8.25)), [SetError.rpeRange]);
      expect(SetLimits.rpeValues, [6, 6.5, 7, 7.5, 8, 8.5, 9, 9.5, 10]);
    });
  });

  test('descanso: rutina → biblioteca → 90 s (R-G8)', () {
    expect(restSecondsFor(routineRest: 120, libraryRest: 60), 120);
    expect(restSecondsFor(libraryRest: 60), 60);
    expect(restSecondsFor(), 90);
  });

  test('incremento: el del ejercicio en su unidad o 2,5 kg / 5 lb', () {
    expect(
      incrementFor(_exercise(increment: 5, unit: WeightUnit.kg), WeightUnit.kg),
      5,
    );
    expect(
      incrementFor(_exercise(increment: 5, unit: WeightUnit.kg), WeightUnit.lb),
      5,
    );
    expect(incrementFor(_exercise(), WeightUnit.kg), 2.5);
    expect(incrementFor(_exercise(), WeightUnit.lb), 5);
  });

  test('volumen sin calentamiento ni series sin hacer', () {
    expect(
      volumeGrams([
        _log(0, kg: 40, reps: 10, type: SetType.warmup),
        _log(1, kg: 80, reps: 8),
        _log(2, kg: 80, reps: 8, completed: false),
        _log(3, kg: 0, reps: 12),
      ]),
      640000,
    );
  });

  test('1RM de Epley con 1 a 12 repeticiones', () {
    expect(estimatedOneRmGrams(100000, 1), 100000);
    expect(estimatedOneRmGrams(85000, 8)!.round(), 107667);
    expect(estimatedOneRmGrams(85000, 13), isNull);
    expect(estimatedOneRmGrams(null, 5), isNull);
  });

  test('récord del día: solo si supera el historial', () {
    final e = _exercise();
    final history = [_log(0, kg: 80, reps: 8)];
    final record = dayRecordFor(e, [_log(0, kg: 85, reps: 5)], history)!;
    expect(record.weightRecord, isTrue);
    // Mismo peso con más reps: récord de 1RM, no de peso.
    final rm = dayRecordFor(e, [_log(0, kg: 80, reps: 10)], history)!;
    expect(rm.weightRecord, isFalse);
    expect(rm.oneRmGrams!.round(), 106667);
    expect(dayRecordFor(e, [_log(0, kg: 80, reps: 8)], history), isNull);
    // Sin historial no hay récord; el calentamiento no cuenta.
    expect(dayRecordFor(e, [_log(0, kg: 85, reps: 5)], const []), isNull);
    expect(
      dayRecordFor(e, [
        _log(0, kg: 200, reps: 1, type: SetType.warmup),
      ], history),
      isNull,
    );
  });

  test('la estructura cambió (R-G12)', () {
    const a = [(exerciseId: 'a', sets: 3), (exerciseId: 'b', sets: 3)];
    expect(structureChanged(a, [...a]), isFalse);
    expect(structureChanged(a, [(exerciseId: 'a', sets: 4), a[1]]), isTrue);
    expect(structureChanged(a, [a[1], a[0]]), isTrue);
    expect(structureChanged(a, [a[0]]), isTrue);
  });

  test('peso en la unidad de la persona, redondeado a 2 decimales', () {
    const v = SetValues(weight: 60, unit: WeightUnit.kg);
    expect(v.weightIn(WeightUnit.lb), 132.28);
    expect(v.weightIn(WeightUnit.kg), 60);
    expect(const SetValues(weight: 135, unit: WeightUnit.lb).grams, 61235);
  });

  test('decimales con coma en es-419 y pt-BR, punto en inglés', () {
    String d(Locale l, double v) => lookupAppLocalizations(l).decimal(v);
    expect(d(const Locale('es', '419'), 82.5), '82,5');
    expect(d(const Locale('es'), 0.25), '0,25');
    expect(d(const Locale('pt', 'BR'), 2.5), '2,5');
    expect(d(const Locale('en'), 2.5), '2.5');
    expect(
      lookupAppLocalizations(const Locale('es', '419')).grouped(6240),
      '6.240',
    );
    expect(lookupAppLocalizations(const Locale('en')).grouped(6240), '6,240');
    expect(parseDecimal('82,5'), 82.5);
    expect(numberLocale('es_419'), 'es');
    expect(numberLocale('pt'), 'pt_BR');
  });
}
