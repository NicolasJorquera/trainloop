import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as gma;

import '../../../data/db/enums.dart';
import '../domain/monetization_config.dart';

/// Lo que UMP sabe ahora (lectura local, sin red).
@immutable
class ConsentSnapshot {
  const ConsentSnapshot({
    required this.state,
    required this.canRequestAds,
    required this.privacyOptionsRequired,
  });

  static const unknown = ConsentSnapshot(
    state: ConsentStatus.unknown,
    canRequestAds: false,
    privacyOptionsRequired: false,
  );

  final ConsentStatus state;
  final bool canRequestAds;

  /// UMP pide ofrecer «Preferencias de privacidad» (EEE, Reino Unido,
  /// Suiza, estados de EE. UU. con ley).
  final bool privacyOptionsRequired;

  @override
  bool operator ==(Object other) =>
      other is ConsentSnapshot &&
      other.state == state &&
      other.canRequestAds == canRequestAds &&
      other.privacyOptionsRequired == privacyOptionsRequired;

  @override
  int get hashCode => Object.hash(state, canRequestAds, privacyOptionsRequired);

  @override
  String toString() =>
      'ConsentSnapshot($state, ads: $canRequestAds, '
      'options: $privacyOptionsRequired)';
}

/// Un banner ya cargado. Se descarta con [dispose].
abstract interface class LoadedBanner {
  Size get size;
  Widget build();
  void dispose();
}

/// Un intersticial ya cargado (R-A4: precargado). Vale una vez.
abstract interface class LoadedInterstitial {
  DateTime get loadedAt;

  /// Lo muestra y espera a que se cierre. `false` si no se pudo mostrar.
  Future<bool> show();
  void dispose();
}

/// Todo lo que habla con AdMob y UMP. Lo único de la app que usa la red
/// (NF-07), aislado aquí para poder reemplazarlo en las pruebas. Cualquier
/// método puede lanzar o tardar: quien lo llama lo trata como opcional.
abstract interface class AdsPlatform {
  /// Pide a UMP el estado del consentimiento (necesita red) y, si
  /// [allowForm] y hace falta, muestra el formulario. Devuelve lo que queda.
  Future<ConsentSnapshot> gatherConsent({required bool allowForm});

  /// Lo último que UMP guardó en el teléfono, sin red.
  Future<ConsentSnapshot> currentConsent();

  /// Abre «Preferencias de privacidad» de UMP.
  Future<ConsentSnapshot> showPrivacyOptions();

  /// Inicia el SDK de anuncios. Solo después de que UMP lo permita.
  Future<void> initialize();

  /// Carga un banner adaptativo anclado del ancho dado; `null` si no hay.
  Future<LoadedBanner?> loadBanner({
    required int width,
    required Orientation orientation,
  });

  /// Carga un intersticial; `null` si no hay.
  Future<LoadedInterstitial?> loadInterstitial();
}

/// [AdsPlatform] con google_mobile_ads (AdMob + UMP).
class GoogleAdsPlatform implements AdsPlatform {
  GoogleAdsPlatform(this.config);

  final MonetizationConfig config;

  static const _consentTimeout = Duration(seconds: 20);
  static const _loadTimeout = Duration(seconds: 45);

  @override
  Future<ConsentSnapshot> gatherConsent({required bool allowForm}) async {
    final done = Completer<void>();
    gma.ConsentInformation.instance.requestConsentInfoUpdate(
      gma.ConsentRequestParameters(consentDebugSettings: _debugSettings()),
      () async {
        try {
          if (allowForm) {
            await gma.ConsentForm.loadAndShowConsentFormIfRequired((_) {});
          }
        } finally {
          if (!done.isCompleted) done.complete();
        }
      },
      (error) {
        if (!done.isCompleted) {
          done.completeError(StateError('UMP: ${error.message}'));
        }
      },
    );
    await done.future.timeout(_consentTimeout);
    return currentConsent();
  }

