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

  /// Número con hasta 2 decimales y el separador decimal del idioma: coma en
  /// español y portugués (82,5), punto en inglés (82.5). Sin separador de
  /// miles, para que se pueda volver a leer al editarlo.
  String decimal(double value) =>
      NumberFormat('0.##', numberLocale(localeName)).format(value);

  /// Como [decimal], con separador de miles (volumen: 6.240 kg).
  String grouped(double value) =>
      NumberFormat('#,##0.##', numberLocale(localeName)).format(value);
}

/// Locale de los números. CLDR usa punto decimal en es-419 (como México),
/// pero la app usa coma en todo el español y en pt-BR (diseño y PRD).
String numberLocale(String localeName) {
  final language = localeName.split(RegExp('[_-]')).first;
  return switch (language) {
    'es' => 'es',
    'pt' => 'pt_BR',
    _ => localeName,
  };
}

/// Lee un número escrito con coma o punto decimal. `null` si no es válido.
double? parseDecimal(String text) {
  final clean = text.trim().replaceAll(',', '.');
  return clean.isEmpty ? null : double.tryParse(clean);
}

extension LocaleOf on BuildContext {
  Locale get locale => Localizations.localeOf(this);
}
