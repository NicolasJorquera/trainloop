// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Trainloop';

  @override
  String get logoWordmark => 'TRAINLOOP';

  @override
  String get navMainLabel => 'Main navigation';

  @override
  String get navHome => 'HOME';

  @override
  String get navTrain => 'TRAIN';

  @override
  String get navHistory => 'HISTORY';

  @override
  String get navProgress => 'PROGRESS';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get backTooltip => 'Back';

  @override
  String get homeWeekOverline => 'THIS WEEK';

  @override
  String get homeWeekEmptyTitle => 'No workouts yet this week';

  @override
  String get homeWeekEmptyBody =>
      'Start an interval timer or a strength session. Everything stays on this phone.';

  @override
  String get homeStartIntervals => 'INTERVALS';

  @override
  String get homeStartStrength => 'STRENGTH';

  @override
  String get trainTitle => 'TRAIN';

  @override
  String get trainKindLabel => 'Workout type';

  @override
  String get trainIntervals => 'Intervals';

  @override
  String get trainRoutines => 'Routines';

  @override
  String get trainIntervalsEmptyTitle => 'Your interval timers';

  @override
  String get trainIntervalsEmptyBody =>
      'Tabata, HIIT, EMOM and your own timers will live here.';

  @override
  String get trainRoutinesEmptyTitle => 'Your strength routines';

  @override
  String get trainRoutinesEmptyBody =>
      'Build routines with your exercises and log every set with one tap.';

  @override
  String get historyTitle => 'HISTORY';

  @override
  String get historyEmptyTitle => 'No sessions yet';

  @override
  String get historyEmptyBody =>
      'Every workout you finish is saved here, on this phone.';

  @override
  String get progressTitle => 'PROGRESS';

  @override
  String get progressEmptyTitle => 'Nothing to chart yet';

  @override
  String get progressEmptyBody =>
      'Train for a couple of weeks to see your sessions, active minutes and records.';

  @override
  String get settingsTitle => 'SETTINGS';

  @override
  String get settingsAppearance => 'APPEARANCE';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsAccent => 'ACCENT COLOR';

  @override
  String get accentHelp =>
      'Changes the color of buttons, bars and the work phase. All options have the same contrast.';

  @override
  String get accentOrquidea => 'Orchid';

  @override
  String get accentRosa => 'Pink';

  @override
  String get accentRojo => 'Red';

  @override
  String get accentNaranja => 'Orange';

  @override
  String get accentAmarillo => 'Yellow';

  @override
  String get accentLima => 'Lime';

  @override
  String get accentAzul => 'Blue';

  @override
  String get accentVioleta => 'Violet';

  @override
  String get phaseWork => 'WORK';

  @override
  String get phaseRest => 'REST';

  @override
  String get settingsLanguage => 'LANGUAGE';

  @override
  String get languageSystem => 'Phone language';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePortuguese => 'Português (Brasil)';

  @override
  String get languagePseudo => 'Pseudo-locale (en-XA, debug)';

  @override
  String get languageHelp =>
      'Applies right away. On Android 13 or later you can also pick it in the system app settings.';

  @override
  String get selectedLabel => 'Selected';

  @override
  String get debugDatabaseSection => 'DEBUG · DATABASE';

  @override
  String debugDatabaseCounts(
    int exercises,
    int routines,
    int workouts,
    int sessions,
    int sets,
  ) {
    return '$exercises exercises · $routines routines · $workouts timers · $sessions sessions · $sets sets';
  }

  @override
  String get debugDatabaseHelp =>
      'Debug builds only. Data stays on this phone: force-stop the app and reopen it to check it persists.';

  @override
  String get debugSeedDemo => 'ADD DEMO DATA';

  @override
  String get trainNewRoutine => 'NEW';

  @override
  String get trainRoutinesHint =>
      'Unlimited routines. Press and hold a card to reorder.';

  @override
  String get trainExerciseLibrary => 'Exercise library';

  @override
  String routineExerciseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exercises',
      one: '1 exercise',
      zero: 'No exercises',
    );
    return '$_temp0';
  }

  @override
  String routineActions(String name) {
    return 'Options for $name';
  }

  @override
  String get routineEdit => 'Edit';

  @override
  String get routineDuplicate => 'Duplicate';

  @override
  String get routineArchive => 'Archive';

  @override
  String routineArchived(String name) {
    return '“$name” archived';
  }

  @override
  String routineDuplicated(String name) {
    return 'Copy created: “$name”';
  }

  @override
  String routineCopyName(String name) {
    return '$name (copy)';
  }

  @override
  String get undo => 'Undo';

  @override
  String get routineNewTitle => 'New routine';

  @override
  String get routineEditTitle => 'Edit routine';

  @override
  String get fieldName => 'NAME';

  @override
  String get routineNameHint => 'E.g. Legs A';

  @override
  String routineDefaultName(int number) {
    return 'Routine $number';
  }

  @override
  String routineExercisesLabel(int count) {
    return 'EXERCISES · $count';
  }

  @override
  String get routineAddExercises => 'Add exercises';

  @override
  String get routineEditorHint =>
      'Editing the routine doesn’t change your past sessions.';

  @override
  String get routineSave => 'Save routine';

  @override
  String routineRemoveExercise(String name) {
    return 'Remove $name';
  }

  @override
  String get routineDragHandle => 'Drag to reorder';

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
      other: '$sets sets',
      one: '1 set',
    );
    return '$_temp0';
  }

  @override
  String summaryRest(String time) {
    return 'rest $time';
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
  String get sheetSets => 'Sets';

  @override
  String get sheetReps => 'Reps';

  @override
  String get sheetDuration => 'Duration';

  @override
  String get sheetWeight => 'Target weight (optional)';

  @override
  String get sheetRest => 'Rest';

  @override
  String get sheetDone => 'Done';

  @override
  String stepperDecrease(String label) {
    return 'Less: $label';
  }

  @override
  String stepperIncrease(String label) {
    return 'More: $label';
  }

  @override
  String get libraryTitle => 'Exercises';

  @override
  String get libraryPickTitle => 'Add exercises';

  @override
  String get librarySearch => 'Search exercise';

  @override
  String get libraryFilterMuscle => 'Filter by muscle';

  @override
  String get libraryAnyEquipment => 'Equipment';

  @override
  String get libraryAnyLogType => 'Tracking';

  @override
  String get libraryAll => 'All';

  @override
  String libraryNotFound(String query) {
    return 'Nothing found for “$query”';
  }

  @override
  String libraryCreateNamed(String query) {
    return 'Create “$query”';
  }

  @override
  String get libraryCreateCustom => 'Create your own exercise';

  @override
  String libraryAddCount(int count) {
    return 'Add $count';
  }

  @override
  String get libraryPickPrompt => 'Select exercises';

  @override
  String get libraryCustomTag => 'Custom';

  @override
  String get muscleGroupLegs => 'Legs';

  @override
  String get muscleGroupChest => 'Chest';

  @override
  String get muscleGroupBack => 'Back';

  @override
  String get muscleGroupShoulders => 'Shoulders';

  @override
  String get muscleGroupArms => 'Arms';

  @override
  String get muscleGroupCore => 'Core';

  @override
  String get muscleGroupOther => 'Cardio & more';

  @override
  String get muscleChest => 'Chest';

  @override
  String get muscleBack => 'Back';

  @override
  String get muscleShoulders => 'Shoulders';

  @override
  String get muscleBiceps => 'Biceps';

  @override
  String get muscleTriceps => 'Triceps';

  @override
  String get muscleForearms => 'Forearms';

  @override
  String get muscleCore => 'Core';

  @override
  String get muscleQuads => 'Quads';

  @override
  String get muscleHamstrings => 'Hamstrings';

  @override
  String get muscleGlutes => 'Glutes';

  @override
  String get muscleCalves => 'Calves';

  @override
  String get muscleFullBody => 'Full body';

  @override
  String get muscleCardio => 'Cardio';

  @override
  String get muscleOther => 'Other';

  @override
  String get equipmentBarbell => 'Barbell';

  @override
  String get equipmentDumbbell => 'Dumbbells';

  @override
  String get equipmentMachine => 'Machine';

  @override
  String get equipmentCable => 'Cable';

  @override
  String get equipmentKettlebell => 'Kettlebell';

  @override
  String get equipmentBand => 'Band';

  @override
  String get equipmentBodyweight => 'Bodyweight';

  @override
  String get equipmentOther => 'Other';

  @override
  String get logTypeWeightReps => 'Weight + reps';

  @override
  String get logTypeReps => 'Reps only';

  @override
  String get logTypeTime => 'Time';

  @override
  String get logTypeDistance => 'Distance';

  @override
  String get logTypeTimeDistance => 'Distance + time';

  @override
  String get exerciseCreateTitle => 'Create exercise';

  @override
  String get exerciseEditTitle => 'Edit exercise';

  @override
  String get exerciseNameHint => 'E.g. Bulgarian split squat';

  @override
  String exerciseDuplicate(String name) {
    return '“$name” already exists. Use the existing one?';
  }

  @override
  String exerciseUseExisting(String name) {
    return 'Use “$name”';
  }

  @override
  String get exerciseTrackLabel => 'WHAT YOU TRACK';

  @override
  String get exerciseMuscleLabel => 'PRIMARY MUSCLE';

  @override
  String get exerciseEquipmentLabel => 'EQUIPMENT';

  @override
  String get exerciseIncrementLabel => 'INCREMENT';

  @override
  String get exerciseRestLabel => 'DEFAULT REST';

  @override
  String get exerciseSave => 'Save exercise';

  @override
  String get exerciseArchive => 'Archive exercise';

  @override
  String get exerciseArchived => 'Exercise archived. Your history keeps it.';
}

