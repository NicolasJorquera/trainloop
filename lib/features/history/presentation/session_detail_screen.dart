import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/units/weight_unit.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/section_label.dart';
import '../../../core/widgets/tab_page.dart';
import '../../../core/widgets/tl_button.dart';
import '../../../data/db/app_database.dart';
import '../../../data/db/database_providers.dart';
import '../../../data/db/enums.dart';
import '../../exercises/domain/exercise_names.dart';
import '../../settings/application/settings_controller.dart';
import '../../strength/application/strength_session_controller.dart';
import '../../strength/application/strength_texts.dart';
import '../../strength/domain/strength_rules.dart';
import '../../strength/domain/strength_session.dart';
import '../../strength/presentation/set_editor_sheet.dart';
import '../application/history_providers.dart';
import '../application/history_texts.dart';
import '../domain/week.dart';
import 'history_widgets.dart';

/// Récords de una sesión (los que hoy le pertenecen).
final _sessionRecordsProvider = StreamProvider.autoDispose
    .family<List<PersonalRecord>, String>(
      (ref, id) =>
          ref.watch(appDatabaseProvider).recordsDao.watchForSession(id),
    );

/// S13 Detalle de sesión (F-10): cifras, series (fuerza) o rondas
/// (intervalos), récords y nota. "Editar" permite cambiar series, pesos,
/// reps y RPE (fuerza), y nombre, esfuerzo y nota (ambos tipos); los
/// récords se recalculan al guardar (R-G14). "Eliminar" pide confirmación
/// y ofrece deshacer durante 5 segundos.
class SessionDetailScreen extends ConsumerStatefulWidget {
  const SessionDetailScreen({required this.sessionId, super.key});

  final String sessionId;

  @override
  ConsumerState<SessionDetailScreen> createState() =>
      _SessionDetailScreenState();
}

class _SessionDetailScreenState extends ConsumerState<SessionDetailScreen> {
  final _name = TextEditingController();
  final _note = TextEditingController();
  var _editing = false;
  int? _effort;
  var _deleting = false;

  @override
  void dispose() {
    _name.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final entry = ref.watch(historyEntryProvider(widget.sessionId));
    final e = entry.value;
    if (e == null) {
      return Scaffold(
        body: TabPage(
          children: [
            ScreenHeader(title: '', leading: _back(context)),
            if (!entry.isLoading && !_deleting)
              Text(l10n.detailMissing, style: t.body),
          ],
        ),
      );
    }
    final unit = ref.watch(settingsControllerProvider).weightUnit;
    final locale = context.locale;
    final when = l10n.summaryJoin(
      shortDate(locale, e.day),
      DateFormat.Hm(locale.toLanguageTag()).format(e.wallClock),
    );
    final effort = e.session.perceivedEffort;
    final strength = e.isStrength
        ? ref.watch(strengthSessionDataProvider(e.id)).value
        : null;
    final records = [
      for (final r
          in ref.watch(_sessionRecordsProvider(e.id)).value ??
              const <PersonalRecord>[])
        if (r.previousValue != null) r,
    ];

    return Scaffold(
      body: TabPage(
        children: [
          ScreenHeader(
            title: entryTitle(l10n, e).toUpperCase(),
            leading: _back(context),
            trailing: TextButton(
              key: const Key('detail-edit'),
              onPressed: () => _editing ? _saveEdits(e) : _startEditing(e),
              child: Text(_editing ? l10n.detailDone : l10n.detailEdit),
            ),
          ),
          Text(
            [
              l10n.historyDate(when),
              l10n.historyMinutes((e.activeSeconds / 60).round()),
              if (effort != null) l10n.detailEffort(effort),
              if (e.incomplete) l10n.historyIncomplete,
            ].join(' · '),
            style: t.bodySm.copyWith(color: c.inkMuted),
          ),
          const SizedBox(height: TlSpace.s3),
          if (e.isStrength)
            Row(
              children: [
                StatBox(
                  label: l10n.detailVolume,
                  value: volumeText(l10n, e.volumeGrams, unit),
                  valueKey: const Key('detail-volume'),
                ),
                const SizedBox(width: TlSpace.s2),
                StatBox(
                  label: l10n.detailSets,
                  value: l10n.numberValue(e.completedSets),
                  valueKey: const Key('detail-sets'),
                ),
                const SizedBox(width: TlSpace.s2),
                StatBox(
                  label: l10n.detailRecords,
                  value: l10n.numberValue(records.length),
                  valueKey: const Key('detail-records'),
                ),
              ],
            )
          else
            Row(
              children: [
                StatBox(
                  label: l10n.detailTotal,
                  value: l10n.duration(e.activeSeconds),
                  valueKey: const Key('detail-total'),
                ),
                const SizedBox(width: TlSpace.s2),
                StatBox(
                  label: l10n.detailRounds,
                  value: l10n.summaryRoundsValue(e.roundsDone, e.roundsPlanned),
                  valueKey: const Key('detail-rounds'),
                ),
                const SizedBox(width: TlSpace.s2),
                StatBox(
                  label: l10n.detailWork,
                  value: l10n.duration(e.workSeconds),
                  valueKey: const Key('detail-work'),
                ),
              ],
            ),
          if (_editing) ..._editFields(context, e),
          if (strength != null)
            for (final x in strength.exercises)
              _ExerciseTable(
                item: x,
                unit: unit,
                editing: _editing,
                records: records,
                onEditSet: (s) => _editSet(x, s),
              ),
          if (!_editing && (e.session.note ?? '').isNotEmpty) ...[
            const SizedBox(height: TlSpace.s4),
            Text(
              l10n.detailNote(e.session.note!),
              key: const Key('detail-note'),
              style: t.body,
            ),
          ],
          const SizedBox(height: TlSpace.s6),
          if (e.isStrength) ...[
            TlButton(
              key: const Key('detail-save-routine'),
              label: l10n.detailSaveRoutine,
              variant: TlButtonVariant.secondary,
              onPressed: () => _saveAsRoutine(e),
            ),
            const SizedBox(height: TlSpace.s2),
          ],
          TlButton(
            key: const Key('detail-delete'),
            label: l10n.detailDelete,
            variant: TlButtonVariant.text,
            onPressed: () => _delete(e),
          ),
        ],
      ),
    );
  }

