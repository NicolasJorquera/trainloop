/// Configuración de anuncios, compra y experimentos (D8, F-15).
///
/// Todo se cambia en el build con `--dart-define`, sin tocar código. Los
/// valores por defecto son los IDs de PRUEBA oficiales de Google: nunca
/// generan ingresos ni cuentan como clics reales. Los IDs reales los entrega
/// Gestión cuando exista la cuenta de AdMob (ver README, «Anuncios»).
///
/// El App ID de AdMob no va aquí: lo lee el SDK nativo del manifiesto y se
/// configura en `android/app/build.gradle.kts` (`TL_ADMOB_APP_ID`).
library;

/// IDs de prueba oficiales de Google para Android.
abstract final class AdTestIds {
  static const appId = 'ca-app-pub-3940256099942544~3347511713';
  static const adaptiveBanner = 'ca-app-pub-3940256099942544/9214589741';
  static const interstitial = 'ca-app-pub-3940256099942544/1033173712';
}

/// Valores leídos de `--dart-define` al compilar.
class MonetizationConfig {
  const MonetizationConfig({
    this.adsEnabled = true,
    this.bannerUnitId = AdTestIds.adaptiveBanner,
    this.interstitialUnitId = AdTestIds.interstitial,
    this.interstitialExperiment = false,
    this.interstitialCaps = true,
    this.umpDebugGeography = '',
    this.umpTestDeviceIds = const [],
    this.adTestDeviceIds = const [],
  });

  /// Lee los `--dart-define` del build:
  ///
  /// * `TL_ADS=off`: sin anuncios ni formulario de consentimiento (capturas,
  ///   pruebas manuales). Por defecto, encendidos.
  /// * `TL_ADMOB_BANNER_ID`, `TL_ADMOB_INTERSTITIAL_ID`: unidades reales.
  /// * `TL_INTERSTITIAL=on`: activa el experimento del intersticial (S20,
  ///   R-A2). Apagado por defecto.
  /// * `TL_INTERSTITIAL_CAPS=off`: solo para QA, ignora los topes de R-A3
  ///   (1 cada 3 sesiones, 1 por día, ninguno en las primeras 5 sesiones ni
  ///   en los primeros 7 días). R-A2, R-A4 y R-A5 se aplican igual.
  /// * `TL_UMP_DEBUG_GEOGRAPHY=eea|us|other` y `TL_UMP_TEST_DEVICES=hash1,…`:
  ///   fuerzan la geografía del formulario de UMP en dispositivos de prueba.
  /// * `TL_AD_TEST_DEVICES=hash1,…`: dispositivos de prueba de AdMob.
  factory MonetizationConfig.fromEnvironment() => MonetizationConfig(
    adsEnabled: _ads != 'off',
    bannerUnitId: _banner.isEmpty ? AdTestIds.adaptiveBanner : _banner,
    interstitialUnitId: _interstitial.isEmpty
        ? AdTestIds.interstitial
        : _interstitial,
    interstitialExperiment: _interstitialFlag == 'on',
    interstitialCaps: _caps != 'off',
    umpDebugGeography: _umpGeo,
    umpTestDeviceIds: _list(_umpDevices),
    adTestDeviceIds: _list(_adDevices),
  );

  static const _ads = String.fromEnvironment('TL_ADS');
  static const _banner = String.fromEnvironment('TL_ADMOB_BANNER_ID');
  static const _interstitial = String.fromEnvironment(
    'TL_ADMOB_INTERSTITIAL_ID',
  );
  static const _interstitialFlag = String.fromEnvironment('TL_INTERSTITIAL');
  static const _caps = String.fromEnvironment('TL_INTERSTITIAL_CAPS');
  static const _umpGeo = String.fromEnvironment('TL_UMP_DEBUG_GEOGRAPHY');
  static const _umpDevices = String.fromEnvironment('TL_UMP_TEST_DEVICES');
  static const _adDevices = String.fromEnvironment('TL_AD_TEST_DEVICES');

  static List<String> _list(String raw) => [
    for (final s in raw.split(','))
      if (s.trim().isNotEmpty) s.trim(),
  ];

  final bool adsEnabled;
  final String bannerUnitId;
  final String interstitialUnitId;
  final bool interstitialExperiment;
  final bool interstitialCaps;
  final String umpDebugGeography;
  final List<String> umpTestDeviceIds;
  final List<String> adTestDeviceIds;

  /// Las unidades siguen siendo las de prueba (antes de publicar deben
  /// cambiarse).
  bool get usesTestAdUnits =>
      bannerUnitId == AdTestIds.adaptiveBanner ||
      interstitialUnitId == AdTestIds.interstitial;

  MonetizationConfig copyWith({
    bool? adsEnabled,
    bool? interstitialExperiment,
    bool? interstitialCaps,
  }) => MonetizationConfig(
    adsEnabled: adsEnabled ?? this.adsEnabled,
    bannerUnitId: bannerUnitId,
    interstitialUnitId: interstitialUnitId,
    interstitialExperiment:
        interstitialExperiment ?? this.interstitialExperiment,
    interstitialCaps: interstitialCaps ?? this.interstitialCaps,
    umpDebugGeography: umpDebugGeography,
    umpTestDeviceIds: umpTestDeviceIds,
    adTestDeviceIds: adTestDeviceIds,
  );
}

/// Producto no consumible «Sin anuncios» (F-15c). Pendiente de crear en Play
/// Console con este mismo ID; el precio (US$3,99 es hipótesis H4) se define
/// allí y la app muestra el que devuelve Play.
const removeAdsProductId = 'trainloop_remove_ads';
