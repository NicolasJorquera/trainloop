# Trainloop — Arquitectura v0.1 (copia de https://claude.ai/artifact/2yN4a2J3kpBRCnqjAocmDw)

# Trainloop — Arquitectura v0.1
 · 

## Resumen
Stack recomendado: Flutter (UI) + motor de temporizador nativo en Kotlin dentro de un servicio en primer plano, Drift (SQLite) para datos locales, Riverpod para estado y go_router para navegación. Sin backend: costo fijo de infraestructura US$ 0.
Decisiones clave

- El tiempo se calcula con el reloj monotónico y objetivos absolutos, nunca contando ticks.

- Servicio specialUse sin alarmas exactas por defecto.

- Recuperación desde checkpoint si el sistema mata la app.

- Datos solo en el teléfono, con respaldo automático de Android y exportación JSON/CSV.

- Anuncios, consentimiento, analítica y compra «sin anuncios» aislados en módulos propios; nunca durante una sesión activa.
Estado del spike: 7 de 8 pruebas pasadas en el emulador. Los cambios de fase llegan con ≤ 8 ms de retraso incluso con la pantalla apagada y en Doze, y una sesión de 30 min termina con +3 ms. La única falla es cuando el usuario marca la app como «Restringida»: se mitiga detectándolo y avisándole. Falta validar en teléfonos Samsung y Xiaomi reales.
Plan: 10 entregables en un repositorio nuevo, empezando por la base del proyecto y el motor del temporizador.

## Flutter vs Kotlin nativo
Recomendamos Flutter para la interfaz y un módulo nativo en Kotlin para el motor del temporizador [R]. La parte crítica (seguir contando con la pantalla apagada) es nativa en cualquiera de las dos opciones, porque depende de un servicio en primer plano de Android. Flutter suma velocidad para la interfaz, el design system en un solo código y la opción de iOS más adelante.

| Criterio
 | Flutter + módulo Kotlin
 | Kotlin nativo (Jetpack Compose)
 | 
| Temporizador con pantalla apagada
 | Servicio Kotlin propio, comunicado por canales con Flutter
 | Servicio Kotlin, acceso directo
 | 
| iOS en el futuro
 | La interfaz se reutiliza; el motor se reescribe en Swift
 | Interfaz y motor nuevos (o migrar a Kotlin Multiplatform)
 | 
| Experiencia del equipo
 | El equipo ya trabaja en Flutter (proyecto Flixer) [O]
 | No verificada
 | 
| Velocidad de interfaz
 | Recarga en caliente; un solo set de widgets del design system
 | Compose también es rápido; solo Android
 | 
| Tamaño de descarga
 | Mayor (motor de Flutter); dentro del límite NF-11 de 20 MB [H]
 | Menor
 | 
| Arranque en frío
 | Algo más lento; hay que medirlo contra NF-02 (1,5 s)
 | Más rápido
 | 
| Widgets, Wear OS, Health Connect
 | Requieren código nativo de todos modos
 | Nativo de primera clase
 | 
| Mantenimiento
 | Dos lenguajes (Dart + Kotlin acotado al motor)
 | Un lenguaje
 | Por qué no depender de un paquete de terceros para el temporizador: es la promesa central del producto. Un módulo propio de ~5 clases Kotlin evita depender del ritmo de mantenimiento de otro y nos deja controlar audio, notificación y recuperación.
Cuándo cambiaríamos a Kotlin nativo: si el spike muestra que la comunicación Flutter–servicio añade fallos o retrasos, o si el arranque en frío no baja de 1,5 s en un teléfono de gama media. La decisión final la valida Arquitectura.

## Diagrama de arquitectura

[diagrama: arquitectura de Trainloop · app Flutter, servicio nativo y servicios externos]
La app Flutter le envía al servicio nativo la lista de fases y recibe eventos de cambio de fase por canales. La capa de datos implementa los contratos del dominio. Solo el módulo de monetización y la analítica hablan con servicios externos; el motor y la base de datos funcionan sin red.

