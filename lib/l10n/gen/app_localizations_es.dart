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
  String get trainRoutines => 'Rutinas';

  @override
  String get trainIntervalsEmptyTitle => 'Tus temporizadores de intervalos';

  @override
  String get trainIntervalsEmptyBody =>
      'Aquí vivirán Tabata, HIIT, EMOM y tus propios temporizadores.';

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
}

/// The translations for Spanish Castilian, as used in Latin America and the Caribbean (`es_419`).
class AppLocalizationsEs419 extends AppLocalizationsEs {
  AppLocalizationsEs419() : super('es_419');
}
