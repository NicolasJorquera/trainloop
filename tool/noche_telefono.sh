#!/bin/bash
# Prueba nocturna en un teléfono real (D9): desfase del temporizador en 60 min
# con la pantalla apagada (NF-03) y consumo de batería por hora (NF-10).
# NO se corrió en el emulador (pedido: nada de pruebas largas); ver
# docs/pruebas-estabilidad.md, «Plan para el bloque en teléfono real».
#
# Preparación (una vez):
#   1. Depuración USB activada y el teléfono autorizado (`adb devices`).
#   2. Build de profile (AOT como release, pero depurable: deja el registro
#      files/timer_debug.csv que lee tool/timer_adb.sh):
#        flutter build apk --profile && adb install -r build/app/outputs/flutter-apk/app-profile.apk
#   3. En la app, crear el temporizador «Prueba 60 min»: preparación 0:10 y
#      una repetición de 60 rondas de Trabajo 0:30 + Descanso 0:30
#      (con «omitir el último descanso»: 59:40 + 0:10 = 59:50).
#   4. Batería sin restricción, notificaciones permitidas, carga > 80 %.
#   5. Desconectar el cargador. Si el teléfono solo tiene un puerto, usar
#      adb por wifi (`adb tcpip 5555` y `adb connect <ip>`): el USB carga y
#      falsea la batería.
#
# Uso: ANDROID_SERIAL=<id> tool/noche_telefono.sh [minutos]   (por defecto 62)
set -euo pipefail
cd "$(dirname "$0")/.."
ADB=${ADB:-adb}
export ADB
MIN=${1:-62}
OUT=build/noche-$(date +%Y%m%d-%H%M)
mkdir -p "$OUT"

$ADB shell dumpsys battery | grep -E "level|AC powered|USB powered" | tee "$OUT/bateria-inicio.txt"
if grep -q "powered: true" "$OUT/bateria-inicio.txt"; then
  echo "AVISO: el teléfono está cargando; la medición de batería no sirve." >&2
fi
$ADB shell dumpsys batterystats --reset
tool/timer_adb.sh clearcsv
tool/timer_adb.sh launch
sleep 3
tool/timer_adb.sh tap 'Prueba 60 min'
sleep 2
tool/timer_adb.sh tap 'EMPEZAR'
sleep 5
tool/timer_adb.sh off
date
echo "Esperando $MIN min con la pantalla apagada…"
sleep $((MIN * 60))
tool/timer_adb.sh on
sleep 3

$ADB shell dumpsys battery | grep -E "level" | tee "$OUT/bateria-fin.txt"
$ADB shell dumpsys batterystats com.gonisoma.trainloop > "$OUT/batterystats.txt"
$ADB shell dumpsys alarm > "$OUT/alarm.txt"
tool/timer_adb.sh csv > "$OUT/timer_debug.csv"
tool/timer_adb.sh stats | tee "$OUT/desfase.txt"

start=$(grep -o 'level: [0-9]*' "$OUT/bateria-inicio.txt" | grep -o '[0-9]*')
end=$(grep -o 'level: [0-9]*' "$OUT/bateria-fin.txt" | grep -o '[0-9]*')
echo "Batería: $start % → $end % en $MIN min ($(( (start - end) * 60 / MIN )) %/h aprox.; umbral NF-10: ≤ 5 %/h)" | tee "$OUT/bateria.txt"
echo "Criterio NF-03: max_late ≤ 1000 ms y session_ms ≈ 3 590 000 (59:50)."
echo "Resultados en $OUT"