/// The translations for English (`en_XA`).
class AppLocalizationsEnXa extends AppLocalizationsEn {
  AppLocalizationsEnXa() : super('en_XA');

  @override
  String get appTitle => '[Ţŕáîñļööþ ····]';

  @override
  String get logoWordmark => '[ŢŔÅÎÑĻÖÖÞ ····]';

  @override
  String get navMainLabel => '[Ṁáîñ ñáṽîĝáţîöñ ······]';

  @override
  String get navHome => '[ĤÖṀÉ ··]';

  @override
  String get navTrain => '[ŢŔÅÎÑ ··]';

  @override
  String get navHistory => '[ĤÎŠŢÖŔÝ ···]';

  @override
  String get navProgress => '[ÞŔÖĜŔÉŠŠ ····]';

  @override
  String get settingsTooltip => '[Šéţţîñĝš ····]';

  @override
  String get backTooltip => '[Ɓáçķ ··]';

  @override
  String get homeWeekOverline => '[ŢĤÎŠ ŴÉÉĶ ····]';

  @override
  String get homeWeekEmptyTitle => '[Ñö ŵöŕķöûţš ýéţ ţĥîš ŵééķ ·········]';

  @override
  String get homeWeekEmptyBody =>
      '[Šţáŕţ áñ îñţéŕṽáļ ţîɱéŕ öŕ á šţŕéñĝţĥ šéššîöñ. Éṽéŕýţĥîñĝ šţáýš öñ ţĥîš þĥöñé. ··························]';

