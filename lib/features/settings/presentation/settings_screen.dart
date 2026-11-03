import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/l10n/pseudo_locale.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/accent.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/accent_picker.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/section_label.dart';
import '../../../core/widgets/tab_page.dart';
import '../../../core/widgets/tl_segmented_control.dart';
import '../application/settings_controller.dart';
import '../domain/app_settings.dart';
import 'debug_database_section.dart';

/// S16 Configuración (mínima en D1): tema, acento e idioma.
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
          if (kDebugMode) const DebugDatabaseSection(),
        ],
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
