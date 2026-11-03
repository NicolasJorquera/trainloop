import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../units/weight_unit.dart';
import 'l10n.dart';

/// Formatos de cantidades. Todo pasa por l10n para que el pseudo-locale
/// marque también los números.
extension TlFormatters on AppLocalizations {
  /// Duración como `m:ss` (p. ej. 1:30).
  String duration(int seconds) =>
      durationMinSec(seconds ~/ 60, (seconds % 60).toString().padLeft(2, '0'));

  String unitSymbol(WeightUnit unit) => switch (unit) {
    WeightUnit.kg => unitKg,
    WeightUnit.lb => unitLb,
  };

  /// Peso con su unidad (hasta 2 decimales, separador del idioma).
  String weight(double value, WeightUnit unit) =>
      weightValue(decimal(value), unitSymbol(unit));

  /// Número con hasta 2 decimales y el separador decimal del idioma.
  String decimal(double value) =>
      NumberFormat('0.##', localeName).format(value);
}

/// Lee un número escrito con coma o punto decimal. `null` si no es válido.
double? parseDecimal(String text) {
  final clean = text.trim().replaceAll(',', '.');
  return clean.isEmpty ? null : double.tryParse(clean);
}

extension LocaleOf on BuildContext {
  Locale get locale => Localizations.localeOf(this);
}