  @override
  String get homeStartIntervals => '[ÎÑŢÉŔṼÅĻŠ ····]';

  @override
  String get homeStartStrength => '[ŠŢŔÉÑĜŢĤ ····]';

  @override
  String get trainTitle => '[ŢŔÅÎÑ ··]';

  @override
  String get trainKindLabel => '[Ŵöŕķöûţ ţýþé ·····]';

  @override
  String get trainIntervals => '[Îñţéŕṽáļš ····]';

  @override
  String get trainRoutines => '[Ŕöûţîñéš ····]';

  @override
  String get trainIntervalsEmptyTitle => '[Ýöûŕ îñţéŕṽáļ ţîɱéŕš ········]';

  @override
  String get trainIntervalsEmptyBody =>
      '[Ţáƀáţá, ĤÎÎŢ, ÉṀÖṀ áñð ýöûŕ öŵñ ţîɱéŕš ŵîļļ ļîṽé ĥéŕé. ·················]';

  @override
  String get trainRoutinesEmptyTitle => '[Ýöûŕ šţŕéñĝţĥ ŕöûţîñéš ········]';

  @override
  String get trainRoutinesEmptyBody =>
      '[Ɓûîļð ŕöûţîñéš ŵîţĥ ýöûŕ éẋéŕçîšéš áñð ļöĝ éṽéŕý šéţ ŵîţĥ öñé ţáþ. ······················]';