## Módulos y estructura de carpetas
Código organizado por funcionalidad, cada una con sus capas de presentación, aplicación, dominio y datos; el dominio no depende de Flutter ni de la base de datos. Agregar una funcionalidad nueva (por ejemplo, sesiones mixtas en v1.1) es sumar una carpeta, no tocar las demás.
trainloop/
  lib/
    core/              tema y tokens, acento, idiomas, rutas, inyección, utilidades
    design_system/     botones, PhaseTimer, SetRow, WeekCard, BottomNav, AccentPicker
    features/
      home/            S01
      intervals/       S02-S06 de intervalos: editor, detalle, ejecución, resumen
      strength/        S07-S11: rutinas, ejercicios, sesión, registro de serie
      history/         S12-S13
      progress/        S14-S15 y cálculo de récords
      settings/        S16, acento, tema, idioma, recordatorios
      backup/          S17: respaldo, restauración, CSV
      monetization/    banner, experimento de intersticial, compra única, consentimiento
        <cada una>/presentation  application  domain  data
    data/db/           tablas, DAOs y migraciones de la base local
    platform/          puente con el motor nativo (canales)
  android/app/src/main/kotlin/.../timer/
    TimerService.kt    servicio en primer plano y wake lock
    TimerEngine.kt     fases y tiempos con reloj monotónico
    CuePlayer.kt       pitidos, voz y vibración con foco de audio
    SessionNotification.kt  notificación con cuenta regresiva y acciones
    CheckpointStore.kt punto de recuperación
  l10n/                app_es.arb, app_en.arb, app_pt_BR.arb
  test/  integration_test/  android/app/src/test/  android/app/src/androidTest/
Dependencias entre capas: presentación → aplicación → dominio ← datos. Las reglas del PRD (R-I, R-G, R-P) viven en el dominio y se prueban sin emulador. El motor nativo solo conoce una lista de fases con duraciones; no sabe de rutinas ni de la base de datos.

## Persistencia local
SQLite a través de Drift: consultas tipadas, transacciones, migraciones versionadas y agregados (volumen, récords) calculados en la propia base [R]. Las preferencias simples (tema, acento, idioma, unidades) van en un almacén clave-valor aparte.

| Opción
 | A favor
 | En contra
 | Decisión
 | 
| Drift (SQLite)
 | Relacional, migraciones probables con tests, consultas reactivas, SQL para estadísticas
 | Generación de código
 | Elegida
 | 
| sqflite
 | Simple, muy usada
 | SQL a mano, sin tipos ni migraciones asistidas
 | Descartada
 | 
| Isar / Hive
 | Rápidas, sin SQL
 | Sin consultas relacionales cómodas; dudas de mantenimiento
 | Descartadas
 | Esquema físico (las 14 entidades del PRD; IDs UUID en texto, fechas en milisegundos UTC + zona horaria en sesiones):

| Tabla
 | Claves e índices
 | 
| exercise
 | índice por nombre normalizado (duplicados, búsqueda) y por músculo
 | 
| strength_routine, routine_exercise, routine_set_target
 | índice por rutina + orden
 | 
| interval_workout, interval_block
 | índice por entrenamiento + padre + orden
 | 
| session
 | índice por fecha de inicio y por estado (recuperación)
 | 
| session_exercise, set_log
 | índice por ejercicio (historial y gráficos) y por sesión
 | 
| interval_phase_log
 | índice por sesión
 | 
| personal_record
 | único por ejercicio + tipo
 | 
| plan_day, reminder
 | —
 | 
- Peso: se guarda el valor y la unidad originales, y además una columna normalizada en gramos (entero) para sumar volumen sin errores de redondeo.

- Escritura: cada serie y cada fase se guarda en su propia transacción al confirmarse (NF-06).

- Migraciones: schemaVersion en la base y en los respaldos; cada migración tiene un test que parte de una base de la versión anterior.

- Respaldo del sistema: se habilita la copia automática de Android hacia el Google Drive de la persona, con reglas que incluyen la base y las preferencias. No pasa por servidores nuestros y complementa el respaldo manual en archivo [R]. Debe mencionarse en la política de privacidad (Legal/Administración).

## Motor del temporizador
El motor corre en Kotlin dentro de un servicio en primer plano; Flutter solo le envía la lista de fases y muestra el estado que el motor publica. Así, si Android detiene la interfaz o la pantalla se apaga, el entrenamiento sigue.
Cómo funciona:

