import 'package:flutter/widgets.dart';

import '../../l10n/gen/app_localizations.dart';
import 'pseudo_locale.dart';

export '../../l10n/gen/app_localizations.dart';

/// Locales que la app ofrece. en-XA queda fuera en release.
List<Locale> get appSupportedLocales => [
  for (final l in AppLocalizations.supportedLocales)
    if (pseudoLocaleAvailable || l.countryCode != 'XA') l,
];

/// Resuelve el idioma del sistema (o el idioma por app de Android 13+):
/// cualquier español → es-419, cualquier portugués → pt-BR, inglés → en.
/// Si ninguno del teléfono está soportado, usa inglés. Un locale soportado
/// exacto (p. ej. en-XA forzado desde Configuración) se respeta tal cual.
Locale resolveAppLocale(
  List<Locale>? deviceLocales,
  Iterable<Locale> supported,
) {
  for (final l in deviceLocales ?? const <Locale>[]) {
    if (supported.contains(l)) return l;
    switch (l.languageCode) {
      case 'es':
        return const Locale('es', '419');
      case 'pt':
        return const Locale('pt', 'BR');
      case 'en':
        return const Locale('en');
    }
  }
  return const Locale('en');
}

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
