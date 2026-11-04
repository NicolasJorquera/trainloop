import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/data/db/enums.dart';
import 'package:trainloop/features/analytics/domain/analytics_service.dart';
import 'package:trainloop/features/monetization/domain/ad_guard.dart';
import 'package:trainloop/features/monetization/domain/interstitial_policy.dart';

AdGuardInputs inputs({
  bool? adsRemoved = false,
  bool adsEnabled = true,
  bool adsReady = true,
  bool sessionActive = false,
  bool timerRunning = false,
  bool loggingSets = false,
  bool summaryOpen = false,
  bool criticalStep = false,
  String path = '/home',
}) => AdGuardInputs(
  adsRemoved: adsRemoved,
  adsEnabled: adsEnabled,
  adsReady: adsReady,
  sessionActive: sessionActive,
  timerRunning: timerRunning,
  loggingSets: loggingSets,
  summaryOpen: summaryOpen,
  criticalStep: criticalStep,
  path: path,
);

void main() {
  group('guard central (R-A1, R-A11)', () {
    const tabs = BannerPlacement.tabs;

    test('permite el banner solo en pantallas de consulta', () {
      for (final path in ['/home', '/train', '/history', '/progress']) {
        expect(decideAd(inputs(path: path), banner: tabs).allowed, isTrue);
      }
      expect(
        decideAd(
          inputs(path: '/exercises'),
          banner: BannerPlacement.library,
        ).allowed,
        isTrue,
      );
      for (final path in [
        '/templates/tabata', // S03
        '/intervals/new', // S04
        '/routines/abc', // S07
        '/settings',
        '/settings/backup',
        '/history/abc', // S13
        '/exercises',
      ]) {
        expect(
          decideAd(inputs(path: path), banner: tabs).reason,
          AdBlockReason.screenNotAllowed,
          reason: path,
        );
      }
    });

    test('la sesión manda sobre todo, también en una pantalla permitida', () {
      expect(
        decideAd(inputs(sessionActive: true), banner: tabs).reason,
        AdBlockReason.sessionActive,
      );
      expect(
        decideAd(inputs(timerRunning: true)).reason,
        AdBlockReason.timerRunning,
      );
      expect(
        decideAd(inputs(loggingSets: true)).reason,
        AdBlockReason.loggingSets,
      );
      expect(
        decideAd(inputs(summaryOpen: true)).reason,
        AdBlockReason.summaryOpen,
      );
      expect(
        decideAd(inputs(criticalStep: true), banner: tabs).reason,
        AdBlockReason.criticalStep,
      );
      for (final path in ['/timer', '/strength']) {
        expect(
          decideAd(inputs(path: path)).reason,
          AdBlockReason.sessionActive,
        );
      }
      for (final path in ['/sessions/x/summary', '/strength/x/summary']) {
        expect(decideAd(inputs(path: path)).reason, AdBlockReason.summaryOpen);
      }
    });

    test('compra, consentimiento y SDK', () {
      expect(
        decideAd(inputs(adsRemoved: true)).reason,
        AdBlockReason.adsRemoved,
      );
      // Mientras no se leyó el estado guardado, no se muestra.
      expect(
        decideAd(inputs(adsRemoved: null)).reason,
        AdBlockReason.adsRemoved,
      );
      expect(
        decideAd(inputs(adsEnabled: false)).reason,
        AdBlockReason.disabled,
      );
      expect(decideAd(inputs(adsReady: false)).reason, AdBlockReason.notReady);
    });

    test('el intersticial solo sobre una pantalla de consulta', () {
      expect(decideAd(inputs()).allowed, isTrue);
      expect(
        decideAd(inputs(path: '/templates/tabata')).reason,
        AdBlockReason.screenNotAllowed,
      );
    });
  });

  group('intersticial (R-A2, R-A3, R-A5)', () {
    final now = DateTime(2026, 11, 3, 18);
    const done = FinishedSession(
      status: SessionStatus.completed,
      activeSeconds: 5 * 60,
      recovered: false,
    );
    final veteran = InterstitialHistory(
      completedSessions: 10,
      firstSessionAt: now.subtract(const Duration(days: 30)),
      sessionsSinceInterstitial: 3,
      lastInterstitialAt: now.subtract(const Duration(days: 2)),
    );

    InterstitialSkip? check({
      bool flag = true,
      bool caps = true,
      FinishedSession session = done,
      InterstitialHistory? history,
    }) => InterstitialPolicy.check(
      experimentOn: flag,
      capsOn: caps,
      session: session,
      history: history ?? veteran,
      now: now,
    );

    test('apagado por defecto; con el indicador, 5 min completada', () {
      expect(check(flag: false), InterstitialSkip.flagOff);
      expect(check(), isNull);
      expect(
        check(
          session: const FinishedSession(
            status: SessionStatus.completed,
            activeSeconds: 5 * 60 - 1,
            recovered: false,
          ),
        ),
        InterstitialSkip.tooShort,
      );
    });

    test('nunca tras incompletas, descartadas ni recuperadas', () {
      for (final status in [
        SessionStatus.incomplete,
        SessionStatus.discarded,
        SessionStatus.recoveryPending,
      ]) {
        expect(
          check(
            session: FinishedSession(
              status: status,
              activeSeconds: 3600,
              recovered: false,
            ),
          ),
          InterstitialSkip.notCompleted,
        );
      }
      expect(
        check(
          session: const FinishedSession(
            status: SessionStatus.completed,
            activeSeconds: 3600,
            recovered: true,
          ),
        ),
        InterstitialSkip.recovered,
      );
    });

    test('topes: primeras 5 sesiones, 7 días, 1 cada 3 y 1 por día', () {
      InterstitialHistory h({
        int completed = 10,
        int days = 30,
        int since = 3,
        Duration? last = const Duration(days: 2),
      }) => InterstitialHistory(
        completedSessions: completed,
        firstSessionAt: now.subtract(Duration(days: days)),
        sessionsSinceInterstitial: since,
        lastInterstitialAt: last == null ? null : now.subtract(last),
      );
      expect(check(history: h(completed: 5)), InterstitialSkip.firstSessions);
      expect(check(history: h(completed: 6)), isNull);
      expect(check(history: h(days: 6)), InterstitialSkip.firstDays);
      expect(check(history: h(since: 2)), InterstitialSkip.everyThirdSession);
      expect(
        check(history: h(last: const Duration(hours: 1))),
        InterstitialSkip.oncePerDay,
      );
      expect(check(history: h(last: null, since: 0)), isNull);
      // Para QA (`TL_INTERSTITIAL_CAPS=off`) los topes no se aplican.
      expect(check(caps: false, history: h(completed: 1, days: 0)), isNull);
    });
  });

  test('analítica: solo tramos y tipos, nunca datos del entrenamiento', () {
    final e = AnalyticsEvent.sessionFinished(
      SessionKindParam.strength,
      completed: true,
      activeSeconds: 47 * 60 + 13,
    );
    expect(e.name, 'session_complete');
    expect(e.params, {
      'type': 'strength',
      'completed': 'yes',
      'duration': '30_60',
    });
    expect(AnalyticsEvent.durationBucket(299), 'lt5');
    expect(AnalyticsEvent.durationBucket(3600), 'gte60');
  });
}