- Al tocar Empezar, Flutter envía por un canal la lista de fases (tipo, etiqueta, duración) y las preferencias de avisos.

- TimerService arranca en primer plano con su notificación y toma un wake lock parcial solo mientras la sesión corre (se suelta en pausa y al terminar).

- TimerEngine guarda el instante de inicio con SystemClock.elapsedRealtime() (reloj monotónico, inmune a cambios de hora) y programa cada cambio de fase en su instante absoluto. Nunca cuenta ticks, así que el error no se acumula.

- En cada cambio de fase: CuePlayer reproduce pitidos precargados y la voz (si hay voz sin conexión para el idioma), con foco de audio transitorio que baja el volumen de la música; vibra con el patrón de la fase; actualiza la notificación; y CheckpointStore guarda el estado (también cada 10 s).

- La interfaz recibe solo eventos de cambio de fase y calcula el tiempo restante localmente; no hay tráfico por fotograma.

- El descanso de la sesión de fuerza usa el mismo servicio con un programa de una sola fase.
Decisiones:

| Tema
 | Decisión
 | Motivo
 | 
| Tipo de servicio en primer plano
 | specialUse, con la justificación "temporizador de intervalos con avisos de audio con la pantalla apagada"
 | health exige permisos de sensores o actividad que no usamos; mediaPlayback no describe lo que hacemos. Riesgo: revisión de Play (ver Riesgos)
 | 
| Alarmas exactas
 | No por defecto
 | Requieren permiso que Android 14+ niega por defecto; solo como respaldo si el spike muestra retrasos
 | 
| Llamadas
 | Se consulta el modo de audio del sistema antes de cada aviso
 | Evita pedir el permiso de estado del teléfono
 | 
| Auriculares desconectados
 | El temporizador sigue; avisos por altavoz o solo vibración según ajuste
 | R-I del PRD
 | 
| Notificación
 | Cuenta regresiva nativa (setChronometerCountDown), acciones Pausar y Saltar, color de la fase
 | El tiempo avanza sin despertar la app
 | 
| Idioma de la voz
 | El motor recibe el idioma de la app y comprueba la voz al empezar; sin voz, solo pitidos y un aviso
 | Las voces sin conexión dependen del teléfono
 | 
| Recuperación
 | Al abrir la app, si hay una sesión "en curso" en el checkpoint, se ofrece Reanudar (en pausa) / Guardar / Descartar
 | F-16
 | Límites que no controlamos: cierres forzados por fabricantes (Xiaomi, Samsung con optimización agresiva), "Forzar detención" desde Ajustes y teléfonos sin voz para el idioma. Se mitigan con la guía de batería (S18-c) y la recuperación; no se pueden eliminar.

## Estado, navegación, temas, acento e idiomas
Riverpod para el estado, go_router para la navegación y un tema construido desde los tokens del design system [R].

| Tema
 | Decisión
 | 
| Estado
 | Riverpod: controladores por pantalla, sin depender del contexto de widgets, fáciles de probar. La sesión activa es un proveedor global alimentado por los eventos del motor nativo
 | 
| Navegación
 | go_router con 4 ramas (Inicio, Entrenar, Historial, Progreso) y rutas de sesión a pantalla completa fuera de las ramas; el botón Atrás en sesión minimiza en vez de cerrar
 | 
| Tema
 | ThemeExtension con los tokens (bg, surface-1, ink, accent, phase-*…) en oscuro y claro; sigue al sistema o a la elección en Configuración
 | 
| Acento
 | Enum de 8 opciones; la función de fases (phasesFor) del design system vive en el dominio y también envía los colores al motor nativo para la notificación
 | 
| Idiomas
 | flutter_localizations + archivos ARB (es, en, pt_BR) con plurales ICU; números y fechas con intl según idioma; idioma por app en Android 13+ (LocaleConfig) y selector propio en Configuración
 | 
| Unidades
 | kg/lb por región al instalar (lb en EE. UU.), cambiable; conversión solo al mostrar
 | 