  Widget _back(BuildContext context) => IconButton(
    key: const Key('detail-back'),
    tooltip: context.l10n.backTooltip,
    icon: const Icon(Icons.arrow_back),
    onPressed: () =>
        context.canPop() ? context.pop() : context.go(Routes.history),
  );

  List<Widget> _editFields(BuildContext context, HistoryEntry e) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    return [
      SectionLabel(l10n.detailNameLabel),
      TextField(
        key: const Key('detail-name'),
        controller: _name,
        maxLength: 120,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(counterText: ''),
      ),
      SectionLabel(l10n.summaryRpeQuestion),
      Wrap(
        spacing: TlSpace.s1,
        runSpacing: TlSpace.s1,
        children: [
          for (var n = 1; n <= 10; n++)
            Semantics(
              button: true,
              selected: _effort == n,
              label: l10n.summaryRpeValue(n),
              excludeSemantics: true,
              child: ChoiceChip(
                key: Key('detail-rpe-$n'),
                label: Text(l10n.numberValue(n)),
                selected: _effort == n,
                showCheckmark: false,
                onSelected: (on) => setState(() => _effort = on ? n : null),
              ),
            ),
        ],
      ),
      SectionLabel(l10n.summaryNote),
      TextField(
        key: const Key('detail-note-field'),
        controller: _note,
        minLines: 2,
        maxLines: 4,
        maxLength: 500,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: l10n.strengthNoteHint,
          counterText: '',
        ),
      ),
      if (e.isStrength) ...[
        const SizedBox(height: TlSpace.s2),
        Text(l10n.detailEditHelp, style: t.bodySm.copyWith(color: c.inkMuted)),
      ],
    ];
  }

  void _startEditing(HistoryEntry e) => setState(() {
    _editing = true;
    _name.text = entryTitle(context.l10n, e);
    _note.text = e.session.note ?? '';
    _effort = e.session.perceivedEffort;
  });

  Future<void> _saveEdits(HistoryEntry e) async {
    final repo = ref.read(historyRepositoryProvider);
    final name = _name.text.trim();
    if (name.isNotEmpty && name != entryTitle(context.l10n, e)) {
      await repo.rename(e.id, name);
    }
    await repo.rate(e.id, perceivedEffort: _effort, note: _note.text);
    if (mounted) setState(() => _editing = false);
  }

  Future<void> _editSet(SessionExerciseItem e, SessionSet s) async {
    final l10n = context.l10n;
    final unit = ref.read(settingsControllerProvider).weightUnit;
    final result = await showSetEditor(
      context,
      heading: setHeading(l10n, exerciseName(e.exercise, context.locale), s),
      previous: null,
      logType: e.exercise.logType,
      initial: s.stored,
      unit: unit,
      increment: incrementFor(e.exercise, unit),
      canDelete: e.sets.length > 1,
    );
    if (!mounted || result == null) return;
    final repo = ref.read(historyRepositoryProvider);
    switch (result) {
      case SetEditDelete():
        await repo.deleteSet(s.id);
      case SetEditSave(:final values):
        await repo.updateSet(s.id, values);
    }
  }

  Future<void> _saveAsRoutine(HistoryEntry e) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final name = entryTitle(l10n, e);
    final id = await ref
        .read(historyRepositoryProvider)
        .saveAsRoutine(e.id, name);
    if (id == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.detailRoutineSaved(name))));
  }

  Future<void> _delete(HistoryEntry e) async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        key: const Key('delete-dialog'),
        title: Text(l10n.detailDeleteTitle),
        content: Text(l10n.detailDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.dialogCancel),
          ),
          TextButton(
            key: const Key('delete-confirm'),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.detailDelete),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final repo = ref.read(historyRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _deleting = true);
    await repo.delete(e.id);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          key: const Key('delete-snackbar'),
          duration: const Duration(seconds: 5),
          content: Text(l10n.detailDeleted),
          action: SnackBarAction(
            key: const Key('delete-undo'),
            label: l10n.undo,
            onPressed: () => repo.restore(e.id),
          ),
        ),
      );
    if (!mounted) return;
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.history);
    }
  }
}