  @override
  String get historyTitle => '[ĤÎŠŢÖŔÝ ···]';

  @override
  String get historyEmptyTitle => '[Ñö šéššîöñš ýéţ ······]';

  @override
  String get historyEmptyBody =>
      '[Éṽéŕý ŵöŕķöûţ ýöû ƒîñîšĥ îš šáṽéð ĥéŕé, öñ ţĥîš þĥöñé. ··················]';

  @override
  String get progressTitle => '[ÞŔÖĜŔÉŠŠ ····]';

  @override
  String get progressEmptyTitle => '[Ñöţĥîñĝ ţö çĥáŕţ ýéţ ·······]';

  @override
  String get progressEmptyBody =>
      '[Ţŕáîñ ƒöŕ á çöûþļé öƒ ŵééķš ţö šéé ýöûŕ šéššîöñš, áçţîṽé ɱîñûţéš áñð ŕéçöŕðš. ·························]';

  @override
  String get settingsTitle => '[ŠÉŢŢÎÑĜŠ ····]';

  @override
  String get settingsAppearance => '[ÅÞÞÉÅŔÅÑÇÉ ····]';

  @override
  String get themeSystem => '[Šýšţéɱ ···]';

  @override
  String get themeLight => '[Ļîĝĥţ ··]';

  @override
  String get themeDark => '[Ðáŕķ ··]';

  @override
  String get settingsAccent => '[ÅÇÇÉÑŢ ÇÖĻÖŔ ·····]';

  @override
  String get accentHelp =>
      '[Çĥáñĝéš ţĥé çöļöŕ öƒ ƀûţţöñš, ƀáŕš áñð ţĥé ŵöŕķ þĥášé. Åļļ öþţîöñš ĥáṽé ţĥé šáɱé çöñţŕášţ. ·····························]';

  @override
  String get accentOrquidea => '[Öŕçĥîð ···]';

  @override
  String get accentRosa => '[Þîñķ ··]';

  @override
  String get accentRojo => '[Ŕéð ··]';

  @override
  String get accentNaranja => '[Öŕáñĝé ···]';

  @override
  String get accentAmarillo => '[Ýéļļöŵ ···]';

  @override
  String get accentLima => '[Ļîɱé ··]';

  @override
  String get accentAzul => '[Ɓļûé ··]';

  @override
  String get accentVioleta => '[Ṽîöļéţ ···]';

  @override
  String get phaseWork => '[ŴÖŔĶ ··]';

  @override
  String get phaseRest => '[ŔÉŠŢ ··]';

  @override
  String get settingsLanguage => '[ĻÅÑĜÛÅĜÉ ····]';

  @override
  String get languageSystem => '[Þĥöñé ļáñĝûáĝé ······]';

  @override
  String get languageSpanish => '[Éšþáñöļ ···]';

  @override
  String get languageEnglish => '[Éñĝļîšĥ ···]';

