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

  /// Empty state title of the intervals section in Train.
  ///
  /// In en, this message translates to:
  /// **'No interval workouts yet'**
  String get trainIntervalsEmptyTitle;

  /// Empty state body of the intervals section in Train.
  ///
  /// In en, this message translates to:
  /// **'Create one with NEW or start from a template.'**
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

  /// Phase type name, sentence case (lists, notification, voice).
  ///
  /// In en, this message translates to:
  /// **'Get ready'**
  String get phaseNamePrepare;

  /// Phase type name, sentence case.
  ///
  /// In en, this message translates to:
  /// **'Warm-up'**
  String get phaseNameWarmup;

  /// Phase type name, sentence case.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get phaseNameWork;

  /// Phase type name, sentence case.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get phaseNameRest;

  /// Phase type name, sentence case.
  ///
  /// In en, this message translates to:
  /// **'Cool-down'**
  String get phaseNameCooldown;

  /// Big phase label on the running timer, uppercase.
  ///
  /// In en, this message translates to:
  /// **'GET READY'**
  String get timerPhasePrepare;

  /// Big phase label on the running timer, uppercase.
  ///
  /// In en, this message translates to:
  /// **'WARM-UP'**
  String get timerPhaseWarmup;

  /// Big phase label on the running timer, uppercase.
  ///
  /// In en, this message translates to:
  /// **'COOL-DOWN'**
  String get timerPhaseCooldown;

  /// Built-in interval template name.
  ///
  /// In en, this message translates to:
  /// **'Tabata 20/10'**
  String get templateTabata;

  /// Built-in interval template name.
  ///
  /// In en, this message translates to:
  /// **'HIIT 40/20'**
  String get templateHiit4020;

  /// Built-in interval template name.
  ///
  /// In en, this message translates to:
  /// **'HIIT 30/30'**
  String get templateHiit3030;

  /// Built-in interval template name (every minute on the minute).
  ///
  /// In en, this message translates to:
  /// **'EMOM 10 min'**
  String get templateEmom10;

  /// Built-in interval template name (as many rounds as possible).
  ///
  /// In en, this message translates to:
  /// **'AMRAP 12 min'**
  String get templateAmrap12;

  /// Built-in interval template name: run intervals with walking breaks.
  ///
  /// In en, this message translates to:
  /// **'Walk/run'**
  String get templateWalkRun;

  /// Label of the run interval in the walk/run template.
  ///
  /// In en, this message translates to:
  /// **'Run'**
  String get templateRun;

  /// Label of the walk interval in the walk/run template.
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get templateWalk;

  /// Tag that marks a built-in template.
  ///
  /// In en, this message translates to:
  /// **'Template'**
  String get templateTag;

  /// Workout card subtitle: rounds (work intervals) and total time with prep.
  ///
  /// In en, this message translates to:
  /// **'{rounds, plural, =1{1 round} other{{rounds} rounds}} · {total}'**
  String intervalMeta(int rounds, String total);

  /// Home section label with built-in interval templates.
  ///
  /// In en, this message translates to:
  /// **'QUICK TEMPLATES'**
  String get homeQuickTemplates;

  /// Train section label with built-in interval templates.
  ///
  /// In en, this message translates to:
  /// **'TEMPLATES'**
  String get trainTemplates;

  /// Train section label with the user interval workouts.
  ///
  /// In en, this message translates to:
  /// **'MY WORKOUTS'**
  String get trainMyIntervals;

  /// Train header button that creates an interval workout, uppercase.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get trainNewInterval;

  /// Tooltip of the new interval workout button.
  ///
  /// In en, this message translates to:
  /// **'New interval workout'**
  String get intervalNewTooltip;

  /// Accessibility label of the play button on a workout card.
  ///
  /// In en, this message translates to:
  /// **'Start {name}'**
  String intervalStart(String name);

  /// Tooltip of the overflow menu of a workout card.
  ///
  /// In en, this message translates to:
  /// **'Actions for {name}'**
  String intervalActions(String name);

  /// Snackbar after archiving an interval workout.
  ///
  /// In en, this message translates to:
  /// **'“{name}” archived'**
  String intervalArchived(String name);

  /// Tooltip of the close button on the workout detail.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get detailCloseTooltip;

  /// Workout detail subtitle. Total includes the get-ready time.
  ///
  /// In en, this message translates to:
  /// **'{total} total · {rounds, plural, =1{1 round} other{{rounds} rounds}}'**
  String detailMeta(String total, int rounds);

  /// Header of a repeat block, uppercase.
  ///
  /// In en, this message translates to:
  /// **'REPEAT'**
  String get repeatCaps;

  /// Rounds of a repeat block, uppercase.
  ///
  /// In en, this message translates to:
  /// **'× {rounds} ROUNDS'**
  String repeatRounds(int rounds);

  /// Note under a repeat block that skips its final rest.
  ///
  /// In en, this message translates to:
  /// **'The last rest is skipped'**
  String get detailSkipLast;

  /// Alert kind, used in a list.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get alertVoice;

  /// Alert kind, used in a list (lowercase, after the first item).
  ///
  /// In en, this message translates to:
  /// **'beeps'**
  String get alertBeeps;

  /// Alert kind, used in a list (lowercase, after the first item).
  ///
  /// In en, this message translates to:
  /// **'vibration'**
  String get alertVibration;

  /// Which alerts will play, e.g. Voice, beeps, vibration on.
  ///
  /// In en, this message translates to:
  /// **'{items} on'**
  String alertsOn(String items);

  /// All alerts are off in Settings.
  ///
  /// In en, this message translates to:
  /// **'Alerts off'**
  String get alertsOff;

  /// Shown when voice is on but the phone has no voice for the app language.
  ///
  /// In en, this message translates to:
  /// **'No offline voice for this language: beeps only'**
  String get detailNoVoice;

  /// Primary button that starts the timer, uppercase.
  ///
  /// In en, this message translates to:
  /// **'START'**
  String get detailStart;

  /// Button that opens the editor, uppercase.
  ///
  /// In en, this message translates to:
  /// **'EDIT'**
  String get detailEdit;

  /// Button that copies the workout, uppercase.
  ///
  /// In en, this message translates to:
  /// **'DUPLICATE'**
  String get detailDuplicate;

  /// Button that copies a template into an editable workout, uppercase.
  ///
  /// In en, this message translates to:
  /// **'CUSTOMIZE'**
  String get detailCustomize;

  /// Interval editor title, uppercase.
  ///
  /// In en, this message translates to:
  /// **'NEW WORKOUT'**
  String get editorNewTitle;

  /// Interval editor title when editing, uppercase.
  ///
  /// In en, this message translates to:
  /// **'EDIT WORKOUT'**
  String get editorEditTitle;

  /// Default workout name; date is short (e.g. Nov 3).
  ///
  /// In en, this message translates to:
  /// **'Intervals {date}'**
  String editorDefaultName(String date);

  /// Accessibility label of the minus button of an interval.
  ///
  /// In en, this message translates to:
  /// **'Remove 5 seconds from {phase}'**
  String editorLess(String phase);

  /// Accessibility label of the plus button of an interval.
  ///
  /// In en, this message translates to:
  /// **'Add 5 seconds to {phase}'**
  String editorMore(String phase);

  /// Accessibility label of the minus rounds button.
  ///
  /// In en, this message translates to:
  /// **'Fewer rounds'**
  String get editorLessRounds;

  /// Accessibility label of the plus rounds button.
  ///
  /// In en, this message translates to:
  /// **'More rounds'**
  String get editorMoreRounds;

  /// Switch of a repeat block.
  ///
  /// In en, this message translates to:
  /// **'Skip the last rest'**
  String get editorSkipLast;

  /// Button that adds a block to the workout, uppercase.
  ///
  /// In en, this message translates to:
  /// **'ADD BLOCK'**
  String get editorAddBlock;

  /// Button that adds a block inside a repeat, uppercase.
  ///
  /// In en, this message translates to:
  /// **'ADD TO REPEAT'**
  String get editorAddToRepeat;

  /// Option of the add block sheet: a repeat with rounds.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get editorRepeat;

  /// Title of the add block sheet.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get editorAddTitle;

  /// Editor error.
  ///
  /// In en, this message translates to:
  /// **'Add at least one work interval of 1 second or more.'**
  String get editorErrorNoWork;

  /// Editor error.
  ///
  /// In en, this message translates to:
  /// **'Each repeat needs at least one interval.'**
  String get editorErrorEmptyRepeat;

  /// Editor error.
  ///
  /// In en, this message translates to:
  /// **'The total can’t be longer than 4 hours.'**
  String get editorErrorTooLong;

  /// Label of the total time in the editor footer, uppercase.
  ///
  /// In en, this message translates to:
  /// **'TOTAL TIME'**
  String get editorTotal;

  /// Save button of the editor, uppercase.
  ///
  /// In en, this message translates to:
  /// **'SAVE'**
  String get editorSave;

  /// Tooltip of the overflow menu of a block.
  ///
  /// In en, this message translates to:
  /// **'Block actions'**
  String get editorBlockActions;

  /// Menu item and dialog title to change an interval label.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get editorRename;

  /// Hint of the interval label field.
  ///
  /// In en, this message translates to:
  /// **'E.g. Squats'**
  String get editorLabelHint;

  /// Menu item that moves a block up.
  ///
  /// In en, this message translates to:
  /// **'Move up'**
  String get editorMoveUp;

  /// Menu item that moves a block down.
  ///
  /// In en, this message translates to:
  /// **'Move down'**
  String get editorMoveDown;

  /// Menu item that removes a block.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get editorRemove;

  /// Title of the duration picker.
  ///
  /// In en, this message translates to:
  /// **'Duration of {phase}'**
  String editorDurationTitle(String phase);

  /// Label of the minutes wheel.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get editorMinutes;

  /// Label of the seconds wheel.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get editorSeconds;

  /// Dialog button.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dialogCancel;

  /// Dialog button.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get dialogOk;

  /// Round counter on the running timer, uppercase.
  ///
  /// In en, this message translates to:
  /// **'ROUND {round}/{rounds}'**
  String timerRound(int round, int rounds);

  /// Outer repeat counter on the running timer, uppercase.
  ///
  /// In en, this message translates to:
  /// **'SET {set}/{sets}'**
  String timerSet(int set, int sets);

  /// Next phase on the running timer.
  ///
  /// In en, this message translates to:
  /// **'Next: {phase} {duration}'**
  String timerNext(String phase, String duration);

  /// Shown instead of the next phase on the last one.
  ///
  /// In en, this message translates to:
  /// **'Last phase'**
  String get timerLast;

  /// Big label while paused, uppercase.
  ///
  /// In en, this message translates to:
  /// **'PAUSED'**
  String get timerPaused;

  /// Hint while paused, uppercase.
  ///
  /// In en, this message translates to:
  /// **'TAP TO RESUME'**
  String get timerTapToResume;

  /// Pause button and notification action.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get timerPause;

  /// Resume button and notification action.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get timerResume;

  /// Accessibility label of the skip button.
  ///
  /// In en, this message translates to:
  /// **'Skip to next phase'**
  String get timerSkip;

  /// Notification action that skips the phase.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get timerSkipShort;

  /// Accessibility label of the previous button.
  ///
  /// In en, this message translates to:
  /// **'Back to phase start'**
  String get timerPrevious;

  /// Stop button: must be held for 1 s, uppercase.
  ///
  /// In en, this message translates to:
  /// **'HOLD TO STOP'**
  String get timerHoldToStop;

  /// Accessibility label of the stop button.
  ///
  /// In en, this message translates to:
  /// **'Press and hold to stop the session'**
  String get timerHoldHint;

  /// Accessibility label of the lock button.
  ///
  /// In en, this message translates to:
  /// **'Lock controls'**
  String get timerLock;

  /// Message while the controls are locked.
  ///
  /// In en, this message translates to:
  /// **'Controls locked · tap the lock to unlock'**
  String get timerLocked;

  /// Accessibility label of the progress bar.
  ///
  /// In en, this message translates to:
  /// **'Phase {current} of {total}'**
  String timerProgress(int current, int total);

  /// Android notification channel name.
  ///
  /// In en, this message translates to:
  /// **'Session in progress'**
  String get timerChannel;

  /// Notification title with the round.
  ///
  /// In en, this message translates to:
  /// **'{phase} · Round {round}/{rounds}'**
  String timerNotificationRound(String phase, int round, int rounds);

  /// Spoken at the start of a phase inside a repeat.
  ///
  /// In en, this message translates to:
  /// **'{phase}, round {round} of {rounds}'**
  String cueRound(String phase, int round, int rounds);

  /// Spoken at the start of a get-ready or rest phase.
  ///
  /// In en, this message translates to:
  /// **'{phase}. Next: {next}'**
  String cueThenNext(String phase, String next);

  /// Spoken at the end of the session.
  ///
  /// In en, this message translates to:
  /// **'Session complete'**
  String get cueFinish;

  /// Summary title of a finished session.
  ///
  /// In en, this message translates to:
  /// **'Session complete!'**
  String get summaryDoneTitle;

  /// Summary title of a session stopped before the end.
  ///
  /// In en, this message translates to:
  /// **'Session stopped'**
  String get summaryStoppedTitle;

  /// Summary subtitle: workout and start date/time.
  ///
  /// In en, this message translates to:
  /// **'{name} · {date}'**
  String summarySubtitle(String name, String date);

  /// Summary stat label, uppercase.
  ///
  /// In en, this message translates to:
  /// **'TOTAL'**
  String get summaryTotal;

  /// Summary stat label, uppercase.
  ///
  /// In en, this message translates to:
  /// **'ROUNDS'**
  String get summaryRounds;

  /// Summary stat label, uppercase.
  ///
  /// In en, this message translates to:
  /// **'WORK'**
  String get summaryWork;

  /// Completed rounds of planned rounds.
  ///
  /// In en, this message translates to:
  /// **'{done}/{total}'**
  String summaryRoundsValue(int done, int total);

  /// Summary line: skipped phases.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 phases skipped} =1{1 phase skipped} other{{count} phases skipped}}'**
  String summarySkipped(int count);

  /// Summary line: total paused time.
  ///
  /// In en, this message translates to:
  /// **'{time} paused'**
  String summaryPaused(String time);

  /// Summary line when there were no pauses.
  ///
  /// In en, this message translates to:
  /// **'no pauses'**
  String get summaryNoPauses;

  /// Shown when the session had less than 30 s of activity.
  ///
  /// In en, this message translates to:
  /// **'It lasted under 30 seconds. Discard it?'**
  String get summaryShort;

  /// Perceived effort question, uppercase.
  ///
  /// In en, this message translates to:
  /// **'HOW HARD WAS IT? (OPTIONAL)'**
  String get summaryRpeQuestion;

  /// Accessibility label of an effort button.
  ///
  /// In en, this message translates to:
  /// **'Effort {value} of 10'**
  String summaryRpeValue(int value);

  /// Label under effort 1.
  ///
  /// In en, this message translates to:
  /// **'Very easy'**
  String get summaryRpeEasy;

  /// Label under effort 10.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get summaryRpeMax;

  /// Note field label, uppercase.
  ///
  /// In en, this message translates to:
  /// **'NOTE'**
  String get summaryNote;

  /// Hint of the note field.
  ///
  /// In en, this message translates to:
  /// **'E.g. “Sore knee in the last round”'**
  String get summaryNoteHint;

  /// Button that saves the summary, uppercase.
  ///
  /// In en, this message translates to:
  /// **'DONE'**
  String get summaryDone;

  /// Button that discards the session.
  ///
  /// In en, this message translates to:
  /// **'Discard session'**
  String get summaryDiscard;

  /// Confirmation title.
  ///
  /// In en, this message translates to:
  /// **'Discard this session?'**
  String get summaryDiscardTitle;

  /// Confirmation body.
  ///
  /// In en, this message translates to:
  /// **'It won’t be saved to your history or count toward your week.'**
  String get summaryDiscardBody;

  /// Confirmation button.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get summaryDiscardConfirm;

  /// Notification permission rationale title, uppercase.
  ///
  /// In en, this message translates to:
  /// **'FOLLOW YOUR WORKOUT WITH THE SCREEN OFF'**
  String get notifyTitle;

  /// Notification permission rationale body.
  ///
  /// In en, this message translates to:
  /// **'Trainloop shows a notification while you train so you can see the phase and time without unlocking the phone.'**
  String get notifyBody;

  /// Button that opens the system permission dialog, uppercase.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE'**
  String get notifyContinue;

  /// Button that starts without the permission.
  ///
  /// In en, this message translates to:
  /// **'Not now · start anyway'**
  String get notifyNotNow;

  /// Recovery dialog title, uppercase.
  ///
  /// In en, this message translates to:
  /// **'YOU HAVE AN UNFINISHED WORKOUT'**
  String get recoveryTitle;

  /// Where the session stopped.
  ///
  /// In en, this message translates to:
  /// **'Round {round}/{rounds}'**
  String recoveryRound(int round, int rounds);

  /// When the session was interrupted.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =0{interrupted moments ago} =1{interrupted 1 min ago} other{interrupted {minutes} min ago}}'**
  String recoveryAgo(int minutes);

  /// Recovery dialog body.
  ///
  /// In en, this message translates to:
  /// **'Android closed the app. We saved your progress up to the last checkpoint.'**
  String get recoveryBody;

  /// Recovery button, uppercase.
  ///
  /// In en, this message translates to:
  /// **'RESUME (PAUSED)'**
  String get recoveryResume;

  /// Recovery button, uppercase.
  ///
  /// In en, this message translates to:
  /// **'SAVE AS INCOMPLETE'**
  String get recoverySaveIncomplete;

  /// Recovery button, uppercase.
  ///
  /// In en, this message translates to:
  /// **'DISCARD'**
  String get recoveryDiscard;

  /// Battery restriction dialog title; brand is the phone maker, uppercase.
  ///
  /// In en, this message translates to:
  /// **'STOP {brand} FROM PAUSING THE TIMER'**
  String batteryTitle(String brand);

  /// Battery restriction dialog body.
  ///
  /// In en, this message translates to:
  /// **'Battery use for Trainloop is restricted, so the timer would stop with the screen off. You only set this once:'**
  String get batteryBody;

  /// Battery dialog step.
  ///
  /// In en, this message translates to:
  /// **'Settings › Apps › Trainloop'**
  String get batteryStep1;

  /// Battery dialog step.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get batteryStep2;

  /// Battery dialog step.
  ///
  /// In en, this message translates to:
  /// **'Choose “Unrestricted”'**
  String get batteryStep3;

  /// Battery dialog button, uppercase.
  ///
  /// In en, this message translates to:
  /// **'OPEN SETTINGS'**
  String get batteryOpenSettings;

  /// Battery dialog button, uppercase.
  ///
  /// In en, this message translates to:
  /// **'I DID IT'**
  String get batteryDone;

  /// Battery dialog button that starts anyway, uppercase.
  ///
  /// In en, this message translates to:
  /// **'LATER'**
  String get batteryLater;

  /// Dialog when starting a second session.
  ///
  /// In en, this message translates to:
  /// **'A session is in progress'**
  String get activeSessionTitle;

  /// Dialog body.
  ///
  /// In en, this message translates to:
  /// **'Finish it before starting another one.'**
  String get activeSessionBody;

  /// Dialog button, uppercase.
  ///
  /// In en, this message translates to:
  /// **'BACK TO SESSION'**
  String get activeSessionGo;

  /// Snackbar when starting with media volume at 0.
  ///
  /// In en, this message translates to:
  /// **'Media volume is at 0: you won’t hear the alerts.'**
  String get volumeZero;

  /// Settings section label, uppercase.
  ///
  /// In en, this message translates to:
  /// **'ALERTS'**
  String get settingsAlerts;

  /// Settings switch.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get settingsVoice;

  /// Settings switch help.
  ///
  /// In en, this message translates to:
  /// **'Says the name of each phase'**
  String get settingsVoiceHelp;

  /// Settings switch.
  ///
  /// In en, this message translates to:
  /// **'3-2-1 beeps'**
  String get settingsBeeps;

  /// Settings switch help.
  ///
  /// In en, this message translates to:
  /// **'Tone at each phase and in the last 3 seconds'**
  String get settingsBeepsHelp;

  /// Settings switch.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get settingsVibration;

  /// Settings switch help.
  ///
  /// In en, this message translates to:
  /// **'Long on work, double on rest'**
  String get settingsVibrationHelp;

  /// Home card overline for the strength session in progress.
  ///
  /// In en, this message translates to:
  /// **'SESSION IN PROGRESS'**
  String get homeActiveSession;

  /// Home card that opens the strength session in progress.
  ///
  /// In en, this message translates to:
  /// **'Back to your strength session'**
  String get homeActiveStrength;

  /// Home section with the last strength session, uppercase.
  ///
  /// In en, this message translates to:
  /// **'REPEAT LAST'**
  String get homeRepeatLast;

  /// Subtitle of the repeat-last card: session type and date.
  ///
  /// In en, this message translates to:
  /// **'Strength · {date}'**
  String homeRepeatMeta(String date);

  /// Accessibility label of the play button of a routine card.
  ///
  /// In en, this message translates to:
  /// **'Start {name}'**
  String routineStart(String name);

  /// Settings section title, uppercase.
  ///
  /// In en, this message translates to:
  /// **'TRAINING'**
  String get settingsTraining;

  /// Settings: weight unit.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get settingsUnits;

  /// Help under the weight unit setting.
  ///
  /// In en, this message translates to:
  /// **'Changes how weights are shown and entered. Logged sets keep their original unit.'**
  String get settingsUnitsHelp;

  /// Spoken when the rest between sets ends.
  ///
  /// In en, this message translates to:
  /// **'Next set'**
  String get cueRestOver;

  /// Button that starts an empty strength session, uppercase.
  ///
  /// In en, this message translates to:
  /// **'FREE WORKOUT'**
  String get strengthFreeWorkout;

  /// Title of a strength session without a routine.
  ///
  /// In en, this message translates to:
  /// **'Free workout'**
  String get strengthFreeTitle;

  /// Snackbar when trying to start an empty routine.
  ///
  /// In en, this message translates to:
  /// **'This routine has no exercises. Add some to start it.'**
  String get strengthEmptyRoutine;

  /// Hint in an empty strength session.
  ///
  /// In en, this message translates to:
  /// **'Add the exercises you are going to do. Each set is saved as soon as you check it.'**
  String get strengthEmptyHint;

  /// Notification text of the strength session without a rest.
  ///
  /// In en, this message translates to:
  /// **'Session in progress'**
  String get strengthInProgress;

  /// Button that finishes the strength session, uppercase.
  ///
  /// In en, this message translates to:
  /// **'FINISH'**
  String get strengthFinish;

  /// Sets done out of total in the session header and notification.
  ///
  /// In en, this message translates to:
  /// **'{done}/{total} sets'**
  String strengthProgress(int done, int total);

  /// Label of the rest bar, uppercase with a dot.
  ///
  /// In en, this message translates to:
  /// **'● REST'**
  String get strengthRestLabel;

  /// Notification title during the rest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get strengthRestNotification;

  /// Accessibility label of the rest bar.
  ///
  /// In en, this message translates to:
  /// **'Rest, {time} left'**
  String strengthRestRemaining(String time);

  /// Shown when the rest ends (screen and notification).
  ///
  /// In en, this message translates to:
  /// **'On to the next set!'**
  String get strengthRestOver;

  /// Rest button that subtracts 15 seconds.
  ///
  /// In en, this message translates to:
  /// **'−15'**
  String get strengthMinus15;

  /// Rest button that adds 15 seconds.
  ///
  /// In en, this message translates to:
  /// **'+15'**
  String get strengthPlus15;

  /// Notification action that adds 15 seconds to the rest.
  ///
  /// In en, this message translates to:
  /// **'+15 s'**
  String get strengthPlus15Short;

  /// Accessibility label of −15.
  ///
  /// In en, this message translates to:
  /// **'Subtract 15 seconds'**
  String get strengthMinus15Tooltip;

  /// Accessibility label of +15.
  ///
  /// In en, this message translates to:
  /// **'Add 15 seconds'**
  String get strengthPlus15Tooltip;

  /// Button that skips the rest, uppercase.
  ///
  /// In en, this message translates to:
  /// **'SKIP'**
  String get strengthSkipRest;

  /// Accessibility label of the skip rest button.
  ///
  /// In en, this message translates to:
  /// **'Skip rest'**
  String get strengthSkipRestTooltip;

  /// Rest of an exercise in the session, e.g. Rest 2:00.
  ///
  /// In en, this message translates to:
  /// **'Rest {time}'**
  String strengthRestFor(String time);

  /// Tooltip of the exercise menu in the session.
  ///
  /// In en, this message translates to:
  /// **'Options for {name}'**
  String strengthExerciseActions(String name);

  /// Exercise menu: move up.
  ///
  /// In en, this message translates to:
  /// **'Move up'**
  String get strengthMoveUp;

  /// Exercise menu: move down.
  ///
  /// In en, this message translates to:
  /// **'Move down'**
  String get strengthMoveDown;

  /// Exercise menu: remove from the session.
  ///
  /// In en, this message translates to:
  /// **'Remove exercise'**
  String get strengthRemoveExercise;

  /// Confirm removing an exercise with logged sets.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String strengthRemoveExerciseTitle(String name);

  /// Body of the remove exercise confirmation.
  ///
  /// In en, this message translates to:
  /// **'Its logged sets will be removed from this session. The routine doesn\'t change.'**
  String get strengthRemoveExerciseBody;

  /// Exercise notes in the session (menu and dialog).
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get strengthNotesTitle;

  /// Hint of the exercise notes field.
  ///
  /// In en, this message translates to:
  /// **'E.g. \"Seat at 4\"'**
  String get strengthNotesHint;

  /// Save exercise notes, uppercase.
  ///
  /// In en, this message translates to:
  /// **'SAVE'**
  String get strengthNotesSave;

  /// Column header: set number.
  ///
  /// In en, this message translates to:
  /// **'SET'**
  String get strengthColSet;

  /// Column header: values from the last session.
  ///
  /// In en, this message translates to:
  /// **'PREVIOUS'**
  String get strengthColPrevious;

  /// Column header: reps.
  ///
  /// In en, this message translates to:
  /// **'REPS'**
  String get strengthColReps;

  /// Column header: duration.
  ///
  /// In en, this message translates to:
  /// **'TIME'**
  String get strengthColTime;

  /// Placeholder when there is no value.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get strengthNoValue;

  /// Last time's values in the PREVIOUS column, e.g. 80 × 8.
  ///
  /// In en, this message translates to:
  /// **'{weight} × {reps}'**
  String strengthPrevious(String weight, int reps);

  /// Weight with unit times reps, e.g. 80 kg × 8.
  ///
  /// In en, this message translates to:
  /// **'{weight} × {reps}'**
  String strengthWeightTimesReps(String weight, int reps);

  /// Reps only, e.g. × 12.
  ///
  /// In en, this message translates to:
  /// **'× {reps}'**
  String strengthTimesReps(int reps);

  /// Tag of a warm-up set (one letter).
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get setTagWarmup;

  /// Letter added to a set to failure.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get setTagFailure;

  /// Letter added to a drop set.
  ///
  /// In en, this message translates to:
  /// **'D'**
  String get setTagDrop;

  /// Set number with its type letter, e.g. 3F.
  ///
  /// In en, this message translates to:
  /// **'{number}{type}'**
  String setTagWithType(int number, String type);

  /// Button that adds a set to the exercise, uppercase.
  ///
  /// In en, this message translates to:
  /// **'+ ADD SET'**
  String get strengthAddSet;

  /// Button that adds exercises to the session, uppercase.
  ///
  /// In en, this message translates to:
  /// **'+ ADD EXERCISE'**
  String get strengthAddExercise;

  /// Accessibility label of a weight cell.
  ///
  /// In en, this message translates to:
  /// **'Edit weight, {set}'**
  String strengthEditWeight(String set);

  /// Accessibility label of a reps cell.
  ///
  /// In en, this message translates to:
  /// **'Edit reps, {set}'**
  String strengthEditReps(String set);

  /// Accessibility label of the check button.
  ///
  /// In en, this message translates to:
  /// **'Complete {set}'**
  String strengthCompleteSet(String set);

  /// Accessibility label of the check button of a done set.
  ///
  /// In en, this message translates to:
  /// **'Uncheck {set}'**
  String strengthUncompleteSet(String set);

  /// Heading of the set editor.
  ///
  /// In en, this message translates to:
  /// **'{exercise} · set {number}'**
  String strengthSetHeading(String exercise, int number);

  /// Heading of the set editor for a warm-up set.
  ///
  /// In en, this message translates to:
  /// **'{exercise} · warm-up'**
  String strengthSetHeadingWarmup(String exercise);

  /// Next set during the rest and in the notification.
  ///
  /// In en, this message translates to:
  /// **'Next: {exercise}, set {number}'**
  String strengthNextSet(String exercise, int number);

  /// Next set when it is a warm-up.
  ///
  /// In en, this message translates to:
  /// **'Next: {exercise}, warm-up'**
  String strengthNextWarmup(String exercise);

  /// Last mark in the set editor.
  ///
  /// In en, this message translates to:
  /// **'Last time: {values}'**
  String strengthLastTime(String values);

  /// Weight field label with the unit, uppercase.
  ///
  /// In en, this message translates to:
  /// **'WEIGHT ({unit})'**
  String strengthWeightLabel(String unit);

  /// Reps field label, uppercase.
  ///
  /// In en, this message translates to:
  /// **'REPS'**
  String get strengthRepsLabel;

  /// Duration field label, uppercase.
  ///
  /// In en, this message translates to:
  /// **'TIME'**
  String get strengthTimeLabel;

  /// RPE chips label, uppercase.
  ///
  /// In en, this message translates to:
  /// **'EFFORT (RPE) · OPTIONAL'**
  String get strengthRpeLabel;

  /// Set type chips label, uppercase.
  ///
  /// In en, this message translates to:
  /// **'SET TYPE'**
  String get strengthSetTypeLabel;

  /// Set type.
  ///
  /// In en, this message translates to:
  /// **'Warm-up'**
  String get setTypeWarmup;

  /// Set type.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get setTypeNormal;

  /// Set type.
  ///
  /// In en, this message translates to:
  /// **'To failure'**
  String get setTypeFailure;

  /// Set type.
  ///
  /// In en, this message translates to:
  /// **'Drop set'**
  String get setTypeDrop;

  /// Weight minus button, e.g. −2.5.
  ///
  /// In en, this message translates to:
  /// **'−{value}'**
  String setStepMinus(String value);

  /// Weight plus button, e.g. +2.5.
  ///
  /// In en, this message translates to:
  /// **'+{value}'**
  String setStepPlus(String value);

  /// Reps minus button.
  ///
  /// In en, this message translates to:
  /// **'−'**
  String get setStepMinusOne;

  /// Reps plus button.
  ///
  /// In en, this message translates to:
  /// **'+'**
  String get setStepPlusOne;

  /// Duration minus button, in seconds.
  ///
  /// In en, this message translates to:
  /// **'−{seconds}'**
  String setStepMinusSeconds(int seconds);

  /// Duration plus button, in seconds.
  ///
  /// In en, this message translates to:
  /// **'+{seconds}'**
  String setStepPlusSeconds(int seconds);

  /// Accessibility label of the weight minus button.
  ///
  /// In en, this message translates to:
  /// **'Subtract {weight}'**
  String strengthWeightMinus(String weight);

  /// Accessibility label of the weight plus button.
  ///
  /// In en, this message translates to:
  /// **'Add {weight}'**
  String strengthWeightPlus(String weight);

  /// Accessibility label.
  ///
  /// In en, this message translates to:
  /// **'Subtract one rep'**
  String get strengthRepsMinus;

  /// Accessibility label.
  ///
  /// In en, this message translates to:
  /// **'Add one rep'**
  String get strengthRepsPlus;

  /// Accessibility label.
  ///
  /// In en, this message translates to:
  /// **'Subtract {seconds} seconds'**
  String strengthTimeMinus(int seconds);

  /// Accessibility label.
  ///
  /// In en, this message translates to:
  /// **'Add {seconds} seconds'**
  String strengthTimePlus(int seconds);

  /// Set editor save button, uppercase.
  ///
  /// In en, this message translates to:
  /// **'SAVE SET'**
  String get strengthSaveSet;

  /// Tooltip of the set editor close button.
  ///
  /// In en, this message translates to:
  /// **'Close without saving'**
  String get strengthCloseNoSave;

  /// Tooltip of the set editor delete button.
  ///
  /// In en, this message translates to:
  /// **'Remove set'**
  String get strengthRemoveSet;

  /// Weight out of range.
  ///
  /// In en, this message translates to:
  /// **'Enter a weight between 0 and {max}.'**
  String setErrorWeightRange(String max);

  /// Weight not multiple of the step.
  ///
  /// In en, this message translates to:
  /// **'Weight goes in steps of {step}.'**
  String setErrorWeightStep(String step);

  /// Reps out of range.
  ///
  /// In en, this message translates to:
  /// **'Reps go from 0 to {max}.'**
  String setErrorReps(int max);

  /// RPE out of range.
  ///
  /// In en, this message translates to:
  /// **'RPE goes from 6 to 10 in steps of 0.5.'**
  String get setErrorRpe;

  /// Duration out of range.
  ///
  /// In en, this message translates to:
  /// **'Enter a time up to 99:59.'**
  String get setErrorDuration;

  /// Finish dialog title when sets are not done.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{There is 1 unfinished set} other{There are {count} unfinished sets}}'**
  String strengthPendingTitle(int count);

  /// Finish dialog body.
  ///
  /// In en, this message translates to:
  /// **'You can discard them, mark them done with the suggested values, or keep training.'**
  String get strengthPendingBody;

  /// Finish dialog: discard unfinished sets, uppercase.
  ///
  /// In en, this message translates to:
  /// **'DISCARD AND FINISH'**
  String get strengthPendingDiscard;

  /// Finish dialog: mark unfinished sets as done, uppercase.
  ///
  /// In en, this message translates to:
  /// **'MARK THEM AS DONE'**
  String get strengthPendingComplete;

  /// Dialog button that returns to the session.
  ///
  /// In en, this message translates to:
  /// **'Back to session'**
  String get strengthBackToSession;

  /// Finish dialog title when no set is done, uppercase.
  ///
  /// In en, this message translates to:
  /// **'NO SETS DONE'**
  String get strengthNoSetsTitle;

  /// Finish dialog body when no set is done.
  ///
  /// In en, this message translates to:
  /// **'A session without completed sets isn\'t saved. Discard it?'**
  String get strengthNoSetsBody;

  /// Recovery dialog body for a strength session.
  ///
  /// In en, this message translates to:
  /// **'Android closed the app. Every set you checked is saved.'**
  String get strengthRecoveryBody;

  /// Recovery dialog: resume the strength session, uppercase.
  ///
  /// In en, this message translates to:
  /// **'RESUME'**
  String get strengthRecoveryResume;

  /// Sets done in the recovery dialog.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{no sets done} =1{1 set done} other{{count} sets done}}'**
  String strengthSetsDone(int count);

  /// Summary title of a strength session saved as incomplete.
  ///
  /// In en, this message translates to:
  /// **'Session saved'**
  String get strengthSavedTitle;

  /// Summary stat label, uppercase.
  ///
  /// In en, this message translates to:
  /// **'DURATION'**
  String get strengthSummaryDuration;

  /// Summary stat label, uppercase.
  ///
  /// In en, this message translates to:
  /// **'VOLUME'**
  String get strengthSummaryVolume;

  /// Summary stat label, uppercase.
  ///
  /// In en, this message translates to:
  /// **'SETS'**
  String get strengthSummarySets;

  /// Session duration in minutes, uppercase.
  ///
  /// In en, this message translates to:
  /// **'{minutes} MIN'**
  String strengthMinutes(int minutes);

  /// Summary record card overline, uppercase.
  ///
  /// In en, this message translates to:
  /// **'NEW RECORD'**
  String get strengthNewRecord;

  /// Record of the day.
  ///
  /// In en, this message translates to:
  /// **'{exercise}: {values}'**
  String strengthRecordSet(String exercise, String values);

  /// Record of the day with estimated one-rep max.
  ///
  /// In en, this message translates to:
  /// **'{exercise}: {values} · estimated 1RM {rm}'**
  String strengthRecordWithRm(String exercise, String values, String rm);

  /// Summary question when exercises or sets changed.
  ///
  /// In en, this message translates to:
  /// **'The structure changed. Update the \"{routine}\" routine?'**
  String strengthUpdateRoutineQuestion(String routine);

  /// Update routine button, uppercase.
  ///
  /// In en, this message translates to:
  /// **'YES, UPDATE'**
  String get strengthUpdateRoutineYes;

  /// Keep routine button.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get strengthUpdateRoutineNo;

  /// Confirmation after updating the routine.
  ///
  /// In en, this message translates to:
  /// **'\"{routine}\" updated: exercises and number of sets.'**
  String strengthRoutineUpdated(String routine);

  /// After answering no to updating the routine.
  ///
  /// In en, this message translates to:
  /// **'The routine stays as it was.'**
  String get strengthRoutineKept;

  /// Summary note hint for strength.
  ///
  /// In en, this message translates to:
  /// **'E.g. \"Knee felt better\"'**
  String get strengthNoteHint;

  /// A number already formatted with the decimal separator of the language, e.g. 82,5.
  ///
  /// In en, this message translates to:
  /// **'{value}'**
  String decimalText(String value);
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
