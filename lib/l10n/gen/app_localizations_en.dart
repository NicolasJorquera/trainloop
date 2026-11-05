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
  String get trainRoutines => 'Strength';

  @override
  String get trainIntervalsEmptyTitle => 'No timers yet';

  @override
  String get trainIntervalsEmptyBody =>
      'Create one with NEW or start from a template.';

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

  @override
  String get phaseNamePrepare => 'Get ready';

  @override
  String get phaseNameWarmup => 'Warm-up';

  @override
  String get phaseNameWork => 'Work';

  @override
  String get phaseNameRest => 'Rest';

  @override
  String get phaseNameCooldown => 'Cool-down';

  @override
  String get timerPhasePrepare => 'GET READY';

  @override
  String get timerPhaseWarmup => 'WARM-UP';

  @override
  String get timerPhaseCooldown => 'COOL-DOWN';

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
  String get templateWalkRun => 'Walk/run';

  @override
  String get templateRun => 'Run';

  @override
  String get templateWalk => 'Walk';

  @override
  String get templateTag => 'Template';

  @override
  String intervalMeta(int rounds, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds rounds',
      one: '1 round',
    );
    return '$_temp0 · $total';
  }

  @override
  String get homeQuickTemplates => 'QUICK TEMPLATES';

  @override
  String get trainTemplates => 'TEMPLATES';

  @override
  String get trainMyIntervals => 'MY TIMERS';

  @override
  String get trainNewInterval => 'NEW';

  @override
  String get intervalNewTooltip => 'New interval timer';

  @override
  String intervalStart(String name) {
    return 'Start $name';
  }

  @override
  String intervalActions(String name) {
    return 'Actions for $name';
  }

  @override
  String intervalArchived(String name) {
    return '“$name” archived';
  }

  @override
  String get detailCloseTooltip => 'Close';

  @override
  String detailMeta(String total, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds rounds',
      one: '1 round',
    );
    return '$total total · $_temp0';
  }

  @override
  String get repeatCaps => 'REPEAT';

  @override
  String repeatRounds(int rounds) {
    return '× $rounds ROUNDS';
  }

  @override
  String get detailSkipLast => 'The last rest is skipped';

  @override
  String get alertVoice => 'Voice';

  @override
  String get alertBeeps => 'beeps';

  @override
  String get alertVibration => 'vibration';

  @override
  String alertsOn(String items) {
    return '$items on';
  }

  @override
  String get alertsOff => 'Alerts off';

  @override
  String get detailNoVoice => 'No offline voice for this language: beeps only';

  @override
  String get detailStart => 'START';

  @override
  String get detailEdit => 'EDIT';

  @override
  String get detailDuplicate => 'DUPLICATE';

  @override
  String get detailCustomize => 'CUSTOMIZE';

  @override
  String get editorNewTitle => 'NEW TIMER';

  @override
  String get editorEditTitle => 'EDIT TIMER';

  @override
  String editorDefaultName(String date) {
    return 'Intervals $date';
  }

  @override
  String editorLess(String phase) {
    return 'Remove 5 seconds from $phase';
  }

  @override
  String editorMore(String phase) {
    return 'Add 5 seconds to $phase';
  }

  @override
  String get editorLessRounds => 'Fewer rounds';

  @override
  String get editorMoreRounds => 'More rounds';

  @override
  String get editorSkipLast => 'Skip the last rest';

  @override
  String get editorAddBlock => 'ADD BLOCK';

  @override
  String get editorAddToRepeat => 'ADD TO REPEAT';

  @override
  String get editorRepeat => 'Repeat';

  @override
  String get editorAddTitle => 'Add';

  @override
  String get editorErrorNoWork =>
      'Add at least one work interval of 1 second or more.';

  @override
  String get editorErrorEmptyRepeat =>
      'Each repeat needs at least one interval.';

  @override
  String get editorErrorTooLong => 'The total can’t be longer than 4 hours.';

  @override
  String get editorTotal => 'TOTAL TIME';

  @override
  String get editorSave => 'SAVE';

  @override
  String get editorBlockActions => 'Block actions';

  @override
  String get editorRename => 'Label';

  @override
  String get editorLabelHint => 'E.g. Squats';

  @override
  String get editorMoveUp => 'Move up';

  @override
  String get editorMoveDown => 'Move down';

  @override
  String get editorRemove => 'Remove';

  @override
  String editorDurationTitle(String phase) {
    return 'Duration of $phase';
  }

  @override
  String get editorMinutes => 'Minutes';

  @override
  String get editorSeconds => 'Seconds';

  @override
  String get dialogCancel => 'Cancel';

  @override
  String get dialogOk => 'OK';

  @override
  String timerRound(int round, int rounds) {
    return 'ROUND $round/$rounds';
  }

  @override
  String timerSet(int set, int sets) {
    return 'SET $set/$sets';
  }

  @override
  String timerNext(String phase, String duration) {
    return 'Next: $phase $duration';
  }

  @override
  String get timerLast => 'Last phase';

  @override
  String get timerPaused => 'PAUSED';

  @override
  String get timerTapToResume => 'TAP TO RESUME';

  @override
  String get timerPause => 'Pause';

  @override
  String get timerResume => 'Resume';

  @override
  String get timerSkip => 'Skip to next phase';

  @override
  String get timerSkipShort => 'Skip';

  @override
  String get timerPrevious => 'Back to phase start';

  @override
  String get timerHoldToStop => 'HOLD TO STOP';

  @override
  String get timerHoldHint => 'Press and hold to stop the session';

  @override
  String get timerLock => 'Lock controls';

  @override
  String get timerLocked => 'Controls locked · tap the lock to unlock';

  @override
  String timerProgress(int current, int total) {
    return 'Phase $current of $total';
  }

  @override
  String get timerChannel => 'Session in progress';

  @override
  String timerNotificationRound(String phase, int round, int rounds) {
    return '$phase · Round $round/$rounds';
  }

  @override
  String cueRound(String phase, int round, int rounds) {
    return '$phase, round $round of $rounds';
  }

  @override
  String cueThenNext(String phase, String next) {
    return '$phase. Next: $next';
  }

  @override
  String get cueFinish => 'Session complete';

  @override
  String get summaryDoneTitle => 'Session complete!';

  @override
  String get summaryStoppedTitle => 'Session stopped';

  @override
  String summarySubtitle(String name, String date) {
    return '$name · $date';
  }

  @override
  String get summaryTotal => 'TOTAL';

  @override
  String get summaryRounds => 'ROUNDS';

  @override
  String get summaryWork => 'WORK';

  @override
  String summaryRoundsValue(int done, int total) {
    return '$done/$total';
  }

  @override
  String summarySkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count phases skipped',
      one: '1 phase skipped',
      zero: '0 phases skipped',
    );
    return '$_temp0';
  }

  @override
  String summaryPaused(String time) {
    return '$time paused';
  }

  @override
  String get summaryNoPauses => 'no pauses';

  @override
  String get summaryShort => 'It lasted under 30 seconds. Discard it?';

  @override
  String get summaryRpeQuestion => 'HOW HARD WAS IT? (OPTIONAL)';

  @override
  String summaryRpeValue(int value) {
    return 'Effort $value of 10';
  }

  @override
  String get summaryRpeEasy => 'Very easy';

  @override
  String get summaryRpeMax => 'Max';

  @override
  String get summaryNote => 'NOTE';

  @override
  String get summaryNoteHint => 'E.g. “Sore knee in the last round”';

  @override
  String get summaryDone => 'DONE';

  @override
  String get summaryDiscard => 'Discard session';

  @override
  String get summaryDiscardTitle => 'Discard this session?';

  @override
  String get summaryDiscardBody =>
      'It won’t be saved to your history or count toward your week.';

  @override
  String get summaryDiscardConfirm => 'Discard';

  @override
  String get notifyTitle => 'FOLLOW YOUR WORKOUT WITH THE SCREEN OFF';

  @override
  String get notifyBody =>
      'Trainloop shows a notification while you train so you can see the phase and time without unlocking the phone.';

  @override
  String get notifyContinue => 'CONTINUE';

  @override
  String get notifyNotNow => 'Not now · start anyway';

  @override
  String get recoveryTitle => 'YOU HAVE AN UNFINISHED WORKOUT';

  @override
  String recoveryRound(int round, int rounds) {
    return 'Round $round/$rounds';
  }

  @override
  String recoveryAgo(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'interrupted $minutes min ago',
      one: 'interrupted 1 min ago',
      zero: 'interrupted moments ago',
    );
    return '$_temp0';
  }

  @override
  String get recoveryBody =>
      'Android closed the app. We saved your progress up to the last checkpoint.';

  @override
  String get recoveryResume => 'RESUME (PAUSED)';

  @override
  String get recoverySaveIncomplete => 'SAVE AS INCOMPLETE';

  @override
  String get recoveryDiscard => 'DISCARD';

  @override
  String batteryTitle(String brand) {
    return 'STOP $brand FROM PAUSING THE TIMER';
  }

  @override
  String get batteryBody =>
      'Battery use for Trainloop is restricted, so the timer would stop with the screen off. You only set this once:';

  @override
  String get batteryStep1 => 'Settings › Apps › Trainloop';

  @override
  String get batteryStep2 => 'Battery';

  @override
  String get batteryStep3 => 'Choose “Unrestricted”';

  @override
  String get batteryOpenSettings => 'OPEN SETTINGS';

  @override
  String get batteryDone => 'I DID IT';

  @override
  String get batteryLater => 'LATER';

  @override
  String get activeSessionTitle => 'A session is in progress';

  @override
  String get activeSessionBody => 'Finish it before starting another one.';

  @override
  String get activeSessionGo => 'BACK TO SESSION';

  @override
  String get volumeZero => 'Media volume is at 0: you won’t hear the alerts.';

  @override
  String get settingsAlerts => 'ALERTS';

  @override
  String get settingsVoice => 'Voice';

  @override
  String get settingsVoiceHelp => 'Says the name of each phase';

  @override
  String get settingsBeeps => '3-2-1 beeps';

  @override
  String get settingsBeepsHelp =>
      'Tone at each phase and in the last 3 seconds';

  @override
  String get settingsVibration => 'Vibration';

  @override
  String get settingsVibrationHelp => 'Long on work, double on rest';

  @override
  String get homeActiveSession => 'SESSION IN PROGRESS';

  @override
  String get homeActiveStrength => 'Back to your strength session';

  @override
  String get homeRepeatLast => 'REPEAT LAST';

  @override
  String homeRepeatMeta(String date) {
    return 'Strength · $date';
  }

  @override
  String routineStart(String name) {
    return 'Start $name';
  }

  @override
  String get settingsTraining => 'TRAINING';

  @override
  String get settingsUnits => 'Units';

  @override
  String get settingsUnitsHelp =>
      'Changes how weights are shown and entered. Logged sets keep their original unit.';

  @override
  String get cueRestOver => 'Next set';

  @override
  String get strengthFreeWorkout => 'FREE WORKOUT';

  @override
  String get strengthFreeTitle => 'Free workout';

  @override
  String get strengthEmptyRoutine =>
      'This routine has no exercises. Add some to start it.';

  @override
  String get strengthEmptyHint =>
      'Add the exercises you are going to do. Each set is saved as soon as you check it.';

  @override
  String get strengthInProgress => 'Session in progress';

  @override
  String get strengthFinish => 'FINISH';

  @override
  String strengthProgress(int done, int total) {
    return '$done/$total sets';
  }

  @override
  String get strengthRestLabel => '● REST';

  @override
  String get strengthRestNotification => 'Rest';

  @override
  String strengthRestRemaining(String time) {
    return 'Rest, $time left';
  }

  @override
  String get strengthRestOver => 'On to the next set!';

  @override
  String get strengthMinus15 => '−15';

  @override
  String get strengthPlus15 => '+15';

  @override
  String get strengthPlus15Short => '+15 s';

  @override
  String get strengthMinus15Tooltip => 'Subtract 15 seconds';

  @override
  String get strengthPlus15Tooltip => 'Add 15 seconds';

  @override
  String get strengthSkipRest => 'SKIP';

  @override
  String get strengthSkipRestTooltip => 'Skip rest';

  @override
  String strengthRestFor(String time) {
    return 'Rest $time';
  }

  @override
  String strengthExerciseActions(String name) {
    return 'Options for $name';
  }

  @override
  String get strengthMoveUp => 'Move up';

  @override
  String get strengthMoveDown => 'Move down';

  @override
  String get strengthRemoveExercise => 'Remove exercise';

  @override
  String strengthRemoveExerciseTitle(String name) {
    return 'Remove $name?';
  }

  @override
  String get strengthRemoveExerciseBody =>
      'Its logged sets will be removed from this session. The routine doesn\'t change.';

  @override
  String get strengthNotesTitle => 'Notes';

  @override
  String get strengthNotesHint => 'E.g. \"Seat at 4\"';

  @override
  String get strengthNotesSave => 'SAVE';

  @override
  String get strengthColSet => 'SET';

  @override
  String get strengthColPrevious => 'PREVIOUS';

  @override
  String get strengthColReps => 'REPS';

  @override
  String get strengthColTime => 'TIME';

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
  String get setTagWarmup => 'W';

  @override
  String get setTagFailure => 'F';

  @override
  String get setTagDrop => 'D';

  @override
  String setTagWithType(int number, String type) {
    return '$number$type';
  }

  @override
  String get strengthAddSet => '+ ADD SET';

  @override
  String get strengthAddExercise => '+ ADD EXERCISE';

  @override
  String strengthEditWeight(String set) {
    return 'Edit weight, $set';
  }

  @override
  String strengthEditReps(String set) {
    return 'Edit reps, $set';
  }

  @override
  String strengthCompleteSet(String set) {
    return 'Complete $set';
  }

  @override
  String strengthUncompleteSet(String set) {
    return 'Uncheck $set';
  }

  @override
  String strengthSetHeading(String exercise, int number) {
    return '$exercise · set $number';
  }

  @override
  String strengthSetHeadingWarmup(String exercise) {
    return '$exercise · warm-up';
  }

  @override
  String strengthNextSet(String exercise, int number) {
    return 'Next: $exercise, set $number';
  }

  @override
  String strengthNextWarmup(String exercise) {
    return 'Next: $exercise, warm-up';
  }

  @override
  String strengthLastTime(String values) {
    return 'Last time: $values';
  }

  @override
  String strengthWeightLabel(String unit) {
    return 'WEIGHT ($unit)';
  }

  @override
  String get strengthRepsLabel => 'REPS';

  @override
  String get strengthTimeLabel => 'TIME';

  @override
  String get strengthRpeLabel => 'EFFORT (RPE) · OPTIONAL';

  @override
  String get strengthSetTypeLabel => 'SET TYPE';

  @override
  String get setTypeWarmup => 'Warm-up';

  @override
  String get setTypeNormal => 'Normal';

  @override
  String get setTypeFailure => 'To failure';

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
    return 'Subtract $weight';
  }

  @override
  String strengthWeightPlus(String weight) {
    return 'Add $weight';
  }

  @override
  String get strengthRepsMinus => 'Subtract one rep';

  @override
  String get strengthRepsPlus => 'Add one rep';

  @override
  String strengthTimeMinus(int seconds) {
    return 'Subtract $seconds seconds';
  }

  @override
  String strengthTimePlus(int seconds) {
    return 'Add $seconds seconds';
  }

  @override
  String get strengthSaveSet => 'SAVE SET';

  @override
  String get strengthCloseNoSave => 'Close without saving';

  @override
  String get strengthRemoveSet => 'Remove set';

  @override
  String setErrorWeightRange(String max) {
    return 'Enter a weight between 0 and $max.';
  }

  @override
  String setErrorWeightStep(String step) {
    return 'Weight goes in steps of $step.';
  }

  @override
  String setErrorReps(int max) {
    return 'Reps go from 0 to $max.';
  }

  @override
  String get setErrorRpe => 'RPE goes from 6 to 10 in steps of 0.5.';

  @override
  String get setErrorDuration => 'Enter a time up to 99:59.';

  @override
  String strengthPendingTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'There are $count unfinished sets',
      one: 'There is 1 unfinished set',
    );
    return '$_temp0';
  }

  @override
  String get strengthPendingBody =>
      'You can discard them, mark them done with the suggested values, or keep training.';

  @override
  String get strengthPendingDiscard => 'DISCARD AND FINISH';

  @override
  String get strengthPendingComplete => 'MARK THEM AS DONE';

  @override
  String get strengthBackToSession => 'Back to session';

  @override
  String get strengthNoSetsTitle => 'NO SETS DONE';

  @override
  String get strengthNoSetsBody =>
      'A session without completed sets isn\'t saved. Discard it?';

  @override
  String get strengthRecoveryBody =>
      'Android closed the app. Every set you checked is saved.';

  @override
  String get strengthRecoveryResume => 'RESUME';

  @override
  String strengthSetsDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sets done',
      one: '1 set done',
      zero: 'no sets done',
    );
    return '$_temp0';
  }

  @override
  String get strengthSavedTitle => 'Session saved';

  @override
  String get strengthSummaryDuration => 'DURATION';

  @override
  String get strengthSummaryVolume => 'VOLUME';

  @override
  String get strengthSummarySets => 'SETS';

  @override
  String strengthMinutes(int minutes) {
    return '$minutes MIN';
  }

  @override
  String get strengthNewRecord => 'NEW RECORD';

  @override
  String strengthRecordSet(String exercise, String values) {
    return '$exercise: $values';
  }

  @override
  String strengthRecordWithRm(String exercise, String values, String rm) {
    return '$exercise: $values · estimated 1RM $rm';
  }

  @override
  String strengthUpdateRoutineQuestion(String routine) {
    return 'The structure changed. Update the \"$routine\" routine?';
  }

  @override
  String get strengthUpdateRoutineYes => 'YES, UPDATE';

  @override
  String get strengthUpdateRoutineNo => 'No';

  @override
  String strengthRoutineUpdated(String routine) {
    return '\"$routine\" updated: exercises and number of sets.';
  }

  @override
  String get strengthRoutineKept => 'The routine stays as it was.';

  @override
  String get strengthNoteHint => 'E.g. \"Knee felt better\"';

  @override
  String decimalText(String value) {
    return '$value';
  }

  @override
  String get debugWeekVariant => 'Weekly view (H5 test)';

  @override
  String get debugWeekVariantHelp =>
      'Internal setting for the usability test: strength and intervals together or separate.';

  @override
  String get weekVariantUnified => 'UNIFIED';

  @override
  String get weekVariantSeparate => 'SEPARATE';

  @override
  String get detailColSet => 'SET';

  @override
  String get detailColReps => 'REPS';

  @override
  String get detailColRpe => 'RPE';

  @override
  String get detailColTime => 'TIME';

  @override
  String get detailDelete => 'DELETE';

  @override
  String get detailDeleteTitle => 'Delete this session?';

  @override
  String get detailDeleteBody =>
      'Your records will be recalculated. You\'ll have 5 seconds to undo.';

  @override
  String get detailDeleted => 'Session deleted';

  @override
  String get detailDone => 'DONE';

  @override
  String get detailEditHelp =>
      'Tap a set to change its weight, reps, RPE or type. Records are recalculated.';

  @override
  String detailEffort(int value) {
    return 'Effort $value/10';
  }

  @override
  String get detailMissing => 'This session is no longer in your history.';

  @override
  String get detailNameLabel => 'NAME';

  @override
  String detailNote(String note) {
    return 'Note: $note';
  }

  @override
  String get detailRecordTag => 'RECORD';

  @override
  String get detailRecords => 'RECORDS';

  @override
  String get detailRounds => 'ROUNDS';

  @override
  String detailRoutineSaved(String name) {
    return 'Routine \"$name\" saved';
  }

  @override
  String get detailSaveRoutine => 'SAVE AS ROUTINE';

  @override
  String get detailSets => 'SETS';

  @override
  String get detailTotal => 'TOTAL';

  @override
  String get detailVolume => 'VOLUME';

  @override
  String get detailWork => 'WORK';

  @override
  String distanceMeters(int meters) {
    return '$meters m';
  }

  @override
  String get exerciseHistory => 'HISTORY';

  @override
  String get exerciseLastMark => 'LAST MARK';

  @override
  String get exerciseNoHistory => 'No sessions with this exercise yet.';

  @override
  String get exerciseNoRecords => 'No records yet.';

  @override
  String exerciseOneRm(String value) {
    return 'estimated 1RM $value';
  }

  @override
  String get exerciseRecords => 'RECORDS';

  @override
  String exerciseTrendMissing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count more sessions to see the trend.',
      one: '1 more session to see the trend.',
    );
    return '$_temp0';
  }

  @override
  String exerciseTrendNote(String from, String to, String change) {
    return 'From $from to $to ($change%)';
  }

  @override
  String get exerciseTrendTitle => 'ESTIMATED 1RM';

  @override
  String historyBlockDone(String day, String name, String minutes) {
    return '✓ $day · $name · $minutes';
  }

  @override
  String get historyBlockEmpty => 'Nothing done or planned this week.';

  @override
  String historyBlockStrength(int done, int total) {
    return 'STRENGTH · $done OF $total';
  }

  @override
  String historyBlockIntervals(int done, int total) {
    return 'INTERVALS · $done OF $total';
  }

  @override
  String historyBlockPlanned(String day, String name) {
    return '○ $day · $name (planned)';
  }

  @override
  String historyCalendarDay(String date, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$date: $count sessions',
      one: '$date: 1 session',
      zero: '$date: no sessions',
    );
    return '$_temp0';
  }

  @override
  String historyDate(String date) {
    return '$date';
  }

  @override
  String get historyDayEmpty => 'No sessions this day.';

  @override
  String get historyDayFree => 'Free';

  @override
  String historyDayName(String day) {
    return '$day';
  }

  @override
  String get historyDayRest => 'Rest';

  @override
  String historyDayTitle(String date) {
    return '$date';
  }

  @override
  String get historyIncomplete => 'incomplete';

  @override
  String get historyIntervalsFallback => 'Intervals';

  @override
  String get historyLastWeek => 'LAST WEEK';

  @override
  String get historyLetterStrength => 'S';

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
  String get historyNextMonth => 'Next month';

  @override
  String get historyPrevMonth => 'Previous month';

  @override
  String historyRounds(int done, int total) {
    return '$done/$total rounds';
  }

  @override
  String historySets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sets',
      one: '1 set',
    );
    return '$_temp0';
  }

  @override
  String get historyStateDone => 'Done';

  @override
  String get historyStateIncomplete => 'Incomplete';

  @override
  String get historyStatePlanned => 'Planned';

  @override
  String get historyTabWeek => 'WEEK';

  @override
  String get historyTabList => 'LIST';

  @override
  String get historyTabCalendar => 'CALENDAR';

  @override
  String get historyTabsLabel => 'History view';

  @override
  String get historyThisWeek => 'THIS WEEK';

  @override
  String historyWeekGroup(String week, int sessions, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      sessions,
      locale: localeName,
      other: '$week · $sessions SESSIONS · $minutes MIN',
      one: '$week · 1 SESSION · $minutes MIN',
    );
    return '$_temp0';
  }

  @override
  String historyWeekHead(int done, int goal) {
    return 'THIS WEEK · $done OF $goal';
  }

  @override
  String get historyWeekLegend =>
      'S = strength · I = intervals · filled = done · outline = planned · dotted = rest or free. Tap a free day to plan it.';

  @override
  String historyWeekOf(String date) {
    return 'WEEK OF $date';
  }

  @override
  String get homeSeeProgress => 'SEE PROGRESS';

  @override
  String homeWeekMinutes(int minutes) {
    return '$minutes active min';
  }

  @override
  String homeWeekProgressLabel(int done, int goal) {
    return '$done of $goal sessions this week';
  }

  @override
  String get homeWeekSessions => 'sessions of your goal';

  @override
  String homeWeekStreak(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: '$weeks-week streak',
      one: '1-week streak',
    );
    return '$_temp0';
  }

  @override
  String get planHelp =>
      'Repeats every week. It only shows in your week: it never starts a session.';

  @override
  String get planNone => 'No plan';

  @override
  String planTitle(String day) {
    return 'Plan for $day';
  }

  @override
  String progressBarLabel(String date, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Week of $date: $count sessions',
      one: 'Week of $date: 1 session',
    );
    return '$_temp0';
  }

  @override
  String get progressChartNote =>
      'Strength and intervals count the same. Tap a bar to see its sessions.';

  @override
  String progressChartSub(String average, int goal) {
    return 'average $average · goal $goal';
  }

  @override
  String get progressChartTitle => 'SESSIONS PER WEEK';

  @override
  String get progressComplete => 'COMPLETE';

  @override
  String get progressGoalLine => 'goal';

  @override
  String progressGoalSuffix(int goal) {
    return '/$goal';
  }

  @override
  String progressIntervalMark(String rounds, String work) {
    return '$rounds · $work of work';
  }

  @override
  String get progressLastMarks => 'LAST MARK PER EXERCISE';

  @override
  String get progressMinutes => 'active min';

  @override
  String get progressRecordBadge => '↑ RECORD';

  @override
  String get progressSameBadge => '= SAME';

  @override
  String get progressSessions => 'sessions';

  @override
  String get progressStreak => 'weeks streak';

  @override
  String get progressThisWeekShort => 'Now';

  @override
  String progressWeekVolume(String volume) {
    return 'Strength volume this week: $volume';
  }

  @override
  String rangeWeeks(int count) {
    return '$count WK';
  }

  @override
  String rangeMonths(int count) {
    return '$count MO';
  }

  @override
  String get rangeYear => '1 YEAR';

  @override
  String get rangeAll => 'ALL';

  @override
  String recordLine(String name, String value) {
    return '$name: $value';
  }

  @override
  String get recordMaxWeight => 'Max weight';

  @override
  String get recordOneRm => 'Estimated 1RM';

  @override
  String recordMaxRepsAt(String weight) {
    return 'Most reps with $weight';
  }

  @override
  String get recordMaxRepsBodyweight => 'Most reps';

  @override
  String get recordMaxVolume => 'Best session volume';

  @override
  String get recordMaxDuration => 'Longest set';

  @override
  String get recordMaxDistance => 'Longest distance';

  @override
  String get settingsWeekStart => 'Week starts on';

  @override
  String get settingsMonday => 'MONDAY';

  @override
  String get settingsSunday => 'SUNDAY';

  @override
  String get settingsWeeklyGoal => 'Weekly goal (sessions)';

  @override
  String get settingsGoalLess => 'Fewer sessions';

  @override
  String get settingsGoalMore => 'More sessions';

  @override
  String get backupTitle => 'BACKUP';

  @override
  String get backupHeadline => 'YOUR DATA LIVES ONLY ON THIS PHONE';

  @override
  String get backupBody =>
      'Trainloop has no account or server. Create a backup and keep it wherever you like (Drive, Downloads or send it to yourself) so you never lose your history.';

  @override
  String get backupNever => 'You haven\'t created a backup yet.';

  @override
  String backupLast(String date, String sessions, String size) {
    return 'Last backup: $date · $sessions · $size';
  }

  @override
  String backupSessions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions',
      one: '1 session',
    );
    return '$_temp0';
  }

  @override
  String backupRoutines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count routines',
      one: '1 routine',
    );
    return '$_temp0';
  }

  @override
  String backupWorkouts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count timers',
      one: '1 timer',
    );
    return '$_temp0';
  }

  @override
  String backupSizeKb(String size) {
    return '$size KB';
  }

  @override
  String get backupCreate => 'CREATE BACKUP';

  @override
  String get backupRestore => 'RESTORE BACKUP';

  @override
  String get backupCsv => 'EXPORT CSV';

  @override
  String get backupCsvHelp =>
      'Two spreadsheet files: sessions and sets. You save one after the other.';

  @override
  String get backupHowTitle => 'HOW TO SAVE IT TO GOOGLE DRIVE';

  @override
  String get backupStep1 => 'Tap “Create backup”.';

  @override
  String get backupStep2 =>
      'In the Android menu, choose Drive (or another folder) and tap Save.';

  @override
  String get backupStep3 =>
      'On the new phone, tap “Restore backup” and pick the file.';

  @override
  String get backupAutoTitle => 'ANDROID AUTOMATIC BACKUP';

  @override
  String get backupAutoBody =>
      'If Google backup is on in your phone, Android also copies Trainloop\'s data and settings to your Google Drive and brings them back when you reinstall with the same account. It doesn\'t go through our servers, but the app doesn\'t control when it runs: a backup file is the safe way to switch phones.';

  @override
  String get backupWorking => 'Working…';

  @override
  String backupSaved(String name) {
    return 'Backup created: $name';
  }

  @override
  String get backupCsvSaved => 'CSV exported: sessions and sets';

  @override
  String get backupRestoreTitle => 'RESTORE THIS BACKUP?';

  @override
  String backupRestoreSummary(
    String date,
    String sessions,
    String routines,
    String workouts,
  ) {
    return 'Backup from $date: $sessions, $routines, $workouts.';
  }

  @override
  String get backupRestoreOlder =>
      'It comes from an older version of the app: it will be updated while restoring.';

  @override
  String get backupRestoreWarn =>
      'It will replace your current data. We will save an automatic copy of what you have now first.';

  @override
  String get backupRestoreConfirm => 'RESTORE';

  @override
  String get backupRestored => 'Backup restored';

  @override
  String get backupErrorInvalid =>
      'That file isn\'t a Trainloop backup or it\'s damaged. Nothing changed.';

  @override
  String get backupErrorNewer =>
      'That backup comes from a newer Trainloop. Update the app and try again.';

  @override
  String get backupErrorIntegrity =>
      'The backup has inconsistent data. Nothing changed.';

  @override
  String get backupErrorActive =>
      'Finish the current session before restoring.';

  @override
  String get backupErrorIo => 'The file couldn\'t be read or saved.';

  @override
  String get settingsDefaultRest => 'Default rest';

  @override
  String get settingsDefaultRestHelp =>
      'For new exercises. Built-in exercises keep their own rest.';

  @override
  String get settingsRestLess => '15 seconds less';

  @override
  String get settingsRestMore => '15 seconds more';

  @override
  String get settingsTestSound => 'TEST SOUND';

  @override
  String get settingsTestSpeech => 'This is how the cues sound';

  @override
  String get settingsData => 'DATA & PRIVACY';

  @override
  String get settingsDataWarnTitle => 'Your data lives only on this phone.';

  @override
  String get settingsDataWarnBody =>
      'If you uninstall the app or switch phones without a backup, it is lost.';

  @override
  String get settingsBackupLink => 'Backup & export';

  @override
  String get settingsBackupNever => 'no backups';

  @override
  String settingsBackupAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'last: $days days ago',
      one: 'last: yesterday',
      zero: 'last: today',
    );
    return '$_temp0';
  }

  @override
  String get remindersTitle => 'REMINDERS';

  @override
  String get remindersEnable => 'Remind me to train';

  @override
  String get remindersHelp =>
      'One notification on the chosen days, only if you haven\'t trained yet';

  @override
  String get remindersTime => 'Time';

  @override
  String remindersNext(String day, String time) {
    return 'Next: $day at $time';
  }

  @override
  String get remindersDenied =>
      'Without notification permission, reminders can\'t appear.';

  @override
  String get remindersOpenSettings => 'SETTINGS';

  @override
  String get reminderNotificationTitle => 'Time to train';

  @override
  String get reminderNotificationBody => 'Your workout is ready when you are.';

  @override
  String get reminderChannelName => 'Reminders';

  @override
  String get homeLocalDataNotice => 'Your data lives only on this phone.';

  @override
  String get homeLocalDataAction => 'Back up ›';

  @override
  String get homeLocalDataDismiss => 'Close notice';

  @override
  String formattedValue(String value) {
    return '$value';
  }

  @override
  String get routineDiscardTitle => 'DISCARD CHANGES?';

  @override
  String get routineDiscardBody => 'The routine stays as it was.';

  @override
  String get routineDiscardConfirm => 'DISCARD';

  @override
  String get routineDiscardKeep => 'Keep editing';

  @override
  String get adBannerLabel => 'Advertisement';

  @override
  String get settingsAnalytics => 'Anonymous usage statistics';

  @override
  String get settingsAnalyticsHelp =>
      'Only which session types start and finish. Never your workouts or personal data.';

  @override
  String get settingsPrivacyOptions => 'Privacy preferences';

  @override
  String get settingsPrivacyOptionsMeta => 'REVIEW';

  @override
  String get removeAdsTitle => 'REMOVE ADS · ONE-TIME';

  @override
  String get removeAdsBody =>
      'One payment, no subscription. All features stay free.';

  @override
  String removeAdsBuy(String price) {
    return 'REMOVE ADS · $price';
  }

  @override
  String get removeAdsBuyNoPrice => 'REMOVE ADS';

  @override
  String get removeAdsRestore => 'Restore purchase';

  @override
  String get removeAdsOwned => 'Ads removed. Thanks for supporting Trainloop!';

  @override
  String get removeAdsRestored => 'Purchase restored: ads removed.';

  @override
  String get removeAdsPending =>
      'Purchase pending: ads are removed once Google Play confirms it.';

  @override
  String get removeAdsCanceled => 'Purchase canceled. You were not charged.';

  @override
  String get removeAdsError =>
      'The purchase couldn\'t be completed. Try again.';

  @override
  String get removeAdsUnavailable =>
      'Google Play isn\'t available right now. Check your connection and try again.';

  @override
  String get removeAdsNothing =>
      'This Google Play account doesn\'t have the purchase.';

  @override
  String get errorLogTitle => 'Error log';

  @override
  String errorLogCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count errors',
      one: '1 error',
      zero: 'no errors',
    );
    return '$_temp0';
  }

  @override
  String get errorLogHelp =>
      'Technical errors stay only on this phone. Export the file if you want to send it to us.';

  @override
  String get errorLogEmpty => 'No errors recorded.';

  @override
  String errorLogSaved(String name) {
    return 'Error log saved: $name';
  }

  @override
  String strengthSameAsBefore(String values) {
    return 'SAME AS BEFORE: $values';
  }

  @override
  String strengthSameAsBeforeHint(String values) {
    return 'Log another set like the last one: $values';
  }
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
  String get trainRoutines => '[Šţŕéñĝţĥ ····]';

  @override
  String get trainIntervalsEmptyTitle => '[Ñö ţîɱéŕš ýéţ ·····]';

  @override
  String get trainIntervalsEmptyBody =>
      '[Çŕéáţé öñé ŵîţĥ ÑÉŴ öŕ šţáŕţ ƒŕöɱ á ţéɱþļáţé. ···············]';

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

  @override
  String get phaseNamePrepare => '[Ĝéţ ŕéáðý ····]';

  @override
  String get phaseNameWarmup => '[Ŵáŕɱ-ûþ ···]';

  @override
  String get phaseNameWork => '[Ŵöŕķ ··]';

  @override
  String get phaseNameRest => '[Ŕéšţ ··]';

  @override
  String get phaseNameCooldown => '[Çööļ-ðöŵñ ····]';

  @override
  String get timerPhasePrepare => '[ĜÉŢ ŔÉÅÐÝ ····]';

  @override
  String get timerPhaseWarmup => '[ŴÅŔṀ-ÛÞ ···]';

  @override
  String get timerPhaseCooldown => '[ÇÖÖĻ-ÐÖŴÑ ····]';

  @override
  String get templateTabata => '[Ţáƀáţá 20/10 ···]';

  @override
  String get templateHiit4020 => '[ĤÎÎŢ 40/20 ··]';

  @override
  String get templateHiit3030 => '[ĤÎÎŢ 30/30 ··]';

  @override
  String get templateEmom10 => '[ÉṀÖṀ 10 ɱîñ ···]';

  @override
  String get templateAmrap12 => '[ÅṀŔÅÞ 12 ɱîñ ····]';

  @override
  String get templateWalkRun => '[Ŵáļķ/ŕûñ ···]';

  @override
  String get templateRun => '[Ŕûñ ··]';

  @override
  String get templateWalk => '[Ŵáļķ ··]';

  @override
  String get templateTag => '[Ţéɱþļáţé ····]';

  @override
  String intervalMeta(int rounds, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds ŕöûñðš',
      one: '1 ŕöûñð',
    );
    return '[$_temp0 · $total ·····]';
  }

  @override
  String get homeQuickTemplates => '[ǪÛÎÇĶ ŢÉṀÞĻÅŢÉŠ ······]';

  @override
  String get trainTemplates => '[ŢÉṀÞĻÅŢÉŠ ····]';

  @override
  String get trainMyIntervals => '[ṀÝ ŢÎṀÉŔŠ ····]';

  @override
  String get trainNewInterval => '[ÑÉŴ ··]';

  @override
  String get intervalNewTooltip => '[Ñéŵ îñţéŕṽáļ ţîɱéŕ ·······]';

  @override
  String intervalStart(String name) {
    return '[Šţáŕţ $name ··]';
  }

  @override
  String intervalActions(String name) {
    return '[Åçţîöñš ƒöŕ $name ····]';
  }

  @override
  String intervalArchived(String name) {
    return '[“$name” áŕçĥîṽéð ····]';
  }

  @override
  String get detailCloseTooltip => '[Çļöšé ··]';

  @override
  String detailMeta(String total, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds ŕöûñðš',
      one: '1 ŕöûñð',
    );
    return '[$total ţöţáļ · $_temp0 ·······]';
  }

  @override
  String get repeatCaps => '[ŔÉÞÉÅŢ ···]';

  @override
  String repeatRounds(int rounds) {
    return '[× $rounds ŔÖÛÑÐŠ ···]';
  }

  @override
  String get detailSkipLast => '[Ţĥé ļášţ ŕéšţ îš šķîþþéð ········]';

  @override
  String get alertVoice => '[Ṽöîçé ··]';

  @override
  String get alertBeeps => '[ƀééþš ··]';

  @override
  String get alertVibration => '[ṽîƀŕáţîöñ ····]';

  @override
  String alertsOn(String items) {
    return '[$items öñ ·]';
  }

  @override
  String get alertsOff => '[Åļéŕţš öƒƒ ····]';

  @override
  String get detailNoVoice =>
      '[Ñö öƒƒļîñé ṽöîçé ƒöŕ ţĥîš ļáñĝûáĝé: ƀééþš öñļý ················]';

  @override
  String get detailStart => '[ŠŢÅŔŢ ··]';

  @override
  String get detailEdit => '[ÉÐÎŢ ··]';

  @override
  String get detailDuplicate => '[ÐÛÞĻÎÇÅŢÉ ····]';

  @override
  String get detailCustomize => '[ÇÛŠŢÖṀÎŽÉ ····]';

  @override
  String get editorNewTitle => '[ÑÉŴ ŢÎṀÉŔ ····]';

  @override
  String get editorEditTitle => '[ÉÐÎŢ ŢÎṀÉŔ ····]';

  @override
  String editorDefaultName(String date) {
    return '[Îñţéŕṽáļš $date ····]';
  }

  @override
  String editorLess(String phase) {
    return '[Ŕéɱöṽé 5 šéçöñðš ƒŕöɱ $phase ·······]';
  }

  @override
  String editorMore(String phase) {
    return '[Åðð 5 šéçöñðš ţö $phase ·····]';
  }

  @override
  String get editorLessRounds => '[Ƒéŵéŕ ŕöûñðš ·····]';

  @override
  String get editorMoreRounds => '[Ṁöŕé ŕöûñðš ····]';

  @override
  String get editorSkipLast => '[Šķîþ ţĥé ļášţ ŕéšţ ······]';

  @override
  String get editorAddBlock => '[ÅÐÐ ƁĻÖÇĶ ····]';

  @override
  String get editorAddToRepeat => '[ÅÐÐ ŢÖ ŔÉÞÉÅŢ ·····]';

  @override
  String get editorRepeat => '[Ŕéþéáţ ···]';

  @override
  String get editorAddTitle => '[Åðð ··]';

  @override
  String get editorErrorNoWork =>
      '[Åðð áţ ļéášţ öñé ŵöŕķ îñţéŕṽáļ öƒ 1 šéçöñð öŕ ɱöŕé. ················]';

  @override
  String get editorErrorEmptyRepeat =>
      '[Éáçĥ ŕéþéáţ ñééðš áţ ļéášţ öñé îñţéŕṽáļ. ··············]';

  @override
  String get editorErrorTooLong =>
      '[Ţĥé ţöţáļ çáñ’ţ ƀé ļöñĝéŕ ţĥáñ 4 ĥöûŕš. ············]';

  @override
  String get editorTotal => '[ŢÖŢÅĻ ŢÎṀÉ ····]';

  @override
  String get editorSave => '[ŠÅṼÉ ··]';

  @override
  String get editorBlockActions => '[Ɓļöçķ áçţîöñš ·····]';

  @override
  String get editorRename => '[Ļáƀéļ ··]';

  @override
  String get editorLabelHint => '[É.ĝ. Šǫûáţš ····]';

  @override
  String get editorMoveUp => '[Ṁöṽé ûþ ···]';

  @override
  String get editorMoveDown => '[Ṁöṽé ðöŵñ ····]';

  @override
  String get editorRemove => '[Ŕéɱöṽé ···]';

  @override
  String editorDurationTitle(String phase) {
    return '[Ðûŕáţîöñ öƒ $phase ····]';
  }

  @override
  String get editorMinutes => '[Ṁîñûţéš ···]';

  @override
  String get editorSeconds => '[Šéçöñðš ···]';

  @override
  String get dialogCancel => '[Çáñçéļ ···]';

  @override
  String get dialogOk => '[ÖĶ ·]';

  @override
  String timerRound(int round, int rounds) {
    return '[ŔÖÛÑÐ $round/$rounds ··]';
  }

  @override
  String timerSet(int set, int sets) {
    return '[ŠÉŢ $set/$sets ··]';
  }

  @override
  String timerNext(String phase, String duration) {
    return '[Ñéẋţ: $phase $duration ··]';
  }

  @override
  String get timerLast => '[Ļášţ þĥášé ····]';

  @override
  String get timerPaused => '[ÞÅÛŠÉÐ ···]';

  @override
  String get timerTapToResume => '[ŢÅÞ ŢÖ ŔÉŠÛṀÉ ·····]';

  @override
  String get timerPause => '[Þáûšé ··]';

  @override
  String get timerResume => '[Ŕéšûɱé ···]';

  @override
  String get timerSkip => '[Šķîþ ţö ñéẋţ þĥášé ······]';

  @override
  String get timerSkipShort => '[Šķîþ ··]';

  @override
  String get timerPrevious => '[Ɓáçķ ţö þĥášé šţáŕţ ·······]';

  @override
  String get timerHoldToStop => '[ĤÖĻÐ ŢÖ ŠŢÖÞ ····]';

  @override
  String get timerHoldHint =>
      '[Þŕéšš áñð ĥöļð ţö šţöþ ţĥé šéššîöñ ············]';

  @override
  String get timerLock => '[Ļöçķ çöñţŕöļš ·····]';

  @override
  String get timerLocked =>
      '[Çöñţŕöļš ļöçķéð · ţáþ ţĥé ļöçķ ţö ûñļöçķ ·············]';

  @override
  String timerProgress(int current, int total) {
    return '[Þĥášé $current öƒ $total ···]';
  }

  @override
  String get timerChannel => '[Šéššîöñ îñ þŕöĝŕéšš ·······]';

  @override
  String timerNotificationRound(String phase, int round, int rounds) {
    return '[$phase · Ŕöûñð $round/$rounds ··]';
  }

  @override
  String cueRound(String phase, int round, int rounds) {
    return '[$phase, ŕöûñð $round öƒ $rounds ···]';
  }

  @override
  String cueThenNext(String phase, String next) {
    return '[$phase. Ñéẋţ: $next ··]';
  }

  @override
  String get cueFinish => '[Šéššîöñ çöɱþļéţé ······]';

  @override
  String get summaryDoneTitle => '[Šéššîöñ çöɱþļéţé! ······]';

  @override
  String get summaryStoppedTitle => '[Šéššîöñ šţöþþéð ······]';

  @override
  String summarySubtitle(String name, String date) {
    return '[$name · $date]';
  }

  @override
  String get summaryTotal => '[ŢÖŢÅĻ ··]';

  @override
  String get summaryRounds => '[ŔÖÛÑÐŠ ···]';

  @override
  String get summaryWork => '[ŴÖŔĶ ··]';

  @override
  String summaryRoundsValue(int done, int total) {
    return '[$done/$total]';
  }

  @override
  String summarySkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count þĥášéš šķîþþéð',
      one: '1 þĥášé šķîþþéð',
      zero: '0 þĥášéš šķîþþéð',
    );
    return '[$_temp0 ················]';
  }

  @override
  String summaryPaused(String time) {
    return '[$time þáûšéð ···]';
  }

  @override
  String get summaryNoPauses => '[ñö þáûšéš ····]';

  @override
  String get summaryShort =>
      '[Îţ ļášţéð ûñðéŕ 30 šéçöñðš. Ðîšçáŕð îţ? ············]';

  @override
  String get summaryRpeQuestion => '[ĤÖŴ ĤÅŔÐ ŴÅŠ ÎŢ? (ÖÞŢÎÖÑÅĻ) ········]';

  @override
  String summaryRpeValue(int value) {
    return '[Éƒƒöŕţ $value öƒ 10 ····]';
  }

  @override
  String get summaryRpeEasy => '[Ṽéŕý éášý ····]';

  @override
  String get summaryRpeMax => '[Ṁáẋ ··]';

  @override
  String get summaryNote => '[ÑÖŢÉ ··]';

  @override
  String get summaryNoteHint =>
      '[É.ĝ. “Šöŕé ķñéé îñ ţĥé ļášţ ŕöûñð” ··········]';

  @override
  String get summaryDone => '[ÐÖÑÉ ··]';

  @override
  String get summaryDiscard => '[Ðîšçáŕð šéššîöñ ······]';

  @override
  String get summaryDiscardTitle => '[Ðîšçáŕð ţĥîš šéššîöñ? ········]';

  @override
  String get summaryDiscardBody =>
      '[Îţ ŵöñ’ţ ƀé šáṽéð ţö ýöûŕ ĥîšţöŕý öŕ çöûñţ ţöŵáŕð ýöûŕ ŵééķ. ···················]';

  @override
  String get summaryDiscardConfirm => '[Ðîšçáŕð ···]';

  @override
  String get notifyTitle =>
      '[ƑÖĻĻÖŴ ÝÖÛŔ ŴÖŔĶÖÛŢ ŴÎŢĤ ŢĤÉ ŠÇŔÉÉÑ ÖƑƑ ··············]';

  @override
  String get notifyBody =>
      '[Ţŕáîñļööþ šĥöŵš á ñöţîƒîçáţîöñ ŵĥîļé ýöû ţŕáîñ šö ýöû çáñ šéé ţĥé þĥášé áñð ţîɱé ŵîţĥöûţ ûñļöçķîñĝ ţĥé þĥöñé. ····································]';

  @override
  String get notifyContinue => '[ÇÖÑŢÎÑÛÉ ····]';

  @override
  String get notifyNotNow => '[Ñöţ ñöŵ · šţáŕţ áñýŵáý ·······]';

  @override
  String get recoveryTitle => '[ÝÖÛ ĤÅṼÉ ÅÑ ÛÑƑÎÑÎŠĤÉÐ ŴÖŔĶÖÛŢ ···········]';

  @override
  String recoveryRound(int round, int rounds) {
    return '[Ŕöûñð $round/$rounds ··]';
  }

  @override
  String recoveryAgo(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'îñţéŕŕûþţéð $minutes ɱîñ áĝö',
      one: 'îñţéŕŕûþţéð 1 ɱîñ áĝö',
      zero: 'îñţéŕŕûþţéð ɱöɱéñţš áĝö',
    );
    return '[$_temp0 ······················]';
  }

  @override
  String get recoveryBody =>
      '[Åñðŕöîð çļöšéð ţĥé áþþ. Ŵé šáṽéð ýöûŕ þŕöĝŕéšš ûþ ţö ţĥé ļášţ çĥéçķþöîñţ. ························]';

  @override
  String get recoveryResume => '[ŔÉŠÛṀÉ (ÞÅÛŠÉÐ) ·····]';

  @override
  String get recoverySaveIncomplete => '[ŠÅṼÉ ÅŠ ÎÑÇÖṀÞĻÉŢÉ ·······]';

  @override
  String get recoveryDiscard => '[ÐÎŠÇÅŔÐ ···]';

  @override
  String batteryTitle(String brand) {
    return '[ŠŢÖÞ $brand ƑŔÖṀ ÞÅÛŠÎÑĜ ŢĤÉ ŢÎṀÉŔ ··········]';
  }

  @override
  String get batteryBody =>
      '[Ɓáţţéŕý ûšé ƒöŕ Ţŕáîñļööþ îš ŕéšţŕîçţéð, šö ţĥé ţîɱéŕ ŵöûļð šţöþ ŵîţĥ ţĥé šçŕééñ öƒƒ. Ýöû öñļý šéţ ţĥîš öñçé: ···································]';

  @override
  String get batteryStep1 => '[Šéţţîñĝš › Åþþš › Ţŕáîñļööþ ·········]';

  @override
  String get batteryStep2 => '[Ɓáţţéŕý ···]';

  @override
  String get batteryStep3 => '[Çĥööšé “Ûñŕéšţŕîçţéð” ········]';

  @override
  String get batteryOpenSettings => '[ÖÞÉÑ ŠÉŢŢÎÑĜŠ ·····]';

  @override
  String get batteryDone => '[Î ÐÎÐ ÎŢ ···]';

  @override
  String get batteryLater => '[ĻÅŢÉŔ ··]';

  @override
  String get activeSessionTitle => '[Å šéššîöñ îš îñ þŕöĝŕéšš ········]';

  @override
  String get activeSessionBody =>
      '[Ƒîñîšĥ îţ ƀéƒöŕé šţáŕţîñĝ áñöţĥéŕ öñé. ·············]';

  @override
  String get activeSessionGo => '[ƁÅÇĶ ŢÖ ŠÉŠŠÎÖÑ ······]';

  @override
  String get volumeZero =>
      '[Ṁéðîá ṽöļûɱé îš áţ 0: ýöû ŵöñ’ţ ĥéáŕ ţĥé áļéŕţš. ··············]';

  @override
  String get settingsAlerts => '[ÅĻÉŔŢŠ ···]';

  @override
  String get settingsVoice => '[Ṽöîçé ··]';

  @override
  String get settingsVoiceHelp => '[Šáýš ţĥé ñáɱé öƒ éáçĥ þĥášé ·········]';

  @override
  String get settingsBeeps => '[3-2-1 ƀééþš ··]';

  @override
  String get settingsBeepsHelp =>
      '[Ţöñé áţ éáçĥ þĥášé áñð îñ ţĥé ļášţ 3 šéçöñðš ··············]';

  @override
  String get settingsVibration => '[Ṽîƀŕáţîöñ ····]';

  @override
  String get settingsVibrationHelp =>
      '[Ļöñĝ öñ ŵöŕķ, ðöûƀļé öñ ŕéšţ ·········]';

  @override
  String get homeActiveSession => '[ŠÉŠŠÎÖÑ ÎÑ ÞŔÖĜŔÉŠŠ ·······]';

  @override
  String get homeActiveStrength => '[Ɓáçķ ţö ýöûŕ šţŕéñĝţĥ šéššîöñ ··········]';

  @override
  String get homeRepeatLast => '[ŔÉÞÉÅŢ ĻÅŠŢ ····]';

  @override
  String homeRepeatMeta(String date) {
    return '[Šţŕéñĝţĥ · $date ····]';
  }

  @override
  String routineStart(String name) {
    return '[Šţáŕţ $name ··]';
  }

  @override
  String get settingsTraining => '[ŢŔÅÎÑÎÑĜ ····]';

  @override
  String get settingsUnits => '[Ûñîţš ··]';

  @override
  String get settingsUnitsHelp =>
      '[Çĥáñĝéš ĥöŵ ŵéîĝĥţš áŕé šĥöŵñ áñð éñţéŕéð. Ļöĝĝéð šéţš ķééþ ţĥéîŕ öŕîĝîñáļ ûñîţ. ···························]';

  @override
  String get cueRestOver => '[Ñéẋţ šéţ ···]';

  @override
  String get strengthFreeWorkout => '[ƑŔÉÉ ŴÖŔĶÖÛŢ ·····]';

  @override
  String get strengthFreeTitle => '[Ƒŕéé ŵöŕķöûţ ·····]';

  @override
  String get strengthEmptyRoutine =>
      '[Ţĥîš ŕöûţîñé ĥáš ñö éẋéŕçîšéš. Åðð šöɱé ţö šţáŕţ îţ. ·················]';

  @override
  String get strengthEmptyHint =>
      '[Åðð ţĥé éẋéŕçîšéš ýöû áŕé ĝöîñĝ ţö ðö. Éáçĥ šéţ îš šáṽéð áš šööñ áš ýöû çĥéçķ îţ. ·························]';

  @override
  String get strengthInProgress => '[Šéššîöñ îñ þŕöĝŕéšš ·······]';

  @override
  String get strengthFinish => '[ƑÎÑÎŠĤ ···]';

  @override
  String strengthProgress(int done, int total) {
    return '[$done/$total šéţš ··]';
  }

  @override
  String get strengthRestLabel => '[● ŔÉŠŢ ··]';

  @override
  String get strengthRestNotification => '[Ŕéšţ ··]';

  @override
  String strengthRestRemaining(String time) {
    return '[Ŕéšţ, $time ļéƒţ ····]';
  }

  @override
  String get strengthRestOver => '[Öñ ţö ţĥé ñéẋţ šéţ! ······]';

  @override
  String get strengthMinus15 => '[−15]';

  @override
  String get strengthPlus15 => '[+15]';

  @override
  String get strengthPlus15Short => '[+15 š ·]';

  @override
  String get strengthMinus15Tooltip => '[Šûƀţŕáçţ 15 šéçöñðš ······]';

  @override
  String get strengthPlus15Tooltip => '[Åðð 15 šéçöñðš ····]';

  @override
  String get strengthSkipRest => '[ŠĶÎÞ ··]';

  @override
  String get strengthSkipRestTooltip => '[Šķîþ ŕéšţ ····]';

  @override
  String strengthRestFor(String time) {
    return '[Ŕéšţ $time ··]';
  }

  @override
  String strengthExerciseActions(String name) {
    return '[Öþţîöñš ƒöŕ $name ····]';
  }

  @override
  String get strengthMoveUp => '[Ṁöṽé ûþ ···]';

  @override
  String get strengthMoveDown => '[Ṁöṽé ðöŵñ ····]';

  @override
  String get strengthRemoveExercise => '[Ŕéɱöṽé éẋéŕçîšé ······]';

  @override
  String strengthRemoveExerciseTitle(String name) {
    return '[Ŕéɱöṽé $name? ···]';
  }

  @override
  String get strengthRemoveExerciseBody =>
      '[Îţš ļöĝĝéð šéţš ŵîļļ ƀé ŕéɱöṽéð ƒŕöɱ ţĥîš šéššîöñ. Ţĥé ŕöûţîñé ðöéšñ\'ţ çĥáñĝé. ··························]';

  @override
  String get strengthNotesTitle => '[Ñöţéš ··]';

  @override
  String get strengthNotesHint => '[É.ĝ. \"Šéáţ áţ 4\" ····]';

  @override
  String get strengthNotesSave => '[ŠÅṼÉ ··]';

  @override
  String get strengthColSet => '[ŠÉŢ ··]';

  @override
  String get strengthColPrevious => '[ÞŔÉṼÎÖÛŠ ····]';

  @override
  String get strengthColReps => '[ŔÉÞŠ ··]';

  @override
  String get strengthColTime => '[ŢÎṀÉ ··]';

  @override
  String get strengthNoValue => '[—]';

  @override
  String strengthPrevious(String weight, int reps) {
    return '[$weight × $reps]';
  }

  @override
  String strengthWeightTimesReps(String weight, int reps) {
    return '[$weight × $reps]';
  }

  @override
  String strengthTimesReps(int reps) {
    return '[× $reps]';
  }

  @override
  String get setTagWarmup => '[Ŵ ·]';

  @override
  String get setTagFailure => '[Ƒ ·]';

  @override
  String get setTagDrop => '[Ð ·]';

  @override
  String setTagWithType(int number, String type) {
    return '[$number$type]';
  }

  @override
  String get strengthAddSet => '[+ ÅÐÐ ŠÉŢ ···]';

  @override
  String get strengthAddExercise => '[+ ÅÐÐ ÉẊÉŔÇÎŠÉ ·····]';

  @override
  String strengthEditWeight(String set) {
    return '[Éðîţ ŵéîĝĥţ, $set ····]';
  }

  @override
  String strengthEditReps(String set) {
    return '[Éðîţ ŕéþš, $set ····]';
  }

  @override
  String strengthCompleteSet(String set) {
    return '[Çöɱþļéţé $set ····]';
  }

  @override
  String strengthUncompleteSet(String set) {
    return '[Ûñçĥéçķ $set ···]';
  }

  @override
  String strengthSetHeading(String exercise, int number) {
    return '[$exercise · šéţ $number ··]';
  }

  @override
  String strengthSetHeadingWarmup(String exercise) {
    return '[$exercise · ŵáŕɱ-ûþ ···]';
  }

  @override
  String strengthNextSet(String exercise, int number) {
    return '[Ñéẋţ: $exercise, šéţ $number ···]';
  }

  @override
  String strengthNextWarmup(String exercise) {
    return '[Ñéẋţ: $exercise, ŵáŕɱ-ûþ ····]';
  }

  @override
  String strengthLastTime(String values) {
    return '[Ļášţ ţîɱé: $values ····]';
  }

  @override
  String strengthWeightLabel(String unit) {
    return '[ŴÉÎĜĤŢ ($unit) ···]';
  }

  @override
  String get strengthRepsLabel => '[ŔÉÞŠ ··]';

  @override
  String get strengthTimeLabel => '[ŢÎṀÉ ··]';

  @override
  String get strengthRpeLabel => '[ÉƑƑÖŔŢ (ŔÞÉ) · ÖÞŢÎÖÑÅĻ ·······]';

  @override
  String get strengthSetTypeLabel => '[ŠÉŢ ŢÝÞÉ ···]';

  @override
  String get setTypeWarmup => '[Ŵáŕɱ-ûþ ···]';

  @override
  String get setTypeNormal => '[Ñöŕɱáļ ···]';

  @override
  String get setTypeFailure => '[Ţö ƒáîļûŕé ····]';

  @override
  String get setTypeDrop => '[Ðŕöþ šéţ ···]';

  @override
  String setStepMinus(String value) {
    return '[−$value]';
  }

  @override
  String setStepPlus(String value) {
    return '[+$value]';
  }

  @override
  String get setStepMinusOne => '[−]';

  @override
  String get setStepPlusOne => '[+]';

  @override
  String setStepMinusSeconds(int seconds) {
    return '[−$seconds]';
  }

  @override
  String setStepPlusSeconds(int seconds) {
    return '[+$seconds]';
  }

  @override
  String strengthWeightMinus(String weight) {
    return '[Šûƀţŕáçţ $weight ····]';
  }

  @override
  String strengthWeightPlus(String weight) {
    return '[Åðð $weight ··]';
  }

  @override
  String get strengthRepsMinus => '[Šûƀţŕáçţ öñé ŕéþ ······]';

  @override
  String get strengthRepsPlus => '[Åðð öñé ŕéþ ····]';

  @override
  String strengthTimeMinus(int seconds) {
    return '[Šûƀţŕáçţ $seconds šéçöñðš ······]';
  }

  @override
  String strengthTimePlus(int seconds) {
    return '[Åðð $seconds šéçöñðš ····]';
  }

  @override
  String get strengthSaveSet => '[ŠÅṼÉ ŠÉŢ ···]';

  @override
  String get strengthCloseNoSave => '[Çļöšé ŵîţĥöûţ šáṽîñĝ ········]';

  @override
  String get strengthRemoveSet => '[Ŕéɱöṽé šéţ ····]';

  @override
  String setErrorWeightRange(String max) {
    return '[Éñţéŕ á ŵéîĝĥţ ƀéţŵééñ 0 áñð $max. ·········]';
  }

  @override
  String setErrorWeightStep(String step) {
    return '[Ŵéîĝĥţ ĝöéš îñ šţéþš öƒ $step. ········]';
  }

  @override
  String setErrorReps(int max) {
    return '[Ŕéþš ĝö ƒŕöɱ 0 ţö $max. ·····]';
  }

  @override
  String get setErrorRpe =>
      '[ŔÞÉ ĝöéš ƒŕöɱ 6 ţö 10 îñ šţéþš öƒ 0.5. ·········]';

  @override
  String get setErrorDuration => '[Éñţéŕ á ţîɱé ûþ ţö 99:59. ······]';

  @override
  String strengthPendingTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ţĥéŕé áŕé $count ûñƒîñîšĥéð šéţš',
      one: 'Ţĥéŕé îš 1 ûñƒîñîšĥéð šéţ',
    );
    return '[$_temp0 ·················]';
  }

  @override
  String get strengthPendingBody =>
      '[Ýöû çáñ ðîšçáŕð ţĥéɱ, ɱáŕķ ţĥéɱ ðöñé ŵîţĥ ţĥé šûĝĝéšţéð ṽáļûéš, öŕ ķééþ ţŕáîñîñĝ. ··························]';

  @override
  String get strengthPendingDiscard => '[ÐÎŠÇÅŔÐ ÅÑÐ ƑÎÑÎŠĤ ·······]';

  @override
  String get strengthPendingComplete => '[ṀÅŔĶ ŢĤÉṀ ÅŠ ÐÖÑÉ ······]';

  @override
  String get strengthBackToSession => '[Ɓáçķ ţö šéššîöñ ······]';

  @override
  String get strengthNoSetsTitle => '[ÑÖ ŠÉŢŠ ÐÖÑÉ ····]';

  @override
  String get strengthNoSetsBody =>
      '[Å šéššîöñ ŵîţĥöûţ çöɱþļéţéð šéţš îšñ\'ţ šáṽéð. Ðîšçáŕð îţ? ···················]';

  @override
  String get strengthRecoveryBody =>
      '[Åñðŕöîð çļöšéð ţĥé áþþ. Éṽéŕý šéţ ýöû çĥéçķéð îš šáṽéð. ··················]';

  @override
  String get strengthRecoveryResume => '[ŔÉŠÛṀÉ ···]';

  @override
  String strengthSetsDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count šéţš ðöñé',
      one: '1 šéţ ðöñé',
      zero: 'ñö šéţš ðöñé',
    );
    return '[$_temp0 ··········]';
  }

  @override
  String get strengthSavedTitle => '[Šéššîöñ šáṽéð ·····]';

  @override
  String get strengthSummaryDuration => '[ÐÛŔÅŢÎÖÑ ····]';

  @override
  String get strengthSummaryVolume => '[ṼÖĻÛṀÉ ···]';

  @override
  String get strengthSummarySets => '[ŠÉŢŠ ··]';

  @override
  String strengthMinutes(int minutes) {
    return '[$minutes ṀÎÑ ··]';
  }

  @override
  String get strengthNewRecord => '[ÑÉŴ ŔÉÇÖŔÐ ····]';

  @override
  String strengthRecordSet(String exercise, String values) {
    return '[$exercise: $values]';
  }

  @override
  String strengthRecordWithRm(String exercise, String values, String rm) {
    return '[$exercise: $values · éšţîɱáţéð 1ŔṀ $rm ·····]';
  }

  @override
  String strengthUpdateRoutineQuestion(String routine) {
    return '[Ţĥé šţŕûçţûŕé çĥáñĝéð. Ûþðáţé ţĥé \"$routine\" ŕöûţîñé? ··············]';
  }

  @override
  String get strengthUpdateRoutineYes => '[ÝÉŠ, ÛÞÐÅŢÉ ····]';

  @override
  String get strengthUpdateRoutineNo => '[Ñö ·]';

  @override
  String strengthRoutineUpdated(String routine) {
    return '[\"$routine\" ûþðáţéð: éẋéŕçîšéš áñð ñûɱƀéŕ öƒ šéţš. ·············]';
  }

  @override
  String get strengthRoutineKept => '[Ţĥé ŕöûţîñé šţáýš áš îţ ŵáš. ·········]';

  @override
  String get strengthNoteHint => '[É.ĝ. \"Ķñéé ƒéļţ ƀéţţéŕ\" ·······]';

  @override
  String decimalText(String value) {
    return '[$value]';
  }

  @override
  String get debugWeekVariant => '[Ŵééķļý ṽîéŵ (Ĥ5 ţéšţ) ······]';

  @override
  String get debugWeekVariantHelp =>
      '[Îñţéŕñáļ šéţţîñĝ ƒöŕ ţĥé ûšáƀîļîţý ţéšţ: šţŕéñĝţĥ áñð îñţéŕṽáļš ţöĝéţĥéŕ öŕ šéþáŕáţé. ·····························]';

  @override
  String get weekVariantUnified => '[ÛÑÎƑÎÉÐ ···]';

  @override
  String get weekVariantSeparate => '[ŠÉÞÅŔÅŢÉ ····]';

  @override
  String get detailColSet => '[ŠÉŢ ··]';

  @override
  String get detailColReps => '[ŔÉÞŠ ··]';

  @override
  String get detailColRpe => '[ŔÞÉ ··]';

  @override
  String get detailColTime => '[ŢÎṀÉ ··]';

  @override
  String get detailDelete => '[ÐÉĻÉŢÉ ···]';

  @override
  String get detailDeleteTitle => '[Ðéļéţé ţĥîš šéššîöñ? ·······]';

  @override
  String get detailDeleteBody =>
      '[Ýöûŕ ŕéçöŕðš ŵîļļ ƀé ŕéçáļçûļáţéð. Ýöû\'ļļ ĥáṽé 5 šéçöñðš ţö ûñðö. ·····················]';

  @override
  String get detailDeleted => '[Šéššîöñ ðéļéţéð ······]';

  @override
  String get detailDone => '[ÐÖÑÉ ··]';

  @override
  String get detailEditHelp =>
      '[Ţáþ á šéţ ţö çĥáñĝé îţš ŵéîĝĥţ, ŕéþš, ŔÞÉ öŕ ţýþé. Ŕéçöŕðš áŕé ŕéçáļçûļáţéð. ························]';

  @override
  String detailEffort(int value) {
    return '[Éƒƒöŕţ $value/10 ···]';
  }

  @override
  String get detailMissing =>
      '[Ţĥîš šéššîöñ îš ñö ļöñĝéŕ îñ ýöûŕ ĥîšţöŕý. ··············]';

  @override
  String get detailNameLabel => '[ÑÅṀÉ ··]';

  @override
  String detailNote(String note) {
    return '[Ñöţé: $note ··]';
  }

  @override
  String get detailRecordTag => '[ŔÉÇÖŔÐ ···]';

  @override
  String get detailRecords => '[ŔÉÇÖŔÐŠ ···]';

  @override
  String get detailRounds => '[ŔÖÛÑÐŠ ···]';

  @override
  String detailRoutineSaved(String name) {
    return '[Ŕöûţîñé \"$name\" šáṽéð ·····]';
  }

  @override
  String get detailSaveRoutine => '[ŠÅṼÉ ÅŠ ŔÖÛŢÎÑÉ ······]';

  @override
  String get detailSets => '[ŠÉŢŠ ··]';

  @override
  String get detailTotal => '[ŢÖŢÅĻ ··]';

  @override
  String get detailVolume => '[ṼÖĻÛṀÉ ···]';

  @override
  String get detailWork => '[ŴÖŔĶ ··]';

  @override
  String distanceMeters(int meters) {
    return '[$meters ɱ ·]';
  }

  @override
  String get exerciseHistory => '[ĤÎŠŢÖŔÝ ···]';

  @override
  String get exerciseLastMark => '[ĻÅŠŢ ṀÅŔĶ ····]';

  @override
  String get exerciseNoHistory =>
      '[Ñö šéššîöñš ŵîţĥ ţĥîš éẋéŕçîšé ýéţ. ············]';

  @override
  String get exerciseNoRecords => '[Ñö ŕéçöŕðš ýéţ. ·····]';

  @override
  String exerciseOneRm(String value) {
    return '[éšţîɱáţéð 1ŔṀ $value ·····]';
  }

  @override
  String get exerciseRecords => '[ŔÉÇÖŔÐŠ ···]';

  @override
  String exerciseTrendMissing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ɱöŕé šéššîöñš ţö šéé ţĥé ţŕéñð.',
      one: '1 ɱöŕé šéššîöñ ţö šéé ţĥé ţŕéñð.',
    );
    return '[$_temp0 ····················]';
  }

  @override
  String exerciseTrendNote(String from, String to, String change) {
    return '[Ƒŕöɱ $from ţö $to ($change%) ···]';
  }

  @override
  String get exerciseTrendTitle => '[ÉŠŢÎṀÅŢÉÐ 1ŔṀ ·····]';

  @override
  String historyBlockDone(String day, String name, String minutes) {
    return '[✓ $day · $name · $minutes]';
  }

  @override
  String get historyBlockEmpty =>
      '[Ñöţĥîñĝ ðöñé öŕ þļáññéð ţĥîš ŵééķ. ············]';

  @override
  String historyBlockStrength(int done, int total) {
    return '[ŠŢŔÉÑĜŢĤ · $done ÖƑ $total ····]';
  }

  @override
  String historyBlockIntervals(int done, int total) {
    return '[ÎÑŢÉŔṼÅĻŠ · $done ÖƑ $total ·····]';
  }

  @override
  String historyBlockPlanned(String day, String name) {
    return '[○ $day · $name (þļáññéð) ···]';
  }

  @override
  String historyCalendarDay(String date, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$date: $count šéššîöñš',
      one: '$date: 1 šéššîöñ',
      zero: '$date: ñö šéššîöñš',
    );
    return '[$_temp0 ··········]';
  }

  @override
  String historyDate(String date) {
    return '[$date]';
  }

  @override
  String get historyDayEmpty => '[Ñö šéššîöñš ţĥîš ðáý. ·······]';

  @override
  String get historyDayFree => '[Ƒŕéé ··]';

  @override
  String historyDayName(String day) {
    return '[$day]';
  }

  @override
  String get historyDayRest => '[Ŕéšţ ··]';

  @override
  String historyDayTitle(String date) {
    return '[$date]';
  }

  @override
  String get historyIncomplete => '[îñçöɱþļéţé ····]';

  @override
  String get historyIntervalsFallback => '[Îñţéŕṽáļš ····]';

  @override
  String get historyLastWeek => '[ĻÅŠŢ ŴÉÉĶ ····]';

  @override
  String get historyLetterStrength => '[Š ·]';

  @override
  String get historyLetterIntervals => '[Î ·]';

  @override
  String historyMinutes(int minutes) {
    return '[$minutes ɱîñ ··]';
  }

  @override
  String historyMonth(String month) {
    return '[$month]';
  }

  @override
  String get historyNextMonth => '[Ñéẋţ ɱöñţĥ ····]';

  @override
  String get historyPrevMonth => '[Þŕéṽîöûš ɱöñţĥ ······]';

  @override
  String historyRounds(int done, int total) {
    return '[$done/$total ŕöûñðš ···]';
  }

  @override
  String historySets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count šéţš',
      one: '1 šéţ',
    );
    return '[$_temp0 ···]';
  }

  @override
  String get historyStateDone => '[Ðöñé ··]';

  @override
  String get historyStateIncomplete => '[Îñçöɱþļéţé ····]';

  @override
  String get historyStatePlanned => '[Þļáññéð ···]';

  @override
  String get historyTabWeek => '[ŴÉÉĶ ··]';

  @override
  String get historyTabList => '[ĻÎŠŢ ··]';

  @override
  String get historyTabCalendar => '[ÇÅĻÉÑÐÅŔ ····]';

  @override
  String get historyTabsLabel => '[Ĥîšţöŕý ṽîéŵ ·····]';

  @override
  String get historyThisWeek => '[ŢĤÎŠ ŴÉÉĶ ····]';

  @override
  String historyWeekGroup(String week, int sessions, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      sessions,
      locale: localeName,
      other: '$week · $sessions ŠÉŠŠÎÖÑŠ · $minutes ṀÎÑ',
      one: '$week · 1 ŠÉŠŠÎÖÑ · $minutes ṀÎÑ',
    );
    return '[$_temp0 ·········]';
  }

  @override
  String historyWeekHead(int done, int goal) {
    return '[ŢĤÎŠ ŴÉÉĶ · $done ÖƑ $goal ····]';
  }

  @override
  String get historyWeekLegend =>
      '[Š = šţŕéñĝţĥ · Î = îñţéŕṽáļš · ƒîļļéð = ðöñé · öûţļîñé = þļáññéð · ðöţţéð = ŕéšţ öŕ ƒŕéé. Ţáþ á ƒŕéé ðáý ţö þļáñ îţ. ································]';

  @override
  String historyWeekOf(String date) {
    return '[ŴÉÉĶ ÖƑ $date ···]';
  }

  @override
  String get homeSeeProgress => '[ŠÉÉ ÞŔÖĜŔÉŠŠ ·····]';

  @override
  String homeWeekMinutes(int minutes) {
    return '[$minutes áçţîṽé ɱîñ ····]';
  }

  @override
  String homeWeekProgressLabel(int done, int goal) {
    return '[$done öƒ $goal šéššîöñš ţĥîš ŵééķ ········]';
  }

  @override
  String get homeWeekSessions => '[šéššîöñš öƒ ýöûŕ ĝöáļ ········]';

  @override
  String homeWeekStreak(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: '$weeks-ŵééķ šţŕéáķ',
      one: '1-ŵééķ šţŕéáķ',
    );
    return '[$_temp0 ········]';
  }

  @override
  String get planHelp =>
      '[Ŕéþéáţš éṽéŕý ŵééķ. Îţ öñļý šĥöŵš îñ ýöûŕ ŵééķ: îţ ñéṽéŕ šţáŕţš á šéššîöñ. ························]';

  @override
  String get planNone => '[Ñö þļáñ ···]';

  @override
  String planTitle(String day) {
    return '[Þļáñ ƒöŕ $day ···]';
  }

  @override
  String progressBarLabel(String date, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ŵééķ öƒ $date: $count šéššîöñš',
      one: 'Ŵééķ öƒ $date: 1 šéššîöñ',
    );
    return '[$_temp0 ···········]';
  }

  @override
  String get progressChartNote =>
      '[Šţŕéñĝţĥ áñð îñţéŕṽáļš çöûñţ ţĥé šáɱé. Ţáþ á ƀáŕ ţö šéé îţš šéššîöñš. ······················]';

  @override
  String progressChartSub(String average, int goal) {
    return '[áṽéŕáĝé $average · ĝöáļ $goal ·····]';
  }

  @override
  String get progressChartTitle => '[ŠÉŠŠÎÖÑŠ ÞÉŔ ŴÉÉĶ ······]';

  @override
  String get progressComplete => '[ÇÖṀÞĻÉŢÉ ····]';

  @override
  String get progressGoalLine => '[ĝöáļ ··]';

  @override
  String progressGoalSuffix(int goal) {
    return '[/$goal]';
  }

  @override
  String progressIntervalMark(String rounds, String work) {
    return '[$rounds · $work öƒ ŵöŕķ ···]';
  }

  @override
  String get progressLastMarks => '[ĻÅŠŢ ṀÅŔĶ ÞÉŔ ÉẊÉŔÇÎŠÉ ········]';

  @override
  String get progressMinutes => '[áçţîṽé ɱîñ ····]';

  @override
  String get progressRecordBadge => '[↑ ŔÉÇÖŔÐ ···]';

  @override
  String get progressSameBadge => '[= ŠÅṀÉ ··]';

  @override
  String get progressSessions => '[šéššîöñš ····]';

  @override
  String get progressStreak => '[ŵééķš šţŕéáķ ·····]';

  @override
  String get progressThisWeekShort => '[Ñöŵ ··]';

  @override
  String progressWeekVolume(String volume) {
    return '[Šţŕéñĝţĥ ṽöļûɱé ţĥîš ŵééķ: $volume ·········]';
  }

  @override
  String rangeWeeks(int count) {
    return '[$count ŴĶ ·]';
  }

  @override
  String rangeMonths(int count) {
    return '[$count ṀÖ ·]';
  }

  @override
  String get rangeYear => '[1 ÝÉÅŔ ··]';

  @override
  String get rangeAll => '[ÅĻĻ ··]';

  @override
  String recordLine(String name, String value) {
    return '[$name: $value]';
  }

  @override
  String get recordMaxWeight => '[Ṁáẋ ŵéîĝĥţ ····]';

  @override
  String get recordOneRm => '[Éšţîɱáţéð 1ŔṀ ·····]';

  @override
  String recordMaxRepsAt(String weight) {
    return '[Ṁöšţ ŕéþš ŵîţĥ $weight ·····]';
  }

  @override
  String get recordMaxRepsBodyweight => '[Ṁöšţ ŕéþš ····]';

  @override
  String get recordMaxVolume => '[Ɓéšţ šéššîöñ ṽöļûɱé ·······]';

  @override
  String get recordMaxDuration => '[Ļöñĝéšţ šéţ ····]';

  @override
  String get recordMaxDistance => '[Ļöñĝéšţ ðîšţáñçé ······]';

  @override
  String get settingsWeekStart => '[Ŵééķ šţáŕţš öñ ·····]';

  @override
  String get settingsMonday => '[ṀÖÑÐÅÝ ···]';

  @override
  String get settingsSunday => '[ŠÛÑÐÅÝ ···]';

  @override
  String get settingsWeeklyGoal => '[Ŵééķļý ĝöáļ (šéššîöñš) ········]';

  @override
  String get settingsGoalLess => '[Ƒéŵéŕ šéššîöñš ······]';

  @override
  String get settingsGoalMore => '[Ṁöŕé šéššîöñš ·····]';

  @override
  String get backupTitle => '[ƁÅÇĶÛÞ ···]';

  @override
  String get backupHeadline =>
      '[ÝÖÛŔ ÐÅŢÅ ĻÎṼÉŠ ÖÑĻÝ ÖÑ ŢĤÎŠ ÞĤÖÑÉ ············]';

  @override
  String get backupBody =>
      '[Ţŕáîñļööþ ĥáš ñö áççöûñţ öŕ šéŕṽéŕ. Çŕéáţé á ƀáçķûþ áñð ķééþ îţ ŵĥéŕéṽéŕ ýöû ļîķé (Ðŕîṽé, Ðöŵñļöáðš öŕ šéñð îţ ţö ýöûŕšéļƒ) šö ýöû ñéṽéŕ ļöšé ýöûŕ ĥîšţöŕý. ··················································]';

  @override
  String get backupNever => '[Ýöû ĥáṽéñ\'ţ çŕéáţéð á ƀáçķûþ ýéţ. ···········]';

  @override
  String backupLast(String date, String sessions, String size) {
    return '[Ļášţ ƀáçķûþ: $date · $sessions · $size ····]';
  }

  @override
  String backupSessions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count šéššîöñš',
      one: '1 šéššîöñ',
    );
    return '[$_temp0 ······]';
  }

  @override
  String backupRoutines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ŕöûţîñéš',
      one: '1 ŕöûţîñé',
    );
    return '[$_temp0 ······]';
  }

  @override
  String backupWorkouts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ţîɱéŕš',
      one: '1 ţîɱéŕ',
    );
    return '[$_temp0 ·····]';
  }

  @override
  String backupSizeKb(String size) {
    return '[$size ĶƁ ·]';
  }

  @override
  String get backupCreate => '[ÇŔÉÅŢÉ ƁÅÇĶÛÞ ·····]';

  @override
  String get backupRestore => '[ŔÉŠŢÖŔÉ ƁÅÇĶÛÞ ······]';

  @override
  String get backupCsv => '[ÉẊÞÖŔŢ ÇŠṼ ····]';

  @override
  String get backupCsvHelp =>
      '[Ţŵö šþŕéáðšĥééţ ƒîļéš: šéššîöñš áñð šéţš. Ýöû šáṽé öñé áƒţéŕ ţĥé öţĥéŕ. ·······················]';

  @override
  String get backupHowTitle => '[ĤÖŴ ŢÖ ŠÅṼÉ ÎŢ ŢÖ ĜÖÖĜĻÉ ÐŔÎṼÉ ··········]';

  @override
  String get backupStep1 => '[Ţáþ “Çŕéáţé ƀáçķûþ”. ······]';

  @override
  String get backupStep2 =>
      '[Îñ ţĥé Åñðŕöîð ɱéñû, çĥööšé Ðŕîṽé (öŕ áñöţĥéŕ ƒöļðéŕ) áñð ţáþ Šáṽé. ·····················]';

  @override
  String get backupStep3 =>
      '[Öñ ţĥé ñéŵ þĥöñé, ţáþ “Ŕéšţöŕé ƀáçķûþ” áñð þîçķ ţĥé ƒîļé. ··················]';

  @override
  String get backupAutoTitle => '[ÅÑÐŔÖÎÐ ÅÛŢÖṀÅŢÎÇ ƁÅÇĶÛÞ ·········]';

  @override
  String get backupAutoBody =>
      '[Îƒ Ĝööĝļé ƀáçķûþ îš öñ îñ ýöûŕ þĥöñé, Åñðŕöîð áļšö çöþîéš Ţŕáîñļööþ\'š ðáţá áñð šéţţîñĝš ţö ýöûŕ Ĝööĝļé Ðŕîṽé áñð ƀŕîñĝš ţĥéɱ ƀáçķ ŵĥéñ ýöû ŕéîñšţáļļ ŵîţĥ ţĥé šáɱé áççöûñţ. Îţ ðöéšñ\'ţ ĝö ţĥŕöûĝĥ öûŕ šéŕṽéŕš, ƀûţ ţĥé áþþ ðöéšñ\'ţ çöñţŕöļ ŵĥéñ îţ ŕûñš: á ƀáçķûþ ƒîļé îš ţĥé šáƒé ŵáý ţö šŵîţçĥ þĥöñéš. ······························································································]';

  @override
  String get backupWorking => '[Ŵöŕķîñĝ… ···]';

  @override
  String backupSaved(String name) {
    return '[Ɓáçķûþ çŕéáţéð: $name ······]';
  }

  @override
  String get backupCsvSaved => '[ÇŠṼ éẋþöŕţéð: šéššîöñš áñð šéţš ···········]';

  @override
  String get backupRestoreTitle => '[ŔÉŠŢÖŔÉ ŢĤÎŠ ƁÅÇĶÛÞ? ·······]';

  @override
  String backupRestoreSummary(
    String date,
    String sessions,
    String routines,
    String workouts,
  ) {
    return '[Ɓáçķûþ ƒŕöɱ $date: $sessions, $routines, $workouts. ····]';
  }

  @override
  String get backupRestoreOlder =>
      '[Îţ çöɱéš ƒŕöɱ áñ öļðéŕ ṽéŕšîöñ öƒ ţĥé áþþ: îţ ŵîļļ ƀé ûþðáţéð ŵĥîļé ŕéšţöŕîñĝ. ·························]';

  @override
  String get backupRestoreWarn =>
      '[Îţ ŵîļļ ŕéþļáçé ýöûŕ çûŕŕéñţ ðáţá. Ŵé ŵîļļ šáṽé áñ áûţöɱáţîç çöþý öƒ ŵĥáţ ýöû ĥáṽé ñöŵ ƒîŕšţ. ······························]';

  @override
  String get backupRestoreConfirm => '[ŔÉŠŢÖŔÉ ···]';

  @override
  String get backupRestored => '[Ɓáçķûþ ŕéšţöŕéð ······]';

  @override
  String get backupErrorInvalid =>
      '[Ţĥáţ ƒîļé îšñ\'ţ á Ţŕáîñļööþ ƀáçķûþ öŕ îţ\'š ðáɱáĝéð. Ñöţĥîñĝ çĥáñĝéð. ······················]';

  @override
  String get backupErrorNewer =>
      '[Ţĥáţ ƀáçķûþ çöɱéš ƒŕöɱ á ñéŵéŕ Ţŕáîñļööþ. Ûþðáţé ţĥé áþþ áñð ţŕý áĝáîñ. ·······················]';

  @override
  String get backupErrorIntegrity =>
      '[Ţĥé ƀáçķûþ ĥáš îñçöñšîšţéñţ ðáţá. Ñöţĥîñĝ çĥáñĝéð. ·················]';

  @override
  String get backupErrorActive =>
      '[Ƒîñîšĥ ţĥé çûŕŕéñţ šéššîöñ ƀéƒöŕé ŕéšţöŕîñĝ. ················]';

  @override
  String get backupErrorIo =>
      '[Ţĥé ƒîļé çöûļðñ\'ţ ƀé ŕéáð öŕ šáṽéð. ···········]';

  @override
  String get settingsDefaultRest => '[Ðéƒáûļţ ŕéšţ ·····]';

  @override
  String get settingsDefaultRestHelp =>
      '[Ƒöŕ ñéŵ éẋéŕçîšéš. Ɓûîļţ-îñ éẋéŕçîšéš ķééþ ţĥéîŕ öŵñ ŕéšţ. ···················]';

  @override
  String get settingsRestLess => '[15 šéçöñðš ļéšš ·····]';

  @override
  String get settingsRestMore => '[15 šéçöñðš ɱöŕé ·····]';

  @override
  String get settingsTestSound => '[ŢÉŠŢ ŠÖÛÑÐ ····]';

  @override
  String get settingsTestSpeech => '[Ţĥîš îš ĥöŵ ţĥé çûéš šöûñð ·········]';

  @override
  String get settingsData => '[ÐÅŢÅ & ÞŔÎṼÅÇÝ ·····]';

  @override
  String get settingsDataWarnTitle =>
      '[Ýöûŕ ðáţá ļîṽéš öñļý öñ ţĥîš þĥöñé. ············]';

  @override
  String get settingsDataWarnBody =>
      '[Îƒ ýöû ûñîñšţáļļ ţĥé áþþ öŕ šŵîţçĥ þĥöñéš ŵîţĥöûţ á ƀáçķûþ, îţ îš ļöšţ. ·······················]';

  @override
  String get settingsBackupLink => '[Ɓáçķûþ & éẋþöŕţ ·····]';

  @override
  String get settingsBackupNever => '[ñö ƀáçķûþš ····]';

  @override
  String settingsBackupAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'ļášţ: $days ðáýš áĝö',
      one: 'ļášţ: ýéšţéŕðáý',
      zero: 'ļášţ: ţöðáý',
    );
    return '[$_temp0 ··············]';
  }

  @override
  String get remindersTitle => '[ŔÉṀÎÑÐÉŔŠ ····]';

  @override
  String get remindersEnable => '[Ŕéɱîñð ɱé ţö ţŕáîñ ······]';

  @override
  String get remindersHelp =>
      '[Öñé ñöţîƒîçáţîöñ öñ ţĥé çĥöšéñ ðáýš, öñļý îƒ ýöû ĥáṽéñ\'ţ ţŕáîñéð ýéţ ······················]';

  @override
  String get remindersTime => '[Ţîɱé ··]';

  @override
  String remindersNext(String day, String time) {
    return '[Ñéẋţ: $day áţ $time ···]';
  }

  @override
  String get remindersDenied =>
      '[Ŵîţĥöûţ ñöţîƒîçáţîöñ þéŕɱîššîöñ, ŕéɱîñðéŕš çáñ\'ţ áþþéáŕ. ····················]';

  @override
  String get remindersOpenSettings => '[ŠÉŢŢÎÑĜŠ ····]';

  @override
  String get reminderNotificationTitle => '[Ţîɱé ţö ţŕáîñ ·····]';

  @override
  String get reminderNotificationBody =>
      '[Ýöûŕ ŵöŕķöûţ îš ŕéáðý ŵĥéñ ýöû áŕé. ············]';

  @override
  String get reminderChannelName => '[Ŕéɱîñðéŕš ····]';

  @override
  String get homeLocalDataNotice =>
      '[Ýöûŕ ðáţá ļîṽéš öñļý öñ ţĥîš þĥöñé. ············]';

  @override
  String get homeLocalDataAction => '[Ɓáçķ ûþ › ···]';

  @override
  String get homeLocalDataDismiss => '[Çļöšé ñöţîçé ·····]';

  @override
  String formattedValue(String value) {
    return '[$value]';
  }

  @override
  String get routineDiscardTitle => '[ÐÎŠÇÅŔÐ ÇĤÅÑĜÉŠ? ······]';

  @override
  String get routineDiscardBody => '[Ţĥé ŕöûţîñé šţáýš áš îţ ŵáš. ·········]';

  @override
  String get routineDiscardConfirm => '[ÐÎŠÇÅŔÐ ···]';

  @override
  String get routineDiscardKeep => '[Ķééþ éðîţîñĝ ·····]';

  @override
  String get adBannerLabel => '[Åðṽéŕţîšéɱéñţ ······]';

  @override
  String get settingsAnalytics => '[Åñöñýɱöûš ûšáĝé šţáţîšţîçš ··········]';

  @override
  String get settingsAnalyticsHelp =>
      '[Öñļý ŵĥîçĥ šéššîöñ ţýþéš šţáŕţ áñð ƒîñîšĥ. Ñéṽéŕ ýöûŕ ŵöŕķöûţš öŕ þéŕšöñáļ ðáţá. ···························]';

  @override
  String get settingsPrivacyOptions => '[Þŕîṽáçý þŕéƒéŕéñçéš ········]';

  @override
  String get settingsPrivacyOptionsMeta => '[ŔÉṼÎÉŴ ···]';

  @override
  String get removeAdsTitle => '[ŔÉṀÖṼÉ ÅÐŠ · ÖÑÉ-ŢÎṀÉ ·······]';

  @override
  String get removeAdsBody =>
      '[Öñé þáýɱéñţ, ñö šûƀšçŕîþţîöñ. Åļļ ƒéáţûŕéš šţáý ƒŕéé. ··················]';

  @override
  String removeAdsBuy(String price) {
    return '[ŔÉṀÖṼÉ ÅÐŠ · $price ····]';
  }

  @override
  String get removeAdsBuyNoPrice => '[ŔÉṀÖṼÉ ÅÐŠ ····]';

  @override
  String get removeAdsRestore => '[Ŕéšţöŕé þûŕçĥášé ······]';

  @override
  String get removeAdsOwned =>
      '[Åðš ŕéɱöṽéð. Ţĥáñķš ƒöŕ šûþþöŕţîñĝ Ţŕáîñļööþ! ················]';

  @override
  String get removeAdsRestored =>
      '[Þûŕçĥášé ŕéšţöŕéð: áðš ŕéɱöṽéð. ···········]';

  @override
  String get removeAdsPending =>
      '[Þûŕçĥášé þéñðîñĝ: áðš áŕé ŕéɱöṽéð öñçé Ĝööĝļé Þļáý çöñƒîŕɱš îţ. ·····················]';

  @override
  String get removeAdsCanceled =>
      '[Þûŕçĥášé çáñçéļéð. Ýöû ŵéŕé ñöţ çĥáŕĝéð. ··············]';

  @override
  String get removeAdsError =>
      '[Ţĥé þûŕçĥášé çöûļðñ\'ţ ƀé çöɱþļéţéð. Ţŕý áĝáîñ. ···············]';

  @override
  String get removeAdsUnavailable =>
      '[Ĝööĝļé Þļáý îšñ\'ţ áṽáîļáƀļé ŕîĝĥţ ñöŵ. Çĥéçķ ýöûŕ çöññéçţîöñ áñð ţŕý áĝáîñ. ·························]';

  @override
  String get removeAdsNothing =>
      '[Ţĥîš Ĝööĝļé Þļáý áççöûñţ ðöéšñ\'ţ ĥáṽé ţĥé þûŕçĥášé. ·················]';

  @override
  String get errorLogTitle => '[Éŕŕöŕ ļöĝ ····]';

  @override
  String errorLogCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éŕŕöŕš',
      one: '1 éŕŕöŕ',
      zero: 'ñö éŕŕöŕš',
    );
    return '[$_temp0 ········]';
  }

  @override
  String get errorLogHelp =>
      '[Ţéçĥñîçáļ éŕŕöŕš šţáý öñļý öñ ţĥîš þĥöñé. Éẋþöŕţ ţĥé ƒîļé îƒ ýöû ŵáñţ ţö šéñð îţ ţö ûš. ····························]';

  @override
  String get errorLogEmpty => '[Ñö éŕŕöŕš ŕéçöŕðéð. ·······]';

  @override
  String errorLogSaved(String name) {
    return '[Éŕŕöŕ ļöĝ šáṽéð: $name ······]';
  }

  @override
  String strengthSameAsBefore(String values) {
    return '[ŠÅṀÉ ÅŠ ƁÉƑÖŔÉ: $values ·····]';
  }

  @override
  String strengthSameAsBeforeHint(String values) {
    return '[Ļöĝ áñöţĥéŕ šéţ ļîķé ţĥé ļášţ öñé: $values ···········]';
  }
}