/// Un ejercicio de la sesión: nombre (abre S15) y sus series en una tabla
/// SERIE · KG · REPS · RPE, con la marca de récord.
class _ExerciseTable extends StatelessWidget {
  const _ExerciseTable({
    required this.item,
    required this.unit,
    required this.editing,
    required this.records,
    required this.onEditSet,
  });

  final SessionExerciseItem item;
  final WeightUnit unit;
  final bool editing;
  final List<PersonalRecord> records;
  final ValueChanged<SessionSet> onEditSet;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final type = item.exercise.logType;
    final head = t.overline.copyWith(color: c.inkMuted);
    final mine = [
      for (final r in records)
        if (r.exerciseId == item.exercise.id) r,
    ];
    bool isRecordSet(SetLog s) => mine.any(
      (r) => switch (r.type) {
        RecordType.maxWeight =>
          s.weightGrams == r.value.round() && s.reps == r.reps,
        RecordType.estimatedOneRm =>
          ((estimatedOneRmGrams(s.weightGrams, s.reps) ?? -1) - r.value).abs() <
              0.01,
        RecordType.maxReps =>
          (s.weightGrams ?? 0) == r.weightGrams && s.reps == r.value.round(),
        RecordType.maxDuration => s.durationSeconds == r.value.round(),
        _ => false,
      },
    );
    final done = item.sets.where((s) => s.completed).toList();
    return Container(
      key: Key(
        'detail-exercise-${item.exercise.catalogKey ?? item.exercise.id}',
      ),
      margin: const EdgeInsets.only(top: TlSpace.s4),
      padding: const EdgeInsets.all(TlSpace.s3),
      decoration: BoxDecoration(
        color: c.surface1,
        borderRadius: BorderRadius.circular(TlRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () =>
                context.push(Routes.exerciseProgress(item.exercise.id)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: TlSpace.s1),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      exerciseName(item.exercise, context.locale).toUpperCase(),
                      style: t.title,
                    ),
                  ),
                  Icon(Icons.chevron_right, color: c.inkMuted),
                ],
              ),
            ),
          ),
          const SizedBox(height: TlSpace.s1),
          Row(
            children: [
              Expanded(child: Text(l10n.detailColSet, style: head)),
              Expanded(
                child: Text(
                  type.tracksWeight
                      ? l10n.unitSymbol(unit).toUpperCase()
                      : type.tracksTime
                      ? l10n.detailColTime
                      : '',
                  style: head,
                ),
              ),
              Expanded(child: Text(l10n.detailColReps, style: head)),
              Expanded(flex: 2, child: Text(l10n.detailColRpe, style: head)),
            ],
          ),
          for (final s in done)
            InkWell(
              key: Key('detail-set-${s.id}'),
              onTap: editing ? () => onEditSet(s) : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: TlSpace.s2),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        setTag(l10n, s),
                        style: t.body.copyWith(
                          color: s.type == SetType.warmup ? c.inkMuted : c.ink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        type.tracksWeight
                            ? (weightNumber(l10n, s.stored, unit) ??
                                  l10n.strengthNoValue)
                            : type.tracksTime && s.log.durationSeconds != null
                            ? l10n.duration(s.log.durationSeconds!)
                            : l10n.strengthNoValue,
                        style: t.body,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        s.log.reps == null
                            ? l10n.strengthNoValue
                            : l10n.numberValue(s.log.reps!),
                        style: t.body,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Text(
                            s.log.rpe == null
                                ? l10n.strengthNoValue
                                : l10n.decimalText(l10n.decimal(s.log.rpe!)),
                            style: t.body,
                          ),
                          if (isRecordSet(s.log)) ...[
                            const SizedBox(width: TlSpace.s2),
                            Text(
                              l10n.detailRecordTag,
                              key: Key('detail-record-${s.id}'),
                              style: t.overline.copyWith(color: c.accent),
                            ),
                          ],
                          const Spacer(),
                          if (editing)
                            Icon(
                              Icons.edit_outlined,
                              size: 18,
                              color: c.inkMuted,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (item.entry.notes != null && item.entry.notes!.isNotEmpty)
            Text(
              l10n.detailNote(item.entry.notes!),
              style: t.bodySm.copyWith(color: c.inkMuted),
            ),
        ],
      ),
    );
  }
}
