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
  String get trainIntervalsEmptyTitle => 'No interval workouts yet';

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
  String get trainMyIntervals => 'MY WORKOUTS';

  @override
  String get trainNewInterval => 'NEW';

  @override
  String get intervalNewTooltip => 'New interval workout';

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
  String get editorNewTitle => 'NEW WORKOUT';

  @override
  String get editorEditTitle => 'EDIT WORKOUT';

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
  String get trainIntervalsEmptyTitle => '[Ñö îñţéŕṽáļ ŵöŕķöûţš ýéţ ·········]';

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
  String get trainMyIntervals => '[ṀÝ ŴÖŔĶÖÛŢŠ ····]';

  @override
  String get trainNewInterval => '[ÑÉŴ ··]';

  @override
  String get intervalNewTooltip => '[Ñéŵ îñţéŕṽáļ ŵöŕķöûţ ········]';

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
  String get editorNewTitle => '[ÑÉŴ ŴÖŔĶÖÛŢ ····]';

  @override
  String get editorEditTitle => '[ÉÐÎŢ ŴÖŔĶÖÛŢ ·····]';

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
}
