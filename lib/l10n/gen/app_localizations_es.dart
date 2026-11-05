// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Trainloop';

  @override
  String get logoWordmark => 'TRAINLOOP';

  @override
  String get navMainLabel => 'Navegación principal';

  @override
  String get navHome => 'INICIO';

  @override
  String get navTrain => 'ENTRENAR';

  @override
  String get navHistory => 'HISTORIAL';

  @override
  String get navProgress => 'PROGRESO';

  @override
  String get settingsTooltip => 'Configuración';

  @override
  String get backTooltip => 'Volver';

  @override
  String get homeWeekOverline => 'ESTA SEMANA';

  @override
  String get homeWeekEmptyTitle => 'Aún no entrenas esta semana';

  @override
  String get homeWeekEmptyBody =>
      'Empieza un temporizador de intervalos o una sesión de fuerza. Todo queda en este teléfono.';

  @override
  String get homeStartIntervals => 'INTERVALOS';

  @override
  String get homeStartStrength => 'FUERZA';

  @override
  String get trainTitle => 'ENTRENAR';

  @override
  String get trainKindLabel => 'Tipo de entrenamiento';

  @override
  String get trainIntervals => 'Intervalos';

  @override
  String get trainRoutines => 'Fuerza';

  @override
  String get trainIntervalsEmptyTitle => 'Aún no tienes temporizadores';

  @override
  String get trainIntervalsEmptyBody =>
      'Crea uno con NUEVO o empieza desde una plantilla.';

  @override
  String get trainRoutinesEmptyTitle => 'Tus rutinas de fuerza';

  @override
  String get trainRoutinesEmptyBody =>
      'Arma rutinas con tus ejercicios y registra cada serie con un toque.';

  @override
  String get historyTitle => 'HISTORIAL';

  @override
  String get historyEmptyTitle => 'Aún no hay sesiones';

  @override
  String get historyEmptyBody =>
      'Cada entrenamiento que termines se guarda aquí, en este teléfono.';

  @override
  String get progressTitle => 'PROGRESO';

  @override
  String get progressEmptyTitle => 'Todavía no hay nada que graficar';

  @override
  String get progressEmptyBody =>
      'Entrena un par de semanas para ver tus sesiones, minutos activos y récords.';

  @override
  String get settingsTitle => 'AJUSTES';

  @override
  String get settingsAppearance => 'APARIENCIA';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get settingsAccent => 'COLOR DE ACENTO';

  @override
  String get accentHelp =>
      'Cambia el color de botones, barras y la fase de trabajo. Todos tienen el mismo contraste.';

  @override
  String get accentOrquidea => 'Orquídea';

  @override
  String get accentRosa => 'Rosa';

  @override
  String get accentRojo => 'Rojo';

  @override
  String get accentNaranja => 'Naranja';

  @override
  String get accentAmarillo => 'Amarillo';

  @override
  String get accentLima => 'Lima';

  @override
  String get accentAzul => 'Azul';

  @override
  String get accentVioleta => 'Violeta';

  @override
  String get phaseWork => 'TRABAJO';

  @override
  String get phaseRest => 'DESCANSO';

  @override
  String get settingsLanguage => 'IDIOMA';

  @override
  String get languageSystem => 'Idioma del teléfono';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePortuguese => 'Português (Brasil)';

  @override
  String get languagePseudo => 'Pseudolocale (en-XA, depuración)';

  @override
  String get languageHelp =>
      'Se aplica al instante. En Android 13 o superior también puedes elegirlo en los ajustes de la app del sistema.';

  @override
  String get selectedLabel => 'Seleccionado';

  @override
  String get debugDatabaseSection => 'DEPURACIÓN · BASE DE DATOS';

  @override
  String debugDatabaseCounts(
    int exercises,
    int routines,
    int workouts,
    int sessions,
    int sets,
  ) {
    return '$exercises ejercicios · $routines rutinas · $workouts temporizadores · $sessions sesiones · $sets series';
  }

  @override
  String get debugDatabaseHelp =>
      'Solo en depuración. Los datos quedan en este teléfono: fuerza la detención de la app y ábrela de nuevo para comprobar que siguen ahí.';

  @override
  String get debugSeedDemo => 'AGREGAR DATOS DE PRUEBA';

  @override
  String get trainNewRoutine => 'NUEVA';

  @override
  String get trainRoutinesHint =>
      'Sin límite de rutinas. Mantén presionada una tarjeta para reordenar.';

  @override
  String get trainExerciseLibrary => 'Biblioteca de ejercicios';

  @override
  String routineExerciseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ejercicios',
      one: '1 ejercicio',
      zero: 'Sin ejercicios',
    );
    return '$_temp0';
  }

  @override
  String routineActions(String name) {
    return 'Opciones de $name';
  }

  @override
  String get routineEdit => 'Editar';

  @override
  String get routineDuplicate => 'Duplicar';

  @override
  String get routineArchive => 'Archivar';

  @override
  String routineArchived(String name) {
    return '«$name» archivada';
  }

  @override
  String routineDuplicated(String name) {
    return 'Copia creada: «$name»';
  }

  @override
  String routineCopyName(String name) {
    return '$name (copia)';
  }

  @override
  String get undo => 'Deshacer';

  @override
  String get routineNewTitle => 'Nueva rutina';

  @override
  String get routineEditTitle => 'Editar rutina';

  @override
  String get fieldName => 'NOMBRE';

  @override
  String get routineNameHint => 'Ej.: Piernas A';

  @override
  String routineDefaultName(int number) {
    return 'Rutina $number';
  }

  @override
  String routineExercisesLabel(int count) {
    return 'EJERCICIOS · $count';
  }

  @override
  String get routineAddExercises => 'Agregar ejercicios';

  @override
  String get routineEditorHint =>
      'Editar la rutina no cambia tus sesiones pasadas.';

  @override
  String get routineSave => 'Guardar rutina';

  @override
  String routineRemoveExercise(String name) {
    return 'Quitar $name';
  }

  @override
  String get routineDragHandle => 'Arrastra para reordenar';

  @override
  String summarySetsReps(int sets, int reps) {
    return '$sets × $reps';
  }

  @override
  String summarySetsTime(int sets, String time) {
    return '$sets × $time';
  }

  @override
  String summarySets(int sets) {
    String _temp0 = intl.Intl.pluralLogic(
      sets,
      locale: localeName,
      other: '$sets series',
      one: '1 serie',
    );
    return '$_temp0';
  }

  @override
  String summaryRest(String time) {
    return 'descanso $time';
  }

  @override
  String summaryJoin(String first, String second) {
    return '$first · $second';
  }

  @override
  String weightValue(String value, String unit) {
    return '$value $unit';
  }

  @override
  String get unitKg => 'kg';

  @override
  String get unitLb => 'lb';

  @override
  String durationMinSec(int minutes, String seconds) {
    return '$minutes:$seconds';
  }

  @override
  String numberValue(int value) {
    return '$value';
  }

  @override
  String get sheetSets => 'Series';

  @override
  String get sheetReps => 'Repeticiones';

  @override
  String get sheetDuration => 'Duración';

  @override
  String get sheetWeight => 'Peso objetivo (opcional)';

  @override
  String get sheetRest => 'Descanso';

  @override
  String get sheetDone => 'Listo';

  @override
  String stepperDecrease(String label) {
    return 'Menos: $label';
  }

  @override
  String stepperIncrease(String label) {
    return 'Más: $label';
  }

  @override
  String get libraryTitle => 'Ejercicios';

  @override
  String get libraryPickTitle => 'Agregar ejercicios';

  @override
  String get librarySearch => 'Buscar ejercicio';

  @override
  String get libraryFilterMuscle => 'Filtrar por músculo';

  @override
  String get libraryAnyEquipment => 'Equipo';

  @override
  String get libraryAnyLogType => 'Registro';

  @override
  String get libraryAll => 'Todos';

  @override
  String libraryNotFound(String query) {
    return 'No encontramos «$query»';
  }

  @override
  String libraryCreateNamed(String query) {
    return 'Crear «$query»';
  }

  @override
  String get libraryCreateCustom => 'Crear ejercicio propio';

  @override
  String libraryAddCount(int count) {
    return 'Agregar $count';
  }

  @override
  String get libraryPickPrompt => 'Selecciona ejercicios';

  @override
  String get libraryCustomTag => 'Propio';

  @override
  String get muscleGroupLegs => 'Piernas';

  @override
  String get muscleGroupChest => 'Pecho';

  @override
  String get muscleGroupBack => 'Espalda';

  @override
  String get muscleGroupShoulders => 'Hombros';

  @override
  String get muscleGroupArms => 'Brazos';

  @override
  String get muscleGroupCore => 'Core';

  @override
  String get muscleGroupOther => 'Cardio y más';

  @override
  String get muscleChest => 'Pecho';

  @override
  String get muscleBack => 'Espalda';

  @override
  String get muscleShoulders => 'Hombros';

  @override
  String get muscleBiceps => 'Bíceps';

  @override
  String get muscleTriceps => 'Tríceps';

  @override
  String get muscleForearms => 'Antebrazos';

  @override
  String get muscleCore => 'Core';

  @override
  String get muscleQuads => 'Cuádriceps';

  @override
  String get muscleHamstrings => 'Isquiotibiales';

  @override
  String get muscleGlutes => 'Glúteos';

  @override
  String get muscleCalves => 'Pantorrillas';

  @override
  String get muscleFullBody => 'Cuerpo completo';

  @override
  String get muscleCardio => 'Cardio';

  @override
  String get muscleOther => 'Otro';

  @override
  String get equipmentBarbell => 'Barra';

  @override
  String get equipmentDumbbell => 'Mancuernas';

  @override
  String get equipmentMachine => 'Máquina';

  @override
  String get equipmentCable => 'Polea';

  @override
  String get equipmentKettlebell => 'Kettlebell';

  @override
  String get equipmentBand => 'Banda elástica';

  @override
  String get equipmentBodyweight => 'Peso corporal';

  @override
  String get equipmentOther => 'Otro';

  @override
  String get logTypeWeightReps => 'Peso + reps';

  @override
  String get logTypeReps => 'Solo reps';

  @override
  String get logTypeTime => 'Tiempo';

  @override
  String get logTypeDistance => 'Distancia';

  @override
  String get logTypeTimeDistance => 'Distancia + tiempo';

  @override
  String get exerciseCreateTitle => 'Crear ejercicio';

  @override
  String get exerciseEditTitle => 'Editar ejercicio';

  @override
  String get exerciseNameHint => 'Ej.: Sentadilla búlgara';

  @override
  String exerciseDuplicate(String name) {
    return 'Ya existe «$name». ¿Usar el existente?';
  }

  @override
  String exerciseUseExisting(String name) {
    return 'Usar «$name»';
  }

  @override
  String get exerciseTrackLabel => 'QUÉ REGISTRAS';

  @override
  String get exerciseMuscleLabel => 'MÚSCULO PRINCIPAL';

  @override
  String get exerciseEquipmentLabel => 'EQUIPO';

  @override
  String get exerciseIncrementLabel => 'INCREMENTO';

  @override
  String get exerciseRestLabel => 'DESCANSO POR DEFECTO';

  @override
  String get exerciseSave => 'Guardar ejercicio';

  @override
  String get exerciseArchive => 'Archivar ejercicio';

  @override
  String get exerciseArchived =>
      'Ejercicio archivado. Tu historial lo conserva.';

  @override
  String get phaseNamePrepare => 'Preparación';

  @override
  String get phaseNameWarmup => 'Calentamiento';

  @override
  String get phaseNameWork => 'Trabajo';

  @override
  String get phaseNameRest => 'Descanso';

  @override
  String get phaseNameCooldown => 'Vuelta a la calma';

  @override
  String get timerPhasePrepare => 'PREPÁRATE';

  @override
  String get timerPhaseWarmup => 'CALENTAMIENTO';

  @override
  String get timerPhaseCooldown => 'VUELTA A LA CALMA';

  @override
  String get templateTabata => 'Tabata 20/10';

  @override
  String get templateHiit4020 => 'HIIT 40/20';

  @override
  String get templateHiit3030 => 'HIIT 30/30';

  @override
  String get templateEmom10 => 'EMOM 10 min';

  @override
  String get templateAmrap12 => 'AMRAP 12 min';

  @override
  String get templateWalkRun => 'Caminar/correr';

  @override
  String get templateRun => 'Correr';

  @override
  String get templateWalk => 'Caminar';

  @override
  String get templateTag => 'Plantilla';

  @override
  String intervalMeta(int rounds, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds rondas',
      one: '1 ronda',
    );
    return '$_temp0 · $total';
  }

  @override
  String get homeQuickTemplates => 'PLANTILLAS RÁPIDAS';

  @override
  String get trainTemplates => 'PLANTILLAS';

  @override
  String get trainMyIntervals => 'MIS TEMPORIZADORES';

  @override
  String get trainNewInterval => 'NUEVO';

  @override
  String get intervalNewTooltip => 'Nuevo temporizador de intervalos';

  @override
  String intervalStart(String name) {
    return 'Empezar $name';
  }

  @override
  String intervalActions(String name) {
    return 'Acciones de $name';
  }

  @override
  String intervalArchived(String name) {
    return '«$name» archivado';
  }

  @override
  String get detailCloseTooltip => 'Cerrar';

  @override
  String detailMeta(String total, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds rondas',
      one: '1 ronda',
    );
    return '$total en total · $_temp0';
  }

  @override
  String get repeatCaps => 'REPETICIÓN';

  @override
  String repeatRounds(int rounds) {
    return '× $rounds RONDAS';
  }

  @override
  String get detailSkipLast => 'Se omite el último descanso';

  @override
  String get alertVoice => 'Voz';

  @override
  String get alertBeeps => 'pitidos';

  @override
  String get alertVibration => 'vibración';

  @override
  String alertsOn(String items) {
    return '$items: activados';
  }

  @override
  String get alertsOff => 'Avisos desactivados';

  @override
  String get detailNoVoice => 'Sin voz para este idioma: solo pitidos';

  @override
  String get detailStart => 'EMPEZAR';

  @override
  String get detailEdit => 'EDITAR';

  @override
  String get detailDuplicate => 'DUPLICAR';

  @override
  String get detailCustomize => 'PERSONALIZAR';

  @override
  String get editorNewTitle => 'NUEVO TEMPORIZADOR';

  @override
  String get editorEditTitle => 'EDITAR TEMPORIZADOR';

  @override
  String editorDefaultName(String date) {
    return 'Intervalos $date';
  }

  @override
  String editorLess(String phase) {
    return 'Restar 5 segundos a $phase';
  }

  @override
  String editorMore(String phase) {
    return 'Sumar 5 segundos a $phase';
  }

  @override
  String get editorLessRounds => 'Menos rondas';

  @override
  String get editorMoreRounds => 'Más rondas';

  @override
  String get editorSkipLast => 'Omitir el último descanso';

  @override
  String get editorAddBlock => 'AGREGAR BLOQUE';

  @override
  String get editorAddToRepeat => 'AGREGAR A LA REPETICIÓN';

  @override
  String get editorRepeat => 'Repetición';

  @override
  String get editorAddTitle => 'Agregar';

  @override
  String get editorErrorNoWork =>
      'Agrega al menos un intervalo de trabajo de 1 segundo o más.';

  @override
  String get editorErrorEmptyRepeat =>
      'Cada repetición necesita al menos un intervalo.';

  @override
  String get editorErrorTooLong => 'El total no puede superar 4 horas.';

  @override
  String get editorTotal => 'DURACIÓN TOTAL';

  @override
  String get editorSave => 'GUARDAR';

  @override
  String get editorBlockActions => 'Acciones del bloque';

  @override
  String get editorRename => 'Etiqueta';

  @override
  String get editorLabelHint => 'Ej.: Sentadillas';

  @override
  String get editorMoveUp => 'Subir';

  @override
  String get editorMoveDown => 'Bajar';

  @override
  String get editorRemove => 'Quitar';

  @override
  String editorDurationTitle(String phase) {
    return 'Duración de $phase';
  }

  @override
  String get editorMinutes => 'Minutos';

  @override
  String get editorSeconds => 'Segundos';

  @override
  String get dialogCancel => 'Cancelar';

  @override
  String get dialogOk => 'Aceptar';

  @override
  String timerRound(int round, int rounds) {
    return 'RONDA $round/$rounds';
  }

  @override
  String timerSet(int set, int sets) {
    return 'SERIE $set/$sets';
  }

  @override
  String timerNext(String phase, String duration) {
    return 'Siguiente: $phase $duration';
  }

  @override
  String get timerLast => 'Última fase';

  @override
  String get timerPaused => 'EN PAUSA';

  @override
  String get timerTapToResume => 'TOCA PARA REANUDAR';

  @override
  String get timerPause => 'Pausar';

  @override
  String get timerResume => 'Reanudar';

  @override
  String get timerSkip => 'Saltar a la siguiente fase';

  @override
  String get timerSkipShort => 'Saltar';

  @override
  String get timerPrevious => 'Volver al inicio de la fase';

  @override
  String get timerHoldToStop => 'MANTÉN PARA DETENER';

  @override
  String get timerHoldHint => 'Mantén presionado para detener la sesión';

  @override
  String get timerLock => 'Bloquear controles';

  @override
  String get timerLocked =>
      'Controles bloqueados · toca el candado para desbloquear';

  @override
  String timerProgress(int current, int total) {
    return 'Fase $current de $total';
  }

  @override
  String get timerChannel => 'Sesión en curso';

  @override
  String timerNotificationRound(String phase, int round, int rounds) {
    return '$phase · Ronda $round/$rounds';
  }

  @override
  String cueRound(String phase, int round, int rounds) {
    return '$phase, ronda $round de $rounds';
  }

  @override
  String cueThenNext(String phase, String next) {
    return '$phase. Sigue: $next';
  }

  @override
  String get cueFinish => 'Sesión completa';

  @override
  String get summaryDoneTitle => '¡Sesión completa!';

  @override
  String get summaryStoppedTitle => 'Sesión detenida';

  @override
  String summarySubtitle(String name, String date) {
    return '$name · $date';
  }

  @override
  String get summaryTotal => 'TOTAL';

  @override
  String get summaryRounds => 'RONDAS';

  @override
  String get summaryWork => 'TRABAJO';

  @override
  String summaryRoundsValue(int done, int total) {
    return '$done/$total';
  }

  @override
  String summarySkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fases omitidas',
      one: '1 fase omitida',
      zero: '0 fases omitidas',
    );
    return '$_temp0';
  }

  @override
  String summaryPaused(String time) {
    return '$time en pausa';
  }

  @override
  String get summaryNoPauses => 'sin pausas';

  @override
  String get summaryShort => 'Duró menos de 30 segundos. ¿Quieres descartarla?';

  @override
  String get summaryRpeQuestion => '¿QUÉ TAN DURO FUE? (OPCIONAL)';

  @override
  String summaryRpeValue(int value) {
    return 'Esfuerzo $value de 10';
  }

  @override
  String get summaryRpeEasy => 'Muy suave';

  @override
  String get summaryRpeMax => 'Máximo';

  @override
  String get summaryNote => 'NOTA';

  @override
  String get summaryNoteHint => 'Ej.: «Rodilla molesta en la última ronda»';

  @override
  String get summaryDone => 'LISTO';

  @override
  String get summaryDiscard => 'Descartar sesión';

  @override
  String get summaryDiscardTitle => '¿Descartar esta sesión?';

  @override
  String get summaryDiscardBody =>
      'No se guardará en tu historial ni contará para tu semana.';

  @override
  String get summaryDiscardConfirm => 'Descartar';

  @override
  String get notifyTitle => 'SIGUE TU ENTRENAMIENTO CON LA PANTALLA APAGADA';

  @override
  String get notifyBody =>
      'Trainloop muestra una notificación mientras entrenas para que veas la fase y el tiempo sin desbloquear el teléfono.';

  @override
  String get notifyContinue => 'CONTINUAR';

  @override
  String get notifyNotNow => 'Ahora no · empezar igual';

  @override
  String get recoveryTitle => 'TIENES UN ENTRENAMIENTO SIN TERMINAR';

  @override
  String recoveryRound(int round, int rounds) {
    return 'Ronda $round/$rounds';
  }

  @override
  String recoveryAgo(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'interrumpido hace $minutes min',
      one: 'interrumpido hace 1 min',
      zero: 'interrumpido hace instantes',
    );
    return '$_temp0';
  }

  @override
  String get recoveryBody =>
      'Android cerró la app. Guardamos tu avance hasta el último punto.';

  @override
  String get recoveryResume => 'REANUDAR (EN PAUSA)';

  @override
  String get recoverySaveIncomplete => 'GUARDAR COMO INCOMPLETA';

  @override
  String get recoveryDiscard => 'DESCARTAR';

  @override
  String batteryTitle(String brand) {
    return 'EVITA QUE $brand PAUSE EL TEMPORIZADOR';
  }

  @override
  String get batteryBody =>
      'La batería de Trainloop está restringida y el temporizador se detendría con la pantalla apagada. Se configura una sola vez:';

  @override
  String get batteryStep1 => 'Ajustes › Aplicaciones › Trainloop';

  @override
  String get batteryStep2 => 'Batería';

  @override
  String get batteryStep3 => 'Elige «Sin restricciones»';

  @override
  String get batteryOpenSettings => 'ABRIR AJUSTES';

  @override
  String get batteryDone => 'YA LO HICE';

  @override
  String get batteryLater => 'MÁS TARDE';

  @override
  String get activeSessionTitle => 'Ya tienes una sesión en curso';

  @override
  String get activeSessionBody => 'Termínala antes de empezar otra.';

  @override
  String get activeSessionGo => 'VOLVER A LA SESIÓN';

  @override
  String get volumeZero =>
      'El volumen multimedia está en 0: no oirás los avisos.';

  @override
  String get settingsAlerts => 'ALERTAS';

  @override
  String get settingsVoice => 'Voz';

  @override
  String get settingsVoiceHelp => 'Dice el nombre de cada fase';

  @override
  String get settingsBeeps => 'Pitidos 3-2-1';

  @override
  String get settingsBeepsHelp =>
      'Tono en cada fase y en los últimos 3 segundos';

  @override
  String get settingsVibration => 'Vibración';

  @override
  String get settingsVibrationHelp => 'Larga en trabajo, doble en descanso';

  @override
  String get homeActiveSession => 'SESIÓN EN CURSO';

  @override
  String get homeActiveStrength => 'Volver a tu sesión de fuerza';

  @override
  String get homeRepeatLast => 'REPETIR ÚLTIMO';

  @override
  String homeRepeatMeta(String date) {
    return 'Fuerza · $date';
  }

  @override
  String routineStart(String name) {
    return 'Empezar $name';
  }

  @override
  String get settingsTraining => 'ENTRENAMIENTO';

  @override
  String get settingsUnits => 'Unidades';

  @override
  String get settingsUnitsHelp =>
      'Cambia cómo se muestran y escriben los pesos. Las series guardadas conservan su unidad original.';

  @override
  String get cueRestOver => 'A la siguiente serie';

  @override
  String get strengthFreeWorkout => 'ENTRENAMIENTO LIBRE';

  @override
  String get strengthFreeTitle => 'Entrenamiento libre';

  @override
  String get strengthEmptyRoutine =>
      'Esta rutina no tiene ejercicios. Agrega alguno para empezarla.';

  @override
  String get strengthEmptyHint =>
      'Agrega los ejercicios que vas a hacer. Cada serie se guarda apenas la marcas.';

  @override
  String get strengthInProgress => 'Sesión en curso';

  @override
  String get strengthFinish => 'TERMINAR';

  @override
  String strengthProgress(int done, int total) {
    return '$done/$total series';
  }

  @override
  String get strengthRestLabel => '● DESCANSO';

  @override
  String get strengthRestNotification => 'Descanso';

  @override
  String strengthRestRemaining(String time) {
    return 'Descanso, quedan $time';
  }

  @override
  String get strengthRestOver => '¡A la siguiente serie!';

  @override
  String get strengthMinus15 => '−15';

  @override
  String get strengthPlus15 => '+15';

  @override
  String get strengthPlus15Short => '+15 s';

  @override
  String get strengthMinus15Tooltip => 'Restar 15 segundos';

  @override
  String get strengthPlus15Tooltip => 'Sumar 15 segundos';

  @override
  String get strengthSkipRest => 'SALTAR';

  @override
  String get strengthSkipRestTooltip => 'Saltar el descanso';

  @override
  String strengthRestFor(String time) {
    return 'Descanso $time';
  }

  @override
  String strengthExerciseActions(String name) {
    return 'Opciones de $name';
  }

  @override
  String get strengthMoveUp => 'Subir';

  @override
  String get strengthMoveDown => 'Bajar';

  @override
  String get strengthRemoveExercise => 'Quitar ejercicio';

  @override
  String strengthRemoveExerciseTitle(String name) {
    return '¿Quitar $name?';
  }

  @override
  String get strengthRemoveExerciseBody =>
      'Sus series hechas se quitarán de esta sesión. La rutina no cambia.';

  @override
  String get strengthNotesTitle => 'Notas';

  @override
  String get strengthNotesHint => 'Ej.: «Asiento en 4»';

  @override
  String get strengthNotesSave => 'GUARDAR';

  @override
  String get strengthColSet => 'SERIE';

  @override
  String get strengthColPrevious => 'ANTERIOR';

  @override
  String get strengthColReps => 'REPS';

  @override
  String get strengthColTime => 'TIEMPO';

  @override
  String get strengthNoValue => '—';

  @override
  String strengthPrevious(String weight, int reps) {
    return '$weight × $reps';
  }

  @override
  String strengthWeightTimesReps(String weight, int reps) {
    return '$weight × $reps';
  }

  @override
  String strengthTimesReps(int reps) {
    return '× $reps';
  }

  @override
  String get setTagWarmup => 'C';

  @override
  String get setTagFailure => 'F';

  @override
  String get setTagDrop => 'D';

  @override
  String setTagWithType(int number, String type) {
    return '$number$type';
  }

  @override
  String get strengthAddSet => '+ AGREGAR SERIE';

  @override
  String get strengthAddExercise => '+ AGREGAR EJERCICIO';

  @override
  String strengthEditWeight(String set) {
    return 'Editar peso, $set';
  }

  @override
  String strengthEditReps(String set) {
    return 'Editar repeticiones, $set';
  }

  @override
  String strengthCompleteSet(String set) {
    return 'Completar $set';
  }

  @override
  String strengthUncompleteSet(String set) {
    return 'Desmarcar $set';
  }

  @override
  String strengthSetHeading(String exercise, int number) {
    return '$exercise · serie $number';
  }

  @override
  String strengthSetHeadingWarmup(String exercise) {
    return '$exercise · calentamiento';
  }

  @override
  String strengthNextSet(String exercise, int number) {
    return 'Siguiente: $exercise, serie $number';
  }

  @override
  String strengthNextWarmup(String exercise) {
    return 'Siguiente: $exercise, calentamiento';
  }

  @override
  String strengthLastTime(String values) {
    return 'La vez anterior: $values';
  }

  @override
  String strengthWeightLabel(String unit) {
    return 'PESO ($unit)';
  }

  @override
  String get strengthRepsLabel => 'REPETICIONES';

  @override
  String get strengthTimeLabel => 'TIEMPO';

  @override
  String get strengthRpeLabel => 'ESFUERZO (RPE) · OPCIONAL';

  @override
  String get strengthSetTypeLabel => 'TIPO DE SERIE';

  @override
  String get setTypeWarmup => 'Calentamiento';

  @override
  String get setTypeNormal => 'Normal';

  @override
  String get setTypeFailure => 'Al fallo';

  @override
  String get setTypeDrop => 'Drop set';

  @override
  String setStepMinus(String value) {
    return '−$value';
  }

  @override
  String setStepPlus(String value) {
    return '+$value';
  }

  @override
  String get setStepMinusOne => '−';

  @override
  String get setStepPlusOne => '+';

  @override
  String setStepMinusSeconds(int seconds) {
    return '−$seconds';
  }

  @override
  String setStepPlusSeconds(int seconds) {
    return '+$seconds';
  }

  @override
  String strengthWeightMinus(String weight) {
    return 'Restar $weight';
  }

  @override
  String strengthWeightPlus(String weight) {
    return 'Sumar $weight';
  }

  @override
  String get strengthRepsMinus => 'Restar una repetición';

  @override
  String get strengthRepsPlus => 'Sumar una repetición';

  @override
  String strengthTimeMinus(int seconds) {
    return 'Restar $seconds segundos';
  }

  @override
  String strengthTimePlus(int seconds) {
    return 'Sumar $seconds segundos';
  }

  @override
  String get strengthSaveSet => 'GUARDAR SERIE';

  @override
  String get strengthCloseNoSave => 'Cerrar sin guardar';

  @override
  String get strengthRemoveSet => 'Quitar serie';

  @override
  String setErrorWeightRange(String max) {
    return 'Ingresa un peso entre 0 y $max.';
  }

  @override
  String setErrorWeightStep(String step) {
    return 'El peso va en pasos de $step.';
  }

  @override
  String setErrorReps(int max) {
    return 'Las repeticiones van de 0 a $max.';
  }

  @override
  String get setErrorRpe => 'El RPE va de 6 a 10 en pasos de 0,5.';

  @override
  String get setErrorDuration => 'Ingresa un tiempo de hasta 99:59.';

  @override
  String strengthPendingTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hay $count series sin completar',
      one: 'Hay 1 serie sin completar',
    );
    return '$_temp0';
  }

  @override
  String get strengthPendingBody =>
      'Puedes descartarlas, darlas por hechas con los valores sugeridos o seguir entrenando.';

  @override
  String get strengthPendingDiscard => 'DESCARTARLAS Y TERMINAR';

  @override
  String get strengthPendingComplete => 'MARCARLAS COMO COMPLETAS';

  @override
  String get strengthBackToSession => 'Volver a la sesión';

  @override
  String get strengthNoSetsTitle => 'NINGUNA SERIE HECHA';

  @override
  String get strengthNoSetsBody =>
      'Una sesión sin series completadas no se guarda. ¿Descartarla?';

  @override
  String get strengthRecoveryBody =>
      'Android cerró la app. Cada serie que marcaste está guardada.';

  @override
  String get strengthRecoveryResume => 'REANUDAR';

  @override
  String strengthSetsDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count series hechas',
      one: '1 serie hecha',
      zero: 'sin series hechas',
    );
    return '$_temp0';
  }

  @override
  String get strengthSavedTitle => 'Sesión guardada';

  @override
  String get strengthSummaryDuration => 'DURACIÓN';

  @override
  String get strengthSummaryVolume => 'VOLUMEN';

  @override
  String get strengthSummarySets => 'SERIES';

  @override
  String strengthMinutes(int minutes) {
    return '$minutes MIN';
  }

  @override
  String get strengthNewRecord => 'RÉCORD NUEVO';

  @override
  String strengthRecordSet(String exercise, String values) {
    return '$exercise: $values';
  }

  @override
  String strengthRecordWithRm(String exercise, String values, String rm) {
    return '$exercise: $values · 1RM estimado $rm';
  }

  @override
  String strengthUpdateRoutineQuestion(String routine) {
    return 'La estructura cambió. ¿Actualizar la rutina «$routine»?';
  }

  @override
  String get strengthUpdateRoutineYes => 'SÍ, ACTUALIZAR';

  @override
  String get strengthUpdateRoutineNo => 'No';

  @override
  String strengthRoutineUpdated(String routine) {
    return '«$routine» actualizada: ejercicios y número de series.';
  }

  @override
  String get strengthRoutineKept => 'La rutina queda como estaba.';

  @override
  String get strengthNoteHint => 'Ej.: «La rodilla mejor»';

  @override
  String decimalText(String value) {
    return '$value';
  }

  @override
  String get debugWeekVariant => 'Vista semanal (prueba H5)';

  @override
  String get debugWeekVariantHelp =>
      'Ajuste interno para la prueba de usabilidad: fuerza e intervalos juntos o separados.';

  @override
  String get weekVariantUnified => 'UNIFICADA';

  @override
  String get weekVariantSeparate => 'SEPARADA';

  @override
  String get detailColSet => 'SERIE';

  @override
  String get detailColReps => 'REPS';

  @override
  String get detailColRpe => 'RPE';

  @override
  String get detailColTime => 'TIEMPO';

  @override
  String get detailDelete => 'ELIMINAR';

  @override
  String get detailDeleteTitle => '¿Eliminar esta sesión?';

  @override
  String get detailDeleteBody =>
      'Se recalcularán tus récords. Tendrás 5 segundos para deshacer.';

  @override
  String get detailDeleted => 'Sesión eliminada';

  @override
  String get detailDone => 'LISTO';

  @override
  String get detailEditHelp =>
      'Toca una serie para cambiar peso, reps, RPE o tipo. Los récords se recalculan.';

  @override
  String detailEffort(int value) {
    return 'Esfuerzo $value/10';
  }

  @override
  String get detailMissing => 'Esta sesión ya no está en tu historial.';

  @override
  String get detailNameLabel => 'NOMBRE';

  @override
  String detailNote(String note) {
    return 'Nota: $note';
  }

  @override
  String get detailRecordTag => 'RÉCORD';

  @override
  String get detailRecords => 'RÉCORDS';

  @override
  String get detailRounds => 'RONDAS';

  @override
  String detailRoutineSaved(String name) {
    return 'Rutina «$name» guardada';
  }

  @override
  String get detailSaveRoutine => 'GUARDAR COMO RUTINA';

  @override
  String get detailSets => 'SERIES';

  @override
  String get detailTotal => 'TOTAL';

  @override
  String get detailVolume => 'VOLUMEN';

  @override
  String get detailWork => 'TRABAJO';

  @override
  String distanceMeters(int meters) {
    return '$meters m';
  }

  @override
  String get exerciseHistory => 'HISTORIAL';

  @override
  String get exerciseLastMark => 'ÚLTIMA MARCA';

  @override
  String get exerciseNoHistory => 'Aún no hay sesiones con este ejercicio.';

  @override
  String get exerciseNoRecords => 'Aún no hay récords.';

  @override
  String exerciseOneRm(String value) {
    return '1RM estimado $value';
  }

  @override
  String get exerciseRecords => 'RÉCORDS';

  @override
  String exerciseTrendMissing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Faltan $count sesiones para ver la tendencia.',
      one: 'Falta 1 sesión para ver la tendencia.',
    );
    return '$_temp0';
  }

  @override
  String exerciseTrendNote(String from, String to, String change) {
    return 'De $from a $to ($change %)';
  }

  @override
  String get exerciseTrendTitle => '1RM ESTIMADO';

  @override
  String historyBlockDone(String day, String name, String minutes) {
    return '✓ $day · $name · $minutes';
  }

  @override
  String get historyBlockEmpty => 'Nada hecho ni planificado esta semana.';

  @override
  String historyBlockStrength(int done, int total) {
    return 'FUERZA · $done DE $total';
  }

  @override
  String historyBlockIntervals(int done, int total) {
    return 'INTERVALOS · $done DE $total';
  }

  @override
  String historyBlockPlanned(String day, String name) {
    return '○ $day · $name (planificado)';
  }

  @override
  String historyCalendarDay(String date, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$date: $count sesiones',
      one: '$date: 1 sesión',
      zero: '$date: sin sesiones',
    );
    return '$_temp0';
  }

  @override
  String historyDate(String date) {
    return '$date';
  }

  @override
  String get historyDayEmpty => 'Sin sesiones este día.';

  @override
  String get historyDayFree => 'Libre';

  @override
  String historyDayName(String day) {
    return '$day';
  }

  @override
  String get historyDayRest => 'Descanso';

  @override
  String historyDayTitle(String date) {
    return '$date';
  }

  @override
  String get historyIncomplete => 'incompleta';

  @override
  String get historyIntervalsFallback => 'Intervalos';

  @override
  String get historyLastWeek => 'SEMANA ANTERIOR';

  @override
  String get historyLetterStrength => 'F';

  @override
  String get historyLetterIntervals => 'I';

  @override
  String historyMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String historyMonth(String month) {
    return '$month';
  }

  @override
  String get historyNextMonth => 'Mes siguiente';

  @override
  String get historyPrevMonth => 'Mes anterior';

  @override
  String historyRounds(int done, int total) {
    return '$done/$total rondas';
  }

  @override
  String historySets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count series',
      one: '1 serie',
    );
    return '$_temp0';
  }

  @override
  String get historyStateDone => 'Hecho';

  @override
  String get historyStateIncomplete => 'Incompleta';

  @override
  String get historyStatePlanned => 'Planificado';

  @override
  String get historyTabWeek => 'SEMANA';

  @override
  String get historyTabList => 'LISTA';

  @override
  String get historyTabCalendar => 'CALENDARIO';

  @override
  String get historyTabsLabel => 'Vista del historial';

  @override
  String get historyThisWeek => 'ESTA SEMANA';

  @override
  String historyWeekGroup(String week, int sessions, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      sessions,
      locale: localeName,
      other: '$week · $sessions SESIONES · $minutes MIN',
      one: '$week · 1 SESIÓN · $minutes MIN',
    );
    return '$_temp0';
  }

  @override
  String historyWeekHead(int done, int goal) {
    return 'ESTA SEMANA · $done DE $goal';
  }

  @override
  String get historyWeekLegend =>
      'F = fuerza · I = intervalos · relleno = hecho · contorno = planificado · punteado = descanso o libre. Toca un día libre para planificarlo.';

  @override
  String historyWeekOf(String date) {
    return 'SEMANA DEL $date';
  }

  @override
  String get homeSeeProgress => 'VER PROGRESO';

  @override
  String homeWeekMinutes(int minutes) {
    return '$minutes min activos';
  }

  @override
  String homeWeekProgressLabel(int done, int goal) {
    return '$done de $goal sesiones esta semana';
  }

  @override
  String get homeWeekSessions => 'sesiones de tu objetivo';

  @override
  String homeWeekStreak(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: '$weeks semanas de racha',
      one: '1 semana de racha',
    );
    return '$_temp0';
  }

  @override
  String get planHelp =>
      'Se repite cada semana. Solo se muestra en tu semana: nunca empieza una sesión.';

  @override
  String get planNone => 'Sin plan';

  @override
  String planTitle(String day) {
    return 'Plan del $day';
  }

  @override
  String progressBarLabel(String date, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Semana del $date: $count sesiones',
      one: 'Semana del $date: 1 sesión',
    );
    return '$_temp0';
  }

  @override
  String get progressChartNote =>
      'Fuerza e intervalos cuentan igual. Toca una barra para ver sus sesiones.';

  @override
  String progressChartSub(String average, int goal) {
    return 'promedio $average · objetivo $goal';
  }

  @override
  String get progressChartTitle => 'SESIONES POR SEMANA';

  @override
  String get progressComplete => 'COMPLETO';

  @override
  String get progressGoalLine => 'objetivo';

  @override
  String progressGoalSuffix(int goal) {
    return '/$goal';
  }

  @override
  String progressIntervalMark(String rounds, String work) {
    return '$rounds · $work de trabajo';
  }

  @override
  String get progressLastMarks => 'ÚLTIMA MARCA POR EJERCICIO';

  @override
  String get progressMinutes => 'min activos';

  @override
  String get progressRecordBadge => '↑ RÉCORD';

  @override
  String get progressSameBadge => '= IGUAL';

  @override
  String get progressSessions => 'sesiones';

  @override
  String get progressStreak => 'semanas de racha';

  @override
  String get progressThisWeekShort => 'Hoy';

  @override
  String progressWeekVolume(String volume) {
    return 'Volumen de fuerza esta semana: $volume';
  }

  @override
  String rangeWeeks(int count) {
    return '$count SEM';
  }

  @override
  String rangeMonths(int count) {
    return '$count M';
  }

  @override
  String get rangeYear => '1 AÑO';

  @override
  String get rangeAll => 'TODO';

  @override
  String recordLine(String name, String value) {
    return '$name: $value';
  }

  @override
  String get recordMaxWeight => 'Peso máximo';

  @override
  String get recordOneRm => '1RM estimado';

  @override
  String recordMaxRepsAt(String weight) {
    return 'Más reps con $weight';
  }

  @override
  String get recordMaxRepsBodyweight => 'Más reps';

  @override
  String get recordMaxVolume => 'Mayor volumen';

  @override
  String get recordMaxDuration => 'Mayor duración';

  @override
  String get recordMaxDistance => 'Mayor distancia';

  @override
  String get settingsWeekStart => 'La semana empieza el';

  @override
  String get settingsMonday => 'LUNES';

  @override
  String get settingsSunday => 'DOMINGO';

  @override
  String get settingsWeeklyGoal => 'Objetivo semanal (sesiones)';

  @override
  String get settingsGoalLess => 'Menos sesiones';

  @override
  String get settingsGoalMore => 'Más sesiones';

  @override
  String get backupTitle => 'RESPALDO';

  @override
  String get backupHeadline => 'TUS DATOS ESTÁN SOLO EN ESTE TELÉFONO';

  @override
  String get backupBody =>
      'Trainloop no tiene cuenta ni servidor. Crea un respaldo y guárdalo donde quieras (Drive, Descargas o envíatelo) para no perder tu historial.';

  @override
  String get backupNever => 'Todavía no creaste un respaldo.';

  @override
  String backupLast(String date, String sessions, String size) {
    return 'Último respaldo: $date · $sessions · $size';
  }

  @override
  String backupSessions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sesiones',
      one: '1 sesión',
    );
    return '$_temp0';
  }

  @override
  String backupRoutines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rutinas',
      one: '1 rutina',
    );
    return '$_temp0';
  }

  @override
  String backupWorkouts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count temporizadores',
      one: '1 temporizador',
    );
    return '$_temp0';
  }

  @override
  String backupSizeKb(String size) {
    return '$size KB';
  }

  @override
  String get backupCreate => 'CREAR RESPALDO';

  @override
  String get backupRestore => 'RESTAURAR RESPALDO';

  @override
  String get backupCsv => 'EXPORTAR CSV';

  @override
  String get backupCsvHelp =>
      'Dos archivos para hojas de cálculo: sesiones y series. Se guardan uno después del otro.';

  @override
  String get backupHowTitle => 'CÓMO GUARDARLO EN GOOGLE DRIVE';

  @override
  String get backupStep1 => 'Toca «Crear respaldo».';

  @override
  String get backupStep2 =>
      'En el menú de Android elige Drive (u otra carpeta) y toca Guardar.';

  @override
  String get backupStep3 =>
      'En el teléfono nuevo, toca «Restaurar respaldo» y elige el archivo.';

  @override
  String get backupAutoTitle => 'RESPALDO AUTOMÁTICO DE ANDROID';

  @override
  String get backupAutoBody =>
      'Si tienes activada la copia de seguridad de Google en el teléfono, Android también copia los datos y ajustes de Trainloop a tu Google Drive y los recupera al reinstalar con la misma cuenta. No pasa por servidores nuestros, pero la app no controla cuándo ocurre: el archivo de respaldo es la forma segura de cambiar de teléfono.';

  @override
  String get backupWorking => 'Trabajando…';

  @override
  String backupSaved(String name) {
    return 'Respaldo creado: $name';
  }

  @override
  String get backupCsvSaved => 'CSV exportado: sesiones y series';

  @override
  String get backupRestoreTitle => '¿RESTAURAR ESTE RESPALDO?';

  @override
  String backupRestoreSummary(
    String date,
    String sessions,
    String routines,
    String workouts,
  ) {
    return 'Respaldo del $date: $sessions, $routines, $workouts.';
  }

  @override
  String get backupRestoreOlder =>
      'Es de una versión anterior de la app: se actualizará al restaurar.';

  @override
  String get backupRestoreWarn =>
      'Reemplazará tus datos actuales. Antes guardaremos una copia automática de lo que tienes ahora.';

  @override
  String get backupRestoreConfirm => 'RESTAURAR';

  @override
  String get backupRestored => 'Respaldo restaurado';

  @override
  String get backupErrorInvalid =>
      'Ese archivo no es un respaldo de Trainloop o está dañado. No se cambió nada.';

  @override
  String get backupErrorNewer =>
      'Ese respaldo es de una versión más nueva de Trainloop. Actualiza la app y vuelve a intentarlo.';

  @override
  String get backupErrorIntegrity =>
      'El respaldo tiene datos inconsistentes. No se cambió nada.';

  @override
  String get backupErrorActive =>
      'Termina la sesión en curso antes de restaurar.';

  @override
  String get backupErrorIo => 'No se pudo leer o guardar el archivo.';

  @override
  String get settingsDefaultRest => 'Descanso por defecto';

  @override
  String get settingsDefaultRestHelp =>
      'Para los ejercicios nuevos. Los de la biblioteca conservan su descanso.';

  @override
  String get settingsRestLess => '15 segundos menos';

  @override
  String get settingsRestMore => '15 segundos más';

  @override
  String get settingsTestSound => 'PROBAR SONIDO';

  @override
  String get settingsTestSpeech => 'Así suenan los avisos';

  @override
  String get settingsData => 'DATOS Y PRIVACIDAD';

  @override
  String get settingsDataWarnTitle => 'Tus datos están solo en este teléfono.';

  @override
  String get settingsDataWarnBody =>
      'Si desinstalas la app o cambias de teléfono sin un respaldo, se pierden.';

  @override
  String get settingsBackupLink => 'Respaldo y exportación';

  @override
  String get settingsBackupNever => 'sin respaldos';

  @override
  String settingsBackupAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'último: hace $days días',
      one: 'último: ayer',
      zero: 'último: hoy',
    );
    return '$_temp0';
  }

  @override
  String get remindersTitle => 'RECORDATORIOS';

  @override
  String get remindersEnable => 'Recordarme entrenar';

  @override
  String get remindersHelp =>
      'Una notificación los días elegidos, solo si aún no entrenaste';

  @override
  String get remindersTime => 'Hora';

  @override
  String remindersNext(String day, String time) {
    return 'Próximo: $day a las $time';
  }

  @override
  String get remindersDenied =>
      'Sin permiso de notificaciones, los recordatorios no pueden aparecer.';

  @override
  String get remindersOpenSettings => 'AJUSTES';

  @override
  String get reminderNotificationTitle => 'Hora de entrenar';

  @override
  String get reminderNotificationBody =>
      'Tu entrenamiento está listo cuando quieras.';

  @override
  String get reminderChannelName => 'Recordatorios';

  @override
  String get homeLocalDataNotice => 'Tus datos viven solo en este teléfono.';

  @override
  String get homeLocalDataAction => 'Respaldar ›';

  @override
  String get homeLocalDataDismiss => 'Cerrar aviso';

  @override
  String formattedValue(String value) {
    return '$value';
  }

  @override
  String get routineDiscardTitle => '¿DESCARTAR LOS CAMBIOS?';

  @override
  String get routineDiscardBody => 'La rutina queda como estaba.';

  @override
  String get routineDiscardConfirm => 'DESCARTAR';

  @override
  String get routineDiscardKeep => 'Seguir editando';

  @override
  String get adBannerLabel => 'Anuncio';

  @override
  String get settingsAnalytics => 'Estadísticas de uso anónimas';

  @override
  String get settingsAnalyticsHelp =>
      'Solo qué tipos de sesión se empiezan y terminan. Nunca tus entrenamientos ni datos personales.';

  @override
  String get settingsPrivacyOptions => 'Preferencias de privacidad';

  @override
  String get settingsPrivacyOptionsMeta => 'REVISAR';

  @override
  String get removeAdsTitle => 'QUITAR ANUNCIOS · PAGO ÚNICO';

  @override
  String get removeAdsBody =>
      'Un solo pago, sin suscripción. Todas las funciones siguen gratis.';

  @override
  String removeAdsBuy(String price) {
    return 'QUITAR ANUNCIOS · $price';
  }

  @override
  String get removeAdsBuyNoPrice => 'QUITAR ANUNCIOS';

  @override
  String get removeAdsRestore => 'Restaurar compra';

  @override
  String get removeAdsOwned => 'Sin anuncios. ¡Gracias por apoyar Trainloop!';

  @override
  String get removeAdsRestored => 'Compra restaurada: sin anuncios.';

  @override
  String get removeAdsPending =>
      'Compra pendiente: los anuncios se quitan cuando Google Play la confirme.';

  @override
  String get removeAdsCanceled => 'Compra cancelada. No se hizo ningún cargo.';

  @override
  String get removeAdsError =>
      'No se pudo completar la compra. Inténtalo de nuevo.';

  @override
  String get removeAdsUnavailable =>
      'Google Play no está disponible ahora. Revisa la conexión e inténtalo de nuevo.';

  @override
  String get removeAdsNothing =>
      'Esta cuenta de Google Play no tiene la compra.';

  @override
  String get errorLogTitle => 'Registro de errores';

  @override
  String errorLogCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count errores',
      one: '1 error',
      zero: 'sin errores',
    );
    return '$_temp0';
  }

  @override
  String get errorLogHelp =>
      'Los errores técnicos quedan solo en este teléfono. Exporta el archivo si quieres enviárnoslo.';

  @override
  String get errorLogEmpty => 'No hay errores registrados.';

  @override
  String errorLogSaved(String name) {
    return 'Registro de errores guardado: $name';
  }
}

/// The translations for Spanish Castilian, as used in Latin America and the Caribbean (`es_419`).
class AppLocalizationsEs419 extends AppLocalizationsEs {
  AppLocalizationsEs419() : super('es_419');
}
