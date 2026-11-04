import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart'
    show InAppPurchasePlatformAddition;
import 'package:trainloop/data/db/enums.dart';
import 'package:trainloop/features/monetization/data/ads_platform.dart';
import 'package:trainloop/features/monetization/domain/monetization_config.dart';

/// AdMob + UMP de prueba: sin red ni canal nativo. Cuenta lo que se cargó,
/// lo que sigue vivo y puede fallar en cada paso.
class FakeAdsPlatform implements AdsPlatform {
  FakeAdsPlatform({
    this.consent = const ConsentSnapshot(
      state: ConsentStatus.notRequired,
      canRequestAds: true,
      privacyOptionsRequired: false,
    ),
    this.fillBanner = false,
    this.fillInterstitial = true,
    this.failConsent = false,
    this.failInit = false,
    this.failLoad = false,
  });

  ConsentSnapshot consent;

  /// AdMob devuelve un banner (por defecto no, para no cambiar el diseño en
  /// las pruebas que no son de anuncios).
  bool fillBanner;
  bool fillInterstitial;

  /// Simulan «sin red»: lanzan.
  bool failConsent;
  bool failInit;
  bool failLoad;

  final calls = <String>[];
  var bannersLoaded = 0;
  var liveBanners = 0;
  var interstitialsShown = 0;

  /// Consentimiento que deja «Preferencias de privacidad».
  ConsentSnapshot? afterPrivacyOptions;

  @override
  Future<ConsentSnapshot> gatherConsent({required bool allowForm}) async {
    calls.add('gatherConsent(form: $allowForm)');
    if (failConsent) throw StateError('sin red');
    return consent;
  }

  @override
  Future<ConsentSnapshot> currentConsent() async {
    calls.add('currentConsent');
    if (failConsent) throw StateError('sin red');
    return consent;
  }

  @override
  Future<ConsentSnapshot> showPrivacyOptions() async {
    calls.add('privacyOptions');
    if (failConsent) throw StateError('sin red');
    return consent = afterPrivacyOptions ?? consent;
  }

  @override
  Future<void> initialize() async {
    calls.add('initialize');
    if (failInit) throw StateError('sin red');
  }

  @override
  Future<LoadedBanner?> loadBanner({
    required int width,
    required Orientation orientation,
  }) async {
    calls.add('loadBanner');
    if (failLoad) throw StateError('sin red');
    if (!fillBanner) return null;
    bannersLoaded++;
    liveBanners++;
    return _FakeBanner(this);
  }

  @override
  Future<LoadedInterstitial?> loadInterstitial() async {
    calls.add('loadInterstitial');
    if (failLoad) throw StateError('sin red');
    if (!fillInterstitial) return null;
    return _FakeInterstitial(this);
  }
}

class _FakeBanner implements LoadedBanner {
  _FakeBanner(this._owner);

  final FakeAdsPlatform _owner;
  var _disposed = false;

  @override
  Size get size => const Size(320, 50);

  @override
  Widget build() => const SizedBox(key: Key('fake-ad-banner'));

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _owner.liveBanners--;
  }
}

class _FakeInterstitial implements LoadedInterstitial {
  _FakeInterstitial(this._owner);

  final FakeAdsPlatform _owner;

  @override
  final DateTime loadedAt = DateTime.now();

  @override
  Future<bool> show() async {
    _owner.interstitialsShown++;
    _owner.calls.add('showInterstitial');
    return true;
  }

  @override
  void dispose() {}
}

/// Qué responde Play al comprar.
enum FakeBuyResult { purchased, pending, canceled, error }

/// Google Play Billing de prueba. [owned] es lo que la cuenta tiene en Play
/// (sobrevive a una «instalación nueva»: otra base y otro controlador).
class FakeInAppPurchase implements InAppPurchase {
  FakeInAppPurchase({
    this.available = true,
    this.productExists = true,
    this.buyResult = FakeBuyResult.purchased,
    this.owned = false,
    this.failRestore = false,
  });

  bool available;
  bool productExists;
  FakeBuyResult buyResult;
  bool owned;
  bool failRestore;

  /// La compra quedó pendiente en Play (se puede confirmar con [confirm]).
  bool pendingInStore = false;

  final calls = <String>[];
  final completed = <String>[];
  final _updates = StreamController<List<PurchaseDetails>>.broadcast();

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _updates.stream;

  @override
  Future<bool> isAvailable() async {
    calls.add('isAvailable');
    return available;
  }

  @override
  Future<ProductDetailsResponse> queryProductDetails(
    Set<String> identifiers,
  ) async {
    calls.add('queryProductDetails');
    return ProductDetailsResponse(
      productDetails: [
        if (productExists && identifiers.contains(removeAdsProductId))
          ProductDetails(
            id: removeAdsProductId,
            title: 'Sin anuncios',
            description: '',
            price: r'US$3.99',
            rawPrice: 3.99,
            currencyCode: 'USD',
          ),
      ],
      notFoundIDs: productExists ? const [] : identifiers.toList(),
    );
  }

  @override
  Future<bool> buyNonConsumable({required PurchaseParam purchaseParam}) async {
    calls.add('buyNonConsumable');
    scheduleMicrotask(() {
      switch (buyResult) {
        case FakeBuyResult.purchased:
          owned = true;
          _emit(PurchaseStatus.purchased);
        case FakeBuyResult.pending:
          pendingInStore = true;
          _emit(PurchaseStatus.pending, complete: false);
        case FakeBuyResult.canceled:
          _emit(PurchaseStatus.canceled, complete: false);
        case FakeBuyResult.error:
          _emit(PurchaseStatus.error, complete: false);
      }
    });
    return true;
  }

  /// Play confirma la compra pendiente (llega por el stream).
  void confirmPending() {
    pendingInStore = false;
    owned = true;
    _emit(PurchaseStatus.purchased);
  }

  void _emit(PurchaseStatus status, {bool complete = true}) {
    _updates.add([
      PurchaseDetails(
        purchaseID: 'GPA.1',
        productID: removeAdsProductId,
        verificationData: PurchaseVerificationData(
          localVerificationData: '',
          serverVerificationData: '',
          source: 'google_play',
        ),
        transactionDate: '0',
        status: status,
      )..pendingCompletePurchase = complete,
    ]);
  }

  @override
  Future<void> restorePurchases({String? applicationUserName}) async {
    calls.add('restorePurchases');
    if (failRestore) throw InAppPurchaseException(source: 'fake', code: 'net');
    _updates.add([
      if (owned)
        PurchaseDetails(
          purchaseID: 'GPA.1',
          productID: removeAdsProductId,
          verificationData: PurchaseVerificationData(
            localVerificationData: '',
            serverVerificationData: '',
            source: 'google_play',
          ),
          transactionDate: '0',
          status: PurchaseStatus.restored,
        ),
    ]);
  }

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {
    completed.add(purchase.productID);
  }

  @override
  Future<bool> buyConsumable({
    required PurchaseParam purchaseParam,
    bool autoConsume = true,
  }) => throw UnimplementedError();

  @override
  Future<String> countryCode() async => 'CL';

  @override
  T getPlatformAddition<T extends InAppPurchasePlatformAddition?>() =>
      throw UnimplementedError();

  Future<void> close() => _updates.close();
}
