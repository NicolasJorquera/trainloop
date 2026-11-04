import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/l10n/pseudo_locale.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/accent.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/units/weight_unit.dart';
import '../../../core/widgets/accent_picker.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/section_label.dart';
import '../../../core/widgets/tab_page.dart';
import '../../../core/widgets/tl_button.dart';
import '../../../core/widgets/tl_segmented_control.dart';
import '../../../core/widgets/tl_stepper.dart';
import '../../diagnostics/presentation/error_log_row.dart';
import '../../intervals/application/interval_providers.dart';
import '../../monetization/presentation/monetization_settings.dart';
import '../../reminders/presentation/reminder_section.dart';
import '../application/settings_controller.dart';
import '../domain/app_settings.dart';
import 'debug_database_section.dart';

/// S16 Configuración: tema, acento, idioma, entrenamiento (unidad, inicio
/// de semana, objetivo y descanso por defecto), recordatorios (F-13),
/// alertas con «Probar sonido», datos y privacidad (aviso, enlace a S17,
/// analítica y preferencias de privacidad) y la compra «Sin anuncios» (D8).
/// Pantalla crítica: sin anuncios.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);
    final help = t.bodySm.copyWith(color: c.inkMuted);

    return Scaffold(
      body: TabPage(
        children: [
          ScreenHeader(
            title: l10n.settingsTitle,
            leading: IconButton(
              key: const Key('settings-back'),
              tooltip: l10n.backTooltip,
              icon: const Icon(Icons.arrow_back),
              onPressed: () =>
                  context.canPop() ? context.pop() : context.go(Routes.home),
            ),
          ),
          SectionLabel(l10n.settingsAppearance),
          TlSegmentedControl<ThemePreference>(
            semanticLabel: l10n.settingsAppearance,
            selected: settings.theme,
            onChanged: controller.setTheme,
            segments: [
              TlSegment(ThemePreference.system, l10n.themeSystem),
              TlSegment(ThemePreference.light, l10n.themeLight),
              TlSegment(ThemePreference.dark, l10n.themeDark),
            ],
          ),
          SectionLabel(l10n.settingsAccent),
          AccentPicker(
            selected: settings.accent,
            onChanged: controller.setAccent,
            labelOf: (a) => accentLabel(l10n, a),
            selectedHint: l10n.selectedLabel,
          ),
          const SizedBox(height: TlSpace.s3),
          Text(l10n.accentHelp, style: help),
          const SizedBox(height: TlSpace.s3),
          PhasePreview(workLabel: l10n.phaseWork, restLabel: l10n.phaseRest),
          SectionLabel(l10n.settingsLanguage),
          for (final lang in AppLanguage.values)
            if (lang != AppLanguage.pseudo || pseudoLocaleAvailable)
              _OptionRow(
                key: ValueKey('language-${lang.name}'),
                label: languageLabel(l10n, lang),
                selected: settings.language == lang,
                selectedHint: l10n.selectedLabel,
                onTap: () => controller.setLanguage(lang),
              ),
          const SizedBox(height: TlSpace.s2),
          Text(l10n.languageHelp, style: help),
          SectionLabel(l10n.settingsTraining),
          Text(l10n.settingsUnits, style: t.body),
          const SizedBox(height: TlSpace.s2),
          TlSegmentedControl<WeightUnit>(
            key: const Key('settings-units'),
            semanticLabel: l10n.settingsUnits,
            selected: settings.weightUnit,
            onChanged: controller.setWeightUnit,
            segments: [
              TlSegment(WeightUnit.kg, l10n.unitKg.toUpperCase()),
              TlSegment(WeightUnit.lb, l10n.unitLb.toUpperCase()),
            ],
          ),
          const SizedBox(height: TlSpace.s2),
          Text(l10n.settingsUnitsHelp, style: help),
          const SizedBox(height: TlSpace.s4),
          Text(l10n.settingsWeekStart, style: t.body),
          const SizedBox(height: TlSpace.s2),
          TlSegmentedControl<WeekStart>(
            key: const Key('settings-week-start'),
            semanticLabel: l10n.settingsWeekStart,
            selected: settings.weekStart,
            onChanged: controller.setWeekStart,
            segments: [
              TlSegment(WeekStart.monday, l10n.settingsMonday),
              TlSegment(WeekStart.sunday, l10n.settingsSunday),
            ],
          ),
          const SizedBox(height: TlSpace.s4),
          TlStepper(
            key: const Key('settings-goal'),
            label: l10n.settingsWeeklyGoal,
            value: l10n.numberValue(settings.weeklyGoal),
            decreaseTooltip: l10n.settingsGoalLess,
            increaseTooltip: l10n.settingsGoalMore,
            onDecrease: settings.weeklyGoal > AppSettings.minWeeklyGoal
                ? () => controller.setWeeklyGoal(settings.weeklyGoal - 1)
                : null,
            onIncrease: settings.weeklyGoal < AppSettings.maxWeeklyGoal
                ? () => controller.setWeeklyGoal(settings.weeklyGoal + 1)
                : null,
          ),
          TlStepper(
            key: const Key('settings-rest'),
            label: l10n.settingsDefaultRest,
            value: l10n.duration(settings.defaultRestSeconds),
            decreaseTooltip: l10n.settingsRestLess,
            increaseTooltip: l10n.settingsRestMore,
            onDecrease: settings.defaultRestSeconds > AppSettings.minRest
                ? () => controller.setDefaultRest(
                    settings.defaultRestSeconds - AppSettings.restStep,
                  )
                : null,
            onIncrease: settings.defaultRestSeconds < AppSettings.maxRest
                ? () => controller.setDefaultRest(
                    settings.defaultRestSeconds + AppSettings.restStep,
                  )
                : null,
          ),
          Text(l10n.settingsDefaultRestHelp, style: help),
          const ReminderSection(),
          SectionLabel(l10n.settingsAlerts),
          _AlertSwitch(
            key: const Key('alert-voice'),
            title: l10n.settingsVoice,
            help: l10n.settingsVoiceHelp,
            value: settings.voice,
            onChanged: controller.setVoice,
          ),
          _AlertSwitch(
            key: const Key('alert-beeps'),
            title: l10n.settingsBeeps,
            help: l10n.settingsBeepsHelp,
            value: settings.sounds,
            onChanged: controller.setSounds,
          ),
          _AlertSwitch(
            key: const Key('alert-vibration'),
            title: l10n.settingsVibration,
            help: l10n.settingsVibrationHelp,
            value: settings.vibration,
            onChanged: controller.setVibration,
          ),
          const SizedBox(height: TlSpace.s2),
          TlButton(
            key: const Key('settings-test-sound'),
            label: l10n.settingsTestSound,
            icon: Icons.volume_up_outlined,
            variant: TlButtonVariant.secondary,
            onPressed: () => ref
                .read(timerEngineClientProvider)
                .testAlert(
                  sounds: settings.sounds,
                  voice: settings.voice,
                  vibration: settings.vibration,
                  speech: l10n.settingsTestSpeech,
                  localeTag: context.locale.toLanguageTag(),
                ),
          ),
          SectionLabel(l10n.settingsData),
          const _DataNotice(),
          _LinkRow(
            key: const Key('settings-backup'),
            label: l10n.settingsBackupLink,
            meta: _backupMeta(l10n, settings.lastBackup),
            onTap: () => context.push(Routes.backup),
          ),
          const PrivacySettingsRows(),
          const ErrorLogRow(),
          const SizedBox(height: TlSpace.s4),
          const RemoveAdsCard(),
          if (kDebugMode) const DebugDatabaseSection(),
        ],
      ),
    );
  }
}

