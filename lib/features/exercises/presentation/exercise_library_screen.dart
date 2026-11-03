import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/tl_button.dart';
import '../../../core/widgets/tl_chip.dart';
import '../../../data/db/app_database.dart';
import '../../../data/db/enums.dart';
import '../application/exercise_providers.dart';
import '../domain/exercise_filter.dart';
import '../domain/exercise_names.dart';
import 'exercise_labels.dart';

/// S08 Biblioteca de ejercicios: búsqueda (por el nombre visible, sin
/// tildes), chips de músculo y filtros de equipo y registro. Con [pick]
/// permite marcar varios y los devuelve en el orden en que se marcaron.
class ExerciseLibraryScreen extends ConsumerStatefulWidget {
  const ExerciseLibraryScreen({this.pick = false, super.key});

  final bool pick;

  @override
  ConsumerState<ExerciseLibraryScreen> createState() =>
      _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends ConsumerState<ExerciseLibraryScreen> {
  final _search = TextEditingController();
  var _filter = const ExerciseFilter();
  final _selected = <Exercise>[];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = context.locale;
    final all = ref.watch(exerciseLibraryProvider).value;
    final items = all == null
        ? const <Exercise>[]
        : filterExercises(all, _filter, (e) => exerciseName(e, locale));
    final query = _filter.query.trim();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TlSpace.s4),
              child: ScreenHeader(
                title: widget.pick ? l10n.libraryPickTitle : l10n.libraryTitle,
                leading: IconButton(
                  tooltip: l10n.backTooltip,
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TlSpace.s4),
              child: TextField(
                key: const Key('library-search'),
                controller: _search,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: l10n.librarySearch,
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (q) =>
                    setState(() => _filter = _filter.copyWith(query: q)),
              ),
            ),
            const SizedBox(height: TlSpace.s3),
            _Filters(
              filter: _filter,
              onChanged: (f) => setState(() => _filter = f),
            ),
            const SizedBox(height: TlSpace.s2),
            Expanded(
              child: ListView.builder(
                key: const Key('library-list'),
                padding: const EdgeInsets.fromLTRB(
                  TlSpace.s4,
                  TlSpace.s2,
                  TlSpace.s4,
                  TlSpace.s8,
                ),
                itemCount: items.length + 1,
                itemBuilder: (context, i) {
                  if (i < items.length) return _row(items[i]);
                  return _Footer(
                    query: items.isEmpty && all != null ? query : '',
                    onCreate: _create,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.pick
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  TlSpace.s4,
                  TlSpace.s2,
                  TlSpace.s4,
                  TlSpace.s4,
                ),
                child: TlButton(
                  key: const Key('library-add'),
                  label: _selected.isEmpty
                      ? l10n.libraryPickPrompt
                      : l10n.libraryAddCount(_selected.length),
                  onPressed: _selected.isEmpty
                      ? null
                      : () => context.pop(List<Exercise>.of(_selected)),
                ),
              ),
            )
          : null,
    );
  }

  Widget _row(Exercise e) {
    final selected = _selected.any((s) => s.id == e.id);
    return Padding(
      padding: const EdgeInsets.only(bottom: TlSpace.s2),
      child: _ExerciseRow(
        key: ValueKey('exercise-${e.catalogKey ?? e.id}'),
        exercise: e,
        pick: widget.pick,
        selected: selected,
        onTap: widget.pick
            ? () => _toggle(e)
            : e.isCustom
            ? () => context.push(Routes.exerciseEdit(e.id))
            : null,
      ),
    );
  }

  void _toggle(Exercise e) => setState(() {
    final i = _selected.indexWhere((s) => s.id == e.id);
    i >= 0 ? _selected.removeAt(i) : _selected.add(e);
  });

  /// Crea un ejercicio propio; en modo selección queda marcado (también si
  /// la persona eligió usar uno existente).
  Future<void> _create(String name) async {
    final created = await context.push<Exercise>(Routes.exerciseNew(name));
    if (created == null || !mounted || !widget.pick) return;
    if (!_selected.any((s) => s.id == created.id)) {
      setState(() => _selected.add(created));
    }
  }
}

/// Chips de músculo (una fila desplazable) y menús de equipo y registro.
class _Filters extends StatelessWidget {
  const _Filters({required this.filter, required this.onChanged});