  @override
  String get languagePortuguese => '[Þöŕţûĝûêš (Ɓŕášîļ) ······]';

  @override
  String get languagePseudo => '[Þšéûðö-ļöçáļé (éñ-ẊÅ, ðéƀûĝ) ·········]';

  @override
  String get languageHelp =>
      '[Åþþļîéš ŕîĝĥţ áŵáý. Öñ Åñðŕöîð 13 öŕ ļáţéŕ ýöû çáñ áļšö þîçķ îţ îñ ţĥé šýšţéɱ áþþ šéţţîñĝš. ····························]';

  @override
  String get selectedLabel => '[Šéļéçţéð ····]';

  @override
  String get debugDatabaseSection => '[ÐÉƁÛĜ · ÐÅŢÅƁÅŠÉ ······]';

  @override
  String debugDatabaseCounts(
    int exercises,
    int routines,
    int workouts,
    int sessions,
    int sets,
  ) {
    return '[$exercises éẋéŕçîšéš · $routines ŕöûţîñéš · $workouts ţîɱéŕš · $sessions šéššîöñš · $sets šéţš ··············]';
  }

  @override
  String get debugDatabaseHelp =>
      '[Ðéƀûĝ ƀûîļðš öñļý. Ðáţá šţáýš öñ ţĥîš þĥöñé: ƒöŕçé-šţöþ ţĥé áþþ áñð ŕéöþéñ îţ ţö çĥéçķ îţ þéŕšîšţš. ································]';

  @override
  String get debugSeedDemo => '[ÅÐÐ ÐÉṀÖ ÐÅŢÅ ·····]';

  @override
  String get trainNewRoutine => '[ÑÉŴ ··]';

  @override
  String get trainRoutinesHint =>
      '[Ûñļîɱîţéð ŕöûţîñéš. Þŕéšš áñð ĥöļð á çáŕð ţö ŕéöŕðéŕ. ··················]';

  @override
  String get trainExerciseLibrary => '[Éẋéŕçîšé ļîƀŕáŕý ······]';

