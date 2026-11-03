import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/pseudo_locale.dart';
import '../../../core/theme/accent.dart';
import '../data/settings_repository.dart';
import '../domain/app_settings.dart';

/// Repositorio de preferencias. Se sobrescribe en `main` (y en las pruebas).
final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => throw UnimplementedError('Sobrescribir en ProviderScope'),
);

/// Estado vivo de las preferencias: cambiarlo repinta la app al instante.
final settingsControllerProvider =
    NotifierProvider<SettingsController, AppSettings>(SettingsController.new);

class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    final stored = ref.watch(settingsRepositoryProvider).load();
    if (pseudoLocaleForced) {
      return stored.copyWith(language: AppLanguage.pseudo);
    }
    // El pseudo-locale nunca sobrevive en un build de release.
    if (!kDebugMode && stored.language == AppLanguage.pseudo) {
      return stored.copyWith(language: AppLanguage.system);
    }
    return stored;
  }

  Future<void> setTheme(ThemePreference theme) =>
      _update(state.copyWith(theme: theme));

  Future<void> setAccent(AccentPreset accent) =>
      _update(state.copyWith(accent: accent));

  Future<void> setLanguage(AppLanguage language) =>
      _update(state.copyWith(language: language));

  Future<void> _update(AppSettings next) async {
    if (next == state) return;
    state = next;
    await ref.read(settingsRepositoryProvider).save(next);
  }
}