| Pruebas de idioma
 | Pseudo-idiomas de Android activados en debug para detectar textos fijos y cortes (alemán ~30% más largo)
 | 
| Fuentes
 | Barlow Condensed e Inter empaquetadas en la app (licencia OFL), sin descargarlas de internet: funciona offline
 | 
## Anuncios, consentimiento, analítica y compra única
Todo lo que habla con internet está aislado en el módulo monetization y en un servicio de analítica; si no hay red o la persona no consiente, la app funciona igual [R].

| Pieza
 | Implementación
 | Reglas
 | 
| Consentimiento
 | UMP de Google (incluido en google_mobile_ads) al primer arranque con red, antes de pedir anuncios
 | Sin consentimiento: anuncios limitados; analítica desactivada donde la ley lo exige. Validar con Legal/Administración
 | 
| Banner
 | Banner adaptativo anclado en Inicio, Entrenar, Historial, Progreso y biblioteca de ejercicios
 | Nunca en sesión, editores, diálogos ni resumen; si no carga, colapsa sin dejar hueco
 | 
| Intersticial
 | Solo como experimento detrás de un indicador de Remote Config, apagado por defecto
 | Topes del PRD v0.2 (R-A3, R-A11); precargado; jamás durante una sesión
 | 
| Analítica
 | Google Analytics for Firebase con los eventos mínimos del PRD; sin datos personales ni contenido del entrenamiento
 | Interruptor en Configuración; declarado en Data safety
 | 
| Experimentos
 | Firebase Remote Config (plan gratuito)
 | Valores por defecto embebidos: sin red, se usan esos
 | 
| Compra única "Sin anuncios"
 | in_app_purchase (Google Play Billing), producto no consumible; se reconoce la compra y se restaura consultando compras pasadas
 | Sin servidor propio: la validación es en el teléfono, riesgo de fraude aceptado por el precio bajo (PRD v0.2)
 | 
| Errores en producción
 | Android vitals de Play Console (gratis); Crashlytics opcional, a decidir
 | Sin infraestructura propia
 | 
## Respaldo, exportación e importación
Dos capas sin servidor propio: la copia automática de Android al Google Drive de la persona y un respaldo manual en archivo abierto que ella guarda donde quiera [R].

| Función
 | Formato
 | Cómo
 | 
| Crear respaldo
 | JSON comprimido (trainloop-AAAA-MM-DD.json.gz) con schemaVersion, versión de la app y todas las tablas
 | Selector de archivos del sistema (Storage Access Framework): Drive, Descargas o compartir
 | 
| Restaurar
 | El mismo JSON
 | Valida esquema e integridad antes de tocar nada; muestra resumen; guarda una copia automática de los datos actuales; restaura en una transacción
 | 
| Exportar CSV
 | Un CSV por sesiones y otro por series, con unidad e idioma neutro (punto decimal, fechas ISO)
 | Para hojas de cálculo y otras apps
 | 
| Importar CSV de Strong, Hevy, FitNotes
 | Mapeo de columnas por formato conocido; ejercicios nuevos se crean como propios
 | v1.1 (F-23); se puede repetir sin duplicar (clave por fecha + ejercicio + orden)
 | 
| Copia automática de Android
 | Base de datos y preferencias, con reglas de extracción
 | Sin código de servidor; la restaura Android al reinstalar con la misma cuenta de Google
 | La restauración queda deshabilitada mientras hay una sesión activa.

## Estrategia de pruebas
La pirámide se carga hacia abajo: las reglas del PRD y la matemática del temporizador se prueban en milisegundos sin emulador; el emulador y los teléfonos reales quedan para lo que solo ellos pueden probar [R].

| Nivel
 | Qué cubre
 | Herramienta
 | Cuándo corre
 | 
| Unitarias (Dart)
 | Reglas R-I, R-G, R-P; 1RM, volumen, récords; phasesFor y acentos; formatos por idioma
 | flutter test
 | Cada cambio (CI)
 | 
| Unitarias (Kotlin)
 | TimerEngine con reloj falso: fases, pausas, saltos, recuperación
 | JUnit
 | Cada cambio (CI)
 | 
