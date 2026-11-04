import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import '../../../data/db/app_database.dart';
import '../../../data/db/database_providers.dart';
import '../../analytics/application/analytics_service.dart';
import '../domain/monetization_config.dart';
import 'ads_controller.dart';

/// Qué está pasando con la compra (lo muestra S16).
enum PurchaseFlow {
  idle,

  /// Consultando a Play o abriendo la hoja de compra.
  busy,

  /// Play la dejó pendiente (pago en efectivo, aprobación familiar…): los
  /// anuncios siguen hasta que se confirme.
  pending,

  /// Comprada o restaurada en esta pantalla.
  purchased,
  restored,

  /// «Restaurar compra»: Play no tiene ninguna para esta cuenta.
  nothingToRestore,
  canceled,
  error,

  /// Sin Play Store, sin red o el producto todavía no existe en Play
  /// Console.
  unavailable,
}

@immutable
class RemoveAdsState {
  const RemoveAdsState({this.owned, this.flow = PurchaseFlow.idle, this.price});

  /// `null` mientras se lee el estado guardado.
  final bool? owned;
  final PurchaseFlow flow;

  /// Precio que informa Play (localizado); `null` si no se pudo consultar.
  final String? price;

  RemoveAdsState copyWith({
    bool? owned,
    PurchaseFlow? flow,
    String? Function()? price,
  }) => RemoveAdsState(
    owned: owned ?? this.owned,
    flow: flow ?? this.flow,
    price: price != null ? price() : this.price,
  );

  @override
  bool operator ==(Object other) =>
      other is RemoveAdsState &&
      other.owned == owned &&
      other.flow == flow &&
      other.price == price;

  @override
  int get hashCode => Object.hash(owned, flow, price);

  @override
  String toString() => 'RemoveAdsState(owned: $owned, $flow, $price)';
}

final removeAdsControllerProvider =
    NotifierProvider<RemoveAdsController, RemoveAdsState>(
      RemoveAdsController.new,
    );

/// `true`/`false` cuando se sabe si la persona compró «Sin anuncios».
final adsRemovedProvider = Provider<bool?>(
  (ref) => ref.watch(removeAdsControllerProvider.select((s) => s.owned)),
);

/// Compra única «Sin anuncios» (F-15c, R-A9) con Google Play Billing.
///
/// * El estado se guarda en `ad_state.ads_removed` y se lee al abrir: sin
///   red, quien compró sigue sin anuncios.
/// * Al abrir se reverifica con Play ([verifyWithStore]): si Play responde,
///   su respuesta manda (también revoca una compra reembolsada o la que
///   trajo un respaldo de otra cuenta). Sin servidor propio: la validación
///   es en el teléfono (riesgo de fraude aceptado, PRD v0.2).
/// * Las compras se reconocen (`completePurchase`) para que Play no las
///   reembolse a los 3 días.
class RemoveAdsController extends Notifier<RemoveAdsState> {
  StreamSubscription<List<PurchaseDetails>>? _sub;
  List<PurchaseDetails>? _restoreBatch;
  ProductDetails? _product;

  InAppPurchase get _iap => ref.read(inAppPurchaseProvider);

  @override
  RemoveAdsState build() {
    try {
      _sub = ref
          .watch(inAppPurchaseProvider)
          .purchaseStream
          .listen(_onPurchases, onError: (Object _) {});
    } catch (_) {
      // Sin Play Billing (p. ej. otro sistema): la app sigue con anuncios.
    }
    ref.onDispose(() => _sub?.cancel());
    unawaited(_loadSaved());
    return const RemoveAdsState();
  }

  Future<void> _loadSaved() async {
    var owned = false;
    try {
      owned = (await ref.read(adStateDaoProvider).read()).adsRemoved;
    } catch (_) {}
    if (ref.mounted && state.owned == null) {
      state = state.copyWith(owned: owned);
    }
  }

  /// Consulta el precio para mostrarlo en S16.
  Future<void> loadProduct() async {
    final product = await _queryProduct();
    if (!ref.mounted || product == null) return;
    state = state.copyWith(price: () => product.price);
  }

