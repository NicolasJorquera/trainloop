import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/pseudo_locale.dart';
import '../../../core/theme/accent.dart';
import '../../../core/units/weight_unit.dart';
import '../data/settings_repository.dart';
import '../domain/app_settings.dart';

/// Repositorio de preferencias. Se sobrescribe en `main` (y en las pruebas).
final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => throw UnimplementedError('Sobrescribir en ProviderScope'),
);

/// Estado vivo de las preferencias: cambiarlo repinta la app al instante.
final settingsControllerProvider =
    NotifierProvider<SettingsController, AppSettings>(SettingsController.new);

/// `--dart-define=TL_WEEK_VARIANT=separate|unified` fija la variante de la
/// vista semanal (prueba H5) por encima del ajuste guardado.
const String weekVariantDefine = String.fromEnvironment('TL_WEEK_VARIANT');

class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    var stored = ref.watch(settingsRepositoryProvider).load();
    if (weekVariantDefine.isNotEmpty) {
      stored = stored.copyWith(
        weekVariant: WeekVariant.fromName(weekVariantDefine),
      );
    }
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

  Future<void> setWeightUnit(WeightUnit unit) =>
      _update(state.copyWith(weightUnit: unit));

  Future<void> setWeekStart(WeekStart weekStart) =>
      _update(state.copyWith(weekStart: weekStart));

  Future<void> setSounds(bool on) => _update(state.copyWith(sounds: on));

  Future<void> setVoice(bool on) => _update(state.copyWith(voice: on));

  Future<void> setVibration(bool on) => _update(state.copyWith(vibration: on));

  Future<void> setWeeklyGoal(int goal) => _update(
    state.copyWith(
      weeklyGoal: goal.clamp(
        AppSettings.minWeeklyGoal,
        AppSettings.maxWeeklyGoal,
      ),
    ),
  );

  Future<void> setDefaultRest(int seconds) => _update(
    state.copyWith(
      defaultRestSeconds: seconds.clamp(
        AppSettings.minRest,
        AppSettings.maxRest,
      ),
    ),
  );

  /// Cierra el aviso de datos locales de Inicio (F-01).
  Future<void> dismissLocalDataNotice() =>
      _update(state.copyWith(localDataNoticeDismissed: true));

  /// Guarda cuándo se creó el último respaldo (S17).
  Future<void> recordBackup(LastBackup backup) =>
      _update(state.copyWith(lastBackup: backup));

  /// «Estadísticas de uso anónimas» (S16, D8).
  Future<void> setAnalytics(bool on) => _update(state.copyWith(analytics: on));

  /// Variante de la vista semanal (H5); solo desde depuración.
  Future<void> setWeekVariant(WeekVariant variant) =>
      _update(state.copyWith(weekVariant: variant));

  Future<void> _update(AppSettings next) async {
    if (next == state) return;
    state = next;
    await ref.read(settingsRepositoryProvider).save(next);
  }
}