| Base de datos
 | DAOs y cada migración desde la versión anterior; respaldo y restauración de ida y vuelta
 | Drift en memoria
 | Cada cambio (CI)
 | 
| Widgets y capturas
 | Pantallas en oscuro/claro, 8 acentos y 3 idiomas; texto al 200%; pseudo-idiomas
 | Tests de widgets + golden tests
 | Cada cambio (CI)
 | 
| Integración
 | Recorridos J1–J5 de punta a punta
 | integration_test en emulador
 | Antes de cada versión
 | 
| Servicio nativo
 | Arranque del servicio, notificación, checkpoint, cierre del proceso
 | Pruebas instrumentadas de Android en emulador
 | Antes de cada versión
 | 
| Matriz de dispositivos
 | Casos T-01 a T-12 del PRD (pantalla apagada, Doze, llamadas, Bluetooth, fabricantes)
 | Emulador + teléfonos reales; Firebase Test Lab tiene un cupo gratuito diario de dispositivos físicos [H: verificar cupo vigente]
 | Antes de beta y de cada versión mayor
 | 
| Accesibilidad
 | Contraste, TalkBack, áreas táctiles
 | Accessibility Scanner + revisión manual
 | Antes de beta
 | 
| Beta cerrada
 | Uso real, estabilidad, retención
 | Play Console (≥ 12 testers, 14 días)
 | Fase 6
 | CI gratuito: GitHub Actions corre las pruebas unitarias, de base de datos y de widgets en cada cambio; el emulador se usa en una tarea separada antes de cada versión para no gastar minutos del plan gratuito.

## Resultados del spike en emulador
Emulador Android 16 (API 36), app mínima: Flutter solo como UI y el motor en un servicio Kotlin en primer plano (specialUse) con elapsedRealtime, objetivos absolutos, wake lock parcial, notificación con cuenta regresiva, voz y pitidos, y checkpoint cada 10 s. Informe completo en trainloop-spike/SPIKE_REPORT.md.

| #
 | Prueba
 | Resultado
 | Datos
 | 
| T1
 | Tabata con pantalla encendida
 | ✅
 | 16 cambios de fase, retraso medio 1,9 ms (máx. 16 ms), desfase final 2 ms
 | 
| T2
 | Pantalla apagada desde el segundo 15
 | ✅
 | 15 cambios, máx. 3 ms, todos los avisos sonaron
 | 
| T3
 | Doze profundo forzado
 | ✅
 | 15 cambios en Doze, máx. 8 ms
 | 
| T4
 | Usuario marca la app como «Restringida» en batería
 | ❌
 | El servicio no queda en primer plano y el sistema lo detiene a los ~63 s; el checkpoint sí queda guardado
 | 
| T5
 | Proceso matado a la fuerza y reapertura
 | ✅ con matiz
 | Aparece la tarjeta de recuperación y restaura en pausa; se pierden 7–11 s (objetivo ≤ 10 s)
 | 
| T6
 | Permiso de notificaciones denegado
 | ✅
 | La sesión corre igual sin notificación visible; máx. 3 ms
 | 
| T7
 | Sesión de 29:50 con pantalla apagada y Doze
 | ✅ en desfase
 | Termina con +3 ms; 58 de 60 cambios ≤ 6 ms; 2 atípicos (18 s y 1,6 s) coinciden con una pausa de todo el sistema, quizá del emulador
 | 
| T8
 | Rotar y salir/volver a la app
 | ✅
 | Sin reinicio: mismo proceso y misma sesión
 | Otros hallazgos

- El primer aviso tras abrir la app sale sin voz porque el TTS aún se está iniciando: hay que precalentarlo.

- Android 16 ignora la petición de foco de audio desde segundo plano, pero los pitidos y la voz suenan igual.

- El Tabata dura 4:00 en total con la preparación: 0:10 + 8 × 0:20 + 7 × 0:10 (sin el último descanso). No 4:10: en D4 se corrigieron S02, S03 y S06 y la app calcula los totales desde la estructura.
Límites: un emulador no reproduce los cierres agresivos de Samsung, Xiaomi u OPPO, ni el comportamiento real de Doze con el teléfono en reposo. Esas pruebas se hacen en teléfonos reales en el entregable del temporizador.
Qué cambia en la arquitectura