  final ExerciseFilter filter;
  final ValueChanged<ExerciseFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final groups = <MuscleGroup?>[null, ...MuscleGroup.values];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          container: true,
          label: l10n.libraryFilterMuscle,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: TlSpace.s4),
            child: Row(
              children: [
                for (final g in groups) ...[
                  TlChip(
                    key: Key('chip-${g?.name ?? 'all'}'),
                    label: g == null ? l10n.libraryAll : l10n.muscleGroup(g),
                    selected: filter.group == g,
                    onTap: () => onChanged(filter.copyWith(group: () => g)),
                  ),
                  if (g != groups.last) const SizedBox(width: TlSpace.s2),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: TlSpace.s2),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: TlSpace.s4),
          child: Row(
            children: [
              _MenuChip<Equipment>(
                key: const Key('filter-equipment'),
                values: Equipment.values,
                selected: filter.equipment,
                anyLabel: l10n.libraryAnyEquipment,
                allLabel: l10n.libraryAll,
                labelOf: l10n.equipment,
                onChanged: (v) =>
                    onChanged(filter.copyWith(equipment: () => v)),
              ),
              const SizedBox(width: TlSpace.s2),
              _MenuChip<ExerciseLogType>(
                key: const Key('filter-logtype'),
                values: ExerciseLogType.values,
                selected: filter.logType,
                anyLabel: l10n.libraryAnyLogType,
                allLabel: l10n.libraryAll,
                labelOf: l10n.logType,
                onChanged: (v) => onChanged(filter.copyWith(logType: () => v)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Chip que abre un menú con "Todos" y los valores de un enum.
class _MenuChip<T extends Enum> extends StatelessWidget {
  const _MenuChip({
    required this.values,
    required this.selected,
    required this.anyLabel,
    required this.allLabel,
    required this.labelOf,
    required this.onChanged,
    super.key,
  });

  final List<T> values;
  final T? selected;
  final String anyLabel;
  final String allLabel;
  final String Function(T) labelOf;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) => PopupMenuButton<int>(
    tooltip: anyLabel,
    onSelected: (i) => onChanged(i < 0 ? null : values[i]),
    itemBuilder: (context) => [
      PopupMenuItem(value: -1, child: Text(allLabel)),
      for (final (i, v) in values.indexed)
        PopupMenuItem(value: i, child: Text(labelOf(v))),
    ],
    child: IgnorePointer(
      child: TlChip(
        label: selected == null ? anyLabel : labelOf(selected as T),
        selected: selected != null,
        trailingIcon: Icons.arrow_drop_down,
        onTap: () {},
      ),
    ),
  );
}

class _ExerciseRow extends StatelessWidget {
  const _ExerciseRow({
    required this.exercise,
    required this.pick,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final Exercise exercise;
  final bool pick;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final name = exerciseName(exercise, context.locale);
    final meta = [
      l10n.muscle(exercise.primaryMuscle),
      if (exercise.equipment != null) l10n.equipment(exercise.equipment!),
      if (exercise.logType != ExerciseLogType.weightReps)
        l10n.logType(exercise.logType),
      if (exercise.isCustom) l10n.libraryCustomTag,
    ].reduce(l10n.summaryJoin);
    return Material(
      color: c.surface1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TlRadius.lg),
        side: BorderSide(
          color: selected ? c.accent : Colors.transparent,
          width: 2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: TlSize.touchSession),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: TlSpace.s4,
              vertical: TlSpace.s2,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: t.body.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(meta, style: t.caption.copyWith(color: c.inkMuted)),
                    ],
                  ),
                ),
                if (pick)
                  ExcludeSemantics(
                    child: Checkbox(
                      value: selected,
                      onChanged: (_) => onTap!(),
                    ),
                  )
                else if (exercise.isCustom)
                  Icon(Icons.edit_outlined, color: c.inkMuted, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Fin de la lista: "no encontramos" con atajo para crear ese nombre, y el
/// botón para crear un ejercicio propio.
class _Footer extends StatelessWidget {
  const _Footer({required this.query, required this.onCreate});

  /// Búsqueda sin resultados; vacía si hubo resultados.
  final String query;
  final ValueChanged<String> onCreate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (query.isNotEmpty) ...[
          const SizedBox(height: TlSpace.s4),
          Text(
            l10n.libraryNotFound(query),
            textAlign: TextAlign.center,
            style: context.text.body.copyWith(color: c.inkMuted),
          ),
          const SizedBox(height: TlSpace.s3),
          TlButton(
            key: const Key('library-create-named'),
            label: l10n.libraryCreateNamed(query),
            variant: TlButtonVariant.secondary,
            onPressed: () => onCreate(query),
          ),
        ],
        const SizedBox(height: TlSpace.s2),
        TlButton(
          key: const Key('library-create'),
          label: l10n.libraryCreateCustom,
          icon: Icons.add,
          variant: TlButtonVariant.text,
          onPressed: () => onCreate(''),
        ),
      ],
    );
  }
}
