import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/section_label.dart';
import '../../../core/widgets/tab_page.dart';
import '../../../core/widgets/tl_button.dart';
import '../../../data/db/database_providers.dart';
import '../../../platform/documents_client.dart';
import '../../exercises/domain/exercise_names.dart';
import '../../history/application/history_texts.dart';
import '../../intervals/presentation/session_dialogs.dart';
import '../../reminders/application/reminder_controller.dart';
import '../../settings/application/settings_controller.dart';
import '../../settings/domain/app_settings.dart';
import '../application/backup_providers.dart';
import '../data/backup_codec.dart';
import '../data/csv_export.dart';

/// S17 Respaldo: crear, restaurar y exportar CSV (F-14), con la
/// explicación del respaldo automático de Android. Pantalla crítica: nunca
/// lleva anuncios.
class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final last = ref.watch(settingsControllerProvider).lastBackup;
    final help = t.bodySm.copyWith(color: c.inkMuted);

    return Scaffold(
      body: Stack(
        children: [
          TabPage(
            children: [
              ScreenHeader(
                title: l10n.backupTitle,
                leading: IconButton(
                  key: const Key('backup-back'),
                  tooltip: l10n.backTooltip,
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.canPop()
                      ? context.pop()
                      : context.go(Routes.settings),
                ),
              ),
              const SizedBox(height: TlSpace.s2),
              Container(
                padding: const EdgeInsets.all(TlSpace.s4),
                decoration: BoxDecoration(
                  color: c.surface1,
                  borderRadius: BorderRadius.circular(TlRadius.lg),
                  border: Border(left: BorderSide(color: c.warning, width: 4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(l10n.backupHeadline, style: t.title),
                    ),
                    const SizedBox(height: TlSpace.s2),
                    Text(l10n.backupBody, style: t.body),
                    const SizedBox(height: TlSpace.s3),
                    Text(
                      last == null ? l10n.backupNever : _lastText(last),
                      key: const Key('backup-last'),
                      style: help,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TlSpace.s6),
              TlButton(
                key: const Key('backup-create'),
                label: l10n.backupCreate,
                icon: Icons.save_alt,
                onPressed: _busy ? null : _create,
              ),
              const SizedBox(height: TlSpace.s3),
              TlButton(
                key: const Key('backup-restore'),
                label: l10n.backupRestore,
                icon: Icons.settings_backup_restore,
                variant: TlButtonVariant.secondary,
                onPressed: _busy ? null : _restore,
              ),
              const SizedBox(height: TlSpace.s3),
              TlButton(
                key: const Key('backup-csv'),
                label: l10n.backupCsv,
                icon: Icons.table_chart_outlined,
                variant: TlButtonVariant.secondary,
                onPressed: _busy ? null : _exportCsv,
              ),
              const SizedBox(height: TlSpace.s2),
              Text(l10n.backupCsvHelp, style: help),
              SectionLabel(l10n.backupHowTitle),
              for (final (i, step) in [
                l10n.backupStep1,
                l10n.backupStep2,
                l10n.backupStep3,
              ].indexed)
                _Step(number: i + 1, text: step),
              SectionLabel(l10n.backupAutoTitle),
              Text(l10n.backupAutoBody, style: t.body),
            ],
          ),
          if (_busy)
            Positioned.fill(
              child: ColoredBox(
                color: c.bg.withValues(alpha: 0.6),
                child: Center(
                  child: CircularProgressIndicator(
                    semanticsLabel: l10n.backupWorking,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _lastText(LastBackup last) {
    final l10n = context.l10n;
    final date = DateFormat.yMMMd(
      context.locale.toLanguageTag(),
    ).format(last.at.toLocal());
    final kb = (last.bytes / 1024).ceil();
    return l10n.backupLast(
      date,
      l10n.backupSessions(last.sessions),
      l10n.backupSizeKb(l10n.numberValue(kb)),
    );
  }

  Future<T?> _run<T>(Future<T> Function() task) async {
    setState(() => _busy = true);
    try {
      return await task();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _say(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
    SemanticsService.sendAnnouncement(
      View.of(context),
      message,
      Directionality.of(context),
    );
  }

  Future<void> _create() async {
    final l10n = context.l10n;
    try {
      await _run(() async {
        final backup = await ref.read(backupRepositoryProvider).create();
        final name = await ref
            .read(documentsClientProvider)
            .save(
              name: backup.fileName,
              mimeType: BackupFormat.mimeType,
              bytes: backup.bytes,
            );
        if (name == null) return;
        await ref
            .read(settingsControllerProvider.notifier)
            .recordBackup(
              LastBackup(
                at: DateTime.now().toUtc(),
                sessions: backup.sessions,
                bytes: backup.bytes.length,
              ),
            );
        _say(l10n.backupSaved(name));
      });
    } on PlatformException {
      _say(l10n.backupErrorIo);
    }
  }

  Future<void> _exportCsv() async {
    final l10n = context.l10n;
    final locale = context.locale;
    final db = ref.read(appDatabaseProvider);
    final docs = ref.read(documentsClientProvider);
    final now = DateTime.now();
    try {
      await _run(() async {
        final sessions = await CsvExport.sessions(
          db,
          titleOf: (e) => entryTitle(l10n, e),
        );
        final first = await docs.save(
          name: CsvExport.sessionsFileName(now),
          mimeType: CsvExport.mimeType,
          bytes: CsvExport.bytes(sessions),
        );
        if (first == null) return;
        final sets = await CsvExport.sets(
          db,
          exerciseName: (e) => exerciseName(e, locale),
        );
        final second = await docs.save(
          name: CsvExport.setsFileName(now),
          mimeType: CsvExport.mimeType,
          bytes: CsvExport.bytes(sets),
        );
        if (second == null) return;
        _say(l10n.backupCsvSaved);
      });
    } on PlatformException {
      _say(l10n.backupErrorIo);
    }
  }

  Future<void> _restore() async {
    final l10n = context.l10n;
    final repo = ref.read(backupRepositoryProvider);
    try {
      if (await repo.hasActiveSession()) {
        _say(l10n.backupErrorActive);
        return;
      }
      final picked = await _run(() => ref.read(documentsClientProvider).open());
      if (picked == null || !mounted) return;
      final file = repo.read(picked.bytes);
      final ok = await _confirm(file);
      if (ok != true) return;
      await _run(() => repo.restore(file));
      await ref.read(reminderControllerProvider.notifier).sync();
      _say(l10n.backupRestored);
    } on BackupException catch (e) {
      _say(switch (e.error) {
        BackupError.invalid => l10n.backupErrorInvalid,
        BackupError.newerVersion => l10n.backupErrorNewer,
        BackupError.integrity => l10n.backupErrorIntegrity,
        BackupError.activeSession => l10n.backupErrorActive,
      });
    } on PlatformException {
      _say(l10n.backupErrorIo);
    }
  }

  Future<bool?> _confirm(BackupFile file) {
    final l10n = context.l10n;
    final s = file.summary;
    final db = ref.read(appDatabaseProvider);
    final date = DateFormat.yMMMd(
      context.locale.toLanguageTag(),
    ).format(s.createdAt.toLocal());
    return showTlDialog<bool>(
      context,
      key: const Key('restore-dialog'),
      icon: Icons.settings_backup_restore,
      title: l10n.backupRestoreTitle,
      body: [
        Text(
          l10n.backupRestoreSummary(
            date,
            l10n.backupSessions(s.sessions),
            l10n.backupRoutines(s.routines),
            l10n.backupWorkouts(s.intervalWorkouts),
          ),
          key: const Key('restore-summary'),
        ),
        const SizedBox(height: TlSpace.s3),
        if (file.schemaVersion < db.schemaVersion) ...[
          Text(l10n.backupRestoreOlder),
          const SizedBox(height: TlSpace.s3),
        ],
        Text(
          l10n.backupRestoreWarn,
          style: context.text.body.copyWith(color: context.colors.danger),
        ),
      ],
      actions: (pop) => [
        TlButton(
          key: const Key('restore-confirm'),
          label: l10n.backupRestoreConfirm,
          onPressed: () => pop(true),
        ),
        TlButton(
          key: const Key('restore-cancel'),
          label: l10n.dialogCancel,
          variant: TlButtonVariant.text,
          onPressed: () => pop(false),
        ),
      ],
    );
  }
}

/// Paso numerado de «Cómo guardarlo en Google Drive».
class _Step extends StatelessWidget {
  const _Step({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TlSpace.s1),
      child: MergeSemantics(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: TlSpace.s1),
              decoration: BoxDecoration(
                color: c.surface2,
                borderRadius: BorderRadius.circular(TlRadius.full),
              ),
              child: Text(
                context.l10n.numberValue(number),
                style: t.bodySm.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: TlSpace.s3),
            Expanded(child: Text(text, style: t.body)),
          ],
        ),
      ),
    );
  }
}