/// «último: hace 12 días» o «sin respaldos».
String _backupMeta(AppLocalizations l10n, LastBackup? last) {
  if (last == null) return l10n.settingsBackupNever;
  final days = DateTime.now().difference(last.at.toLocal()).inDays;
  return l10n.settingsBackupAgo(days < 0 ? 0 : days);
}

/// Aviso de S16: los datos están solo en este teléfono.
class _DataNotice extends StatelessWidget {
  const _DataNotice();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(TlSpace.s3),
      decoration: BoxDecoration(
        color: c.surface1,
        borderRadius: BorderRadius.circular(TlRadius.md),
        border: Border(left: BorderSide(color: c.warning, width: 4)),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: l10n.settingsDataWarnTitle,
              style: t.body.copyWith(fontWeight: FontWeight.w600),
            ),
            const TextSpan(text: ' '),
            TextSpan(text: l10n.settingsDataWarnBody),
          ],
        ),
        style: t.body,
      ),
    );
  }
}

/// Fila que abre otra pantalla, con un dato a la derecha.
class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.label,
    required this.meta,
    required this.onTap,
    super.key,
  });

  final String label;
  final String meta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return MergeSemantics(
      child: Semantics(
        button: true,
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: TlSize.touchMin),
            padding: const EdgeInsets.symmetric(vertical: TlSpace.s3),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: c.line)),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: TlSpace.s2,
              children: [
                Text(label, style: t.body),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        meta,
                        style: t.bodySm.copyWith(color: c.inkMuted),
                      ),
                    ),
                    Icon(Icons.chevron_right, color: c.inkMuted),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String accentLabel(AppLocalizations l10n, AccentPreset accent) =>
    switch (accent) {
      AccentPreset.orquidea => l10n.accentOrquidea,
      AccentPreset.rosa => l10n.accentRosa,
      AccentPreset.rojo => l10n.accentRojo,
      AccentPreset.naranja => l10n.accentNaranja,
      AccentPreset.amarillo => l10n.accentAmarillo,
      AccentPreset.lima => l10n.accentLima,
      AccentPreset.azul => l10n.accentAzul,
      AccentPreset.violeta => l10n.accentVioleta,
    };

String languageLabel(AppLocalizations l10n, AppLanguage language) =>
    switch (language) {
      AppLanguage.system => l10n.languageSystem,
      AppLanguage.es => l10n.languageSpanish,
      AppLanguage.en => l10n.languageEnglish,
      AppLanguage.ptBR => l10n.languagePortuguese,
      AppLanguage.pseudo => l10n.languagePseudo,
    };

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.label,
    required this.selected,
    required this.selectedHint,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final String selectedHint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      selected: selected,
      hint: selected ? selectedHint : null,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: TlSize.touchMin),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: c.line)),
          ),
          padding: const EdgeInsets.symmetric(vertical: TlSpace.s2),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: context.text.body.copyWith(
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (selected) Icon(Icons.check, color: c.accent, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

/// Interruptor de un aviso del temporizador (S16, ALERTAS).
class _AlertSwitch extends StatelessWidget {
  const _AlertSwitch({
    required this.title,
    required this.help,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String title;
  final String help;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => SwitchListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(title, style: context.text.body),
    subtitle: Text(
      help,
      style: context.text.bodySm.copyWith(color: context.colors.inkMuted),
    ),
    value: value,
    onChanged: onChanged,
  );
}