  /// QUITAR ANUNCIOS: abre la hoja de compra de Play. El resultado llega
  /// por [InAppPurchase.purchaseStream].
  Future<void> buy() async {
    if (state.owned ?? false) return;
    state = state.copyWith(flow: PurchaseFlow.busy);
    try {
      final product = await _queryProduct();
      if (product == null) {
        _setFlow(PurchaseFlow.unavailable);
        return;
      }
      state = state.copyWith(price: () => product.price);
      final launched = await _iap.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: product),
      );
      if (!launched) _setFlow(PurchaseFlow.error);
    } catch (e) {
      // La cuenta ya la tenía (p. ej. otra instalación): se restaura.
      if (_isAlreadyOwned(e)) {
        await _restore(userInitiated: true);
      } else {
        _setFlow(PurchaseFlow.error);
      }
    }
  }

  /// «Restaurar compra»: consulta las compras de la cuenta de Play.
  Future<void> restore() => _restore(userInitiated: true);

  /// Al abrir la app: reverifica en silencio.
  Future<void> verifyWithStore() => _restore(userInitiated: false);

  Future<void> _restore({required bool userInitiated}) async {
    if (_restoreBatch != null) return;
    if (userInitiated) state = state.copyWith(flow: PurchaseFlow.busy);
    _restoreBatch = [];
    try {
      if (!await _iap.isAvailable()) {
        if (userInitiated) _setFlow(PurchaseFlow.unavailable);
        return;
      }
      await _iap.restorePurchases();
      // El lote llega por el stream justo antes de que termine la llamada.
      await Future<void>.delayed(Duration.zero);
      final batch = _restoreBatch ?? const [];
      final owned = batch.any((p) => _isRemoveAds(p) && !_isPending(p));
      final pending = batch.any((p) => _isRemoveAds(p) && _isPending(p));
      await _saveOwned(owned);
      if (owned && userInitiated) _log('restored');
      if (userInitiated) {
        _setFlow(
          owned
              ? PurchaseFlow.restored
              : pending
              ? PurchaseFlow.pending
              : PurchaseFlow.nothingToRestore,
        );
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[purchase] restore: $e');
      if (userInitiated) _setFlow(PurchaseFlow.unavailable);
    } finally {
      _restoreBatch = null;
    }
  }

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    for (final p in purchases) {
      if (!_isRemoveAds(p)) continue;
      final batch = _restoreBatch;
      if (batch != null && p.status == PurchaseStatus.restored) {
        batch.add(p);
        if (!_isPending(p)) await _complete(p);
        continue;
      }
      switch (p.status) {
        case PurchaseStatus.pending:
          _setFlow(PurchaseFlow.pending);
          _log('pending');
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          if (_isPending(p)) {
            _setFlow(PurchaseFlow.pending);
            continue;
          }
          await _saveOwned(true);
          _setFlow(
            p.status == PurchaseStatus.purchased
                ? PurchaseFlow.purchased
                : PurchaseFlow.restored,
          );
          _log(p.status == PurchaseStatus.purchased ? 'purchased' : 'restored');
        case PurchaseStatus.canceled:
          _setFlow(PurchaseFlow.canceled);
          _log('canceled');
        case PurchaseStatus.error:
          if (_isAlreadyOwned(p.error)) {
            await _complete(p);
            await _restore(userInitiated: true);
            continue;
          }
          _setFlow(PurchaseFlow.error);
          _log('error');
      }
      await _complete(p);
    }
  }

  Future<ProductDetails?> _queryProduct() async {
    if (_product case final p?) return p;
    try {
      if (!await _iap.isAvailable()) return null;
      final response = await _iap.queryProductDetails({removeAdsProductId});
      final found = response.productDetails.where(
        (p) => p.id == removeAdsProductId,
      );
      return _product = found.isEmpty ? null : found.first;
    } catch (_) {
      return null;
    }
  }

  Future<void> _complete(PurchaseDetails p) async {
    if (!p.pendingCompletePurchase) return;
    try {
      await _iap.completePurchase(p);
    } catch (_) {
      // Se reintenta en la próxima reverificación.
    }
  }

  Future<void> _saveOwned(bool owned) async {
    if (ref.mounted) state = state.copyWith(owned: owned);
    try {
      await ref
          .read(adStateDaoProvider)
          .write(AdStatesCompanion(adsRemoved: Value(owned)));
    } catch (_) {}
  }

  void _setFlow(PurchaseFlow flow) {
    if (ref.mounted) state = state.copyWith(flow: flow);
  }

  void _log(String result) =>
      ref.read(analyticsServiceProvider).log(AnalyticsEvent.removeAds(result));

  static bool _isRemoveAds(PurchaseDetails p) =>
      p.productID == removeAdsProductId;

  /// En Android, `restorePurchases` marca como restauradas también las
  /// compras pendientes: hay que mirar el estado de Play.
  static bool _isPending(PurchaseDetails p) =>
      p.status == PurchaseStatus.pending ||
      (p is GooglePlayPurchaseDetails &&
          p.billingClientPurchase.purchaseState ==
              PurchaseStateWrapper.pending);

  static bool _isAlreadyOwned(Object? e) =>
      e.toString().contains('itemAlreadyOwned') ||
      e.toString().contains('ITEM_ALREADY_OWNED');
}
