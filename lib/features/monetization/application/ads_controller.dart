import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../data/db/app_database.dart';
import '../../../data/db/database_providers.dart';
import '../../../data/db/enums.dart';
import '../../analytics/application/analytics_service.dart';
import '../data/ads_platform.dart';
import '../domain/monetization_config.dart';

/// Configuración del build (`--dart-define`). Las pruebas la sobrescriben.
final monetizationConfigProvider = Provider<MonetizationConfig>(
  (ref) => MonetizationConfig.fromEnvironment(),
);

/// AdMob + UMP. Las pruebas lo sobrescriben con un doble.
final adsPlatformProvider = Provider<AdsPlatform>(
  (ref) => GoogleAdsPlatform(ref.watch(monetizationConfigProvider)),
);

/// Google Play Billing. Las pruebas lo sobrescriben con un doble.
final inAppPurchaseProvider = Provider<InAppPurchase>(
  (ref) => InAppPurchase.instance,
);

/// Estado del consentimiento y del SDK de anuncios.
@immutable
class AdsState {
  const AdsState({
    this.consent = ConsentSnapshot.unknown,
    this.sdkReady = false,
    this.consentChecked = false,
  });

  final ConsentSnapshot consent;

  /// SDK iniciado (solo después de que UMP lo permite).
  final bool sdkReady;

  /// UMP respondió con red al menos una vez en este arranque.
  final bool consentChecked;

  /// Se pueden pedir anuncios.
  bool get ready => sdkReady && consent.canRequestAds;

  AdsState copyWith({
    ConsentSnapshot? consent,
    bool? sdkReady,
    bool? consentChecked,
  }) => AdsState(
    consent: consent ?? this.consent,
    sdkReady: sdkReady ?? this.sdkReady,
    consentChecked: consentChecked ?? this.consentChecked,
  );

  @override
  bool operator ==(Object other) =>
      other is AdsState &&
      other.consent == consent &&
      other.sdkReady == sdkReady &&
      other.consentChecked == consentChecked;

  @override
  int get hashCode => Object.hash(consent, sdkReady, consentChecked);

  @override
  String toString() =>
      'AdsState($consent, sdk: $sdkReady, checked: $consentChecked)';
}

final adsControllerProvider = NotifierProvider<AdsController, AdsState>(
  AdsController.new,
);

/// Consentimiento (UMP, R-A7) y arranque del SDK, en ese orden: no se pide
/// ningún anuncio antes de que UMP lo permita. Sin red, sin consentimiento o
/// con cualquier error, el estado queda «sin anuncios» y la app sigue igual
/// (nunca muestra un error por esto, NF-05).
class AdsController extends Notifier<AdsState> {
  Future<void>? _running;

  AdsPlatform get _platform => ref.read(adsPlatformProvider);

  @override
  AdsState build() => const AdsState();

  /// Al abrir la app (y al volver, mientras UMP no haya respondido).
  /// [allowForm] es `false` si hay una sesión abierta: el formulario espera.
  /// Las llamadas se encadenan: una con formulario no se pierde detrás de
  /// otra sin él.
  Future<void> start({required bool allowForm}) {
    final previous = _running ?? Future<void>.value();
    late final Future<void> run;
    run = previous.then((_) => _start(allowForm)).whenComplete(() {
      if (identical(_running, run)) _running = null;
    });
    return _running = run;
  }

  Future<void> _start(bool allowForm) async {
    if (!ref.read(monetizationConfigProvider).adsEnabled) return;
    var snapshot = await _safe(
      () => _platform.gatherConsent(allowForm: allowForm),
    );
    final checked = snapshot != null;
    // Sin red: lo que UMP guardó la última vez (puede permitir anuncios).
    snapshot ??= await _safe(_platform.currentConsent);
    _apply(snapshot ?? ConsentSnapshot.unknown, checked: checked);
    await _initializeIfAllowed();
  }

  /// «Preferencias de privacidad» (S16): vuelve a abrir el formulario.
  Future<void> showPrivacyOptions() async {
    final snapshot = await _safe(_platform.showPrivacyOptions);
    if (snapshot != null) _apply(snapshot, checked: true);
    await _initializeIfAllowed();
  }

  void _apply(ConsentSnapshot snapshot, {required bool checked}) {
    state = state.copyWith(
      consent: snapshot,
      consentChecked: state.consentChecked || checked,
    );
    ref
        .read(analyticsConsentProvider.notifier)
        .set(
          snapshot.state == ConsentStatus.notRequired ||
              snapshot.state == ConsentStatus.obtained,
        );
    unawaited(
      _safe(
        () => ref
            .read(adStateDaoProvider)
            .write(AdStatesCompanion(consentStatus: Value(snapshot.state))),
      ),
    );
  }

  Future<void> _initializeIfAllowed() async {
    if (state.sdkReady || !state.consent.canRequestAds) return;
    final ok = await _safe(() async {
      await _platform.initialize();
      return true;
    });
    if (ok ?? false) state = state.copyWith(sdkReady: true);
  }

  static Future<T?> _safe<T>(Future<T> Function() f) async {
    try {
      return await f();
    } catch (e) {
      if (kDebugMode) debugPrint('[ads] $e');
      return null;
    }
  }
}