  @override
  String routineExerciseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éẋéŕçîšéš',
      one: '1 éẋéŕçîšé',
      zero: 'Ñö éẋéŕçîšéš',
    );
    return '[$_temp0 ············]';
  }

  @override
  String routineActions(String name) {
    return '[Öþţîöñš ƒöŕ $name ····]';
  }

  @override
  String get routineEdit => '[Éðîţ ··]';

  @override
  String get routineDuplicate => '[Ðûþļîçáţé ····]';

  @override
  String get routineArchive => '[Åŕçĥîṽé ···]';

  @override
  String routineArchived(String name) {
    return '[“$name” áŕçĥîṽéð ····]';
  }

  @override
  String routineDuplicated(String name) {
    return '[Çöþý çŕéáţéð: “$name” ·····]';
  }

  @override
  String routineCopyName(String name) {
    return '[$name (çöþý) ··]';
  }

  @override
  String get undo => '[Ûñðö ··]';

  @override
  String get routineNewTitle => '[Ñéŵ ŕöûţîñé ····]';

  @override
  String get routineEditTitle => '[Éðîţ ŕöûţîñé ·····]';

  @override
  String get fieldName => '[ÑÅṀÉ ··]';

  @override
  String get routineNameHint => '[É.ĝ. Ļéĝš Å ···]';

  @override
  String routineDefaultName(int number) {
    return '[Ŕöûţîñé $number ···]';
  }

  @override
  String routineExercisesLabel(int count) {
    return '[ÉẊÉŔÇÎŠÉŠ · $count ····]';
  }

  @override
  String get routineAddExercises => '[Åðð éẋéŕçîšéš ·····]';

  @override
  String get routineEditorHint =>
      '[Éðîţîñĝ ţĥé ŕöûţîñé ðöéšñ’ţ çĥáñĝé ýöûŕ þášţ šéššîöñš. ··················]';

  @override
  String get routineSave => '[Šáṽé ŕöûţîñé ·····]';

  @override
  String routineRemoveExercise(String name) {
    return '[Ŕéɱöṽé $name ···]';
  }

  @override
  String get routineDragHandle => '[Ðŕáĝ ţö ŕéöŕðéŕ ······]';

  @override
  String summarySetsReps(int sets, int reps) {
    return '[$sets × $reps]';
  }

  @override
  String summarySetsTime(int sets, String time) {
    return '[$sets × $time]';
  }

  @override
  String summarySets(int sets) {
    String _temp0 = intl.Intl.pluralLogic(
      sets,
      locale: localeName,
      other: '$sets šéţš',
      one: '1 šéţ',
    );
    return '[$_temp0 ···]';
  }

  @override
  String summaryRest(String time) {
    return '[ŕéšţ $time ··]';
  }

  @override
  String summaryJoin(String first, String second) {
    return '[$first · $second]';
  }

  @override
  String weightValue(String value, String unit) {
    return '[$value $unit]';
  }

  @override
  String get unitKg => '[ķĝ ·]';

  @override
  String get unitLb => '[ļƀ ·]';

  @override
  String durationMinSec(int minutes, String seconds) {
    return '[$minutes:$seconds]';
  }

  @override
  String numberValue(int value) {
    return '[$value]';
  }

  @override
  String get sheetSets => '[Šéţš ··]';

  @override
  String get sheetReps => '[Ŕéþš ··]';

  @override
  String get sheetDuration => '[Ðûŕáţîöñ ····]';

  @override
  String get sheetWeight => '[Ţáŕĝéţ ŵéîĝĥţ (öþţîöñáļ) ········]';

  @override
  String get sheetRest => '[Ŕéšţ ··]';

  @override
  String get sheetDone => '[Ðöñé ··]';

  @override
  String stepperDecrease(String label) {
    return '[Ļéšš: $label ··]';
  }

  @override
  String stepperIncrease(String label) {
    return '[Ṁöŕé: $label ··]';
  }

  @override
  String get libraryTitle => '[Éẋéŕçîšéš ····]';

  @override
  String get libraryPickTitle => '[Åðð éẋéŕçîšéš ·····]';

  @override
  String get librarySearch => '[Šéáŕçĥ éẋéŕçîšé ······]';

  @override
  String get libraryFilterMuscle => '[Ƒîļţéŕ ƀý ɱûšçļé ······]';

  @override
  String get libraryAnyEquipment => '[Éǫûîþɱéñţ ····]';

  @override
  String get libraryAnyLogType => '[Ţŕáçķîñĝ ····]';

  @override
  String get libraryAll => '[Åļļ ··]';

  @override
  String libraryNotFound(String query) {
    return '[Ñöţĥîñĝ ƒöûñð ƒöŕ “$query” ······]';
  }

  @override
  String libraryCreateNamed(String query) {
    return '[Çŕéáţé “$query” ···]';
  }

  @override
  String get libraryCreateCustom => '[Çŕéáţé ýöûŕ öŵñ éẋéŕçîšé ·········]';

  @override
  String libraryAddCount(int count) {
    return '[Åðð $count ··]';
  }

  @override
  String get libraryPickPrompt => '[Šéļéçţ éẋéŕçîšéš ······]';

  @override
  String get libraryCustomTag => '[Çûšţöɱ ···]';

  @override
  String get muscleGroupLegs => '[Ļéĝš ··]';

  @override
  String get muscleGroupChest => '[Çĥéšţ ··]';

  @override
  String get muscleGroupBack => '[Ɓáçķ ··]';

  @override
  String get muscleGroupShoulders => '[Šĥöûļðéŕš ····]';

  @override
  String get muscleGroupArms => '[Åŕɱš ··]';

  @override
  String get muscleGroupCore => '[Çöŕé ··]';

  @override
  String get muscleGroupOther => '[Çáŕðîö & ɱöŕé ····]';

  @override
  String get muscleChest => '[Çĥéšţ ··]';

  @override
  String get muscleBack => '[Ɓáçķ ··]';

  @override
  String get muscleShoulders => '[Šĥöûļðéŕš ····]';

  @override
  String get muscleBiceps => '[Ɓîçéþš ···]';

  @override
  String get muscleTriceps => '[Ţŕîçéþš ···]';

  @override
  String get muscleForearms => '[Ƒöŕéáŕɱš ····]';

  @override
  String get muscleCore => '[Çöŕé ··]';

  @override
  String get muscleQuads => '[Ǫûáðš ··]';

  @override
  String get muscleHamstrings => '[Ĥáɱšţŕîñĝš ····]';

  @override
  String get muscleGlutes => '[Ĝļûţéš ···]';

  @override
  String get muscleCalves => '[Çáļṽéš ···]';

  @override
  String get muscleFullBody => '[Ƒûļļ ƀöðý ····]';

  @override
  String get muscleCardio => '[Çáŕðîö ···]';

  @override
  String get muscleOther => '[Öţĥéŕ ··]';

  @override
  String get equipmentBarbell => '[Ɓáŕƀéļļ ···]';

  @override
  String get equipmentDumbbell => '[Ðûɱƀƀéļļš ····]';

  @override
  String get equipmentMachine => '[Ṁáçĥîñé ···]';

  @override
  String get equipmentCable => '[Çáƀļé ··]';

  @override
  String get equipmentKettlebell => '[Ķéţţļéƀéļļ ····]';

  @override
  String get equipmentBand => '[Ɓáñð ··]';

  @override
  String get equipmentBodyweight => '[Ɓöðýŵéîĝĥţ ····]';

  @override
  String get equipmentOther => '[Öţĥéŕ ··]';

  @override
  String get logTypeWeightReps => '[Ŵéîĝĥţ + ŕéþš ····]';

  @override
  String get logTypeReps => '[Ŕéþš öñļý ····]';

  @override
  String get logTypeTime => '[Ţîɱé ··]';

  @override
  String get logTypeDistance => '[Ðîšţáñçé ····]';

  @override
  String get logTypeTimeDistance => '[Ðîšţáñçé + ţîɱé ·····]';

  @override
  String get exerciseCreateTitle => '[Çŕéáţé éẋéŕçîšé ······]';

  @override
  String get exerciseEditTitle => '[Éðîţ éẋéŕçîšé ·····]';

  @override
  String get exerciseNameHint => '[É.ĝ. Ɓûļĝáŕîáñ šþļîţ šǫûáţ ·········]';

  @override
  String exerciseDuplicate(String name) {
    return '[“$name” áļŕéáðý éẋîšţš. Ûšé ţĥé éẋîšţîñĝ öñé? ············]';
  }

  @override
  String exerciseUseExisting(String name) {
    return '[Ûšé “$name” ··]';
  }

  @override
  String get exerciseTrackLabel => '[ŴĤÅŢ ÝÖÛ ŢŔÅÇĶ ·····]';

  @override
  String get exerciseMuscleLabel => '[ÞŔÎṀÅŔÝ ṀÛŠÇĻÉ ······]';

  @override
  String get exerciseEquipmentLabel => '[ÉǪÛÎÞṀÉÑŢ ····]';

  @override
  String get exerciseIncrementLabel => '[ÎÑÇŔÉṀÉÑŢ ····]';

  @override
  String get exerciseRestLabel => '[ÐÉƑÅÛĻŢ ŔÉŠŢ ·····]';

  @override
  String get exerciseSave => '[Šáṽé éẋéŕçîšé ·····]';

  @override
  String get exerciseArchive => '[Åŕçĥîṽé éẋéŕçîšé ······]';

  @override
  String get exerciseArchived =>
      '[Éẋéŕçîšé áŕçĥîṽéð. Ýöûŕ ĥîšţöŕý ķééþš îţ. ··············]';
}