  gma.ConsentDebugSettings? _debugSettings() {
    final geography = switch (config.umpDebugGeography) {
      'eea' => gma.DebugGeography.debugGeographyEea,
      'us' => gma.DebugGeography.debugGeographyRegulatedUsState,
      'other' => gma.DebugGeography.debugGeographyOther,
      _ => null,
    };
    if (geography == null) return null;
    return gma.ConsentDebugSettings(
      debugGeography: geography,
      testIdentifiers: config.umpTestDeviceIds,
    );
  }

  @override
  Future<ConsentSnapshot> currentConsent() async {
    final info = gma.ConsentInformation.instance;
    final status = await info.getConsentStatus();
    final options = await info.getPrivacyOptionsRequirementStatus();
    return ConsentSnapshot(
      state: switch (status) {
        gma.ConsentStatus.notRequired => ConsentStatus.notRequired,
        gma.ConsentStatus.obtained => ConsentStatus.obtained,
        gma.ConsentStatus.required => ConsentStatus.required,
        gma.ConsentStatus.unknown => ConsentStatus.unknown,
      },
      canRequestAds: await info.canRequestAds(),
      privacyOptionsRequired:
          options == gma.PrivacyOptionsRequirementStatus.required,
    );
  }

  @override
  Future<ConsentSnapshot> showPrivacyOptions() async {
    final done = Completer<void>();
    await gma.ConsentForm.showPrivacyOptionsForm((_) {
      if (!done.isCompleted) done.complete();
    });
    await done.future;
    return currentConsent();
  }

  @override
  Future<void> initialize() async {
    // R-A8: público mayor de 13 años, anuncios hasta clasificación T.
    await gma.MobileAds.instance.updateRequestConfiguration(
      gma.RequestConfiguration(
        maxAdContentRating: gma.MaxAdContentRating.t,
        testDeviceIds: config.adTestDeviceIds,
      ),
    );
    await gma.MobileAds.instance.initialize();
  }

  @override
  Future<LoadedBanner?> loadBanner({
    required int width,
    required Orientation orientation,
  }) async {
    final size =
        await gma.AdSize.getLargeAnchoredAdaptiveBannerAdSizeWithOrientation(
          orientation,
          width,
        );
    if (size == null) return null;
    final result = Completer<LoadedBanner?>();
    final ad = gma.BannerAd(
      adUnitId: config.bannerUnitId,
      size: size,
      request: const gma.AdRequest(),
      listener: gma.BannerAdListener(
        onAdLoaded: (ad) {
          if (!result.isCompleted) {
            result.complete(_GoogleBanner(ad as gma.BannerAd, size));
          }
        },
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          if (!result.isCompleted) result.complete(null);
        },
      ),
    );
    await ad.load();
    return result.future.timeout(
      _loadTimeout,
      onTimeout: () {
        ad.dispose();
        return null;
      },
    );
  }

  @override
  Future<LoadedInterstitial?> loadInterstitial() async {
    final result = Completer<LoadedInterstitial?>();
    await gma.InterstitialAd.load(
      adUnitId: config.interstitialUnitId,
      request: const gma.AdRequest(),
      adLoadCallback: gma.InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          if (!result.isCompleted) result.complete(_GoogleInterstitial(ad));
        },
        onAdFailedToLoad: (_) {
          if (!result.isCompleted) result.complete(null);
        },
      ),
    );
    return result.future.timeout(_loadTimeout, onTimeout: () => null);
  }
}

class _GoogleBanner implements LoadedBanner {
  _GoogleBanner(this._ad, this._size);

  final gma.BannerAd _ad;
  final gma.AdSize _size;

  @override
  Size get size => Size(_size.width.toDouble(), _size.height.toDouble());

  @override
  Widget build() => gma.AdWidget(ad: _ad);

  @override
  void dispose() => _ad.dispose();
}

class _GoogleInterstitial implements LoadedInterstitial {
  _GoogleInterstitial(this._ad) : loadedAt = DateTime.now();

  final gma.InterstitialAd _ad;

  @override
  final DateTime loadedAt;

  @override
  Future<bool> show() async {
    final closed = Completer<bool>();
    _ad.fullScreenContentCallback = gma.FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        if (!closed.isCompleted) closed.complete(true);
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        if (!closed.isCompleted) closed.complete(false);
      },
    );
    await _ad.show();
    return closed.future;
  }

  @override
  void dispose() => _ad.dispose();
}
