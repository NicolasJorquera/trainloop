#!/bin/bash
# Ayudante para probar el temporizador en un emulador o teléfono por adb (D4).
# Uso: tool/timer_adb.sh <comando> [args]. Solo builds de depuración: el
# registro CSV (files/timer_debug.csv) no existe en release.
ADB=${ADB:-$HOME/Library/Android/sdk/platform-tools/adb}
export ANDROID_SERIAL=${ANDROID_SERIAL:-emulator-5560}
PKG=com.trainloop.app

tap_text() { # toca el primer nodo cuyo texto o content-desc contiene $1
  $ADB shell uiautomator dump /sdcard/ui.xml >/dev/null 2>&1
  local b
  b=$($ADB shell cat /sdcard/ui.xml | tr '<' '\n' | grep -E "(text|content-desc)=\"[^\"]*$1" | head -1 | grep -o 'bounds="[^"]*"' | grep -oE '[0-9]+' | tr '\n' ' ')
  set -- $b
  if [ -z "$1" ]; then echo "no encontrado"; return 1; fi
  $ADB shell input tap $(( ($1 + $3) / 2 )) $(( ($2 + $4) / 2 ))
}

wait_text() { # espera (hasta 60 s) a que aparezca un nodo con el texto $1
  for _ in $(seq 1 30); do
    $ADB shell uiautomator dump /sdcard/ui.xml >/dev/null 2>&1
    $ADB shell cat /sdcard/ui.xml | grep -q "$1" && return 0
    sleep 2
  done
  echo "no apareció"; return 1
}

case "$1" in
  launch) $ADB shell am start -n $PKG/.MainActivity >/dev/null ;;
  tap) tap_text "$2" ;;
  wait) wait_text "$2" ;;
  off) $ADB shell input keyevent KEYCODE_SLEEP ;;
  on) $ADB shell input keyevent KEYCODE_WAKEUP; $ADB shell wm dismiss-keyguard ;;
  csv) $ADB shell run-as $PKG cat files/timer_debug.csv ;;
  clearcsv) $ADB shell run-as $PKG rm -f files/timer_debug.csv ;;
  checkpoint) $ADB shell run-as $PKG cat files/timer_checkpoint.json ;;
  pid) $ADB shell pidof $PKG ;;
  kill) $ADB shell run-as $PKG kill -9 "$($ADB shell pidof $PKG)" ;;
  stats) # retraso de los cambios de fase de la última sesión del CSV
    $ADB shell run-as $PKG cat files/timer_debug.csv | awk -F, '
      $1=="start"{n=0;s=0;m=0;mi=1e9;st=$6;off=0;idle=0;fin=0}
      $1=="transition"{n++;s+=$7;if($7>m)m=$7;if($7<mi)mi=$7;last=$6;off+=($8=="false");idle+=($9=="true")}
      $1=="finished"{fin=$6}
      END{if(n)printf "transitions=%d avg_late=%.1fms min=%dms max=%dms screen_off=%d idle=%d session_ms=%d\n",n,s/n,mi,m,off,idle,(fin?fin:last)-st}' ;;
  *) echo "comandos: launch tap wait off on csv clearcsv checkpoint pid kill stats" ;;
esac