- Se mantiene: motor nativo en un servicio Kotlin en primer plano y Flutter solo como UI.

- Sin alarmas exactas por defecto. Solo se agregan (setExactAndAllowWhileIdle/setAlarmClock) si el atípico de 18 s se repite en teléfonos reales.

- Nuevo: detectar isBackgroundRestricted() y mostrar cómo quitar la restricción (cubre T4).

- Nuevo: pedir el permiso de notificaciones antes de la primera sesión, precalentar el TTS y hacer el checkpoint atómico (archivo temporal + renombrar) para no perder más de 10 s.

- Tipo del servicio: specialUse funciona. Antes de publicar se revisa si conviene un tipo estándar (por ejemplo mediaPlayback) para la declaración en Play.
Veredicto: GO, condicionado a repetir T3, T4, T5 y T7 en un Samsung y un Xiaomi reales.

## Costos
El único pago obligatorio es la cuenta de desarrollador de Google Play (US$25, una vez); la operación mensual cuesta US$0 [R]. Los precios hay que confirmarlos con Finanzas antes de registrar la cuenta.

| Concepto
 | Costo
 | Tipo
 | Nota
 | 
| Cuenta de desarrollador Google Play
 | US$25
 | Único
 | Obligatoria para publicar
 | 
| Servidores, base de datos, autenticación
 | US$0
 | —
 | No existen: todo es local
 | 
| Firebase (Analytics, Remote Config, Test Lab)
 | US$0
 | Mensual
 | Plan gratuito
 | 
| AdMob
 | US$0
 | —
 | Ingreso, no costo
 | 
| Comisión de Google Play sobre la compra única
 | 15% de cada venta
 | Variable
 | Tasa para el primer US$1 M anual de ingresos
 | 
| GitHub (repositorio y CI)
 | US$0
 | Mensual
 | Plan gratuito; minutos de CI limitados
 | 
| Política de privacidad
 | US$0
 | —
 | Publicada en una página gratuita (GitHub Pages o similar)
 | 
| Fuentes (Barlow Condensed, Inter)
 | US$0
 | —
 | Licencia OFL
 | 
| Teléfonos de prueba
 | US$0 a definir
 | Único
 | Emulador + teléfonos del equipo + cupo gratuito de Test Lab; comprar un Xiaomi de gama media es opcional
 | 
| Revisión nativa de traducciones (en, pt-BR)
 | A definir
 | Único
 | Voluntarios o proveedor; decisión de Gestión
 | 
## Plan de desarrollo
Diez entregables en el orden del brief; la app es completamente usable al cerrar el 7, antes de sumar anuncios. El motor del temporizador se adelanta al entregable 2 porque es el mayor riesgo [R]. Tamaño relativo: S (días), M (1–2 semanas), L (2–3 semanas), a recalibrar tras el entregable 1.

| #
 | Entregable
 | Incluye (PRD)
 | Tamaño
 | Criterios de aceptación
 | 
| 1
 | Proyecto base y navegación
 | Repositorio propio, CI, tema y tokens, acento, 4 pestañas, idiomas es/en/pt-BR, pseudo-idiomas
 | M
 | Compila en CI; las 4 pestañas navegan; cambiar tema, acento e idioma repinta sin reiniciar; sin textos fijos detectados con pseudo-idiomas
 | 
| 2
 | Almacenamiento local
 | Base Drift con las 14 tablas, migración inicial, preferencias, copia automática de Android
 | M
 | Tests de DAOs y migración en verde; los datos sobreviven a cerrar y reabrir; ningún acceso a red
 | 
| 3
 | Ejercicios y rutinas
 | F-06, F-07: biblioteca de ~100 ejercicios, ejercicios propios, rutinas ilimitadas
 | M
 | Crear rutina de 5 ejercicios en < 2 min; duplicado detectado; editar no altera sesiones pasadas
 | 
| 4
 | Temporizador de intervalos
 | F-02 a F-05, F-16: editor, plantillas, motor nativo, avisos, notificación, recuperación
 | L
 | Casos T-01 a T-12 del PRD en emulador; desfase ≤ 1 s en 60 min con pantalla apagada; Tabata en ≤ 3 toques desde Inicio
 | 
