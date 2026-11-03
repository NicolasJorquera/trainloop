import 'package:flutter/foundation.dart';

/// `flutter run --dart-define=TL_PSEUDO=true` arranca la app en en-XA.
/// Solo tiene efecto en depuración.
const bool pseudoLocaleForced = kDebugMode && bool.fromEnvironment('TL_PSEUDO');

/// El pseudo-locale (en-XA) solo se ofrece en builds de depuración.
const bool pseudoLocaleAvailable = kDebugMode;
