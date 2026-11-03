import 'dart:ui';

import '../../core/l10n/pseudo.dart';
import '../db/enums.dart';

/// Ejercicio de la biblioteca incluida en la app. La base guarda su [key]
/// (`exercise.catalog_key`); el nombre visible sale de aquí según el idioma,
/// así cambiar de idioma renombra la biblioteca sin reiniciar.
///
/// Para ampliar la biblioteca basta con agregar entradas con claves nuevas:
/// la siembra inserta solo las que faltan. Nunca cambies ni reutilices una
/// clave existente (la usan las rutinas y el historial).
class CatalogExercise {
  const CatalogExercise(
    this.key,
    this.muscle,
    this.equipment,
    this.es,
    this.en,
    this.pt, {
    this.logType = ExerciseLogType.weightReps,
    double? incrementKg,
    int? restSeconds,
  }) : _incrementKg = incrementKg,
       _restSeconds = restSeconds;

  final String key;
  final Muscle muscle;
  final Equipment equipment;
  final ExerciseLogType logType;
  final String es;
  final String en;
  final String pt;
  final double? _incrementKg;
  final int? _restSeconds;

  /// Incremento de peso en kg; `null` si el ejercicio no lleva carga.
  double? get incrementKg {
    if (_incrementKg != null) return _incrementKg;
    if (logType != ExerciseLogType.weightReps) return null;
    return switch (equipment) {
      Equipment.barbell || Equipment.cable => 2.5,
      Equipment.dumbbell => 2,
      Equipment.machine => 5,
      Equipment.kettlebell => 4,
      _ => null,
    };
  }

  /// Descanso por defecto entre series.
  int get restSeconds =>
      _restSeconds ??
      switch ((logType, equipment)) {
        (ExerciseLogType.weightReps, Equipment.barbell) => 120,
        (ExerciseLogType.weightReps, _) => 90,
        (ExerciseLogType.reps, _) => 60,
        _ => 60,
      };

  /// Nombre en el idioma de [locale]: es, pt o inglés para el resto. En el
  /// pseudo-locale (en-XA) se pseudo-localiza el inglés.
  String nameFor(Locale locale) {
    if (locale.countryCode == 'XA') return pseudoLocalize(en);
    return switch (locale.languageCode) {
      'es' => es,
      'pt' => pt,
      _ => en,
    };
  }

  /// Nombres en todos los idiomas (detección de duplicados).
  List<String> get allNames => [es, en, pt];
}

/// Ejercicios por clave.
final Map<String, CatalogExercise> exerciseCatalogByKey = {
  for (final e in exerciseCatalog) e.key: e,
};

const _bb = Equipment.barbell;
const _db = Equipment.dumbbell;
const _ma = Equipment.machine;
const _ca = Equipment.cable;
const _kb = Equipment.kettlebell;
const _bw = Equipment.bodyweight;
const _ot = Equipment.other;
const _reps = ExerciseLogType.reps;
const _time = ExerciseLogType.time;
const _dist = ExerciseLogType.distance;
const _timeDist = ExerciseLogType.timeDistance;

