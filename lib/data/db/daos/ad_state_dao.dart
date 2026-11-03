import 'package:drift/drift.dart';

import '../app_database.dart';
import '../converters.dart';
import '../tables.dart';

part 'ad_state_dao.g.dart';

/// Estado de anuncios en una fila única (D8).
@DriftAccessor(tables: [AdStates])
class AdStateDao extends DatabaseAccessor<AppDatabase> with _$AdStateDaoMixin {
  AdStateDao(super.attachedDatabase);

  /// Id fijo de la fila única.
  static const rowId = 'ad_state';

  /// Lee la fila, creándola con los valores por defecto si no existe.
  Future<AdState> read() async {
    await into(adStates).insert(
      const AdStatesCompanion(id: Value(rowId)),
      mode: InsertMode.insertOrIgnore,
    );
    return (select(adStates)..where((t) => t.id.equals(rowId))).getSingle();
  }

  Stream<AdState?> watch() =>
      (select(adStates)..where((t) => t.id.equals(rowId))).watchSingleOrNull();

  Future<void> write(AdStatesCompanion changes) async {
    await read();
    await (update(adStates)..where((t) => t.id.equals(rowId))).write(
      changes.copyWith(updatedAt: Value(nowUtc())),
    );
  }

  /// Suma una sesión terminada desde el último intersticial.
  Future<void> countSession() => transaction(() async {
    final current = await read();
    await write(
      AdStatesCompanion(
        sessionsSinceInterstitial: Value(current.sessionsSinceInterstitial + 1),
      ),
    );
  });

  /// Registra un intersticial mostrado y reinicia el contador.
  Future<void> markInterstitialShown() => write(
    AdStatesCompanion(
      lastInterstitialAt: Value(nowUtc()),
      sessionsSinceInterstitial: const Value(0),
    ),
  );
}
