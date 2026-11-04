import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/database_providers.dart';
import '../../../data/db/enums.dart';
import '../../analytics/application/analytics_service.dart';
import '../data/ad_history_repository.dart';
import '../data/ads_platform.dart';
import '../domain/interstitial_policy.dart';
import 'ad_guard_provider.dart';
import 'ads_controller.dart';

final adHistoryRepositoryProvider = Provider<AdHistoryRepository>(
  (ref) => AdHistoryRepository(ref.watch(appDatabaseProvider)),
);

/// Sesiones que pasaron por la recuperación en este arranque (R-A5).
final recoveredSessionsProvider =
    NotifierProvider<RecoveredSessions, Set<String>>(RecoveredSessions.new);

class RecoveredSessions extends Notifier<Set<String>> {
  @override
  Set<String> build() => const {};

  void add(String id) => state = {...state, id};
}

/// Resultado de cerrar un resumen con «Listo» (para pruebas y registro).
enum InterstitialOutcome { shown, skipped, notLoaded, blocked, failed }

final interstitialControllerProvider =
    NotifierProvider<InterstitialController, bool>(InterstitialController.new);

/// Intersticial S20: experimento apagado por defecto
/// (`--dart-define=TL_INTERSTITIAL=on`). Estado: hay uno precargado.
///
/// * Se precarga (R-A4) cuando el experimento está activo, hay
///   consentimiento y SDK, y la persona no compró «Sin anuncios».
/// * Solo se ofrece desde [afterSummaryDone], que llaman los resúmenes al
///   tocar «Listo» (R-A2: nunca automáticamente). Pasa por el guard central
///   y por [InterstitialPolicy]; si no está cargado, no se muestra y no se
///   espera.
class InterstitialController extends Notifier<bool> {
  LoadedInterstitial? _ad;
  bool _loading = false;

  /// Un intersticial cargado caduca a la hora (AdMob).
  static const _maxAge = Duration(minutes: 55);

  @override
  bool build() {
    ref.onDispose(() => _ad?.dispose());
    ref.listen(
      adGuardInputsProvider.select((i) => i.adsReady && i.adsRemoved == false),
      (_, ok) => ok ? unawaited(preload()) : _drop(),
      fireImmediately: true,
    );
    return false;
  }

  bool get _experimentOn =>
      ref.read(monetizationConfigProvider).interstitialExperiment;

  /// Carga uno si hace falta. Nunca lanza.
  Future<void> preload() async {
    if (!_experimentOn || _loading) return;
    final inputs = ref.read(adGuardInputsProvider);
    if (!inputs.adsReady || inputs.adsRemoved != false) return;
    final current = _ad;
    if (current != null) {
      if (DateTime.now().difference(current.loadedAt) < _maxAge) return;
      _drop();
    }
    _loading = true;
    try {
      final ad = await ref.read(adsPlatformProvider).loadInterstitial();
      if (!ref.mounted) {
        ad?.dispose();
        return;
      }
      _ad = ad;
      state = ad != null;
    } catch (e) {
      if (kDebugMode) debugPrint('[ads] interstitial: $e');
    } finally {
      _loading = false;
    }
  }

  void _drop() {
    if (_ad == null) return;
    _ad?.dispose();
    _ad = null;
    if (ref.mounted) state = false;
  }

  /// La persona tocó «Listo» en el resumen de [sessionId] y salió de él.
  /// Cuenta la sesión para los topes, registra el fin de sesión y, si todo
  /// lo permite, muestra el intersticial.
  Future<InterstitialOutcome> afterSummaryDone(String sessionId) async {
    try {
      final repo = ref.read(adHistoryRepositoryProvider);
      final session = await repo.session(sessionId);
      if (session == null) return InterstitialOutcome.skipped;
      final seconds = AdHistoryRepository.activeSeconds(session);
      ref
          .read(analyticsServiceProvider)
          .log(
            AnalyticsEvent.sessionFinished(
              session.kind == SessionKind.intervals
                  ? SessionKindParam.intervals
                  : SessionKindParam.strength,
              completed: session.status == SessionStatus.completed,
              activeSeconds: seconds,
            ),
          );
      if (session.status == SessionStatus.completed) {
        await repo.countSession();
      }
      if (!_experimentOn) return InterstitialOutcome.skipped;

      final skip = InterstitialPolicy.check(
        experimentOn: _experimentOn,
        capsOn: ref.read(monetizationConfigProvider).interstitialCaps,
        session: FinishedSession(
          status: session.status,
          activeSeconds: seconds,
          recovered: ref.read(recoveredSessionsProvider).contains(sessionId),
        ),
        history: await repo.history(),
        now: DateTime.now(),
      );
      if (skip != null) return InterstitialOutcome.skipped;

      // Se decide con la pantalla ya fuera del resumen (R-A1).
      await _nextFrame();
      if (!ref.mounted) return InterstitialOutcome.blocked;
      if (!ref.read(interstitialDecisionProvider).allowed) {
        return InterstitialOutcome.blocked;
      }
      final ad = _ad;
      if (ad == null) {
        unawaited(preload());
        return InterstitialOutcome.notLoaded;
      }
      _ad = null;
      state = false;
      final shown = await ad.show();
      if (shown) await repo.markShown();
      unawaited(preload());
      return shown ? InterstitialOutcome.shown : InterstitialOutcome.failed;
    } catch (e) {
      if (kDebugMode) debugPrint('[ads] after summary: $e');
      return InterstitialOutcome.failed;
    }
  }

  static Future<void> _nextFrame() {
    final done = Completer<void>();
    SchedulerBinding.instance
      ..addPostFrameCallback((_) => done.complete())
      ..scheduleFrame();
    return done.future;
  }
}