| 5
 | Ejecución y registro de fuerza
 | F-08, F-09: sesión, series con valores anteriores, descanso automático, resumen
 | L
 | Serie repetida en 1 toque; descanso suena con pantalla apagada; ninguna serie se pierde al cerrar la app a la fuerza
 | 
| 6
 | Historial y estadísticas
 | F-10, F-11, F-12 (alcance v0.2): historial, semana, calendario, última marca, récords
 | M
 | Cifras coinciden con un conjunto de datos de prueba calculado a mano; semana unificada y separada disponibles para el test
 | 
| 7
 | Experiencia y accesibilidad
 | F-01, F-13, F-14, F-17: inicio sin cuenta, recordatorios, respaldo y CSV, configuración completa
 | M
 | NF-01 y NF-08 cumplidos; respaldo restaurado en un emulador limpio; TalkBack recorre J1–J3. App completa sin anuncios
 | 
| 8
 | Monetización y consentimiento
 | F-15: UMP, banner, intersticial detrás de indicador apagado, compra única, analítica
 | M
 | Ningún anuncio en sesión (prueba automatizada); sin red la app funciona igual; compra restaurable; Data safety completo
 | 
| 9
 | Pruebas y estabilidad
 | Matriz de dispositivos, Test Lab, rendimiento, batería
 | M
 | NF-02 a NF-06 y NF-10 medidos; ≥ 99,5% de sesiones sin fallos en la prueba interna
 | 
| 10
 | Publicación
 | Ficha de Play en 3 idiomas, política de privacidad, declaración del servicio en primer plano, prueba cerrada (≥ 12 testers, 14 días)
 | M
 | Aprobada la revisión de Play; beta cerrada cumplida; checklist del Gate 6
 | Las funciones v1.1 (sesiones mixtas, superseries, calculadora de discos, importación de CSV, widget) empiezan solo después del entregable 10.

## Riesgos y decisiones para el Gate 4

| Riesgo técnico
 | Probabilidad
 | Impacto
 | Mitigación
 | 
| Play rechaza el servicio en primer plano specialUse
 | Media
 | Alto
 | Declaración clara con video del caso de uso; alternativa health si se suma un sensor (p. ej. ritmo cardíaco) en el futuro
 | 
| Fabricantes cierran el servicio pese a todo
 | Alta
 | Alto
 | Recuperación desde checkpoint, guía de batería por fabricante, pruebas en teléfonos reales y Test Lab
 | 
| Doze retrasa los avisos con pantalla apagada
 | Media
 | Alto
 | Medido en el spike; respaldo con alarmas exactas solo si hace falta y con permiso pedido en contexto
 | 
| Voz sin conexión no disponible en el idioma
 | Media
 | Medio
 | Comprobación al empezar; pitidos y vibración siempre disponibles
 | 
| Arranque en frío > 1,5 s por Flutter
 | Baja
 | Medio
 | Medir en el entregable 1 en gama media; reducir trabajo inicial; plan B Kotlin nativo para la interfaz
 | 
| Dependencias de terceros abandonadas
 | Baja
 | Medio
 | Paquetes oficiales de Google/Flutter para lo crítico; motor propio
 | 
| Fraude en la compra única sin servidor
 | Media
 | Bajo
 | Riesgo aceptado (PRD v0.2) por el precio bajo
 | Para aprobar el Gate 4 necesitamos tu decisión en:

- Stack: Flutter para la interfaz + módulo Kotlin propio para el motor del temporizador (validar con Arquitectura).

- Persistencia: Drift (SQLite) + copia automática de Android.

- Servicio en primer plano specialUse y sin alarmas exactas por defecto (según el resultado del spike).

- Estado con Riverpod y navegación con go_router.

- Plan de 10 entregables y criterios de aceptación.

- Repositorio nuevo y propio para Trainloop (separado de Flixer).
Gate 4 aprobado por Nicolás el 3 de noviembre de 2026. Stack y plan como arriba. El repositorio es NicolasJorquera/trainloop. El desarrollo parte con el entregable 1.
