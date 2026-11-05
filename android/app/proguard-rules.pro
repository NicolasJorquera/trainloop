# Reglas de R8 del release (D9). Flutter agrega las suyas
# (flutter_proguard_rules.pro) y cada biblioteca trae sus reglas de consumo;
# aquí va lo propio y lo que R8 no puede ver.

# --- Código nativo de Trainloop -------------------------------------------
# Motor del temporizador (TimerService, TimerEngine, RestTimer, CuePlayer,
# CheckpointStore, TimerBridge), DocumentsBridge (SAF), recordatorios y
# CrashLog. Los canales se llaman por nombre de método (cadenas) y el punto
# de recuperación es JSON: nada se busca por reflexión, pero la app es chica
# y conservar los nombres deja pilas legibles en el registro de errores y
# en Android vitals sin subir el mapping. Costo: unos pocos KB.
-keep class com.trainloop.app.** { *; }

# --- google_mobile_ads (AdMob + UMP) --------------------------------------
# El plugin crea vistas de plataforma y fábricas de anuncios nativos por
# nombre; play-services-ads trae sus propias reglas.
-keep class io.flutter.plugins.googlemobileads.** { *; }
-dontwarn io.flutter.plugins.googlemobileads.**

# --- in_app_purchase (Play Billing) ---------------------------------------
-keep class io.flutter.plugins.inapppurchase.** { *; }
-keep class com.android.billingclient.api.** { *; }
-dontwarn com.android.billingclient.api.**

# --- Drift / sqlite3 --------------------------------------------------------
# drift_flutter usa sqlite3 3.x por FFI: libsqlite3.so llega por los build
# hooks de Dart (sqlite3_flutter_libs 0.6 ya no trae código Android). No hay
# clases Java que conservar; R8 no toca las .so. path_provider y
# shared_preferences traen sus propias reglas.

# --- Varios ------------------------------------------------------------------
# Play Core (componentes diferidos): Flutter lo referencia, la app no lo usa.
-dontwarn com.google.android.play.core.**
