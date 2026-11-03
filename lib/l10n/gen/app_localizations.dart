import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('en', 'XA'),
    Locale('es'),
    Locale('es', '419'),
    Locale('pt'),
    Locale('pt', 'BR'),
  ];

  /// App name shown by the OS task switcher. Brand: do not translate.
  ///
  /// In en, this message translates to:
  /// **'Trainloop'**
  String get appTitle;

  /// Wordmark in the Home header. Brand: do not translate.
  ///
  /// In en, this message translates to:
  /// **'TRAINLOOP'**
  String get logoWordmark;

  /// Accessibility label of the bottom navigation bar.
  ///
  /// In en, this message translates to:
  /// **'Main navigation'**
  String get navMainLabel;

  /// Bottom nav tab label, uppercase.
  ///
  /// In en, this message translates to:
  /// **'HOME'**
  String get navHome;

  /// Bottom nav tab label, uppercase.
  ///
  /// In en, this message translates to:
  /// **'TRAIN'**
  String get navTrain;

  /// Bottom nav tab label, uppercase.
  ///
  /// In en, this message translates to:
  /// **'HISTORY'**
  String get navHistory;

  /// Bottom nav tab label, uppercase.
  ///
  /// In en, this message translates to:
  /// **'PROGRESS'**
  String get navProgress;

  /// Tooltip and accessibility label of the settings button on Home.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTooltip;

  /// Tooltip and accessibility label of the back button.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backTooltip;

  /// Section label on Home, uppercase.
  ///
  /// In en, this message translates to:
  /// **'THIS WEEK'**
  String get homeWeekOverline;

  /// Empty state title of the weekly card on Home.
  ///
  /// In en, this message translates to:
  /// **'No workouts yet this week'**
  String get homeWeekEmptyTitle;

  /// Empty state body of the weekly card on Home.
  ///
  /// In en, this message translates to:
  /// **'Start an interval timer or a strength session. Everything stays on this phone.'**
  String get homeWeekEmptyBody;

  /// Button on Home that opens the interval timers, uppercase.
  ///
  /// In en, this message translates to:
  /// **'INTERVALS'**
  String get homeStartIntervals;

  /// Button on Home that opens the strength routines, uppercase.
  ///
  /// In en, this message translates to:
  /// **'STRENGTH'**
  String get homeStartStrength;

  /// Screen title, uppercase.
  ///
  /// In en, this message translates to:
  /// **'TRAIN'**
  String get trainTitle;

  /// Accessibility label of the intervals/routines switch.
  ///
  /// In en, this message translates to:
  /// **'Workout type'**
  String get trainKindLabel;

  /// Segment: interval timers.
  ///
  /// In en, this message translates to:
  /// **'Intervals'**
  String get trainIntervals;

  /// Segment: strength routines.
  ///
  /// In en, this message translates to:
  /// **'Routines'**
  String get trainRoutines;

  /// Empty state title in Train > Intervals.
  ///
  /// In en, this message translates to:
  /// **'Your interval timers'**
  String get trainIntervalsEmptyTitle;

  /// Empty state body in Train > Intervals.
  ///
  /// In en, this message translates to:
  /// **'Tabata, HIIT, EMOM and your own timers will live here.'**
  String get trainIntervalsEmptyBody;

  /// Empty state title in Train > Routines.
  ///
  /// In en, this message translates to:
  /// **'Your strength routines'**
  String get trainRoutinesEmptyTitle;

  /// Empty state body in Train > Routines.
  ///
  /// In en, this message translates to:
  /// **'Build routines with your exercises and log every set with one tap.'**
  String get trainRoutinesEmptyBody;

  /// Screen title, uppercase.
  ///
  /// In en, this message translates to:
  /// **'HISTORY'**
  String get historyTitle;

  /// Empty state title in History.
  ///
  /// In en, this message translates to:
  /// **'No sessions yet'**
  String get historyEmptyTitle;

  /// Empty state body in History.
  ///
  /// In en, this message translates to:
  /// **'Every workout you finish is saved here, on this phone.'**
  String get historyEmptyBody;

  /// Screen title, uppercase.
  ///
  /// In en, this message translates to:
  /// **'PROGRESS'**
  String get progressTitle;

  /// Empty state title in Progress.
  ///
  /// In en, this message translates to:
  /// **'Nothing to chart yet'**
  String get progressEmptyTitle;

  /// Empty state body in Progress.
  ///
  /// In en, this message translates to:
  /// **'Train for a couple of weeks to see your sessions, active minutes and records.'**
  String get progressEmptyBody;

  /// Screen title, uppercase.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settingsTitle;

  /// Section label, uppercase.
  ///
  /// In en, this message translates to:
  /// **'APPEARANCE'**
  String get settingsAppearance;

  /// Theme option: follow the system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// Theme option.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Theme option.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// Section label, uppercase.
  ///
  /// In en, this message translates to:
  /// **'ACCENT COLOR'**
  String get settingsAccent;

  /// Help text under the accent picker.
  ///
  /// In en, this message translates to:
  /// **'Changes the color of buttons, bars and the work phase. All options have the same contrast.'**
  String get accentHelp;

  /// Accent color name.
  ///
  /// In en, this message translates to:
  /// **'Orchid'**
  String get accentOrquidea;

  /// Accent color name.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get accentRosa;

  /// Accent color name.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get accentRojo;

  /// Accent color name.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get accentNaranja;

  /// Accent color name.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get accentAmarillo;

  /// Accent color name.
  ///
  /// In en, this message translates to:
  /// **'Lime'**
  String get accentLima;

  /// Accent color name.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get accentAzul;

  /// Accent color name.
  ///
  /// In en, this message translates to:
  /// **'Violet'**
  String get accentVioleta;

  /// Timer phase name, uppercase. Glossary: work.
  ///
  /// In en, this message translates to:
  /// **'WORK'**
  String get phaseWork;

  /// Timer phase name, uppercase. Glossary: rest.
  ///
  /// In en, this message translates to:
  /// **'REST'**
  String get phaseRest;

  /// Section label, uppercase.
  ///
  /// In en, this message translates to:
  /// **'LANGUAGE'**
  String get settingsLanguage;

  /// Language option: follow the device or per-app setting.
  ///
  /// In en, this message translates to:
  /// **'Phone language'**
  String get languageSystem;

  /// Endonym. Keep as is in every language.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// Endonym. Keep as is in every language.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Endonym. Keep as is in every language.
  ///
  /// In en, this message translates to:
  /// **'Português (Brasil)'**
  String get languagePortuguese;

  /// Debug-only option. Not shown in release builds.
  ///
  /// In en, this message translates to:
  /// **'Pseudo-locale (en-XA, debug)'**
  String get languagePseudo;

  /// Help text under the language options.
  ///
  /// In en, this message translates to:
  /// **'Applies right away. On Android 13 or later you can also pick it in the system app settings.'**
  String get languageHelp;

  /// Accessibility hint for the selected option.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selectedLabel;

  /// Debug-only section label in Settings, uppercase.
  ///
  /// In en, this message translates to:
  /// **'DEBUG · DATABASE'**
  String get debugDatabaseSection;

  /// Debug-only row counts of the local database.
  ///
  /// In en, this message translates to:
  /// **'{exercises} exercises · {routines} routines · {workouts} timers · {sessions} sessions · {sets} sets'**
  String debugDatabaseCounts(
    int exercises,
    int routines,
    int workouts,
    int sessions,
    int sets,
  );

  /// Help text of the debug database section.
  ///
  /// In en, this message translates to:
  /// **'Debug builds only. Data stays on this phone: force-stop the app and reopen it to check it persists.'**
  String get debugDatabaseHelp;

  /// Debug-only button that inserts sample rows, uppercase.
  ///
  /// In en, this message translates to:
  /// **'ADD DEMO DATA'**
  String get debugSeedDemo;

  /// Header button on Train > Routines that creates a routine. Uppercase, short.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get trainNewRoutine;

  /// Hint below the routine list.
  ///
  /// In en, this message translates to:
  /// **'Unlimited routines. Press and hold a card to reorder.'**
  String get trainRoutinesHint;

  /// Link from Train > Routines to browse exercises.
  ///
  /// In en, this message translates to:
  /// **'Exercise library'**
  String get trainExerciseLibrary;

  /// Routine card subtitle: number of exercises.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No exercises} =1{1 exercise} other{{count} exercises}}'**
  String routineExerciseCount(int count);

  /// Tooltip of the overflow menu of a routine card.
  ///
  /// In en, this message translates to:
  /// **'Options for {name}'**
  String routineActions(String name);

  /// Routine menu action.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get routineEdit;

  /// Routine menu action.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get routineDuplicate;

  /// Routine menu action: hides the routine; history keeps it.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get routineArchive;

  /// Snackbar after archiving a routine.
  ///
  /// In en, this message translates to:
  /// **'“{name}” archived'**
  String routineArchived(String name);

  /// Snackbar after duplicating a routine.
  ///
  /// In en, this message translates to:
  /// **'Copy created: “{name}”'**
  String routineDuplicated(String name);

  /// Name of a duplicated routine.
  ///
  /// In en, this message translates to:
  /// **'{name} (copy)'**
  String routineCopyName(String name);

  /// Snackbar action that reverts the last action.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// Routine editor title when creating.
  ///
  /// In en, this message translates to:
  /// **'New routine'**
  String get routineNewTitle;

  /// Routine editor title when editing.
  ///
  /// In en, this message translates to:
  /// **'Edit routine'**
  String get routineEditTitle;

  /// Label of a name field, uppercase overline.
  ///
  /// In en, this message translates to:
  /// **'NAME'**
  String get fieldName;

  /// Placeholder of the routine name.
  ///
  /// In en, this message translates to:
  /// **'E.g. Legs A'**
  String get routineNameHint;

  /// Name used when a routine is saved without a name.
  ///
  /// In en, this message translates to:
  /// **'Routine {number}'**
  String routineDefaultName(int number);

  /// Section label of the routine editor with the exercise count.
  ///
  /// In en, this message translates to:
  /// **'EXERCISES · {count}'**
  String routineExercisesLabel(int count);

  /// Button that opens the exercise library to add exercises.
  ///
  /// In en, this message translates to:
  /// **'Add exercises'**
  String get routineAddExercises;

  /// Hint at the bottom of the routine editor.
  ///
  /// In en, this message translates to:
  /// **'Editing the routine doesn’t change your past sessions.'**
  String get routineEditorHint;

  /// Primary button of the routine editor.
  ///
  /// In en, this message translates to:
  /// **'Save routine'**
  String get routineSave;

  /// Tooltip of the remove button of an exercise in the routine.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}'**
  String routineRemoveExercise(String name);

  /// Accessibility label of the drag handle.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder'**
  String get routineDragHandle;

  /// Sets times reps, e.g. 3 × 10.
  ///
  /// In en, this message translates to:
  /// **'{sets} × {reps}'**
  String summarySetsReps(int sets, int reps);

  /// Sets times duration, e.g. 3 × 0:45.
  ///
  /// In en, this message translates to:
  /// **'{sets} × {time}'**
  String summarySetsTime(int sets, String time);

  /// Number of sets when there is no reps or time target.
  ///
  /// In en, this message translates to:
  /// **'{sets, plural, =1{1 set} other{{sets} sets}}'**
  String summarySets(int sets);

  /// Rest part of the routine exercise summary.
  ///
  /// In en, this message translates to:
  /// **'rest {time}'**
  String summaryRest(String time);

  /// Joins two parts of a summary.
  ///
  /// In en, this message translates to:
  /// **'{first} · {second}'**
  String summaryJoin(String first, String second);

  /// A weight with its unit, e.g. 60 kg.
  ///
  /// In en, this message translates to:
  /// **'{value} {unit}'**
  String weightValue(String value, String unit);

  /// Kilograms unit symbol.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get unitKg;

  /// Pounds unit symbol.
  ///
  /// In en, this message translates to:
  /// **'lb'**
  String get unitLb;

  /// Duration as m:ss; seconds come zero-padded.
  ///
  /// In en, this message translates to:
  /// **'{minutes}:{seconds}'**
  String durationMinSec(int minutes, String seconds);

  /// A bare number shown in a stepper.
  ///
  /// In en, this message translates to:
  /// **'{value}'**
  String numberValue(int value);

  /// Stepper label in the routine exercise sheet.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get sheetSets;

  /// Stepper label in the routine exercise sheet.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get sheetReps;

  /// Stepper label (time target) in the routine exercise sheet.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get sheetDuration;

  /// Weight field label in the routine exercise sheet.
  ///
  /// In en, this message translates to:
  /// **'Target weight (optional)'**
  String get sheetWeight;

  /// Stepper label in the routine exercise sheet.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get sheetRest;

  /// Button closing the routine exercise sheet.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get sheetDone;

  /// Tooltip of a stepper minus button.
  ///
  /// In en, this message translates to:
  /// **'Less: {label}'**
  String stepperDecrease(String label);

  /// Tooltip of a stepper plus button.
  ///
  /// In en, this message translates to:
  /// **'More: {label}'**
  String stepperIncrease(String label);

  /// Exercise library title (browse mode).
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get libraryTitle;

  /// Exercise library title when adding to a routine.
  ///
  /// In en, this message translates to:
  /// **'Add exercises'**
  String get libraryPickTitle;

  /// Search field placeholder.
  ///
  /// In en, this message translates to:
  /// **'Search exercise'**
  String get librarySearch;

  /// Accessibility label of the muscle chips.
  ///
  /// In en, this message translates to:
  /// **'Filter by muscle'**
  String get libraryFilterMuscle;

  /// Equipment filter chip when no equipment is chosen.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get libraryAnyEquipment;

  /// Tracking-type filter chip when no type is chosen.
  ///
  /// In en, this message translates to:
  /// **'Tracking'**
  String get libraryAnyLogType;

  /// Filter option that clears the filter.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get libraryAll;

  /// Empty search result.
  ///
  /// In en, this message translates to:
  /// **'Nothing found for “{query}”'**
  String libraryNotFound(String query);

  /// Button to create a custom exercise with the searched name.
  ///
  /// In en, this message translates to:
  /// **'Create “{query}”'**
  String libraryCreateNamed(String query);

  /// Button to create a custom exercise.
  ///
  /// In en, this message translates to:
  /// **'Create your own exercise'**
  String get libraryCreateCustom;

  /// Footer button adding the selected exercises.
  ///
  /// In en, this message translates to:
  /// **'Add {count}'**
  String libraryAddCount(int count);

  /// Disabled footer when nothing is selected.
  ///
  /// In en, this message translates to:
  /// **'Select exercises'**
  String get libraryPickPrompt;

  /// Tag of exercises created by the person.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get libraryCustomTag;

  /// Muscle group chip.
  ///
  /// In en, this message translates to:
  /// **'Legs'**
  String get muscleGroupLegs;

  /// Muscle group chip.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get muscleGroupChest;

  /// Muscle group chip.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get muscleGroupBack;

  /// Muscle group chip.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get muscleGroupShoulders;

  /// Muscle group chip.
  ///
  /// In en, this message translates to:
  /// **'Arms'**
  String get muscleGroupArms;

  /// Muscle group chip.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get muscleGroupCore;

  /// Muscle group chip: full body, cardio and others.
  ///
  /// In en, this message translates to:
  /// **'Cardio & more'**
  String get muscleGroupOther;

  /// Primary muscle.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get muscleChest;

  /// Primary muscle.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get muscleBack;

  /// Primary muscle.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get muscleShoulders;

  /// Primary muscle.
  ///
  /// In en, this message translates to:
  /// **'Biceps'**
  String get muscleBiceps;

  /// Primary muscle.
  ///
  /// In en, this message translates to:
  /// **'Triceps'**
  String get muscleTriceps;

  /// Primary muscle.
  ///
  /// In en, this message translates to:
  /// **'Forearms'**
  String get muscleForearms;

  /// Primary muscle.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get muscleCore;

  /// Primary muscle.
  ///
  /// In en, this message translates to:
  /// **'Quads'**
  String get muscleQuads;

  /// Primary muscle.
  ///
  /// In en, this message translates to:
  /// **'Hamstrings'**
  String get muscleHamstrings;

  /// Primary muscle.
  ///
  /// In en, this message translates to:
  /// **'Glutes'**
  String get muscleGlutes;

  /// Primary muscle.
  ///
  /// In en, this message translates to:
  /// **'Calves'**
  String get muscleCalves;

  /// Primary muscle.
  ///
  /// In en, this message translates to:
  /// **'Full body'**
  String get muscleFullBody;

  /// Primary muscle.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get muscleCardio;

  /// Primary muscle.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get muscleOther;

  /// Equipment.
  ///
  /// In en, this message translates to:
  /// **'Barbell'**
  String get equipmentBarbell;

  /// Equipment.
  ///
  /// In en, this message translates to:
  /// **'Dumbbells'**
  String get equipmentDumbbell;

  /// Equipment.
  ///
  /// In en, this message translates to:
  /// **'Machine'**
  String get equipmentMachine;

  /// Equipment.
  ///
  /// In en, this message translates to:
  /// **'Cable'**
  String get equipmentCable;

  /// Equipment.
  ///
  /// In en, this message translates to:
  /// **'Kettlebell'**
  String get equipmentKettlebell;

  /// Equipment.
  ///
  /// In en, this message translates to:
  /// **'Band'**
  String get equipmentBand;

  /// Equipment.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight'**
  String get equipmentBodyweight;

  /// Equipment.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get equipmentOther;

  /// What an exercise tracks.
  ///
  /// In en, this message translates to:
  /// **'Weight + reps'**
  String get logTypeWeightReps;

  /// What an exercise tracks.
  ///
  /// In en, this message translates to:
  /// **'Reps only'**
  String get logTypeReps;

  /// What an exercise tracks.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get logTypeTime;

  /// What an exercise tracks.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get logTypeDistance;

  /// What an exercise tracks.
  ///
  /// In en, this message translates to:
  /// **'Distance + time'**
  String get logTypeTimeDistance;

  /// Title of the custom exercise form.
  ///
  /// In en, this message translates to:
  /// **'Create exercise'**
  String get exerciseCreateTitle;

  /// Title of the custom exercise form when editing.
  ///
  /// In en, this message translates to:
  /// **'Edit exercise'**
  String get exerciseEditTitle;

  /// Placeholder of the exercise name.
  ///
  /// In en, this message translates to:
  /// **'E.g. Bulgarian split squat'**
  String get exerciseNameHint;

  /// Warning when the typed name matches an existing exercise.
  ///
  /// In en, this message translates to:
  /// **'“{name}” already exists. Use the existing one?'**
  String exerciseDuplicate(String name);

  /// Button that picks the existing exercise instead of creating a duplicate.
  ///
  /// In en, this message translates to:
  /// **'Use “{name}”'**
  String exerciseUseExisting(String name);

  /// Overline of the tracking-type choice.
  ///
  /// In en, this message translates to:
  /// **'WHAT YOU TRACK'**
  String get exerciseTrackLabel;

  /// Overline of the muscle field.
  ///
  /// In en, this message translates to:
  /// **'PRIMARY MUSCLE'**
  String get exerciseMuscleLabel;

  /// Overline of the equipment field.
  ///
  /// In en, this message translates to:
  /// **'EQUIPMENT'**
  String get exerciseEquipmentLabel;

  /// Overline of the weight increment field.
  ///
  /// In en, this message translates to:
  /// **'INCREMENT'**
  String get exerciseIncrementLabel;

  /// Overline of the default rest stepper.
  ///
  /// In en, this message translates to:
  /// **'DEFAULT REST'**
  String get exerciseRestLabel;

  /// Primary button of the exercise form.
  ///
  /// In en, this message translates to:
  /// **'Save exercise'**
  String get exerciseSave;

  /// Tooltip of the archive action in the exercise form.
  ///
  /// In en, this message translates to:
  /// **'Archive exercise'**
  String get exerciseArchive;

  /// Snackbar after archiving a custom exercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise archived. Your history keeps it.'**
  String get exerciseArchived;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'en':
      {
        switch (locale.countryCode) {
          case 'XA':
            return AppLocalizationsEnXa();
        }
        break;
      }
    case 'es':
      {
        switch (locale.countryCode) {
          case '419':
            return AppLocalizationsEs419();
        }
        break;
      }
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