/// Biblioteca incluida: ejercicios comunes de gimnasio (español
/// latinoamericano, inglés y portugués de Brasil).
// dart format off
const exerciseCatalog = <CatalogExercise>[
  // Pecho
  CatalogExercise('bench_press_barbell', Muscle.chest, _bb, 'Press de banca con barra', 'Barbell bench press', 'Supino reto com barra', restSeconds: 150),
  CatalogExercise('incline_bench_press_barbell', Muscle.chest, _bb, 'Press inclinado con barra', 'Incline barbell bench press', 'Supino inclinado com barra'),
  CatalogExercise('decline_bench_press_barbell', Muscle.chest, _bb, 'Press declinado con barra', 'Decline barbell bench press', 'Supino declinado com barra'),
  CatalogExercise('bench_press_dumbbell', Muscle.chest, _db, 'Press de banca con mancuernas', 'Dumbbell bench press', 'Supino reto com halteres'),
  CatalogExercise('incline_bench_press_dumbbell', Muscle.chest, _db, 'Press inclinado con mancuernas', 'Incline dumbbell press', 'Supino inclinado com halteres'),
  CatalogExercise('fly_dumbbell', Muscle.chest, _db, 'Aperturas con mancuernas', 'Dumbbell fly', 'Crucifixo com halteres', restSeconds: 60),
  CatalogExercise('chest_press_machine', Muscle.chest, _ma, 'Press de pecho en máquina', 'Machine chest press', 'Supino na máquina'),
  CatalogExercise('pec_deck_machine', Muscle.chest, _ma, 'Pec deck', 'Pec deck', 'Voador', restSeconds: 60),
  CatalogExercise('cable_crossover', Muscle.chest, _ca, 'Cruce de poleas', 'Cable crossover', 'Crossover na polia', restSeconds: 60),
  CatalogExercise('smith_bench_press', Muscle.chest, _ma, 'Press de banca en Smith', 'Smith machine bench press', 'Supino no Smith'),
  CatalogExercise('push_up', Muscle.chest, _bw, 'Flexiones de brazos', 'Push-up', 'Flexão de braço', logType: _reps),
  CatalogExercise('dip', Muscle.chest, _bw, 'Fondos en paralelas', 'Dip', 'Mergulho nas paralelas', logType: _reps, restSeconds: 90),
  // Espalda
  CatalogExercise('deadlift_barbell', Muscle.back, _bb, 'Peso muerto', 'Deadlift', 'Levantamento terra', incrementKg: 5, restSeconds: 180),
  CatalogExercise('bent_over_row_barbell', Muscle.back, _bb, 'Remo con barra', 'Barbell row', 'Remada curvada com barra'),
  CatalogExercise('pull_up', Muscle.back, _bw, 'Dominadas', 'Pull-up', 'Barra fixa', logType: _reps, restSeconds: 120),
  CatalogExercise('chin_up', Muscle.back, _bw, 'Dominadas supinas', 'Chin-up', 'Barra fixa supinada', logType: _reps, restSeconds: 120),
  CatalogExercise('assisted_pull_up_machine', Muscle.back, _ma, 'Dominadas asistidas', 'Assisted pull-up', 'Barra fixa assistida'),
  CatalogExercise('lat_pulldown_cable', Muscle.back, _ca, 'Jalón al pecho', 'Lat pulldown', 'Puxada frontal'),
  CatalogExercise('seated_row_cable', Muscle.back, _ca, 'Remo sentado en polea', 'Seated cable row', 'Remada sentada na polia'),
  CatalogExercise('one_arm_row_dumbbell', Muscle.back, _db, 'Remo con mancuerna a una mano', 'One-arm dumbbell row', 'Remada unilateral com halter'),
  CatalogExercise('t_bar_row', Muscle.back, _bb, 'Remo en T', 'T-bar row', 'Remada cavalinho'),
  CatalogExercise('row_machine', Muscle.back, _ma, 'Remo en máquina', 'Machine row', 'Remada na máquina'),
  CatalogExercise('straight_arm_pulldown_cable', Muscle.back, _ca, 'Pullover en polea', 'Straight-arm pulldown', 'Pulldown com braços estendidos', restSeconds: 60),
  CatalogExercise('inverted_row', Muscle.back, _bw, 'Remo invertido', 'Inverted row', 'Remada invertida', logType: _reps),
  CatalogExercise('back_extension', Muscle.back, _bw, 'Hiperextensiones', 'Back extension', 'Extensão lombar', logType: _reps),
  CatalogExercise('shrug_dumbbell', Muscle.back, _db, 'Encogimientos con mancuernas', 'Dumbbell shrug', 'Encolhimento com halteres', restSeconds: 60),
  // Hombros
  CatalogExercise('overhead_press_barbell', Muscle.shoulders, _bb, 'Press militar', 'Overhead press', 'Desenvolvimento militar com barra'),
  CatalogExercise('shoulder_press_dumbbell', Muscle.shoulders, _db, 'Press de hombros con mancuernas', 'Dumbbell shoulder press', 'Desenvolvimento com halteres'),
  CatalogExercise('arnold_press_dumbbell', Muscle.shoulders, _db, 'Press Arnold', 'Arnold press', 'Desenvolvimento Arnold'),
  CatalogExercise('shoulder_press_machine', Muscle.shoulders, _ma, 'Press de hombros en máquina', 'Machine shoulder press', 'Desenvolvimento na máquina'),
  CatalogExercise('lateral_raise_dumbbell', Muscle.shoulders, _db, 'Elevaciones laterales', 'Lateral raise', 'Elevação lateral', incrementKg: 1, restSeconds: 60),
  CatalogExercise('lateral_raise_cable', Muscle.shoulders, _ca, 'Elevación lateral en polea', 'Cable lateral raise', 'Elevação lateral na polia', restSeconds: 60),
  CatalogExercise('front_raise_dumbbell', Muscle.shoulders, _db, 'Elevaciones frontales', 'Front raise', 'Elevação frontal', incrementKg: 1, restSeconds: 60),
  CatalogExercise('rear_delt_fly_dumbbell', Muscle.shoulders, _db, 'Pájaros con mancuernas', 'Rear delt fly', 'Crucifixo invertido', incrementKg: 1, restSeconds: 60),
  CatalogExercise('face_pull_cable', Muscle.shoulders, _ca, 'Face pull', 'Face pull', 'Face pull', restSeconds: 60),
  CatalogExercise('upright_row_barbell', Muscle.shoulders, _bb, 'Remo al mentón', 'Upright row', 'Remada alta', restSeconds: 90),
  // Bíceps
  CatalogExercise('curl_barbell', Muscle.biceps, _bb, 'Curl con barra', 'Barbell curl', 'Rosca direta com barra', incrementKg: 1, restSeconds: 60),
  CatalogExercise('curl_dumbbell', Muscle.biceps, _db, 'Curl con mancuernas', 'Dumbbell curl', 'Rosca alternada com halteres', incrementKg: 1, restSeconds: 60),
  CatalogExercise('hammer_curl_dumbbell', Muscle.biceps, _db, 'Curl martillo', 'Hammer curl', 'Rosca martelo', incrementKg: 1, restSeconds: 60),
  CatalogExercise('preacher_curl', Muscle.biceps, _bb, 'Curl predicador', 'Preacher curl', 'Rosca Scott', incrementKg: 1, restSeconds: 60),
  CatalogExercise('curl_cable', Muscle.biceps, _ca, 'Curl en polea', 'Cable curl', 'Rosca na polia', restSeconds: 60),
  CatalogExercise('concentration_curl_dumbbell', Muscle.biceps, _db, 'Curl concentrado', 'Concentration curl', 'Rosca concentrada', incrementKg: 1, restSeconds: 60),
  CatalogExercise('incline_curl_dumbbell', Muscle.biceps, _db, 'Curl inclinado con mancuernas', 'Incline dumbbell curl', 'Rosca inclinada com halteres', incrementKg: 1, restSeconds: 60),
  // Tríceps
  CatalogExercise('triceps_pushdown_cable', Muscle.triceps, _ca, 'Extensión de tríceps en polea', 'Triceps pushdown', 'Tríceps na polia', restSeconds: 60),
  CatalogExercise('overhead_triceps_extension_cable', Muscle.triceps, _ca, 'Extensión de tríceps en polea alta', 'Cable overhead triceps extension', 'Tríceps francês na polia', restSeconds: 60),
  CatalogExercise('skull_crusher_barbell', Muscle.triceps, _bb, 'Press francés', 'Skull crusher', 'Tríceps testa', incrementKg: 1, restSeconds: 90),
  CatalogExercise('overhead_triceps_extension_dumbbell', Muscle.triceps, _db, 'Extensión de tríceps sobre la cabeza', 'Overhead triceps extension', 'Tríceps francês com halter', restSeconds: 60),
  CatalogExercise('triceps_kickback_dumbbell', Muscle.triceps, _db, 'Patada de tríceps', 'Triceps kickback', 'Tríceps coice', incrementKg: 1, restSeconds: 60),
  CatalogExercise('close_grip_bench_press', Muscle.triceps, _bb, 'Press de banca agarre cerrado', 'Close-grip bench press', 'Supino fechado'),
  CatalogExercise('bench_dip', Muscle.triceps, _bw, 'Fondos en banco', 'Bench dip', 'Mergulho no banco', logType: _reps),
  // Antebrazos
  CatalogExercise('wrist_curl_barbell', Muscle.forearms, _bb, 'Curl de muñeca', 'Wrist curl', 'Rosca de punho', incrementKg: 1, restSeconds: 60),
  CatalogExercise('reverse_curl_barbell', Muscle.forearms, _bb, 'Curl invertido', 'Reverse curl', 'Rosca inversa', incrementKg: 1, restSeconds: 60),
  CatalogExercise('farmers_walk', Muscle.forearms, _db, 'Paseo del granjero', "Farmer's walk", 'Caminhada do fazendeiro', logType: _time, restSeconds: 90),
  // Cuádriceps
  CatalogExercise('back_squat_barbell', Muscle.quads, _bb, 'Sentadilla con barra', 'Barbell back squat', 'Agachamento livre com barra', incrementKg: 5, restSeconds: 180),
  CatalogExercise('front_squat_barbell', Muscle.quads, _bb, 'Sentadilla frontal', 'Front squat', 'Agachamento frontal', restSeconds: 150),
  CatalogExercise('smith_squat', Muscle.quads, _ma, 'Sentadilla en Smith', 'Smith machine squat', 'Agachamento no Smith', incrementKg: 2.5),
  CatalogExercise('hack_squat_machine', Muscle.quads, _ma, 'Sentadilla hack', 'Hack squat', 'Agachamento hack', restSeconds: 120),
  CatalogExercise('goblet_squat', Muscle.quads, _db, 'Sentadilla goblet', 'Goblet squat', 'Agachamento goblet'),
  CatalogExercise('bodyweight_squat', Muscle.quads, _bw, 'Sentadilla sin peso', 'Bodyweight squat', 'Agachamento sem peso', logType: _reps),
  CatalogExercise('leg_press_machine', Muscle.quads, _ma, 'Prensa de piernas', 'Leg press', 'Leg press', incrementKg: 10, restSeconds: 120),
  CatalogExercise('leg_extension_machine', Muscle.quads, _ma, 'Extensión de cuádriceps', 'Leg extension', 'Cadeira extensora', restSeconds: 60),
  CatalogExercise('lunge_dumbbell', Muscle.quads, _db, 'Zancadas con mancuernas', 'Dumbbell lunge', 'Avanço com halteres'),
  CatalogExercise('walking_lunge', Muscle.quads, _bw, 'Zancadas caminando', 'Walking lunge', 'Avanço caminhando', logType: _reps),
  CatalogExercise('step_up_dumbbell', Muscle.quads, _db, 'Subidas al cajón', 'Step-up', 'Subida no banco'),
  // Isquiotibiales
  CatalogExercise('romanian_deadlift_barbell', Muscle.hamstrings, _bb, 'Peso muerto rumano', 'Romanian deadlift', 'Levantamento terra romeno', restSeconds: 150),
  CatalogExercise('romanian_deadlift_dumbbell', Muscle.hamstrings, _db, 'Peso muerto rumano con mancuernas', 'Dumbbell Romanian deadlift', 'Terra romeno com halteres'),
  CatalogExercise('good_morning_barbell', Muscle.hamstrings, _bb, 'Buenos días con barra', 'Good morning', 'Bom dia com barra'),
  CatalogExercise('lying_leg_curl_machine', Muscle.hamstrings, _ma, 'Curl femoral acostado', 'Lying leg curl', 'Mesa flexora', restSeconds: 60),
  CatalogExercise('seated_leg_curl_machine', Muscle.hamstrings, _ma, 'Curl femoral sentado', 'Seated leg curl', 'Cadeira flexora', restSeconds: 60),
  CatalogExercise('nordic_curl', Muscle.hamstrings, _bw, 'Curl nórdico', 'Nordic curl', 'Flexão nórdica', logType: _reps, restSeconds: 90),
  // Glúteos
  CatalogExercise('hip_thrust_barbell', Muscle.glutes, _bb, 'Hip thrust con barra', 'Barbell hip thrust', 'Elevação pélvica com barra', incrementKg: 5),
  CatalogExercise('glute_bridge', Muscle.glutes, _bw, 'Puente de glúteos', 'Glute bridge', 'Ponte de glúteos', logType: _reps),
  CatalogExercise('sumo_deadlift_barbell', Muscle.glutes, _bb, 'Peso muerto sumo', 'Sumo deadlift', 'Levantamento terra sumô', incrementKg: 5, restSeconds: 180),
  CatalogExercise('cable_kickback', Muscle.glutes, _ca, 'Patada de glúteo en polea', 'Cable glute kickback', 'Coice na polia', restSeconds: 60),
  CatalogExercise('hip_abduction_machine', Muscle.glutes, _ma, 'Abducción de cadera en máquina', 'Hip abduction machine', 'Cadeira abdutora', restSeconds: 60),
  CatalogExercise('kettlebell_swing', Muscle.glutes, _kb, 'Swing con kettlebell', 'Kettlebell swing', 'Swing com kettlebell'),
  // Pantorrillas
  CatalogExercise('standing_calf_raise_machine', Muscle.calves, _ma, 'Elevación de talones de pie', 'Standing calf raise', 'Panturrilha em pé', restSeconds: 60),
  CatalogExercise('seated_calf_raise_machine', Muscle.calves, _ma, 'Elevación de talones sentado', 'Seated calf raise', 'Panturrilha sentado', restSeconds: 60),
  CatalogExercise('leg_press_calf_raise', Muscle.calves, _ma, 'Elevación de talones en prensa', 'Leg press calf raise', 'Panturrilha no leg press', restSeconds: 60),
  // Core
  CatalogExercise('plank', Muscle.core, _bw, 'Plancha', 'Plank', 'Prancha', logType: _time),
  CatalogExercise('side_plank', Muscle.core, _bw, 'Plancha lateral', 'Side plank', 'Prancha lateral', logType: _time),
  CatalogExercise('hollow_hold', Muscle.core, _bw, 'Hollow hold', 'Hollow hold', 'Hollow hold', logType: _time),
  CatalogExercise('crunch', Muscle.core, _bw, 'Abdominales', 'Crunch', 'Abdominal', logType: _reps),
  CatalogExercise('hanging_leg_raise', Muscle.core, _bw, 'Elevación de piernas colgado', 'Hanging leg raise', 'Elevação de pernas na barra', logType: _reps),
  CatalogExercise('cable_crunch', Muscle.core, _ca, 'Crunch en polea', 'Cable crunch', 'Abdominal na polia', restSeconds: 60),
  CatalogExercise('russian_twist', Muscle.core, _bw, 'Giros rusos', 'Russian twist', 'Giro russo', logType: _reps),
  CatalogExercise('ab_wheel_rollout', Muscle.core, _ot, 'Rueda abdominal', 'Ab wheel rollout', 'Roda abdominal', logType: _reps),
  CatalogExercise('dead_bug', Muscle.core, _bw, 'Bicho muerto', 'Dead bug', 'Dead bug', logType: _reps),
  CatalogExercise('mountain_climber', Muscle.core, _bw, 'Escaladores', 'Mountain climber', 'Escalador', logType: _time),
  CatalogExercise('pallof_press_cable', Muscle.core, _ca, 'Press Pallof', 'Pallof press', 'Pallof press', restSeconds: 60),
  // Cuerpo completo
  CatalogExercise('burpee', Muscle.fullBody, _bw, 'Burpees', 'Burpee', 'Burpee', logType: _reps),
  CatalogExercise('power_clean_barbell', Muscle.fullBody, _bb, 'Cargada de potencia', 'Power clean', 'Power clean', restSeconds: 150),
  CatalogExercise('thruster_barbell', Muscle.fullBody, _bb, 'Thruster con barra', 'Barbell thruster', 'Thruster com barra'),
  CatalogExercise('turkish_get_up', Muscle.fullBody, _kb, 'Levantada turca', 'Turkish get-up', 'Levantamento turco'),
  CatalogExercise('battle_ropes', Muscle.fullBody, _ot, 'Cuerdas de batalla', 'Battle ropes', 'Corda naval', logType: _time),
  CatalogExercise('sled_push', Muscle.fullBody, _ot, 'Empuje de trineo', 'Sled push', 'Empurrar trenó', logType: _dist, restSeconds: 120),
  // Cardio
  CatalogExercise('running', Muscle.cardio, _bw, 'Correr', 'Running', 'Corrida', logType: _timeDist),
  CatalogExercise('walking', Muscle.cardio, _bw, 'Caminar', 'Walking', 'Caminhada', logType: _timeDist),
  CatalogExercise('treadmill', Muscle.cardio, _ma, 'Cinta de correr', 'Treadmill', 'Esteira', logType: _timeDist),
  CatalogExercise('stationary_bike', Muscle.cardio, _ma, 'Bicicleta estática', 'Stationary bike', 'Bicicleta ergométrica', logType: _timeDist),
  CatalogExercise('rowing_machine', Muscle.cardio, _ma, 'Remo ergómetro', 'Rowing machine', 'Remo ergômetro', logType: _timeDist),
  CatalogExercise('elliptical', Muscle.cardio, _ma, 'Elíptica', 'Elliptical', 'Elíptico', logType: _time),
  CatalogExercise('stair_climber', Muscle.cardio, _ma, 'Escaladora', 'Stair climber', 'Simulador de escada', logType: _time),
  CatalogExercise('jump_rope', Muscle.cardio, _ot, 'Saltar la cuerda', 'Jump rope', 'Pular corda', logType: _time),
  CatalogExercise('jumping_jacks', Muscle.cardio, _bw, 'Saltos de tijera', 'Jumping jacks', 'Polichinelo', logType: _time),
];
// dart format on
