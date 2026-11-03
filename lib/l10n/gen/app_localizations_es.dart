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
}

/// The translations for Spanish Castilian, as used in Latin America and the Caribbean (`es_419`).
class AppLocalizationsEs419 extends AppLocalizationsEs {
  AppLocalizationsEs419() : super('es_419');
}
