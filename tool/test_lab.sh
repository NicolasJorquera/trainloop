#!/bin/bash
# Corre los recorridos de integration_test/ en Firebase Test Lab (D9).
#
# Requisitos (pendientes de Gestión: hoy no hay proyecto de Firebase):
#   - gcloud instalado y con sesión: `gcloud auth login` o
#     `gcloud auth activate-service-account --key-file=<llave.json>`;
#   - un proyecto de Firebase con Test Lab y su bucket de resultados.
#
# Uso:
#   TL_FIREBASE_PROJECT=mi-proyecto tool/test_lab.sh [integration_test/app_test.dart]
#
# Variables opcionales:
#   TL_TEST_LAB_BUCKET   bucket de resultados (por defecto, el del proyecto)
#   TL_TEST_LAB_DEVICES  matriz propia: líneas "model=…,version=…" separadas por ';'
#   TL_TEST_LAB_TIMEOUT  límite por dispositivo (por defecto 10m)
#   TL_DRY_RUN=1         solo compila y muestra el comando de gcloud
#
# El APK de depuración lleva los recorridos (AdMob y Play Billing de prueba;
# offline_test.dart usa los reales). Los permisos se conceden con
# --grant-permissions=all, así no aparece el diálogo de notificaciones.
set -euo pipefail

cd "$(dirname "$0")/.."
TARGET=${1:-integration_test/app_test.dart}
PROJECT=${TL_FIREBASE_PROJECT:-}
TIMEOUT=${TL_TEST_LAB_TIMEOUT:-10m}
export PUB_HOSTED_URL=${PUB_HOSTED_URL:-https://pub.dev}

# Matriz propuesta: gama media, Samsung/Xiaomi/Pixel, API 26–36. Los
# modelos de Test Lab cambian: revisar antes con
#   gcloud firebase test android models list --filter="form:PHYSICAL"
#   gcloud firebase test android models list --filter="form:VIRTUAL"
# y ajustar ids o versiones en TL_TEST_LAB_DEVICES si alguno ya no está.
DEFAULT_DEVICES=(
  # Virtuales (baratos, para cada PR que toque el motor): extremos de API.
  "model=MediumPhone.arm,version=26"   # Android 8.0, minSdk
  "model=MediumPhone.arm,version=30"   # Android 11
  "model=MediumPhone.arm,version=34"   # Android 14
  "model=MediumPhone.arm,version=36"   # Android 16, targetSdk
  # Físicos de gama media (antes de cada versión a Play).
  "model=a12,version=30"               # Samsung Galaxy A12 (gama de entrada/media)
  "model=a52sxq,version=33"            # Samsung Galaxy A52s 5G (One UI, batería agresiva)
  "model=joyeuse,version=30"           # Xiaomi Redmi Note 9 Pro (MIUI)
  "model=oriole,version=33"            # Google Pixel 6
  "model=shiba,version=34"             # Google Pixel 8
)

if [ -n "${TL_TEST_LAB_DEVICES:-}" ]; then
  IFS=';' read -r -a DEVICES <<< "$TL_TEST_LAB_DEVICES"
else
  DEVICES=("${DEFAULT_DEVICES[@]}")
fi

echo "==> Compilando la app y la prueba instrumentada ($TARGET)"
flutter pub get
flutter build apk --debug
(
  cd android
  ./gradlew app:assembleAndroidTest
  ./gradlew app:assembleDebug -Ptarget="$(pwd)/../$TARGET"
)

APP=build/app/outputs/apk/debug/app-debug.apk
TEST=build/app/outputs/apk/androidTest/debug/app-debug-androidTest.apk

CMD=(gcloud firebase test android run
  --type instrumentation
  --app "$APP"
  --test "$TEST"
  --timeout "$TIMEOUT"
  --grant-permissions all
  --num-flaky-test-attempts 1
  --results-dir "trainloop-$(date +%Y%m%d-%H%M%S)")
if [ -n "$PROJECT" ]; then CMD+=(--project "$PROJECT"); fi
if [ -n "${TL_TEST_LAB_BUCKET:-}" ]; then CMD+=(--results-bucket "$TL_TEST_LAB_BUCKET"); fi
for d in "${DEVICES[@]}"; do CMD+=(--device "$d,locale=es_419,orientation=portrait"); done

echo "==> ${CMD[*]}"
if [ "${TL_DRY_RUN:-}" = "1" ]; then exit 0; fi
if [ -z "$PROJECT" ]; then
  echo "Falta TL_FIREBASE_PROJECT (proyecto de Firebase con Test Lab)." >&2
  exit 1
fi
"${CMD[@]}"
