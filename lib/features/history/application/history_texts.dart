import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/units/weight_unit.dart';
import '../../../data/db/app_database.dart';
import '../../../data/db/enums.dart';
import '../../intervals/application/interval_texts.dart';
import '../../intervals/domain/interval_templates.dart';
import '../../strength/application/strength_texts.dart';
import '../domain/week.dart';

// Textos del historial y el progreso que dependen del idioma y de la unidad:
// fechas, pesos (R-P4), volumen, metas de cada sesión y récords. Todo valor
// pasa por un mensaje de l10n para que el pseudo-idioma lo marque.

/// Redondeo a 0,1 de un valor convertido (R-P4).
double round1(double value) => (value * 10).roundToDouble() / 10;

/// Gramos en la unidad de la persona, redondeados a 0,1: «107,7 kg».
String gramsText(AppLocalizations l10n, num grams, WeightUnit unit) =>
    l10n.weight(round1(unit.fromGrams(grams.round())), unit);

/// Volumen en la unidad de la persona, sin decimales y con miles: «6.240 kg».
String volumeText(AppLocalizations l10n, int grams, WeightUnit unit) =>
    l10n.weightValue(
      l10n.grouped(unit.fromGrams(grams).roundToDouble()),
      l10n.unitSymbol(unit),
    );

/// «Lun, 26 oct»: día de la semana abreviado y fecha, con mayúscula inicial.
String shortDate(Locale locale, DateTime day) =>
    capitalize(DateFormat.MMMEd(locale.toLanguageTag()).format(day));

/// «LUN»: día de la semana abreviado en mayúsculas.
String weekdayShort(Locale locale, DateTime day) => DateFormat.E(
  locale.toLanguageTag(),
).format(day).replaceAll('.', '').toUpperCase();

/// «lunes».
String weekdayLong(Locale locale, DateTime day) =>
    DateFormat.EEEE(locale.toLanguageTag()).format(day);

/// «L»: inicial del día de la semana (encabezado del calendario).
String weekdayNarrow(Locale locale, DateTime day) =>
    DateFormat('EEEEE', locale.toLanguageTag()).format(day).toUpperCase();

/// «OCTUBRE DE 2026».
String monthTitle(Locale locale, DateTime month) =>
    DateFormat.yMMMM(locale.toLanguageTag()).format(month).toUpperCase();

/// «26 oct» (ejes y semanas).
String dayMonth(Locale locale, DateTime day) =>
    DateFormat.MMMd(locale.toLanguageTag()).format(day);

String capitalize(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

/// Nombre de la sesión: la rutina o el entrenamiento, o "Entrenamiento
/// libre".
String entryTitle(AppLocalizations l10n, HistoryEntry e) => e.isStrength
    ? sessionTitle(l10n, e.title)
    : (e.title ?? l10n.historyIntervalsFallback);

/// Lo que se hizo, sin la fecha: «52 min · 6.240 kg», «19 min · 6/6
/// rondas» o «4 min · incompleta» (sin [withState], la cifra en vez del
/// estado).
String entryFacts(
  AppLocalizations l10n,
  HistoryEntry e,
  WeightUnit unit, {
  bool withState = true,
}) {
  final minutes = l10n.historyMinutes((e.activeSeconds / 60).round());
  final String detail;
  if (e.incomplete && withState) {
    detail = l10n.historyIncomplete;
  } else if (e.isStrength) {
    detail = e.volumeGrams > 0
        ? volumeText(l10n, e.volumeGrams, unit)
        : l10n.historySets(e.completedSets);
  } else {
    detail = l10n.historyRounds(e.roundsDone, e.roundsPlanned);
  }
  return l10n.summaryJoin(minutes, detail);
}

/// Meta de una fila de la lista: «Lun, 26 oct · 52 min · 6.240 kg».
String entryMeta(
  AppLocalizations l10n,
  Locale locale,
  HistoryEntry e,
  WeightUnit unit,
) => l10n.summaryJoin(
  l10n.historyDate(shortDate(locale, e.day)),
  entryFacts(l10n, e, unit),
);

/// Nombre de un entrenamiento planificado.
String plannedName(AppLocalizations l10n, PlannedWorkout p) {
  final template = IntervalTemplate.bySourceId(p.templateId);
  return p.name ?? (template == null ? '' : templateName(l10n, template));
}

/// Letra del tipo: «F» fuerza, «I» intervalos.
String kindLetter(AppLocalizations l10n, SessionKind kind) =>
    kind == SessionKind.strength
    ? l10n.historyLetterStrength
    : l10n.historyLetterIntervals;

/// Nombre de un récord: «Peso máximo», «Más reps con 80 kg»…
String recordName(AppLocalizations l10n, PersonalRecord r, WeightUnit unit) =>
    switch (r.type) {
      RecordType.maxWeight => l10n.recordMaxWeight,
      RecordType.estimatedOneRm => l10n.recordOneRm,
      RecordType.maxReps =>
        r.weightGrams > 0
            ? l10n.recordMaxRepsAt(gramsText(l10n, r.weightGrams, unit))
            : l10n.recordMaxRepsBodyweight,
      RecordType.maxSessionVolume => l10n.recordMaxVolume,
      RecordType.maxDuration => l10n.recordMaxDuration,
      RecordType.maxDistance => l10n.recordMaxDistance,
    };

/// Valor de un récord: «90 kg × 3», «107,7 kg», «10», «2.480 kg», «1:30».
String recordValue(AppLocalizations l10n, PersonalRecord r, WeightUnit unit) =>
    switch (r.type) {
      RecordType.maxWeight =>
        r.reps == null
            ? gramsText(l10n, r.value, unit)
            : l10n.strengthWeightTimesReps(
                gramsText(l10n, r.value, unit),
                r.reps!,
              ),
      RecordType.estimatedOneRm => gramsText(l10n, r.value, unit),
      RecordType.maxReps => l10n.numberValue(r.value.round()),
      RecordType.maxSessionVolume => volumeText(l10n, r.value.round(), unit),
      RecordType.maxDuration => l10n.duration(r.value.round()),
      RecordType.maxDistance => l10n.distanceMeters(r.value.round()),
    };

/// «Peso máximo: 90 kg × 3».
String recordLine(AppLocalizations l10n, PersonalRecord r, WeightUnit unit) =>
    l10n.recordLine(recordName(l10n, r, unit), recordValue(l10n, r, unit));
