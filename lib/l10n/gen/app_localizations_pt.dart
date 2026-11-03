// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Trainloop';

  @override
  String get logoWordmark => 'TRAINLOOP';

  @override
  String get navMainLabel => 'Navegação principal';

  @override
  String get navHome => 'INÍCIO';

  @override
  String get navTrain => 'TREINAR';

  @override
  String get navHistory => 'HISTÓRICO';

  @override
  String get navProgress => 'PROGRESSO';

  @override
  String get settingsTooltip => 'Configurações';

  @override
  String get backTooltip => 'Voltar';

  @override
  String get homeWeekOverline => 'ESTA SEMANA';

  @override
  String get homeWeekEmptyTitle => 'Nenhum treino nesta semana ainda';

  @override
  String get homeWeekEmptyBody =>
      'Comece um timer de intervalos ou uma sessão de força. Tudo fica neste celular.';

  @override
  String get homeStartIntervals => 'INTERVALOS';

  @override
  String get homeStartStrength => 'FORÇA';

  @override
  String get trainTitle => 'TREINAR';

  @override
  String get trainKindLabel => 'Tipo de treino';

  @override
  String get trainIntervals => 'Intervalos';

  @override
  String get trainRoutines => 'Rotinas';

  @override
  String get trainIntervalsEmptyTitle => 'Seus timers de intervalos';

  @override
  String get trainIntervalsEmptyBody =>
      'Tabata, HIIT, EMOM e seus próprios timers vão ficar aqui.';

  @override
  String get trainRoutinesEmptyTitle => 'Suas rotinas de força';

  @override
  String get trainRoutinesEmptyBody =>
      'Monte rotinas com seus exercícios e registre cada série com um toque.';

  @override
  String get historyTitle => 'HISTÓRICO';

  @override
  String get historyEmptyTitle => 'Nenhuma sessão ainda';

  @override
  String get historyEmptyBody =>
      'Cada treino que você terminar fica salvo aqui, neste celular.';

  @override
  String get progressTitle => 'PROGRESSO';

  @override
  String get progressEmptyTitle => 'Ainda não há nada para mostrar';

  @override
  String get progressEmptyBody =>
      'Treine por algumas semanas para ver suas sessões, minutos ativos e recordes.';

  @override
  String get settingsTitle => 'CONFIGURAÇÕES';

  @override
  String get settingsAppearance => 'APARÊNCIA';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get settingsAccent => 'COR DE DESTAQUE';

  @override
  String get accentHelp =>
      'Muda a cor dos botões, das barras e da fase de trabalho. Todas têm o mesmo contraste.';

  @override
  String get accentOrquidea => 'Orquídea';

  @override
  String get accentRosa => 'Rosa';

  @override
  String get accentRojo => 'Vermelho';

  @override
  String get accentNaranja => 'Laranja';

  @override
  String get accentAmarillo => 'Amarelo';

  @override
  String get accentLima => 'Lima';

  @override
  String get accentAzul => 'Azul';

  @override
  String get accentVioleta => 'Violeta';

  @override
  String get phaseWork => 'TRABALHO';

  @override
  String get phaseRest => 'DESCANSO';

  @override
  String get settingsLanguage => 'IDIOMA';

  @override
  String get languageSystem => 'Idioma do celular';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePortuguese => 'Português (Brasil)';

  @override
  String get languagePseudo => 'Pseudolocale (en-XA, depuração)';

  @override
  String get languageHelp =>
      'Aplica na hora. No Android 13 ou superior você também pode escolher nas configurações do app no sistema.';

  @override
  String get selectedLabel => 'Selecionado';

  @override
  String get debugDatabaseSection => 'DEPURAÇÃO · BANCO DE DADOS';

  @override
  String debugDatabaseCounts(
    int exercises,
    int routines,
    int workouts,
    int sessions,
    int sets,
  ) {
    return '$exercises exercícios · $routines rotinas · $workouts timers · $sessions sessões · $sets séries';
  }

  @override
  String get debugDatabaseHelp =>
      'Só em depuração. Os dados ficam neste celular: force a parada do app e abra de novo para conferir que continuam lá.';

  @override
  String get debugSeedDemo => 'ADICIONAR DADOS DE TESTE';

  @override
  String get trainNewRoutine => 'NOVA';

  @override
  String get trainRoutinesHint =>
      'Rotinas ilimitadas. Toque e segure um cartão para reordenar.';

  @override
  String get trainExerciseLibrary => 'Biblioteca de exercícios';

  @override
  String routineExerciseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exercícios',
      one: '1 exercício',
      zero: 'Sem exercícios',
    );
    return '$_temp0';
  }

  @override
  String routineActions(String name) {
    return 'Opções de $name';
  }

  @override
  String get routineEdit => 'Editar';

  @override
  String get routineDuplicate => 'Duplicar';

  @override
  String get routineArchive => 'Arquivar';

  @override
  String routineArchived(String name) {
    return '«$name» arquivada';
  }

  @override
  String routineDuplicated(String name) {
    return 'Cópia criada: «$name»';
  }

  @override
  String routineCopyName(String name) {
    return '$name (cópia)';
  }

  @override
  String get undo => 'Desfazer';

  @override
  String get routineNewTitle => 'Nova rotina';

  @override
  String get routineEditTitle => 'Editar rotina';

  @override
  String get fieldName => 'NOME';

  @override
  String get routineNameHint => 'Ex.: Pernas A';

  @override
  String routineDefaultName(int number) {
    return 'Rotina $number';
  }

  @override
  String routineExercisesLabel(int count) {
    return 'EXERCÍCIOS · $count';
  }

  @override
  String get routineAddExercises => 'Adicionar exercícios';

  @override
  String get routineEditorHint =>
      'Editar a rotina não altera suas sessões anteriores.';

  @override
  String get routineSave => 'Salvar rotina';

  @override
  String routineRemoveExercise(String name) {
    return 'Remover $name';
  }

  @override
  String get routineDragHandle => 'Arraste para reordenar';

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
      other: '$sets séries',
      one: '1 série',
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
  String get sheetSets => 'Séries';

  @override
  String get sheetReps => 'Repetições';

  @override
  String get sheetDuration => 'Duração';

  @override
  String get sheetWeight => 'Peso alvo (opcional)';

  @override
  String get sheetRest => 'Descanso';

  @override
  String get sheetDone => 'Pronto';

  @override
  String stepperDecrease(String label) {
    return 'Menos: $label';
  }

  @override
  String stepperIncrease(String label) {
    return 'Mais: $label';
  }

  @override
  String get libraryTitle => 'Exercícios';

  @override
  String get libraryPickTitle => 'Adicionar exercícios';

  @override
  String get librarySearch => 'Buscar exercício';

  @override
  String get libraryFilterMuscle => 'Filtrar por músculo';

  @override
  String get libraryAnyEquipment => 'Equipamento';

  @override
  String get libraryAnyLogType => 'Registro';

  @override
  String get libraryAll => 'Todos';

  @override
  String libraryNotFound(String query) {
    return 'Nada encontrado para «$query»';
  }

  @override
  String libraryCreateNamed(String query) {
    return 'Criar «$query»';
  }

  @override
  String get libraryCreateCustom => 'Criar exercício próprio';

  @override
  String libraryAddCount(int count) {
    return 'Adicionar $count';
  }

  @override
  String get libraryPickPrompt => 'Selecione exercícios';

  @override
  String get libraryCustomTag => 'Próprio';

  @override
  String get muscleGroupLegs => 'Pernas';

  @override
  String get muscleGroupChest => 'Peito';

  @override
  String get muscleGroupBack => 'Costas';

  @override
  String get muscleGroupShoulders => 'Ombros';

  @override
  String get muscleGroupArms => 'Braços';

  @override
  String get muscleGroupCore => 'Core';

  @override
  String get muscleGroupOther => 'Cardio e mais';

  @override
  String get muscleChest => 'Peito';

  @override
  String get muscleBack => 'Costas';

  @override
  String get muscleShoulders => 'Ombros';

  @override
  String get muscleBiceps => 'Bíceps';

  @override
  String get muscleTriceps => 'Tríceps';

  @override
  String get muscleForearms => 'Antebraços';

  @override
  String get muscleCore => 'Core';

  @override
  String get muscleQuads => 'Quadríceps';

  @override
  String get muscleHamstrings => 'Posteriores de coxa';

  @override
  String get muscleGlutes => 'Glúteos';

  @override
  String get muscleCalves => 'Panturrilhas';

  @override
  String get muscleFullBody => 'Corpo inteiro';

  @override
  String get muscleCardio => 'Cardio';

  @override
  String get muscleOther => 'Outro';

  @override
  String get equipmentBarbell => 'Barra';

  @override
  String get equipmentDumbbell => 'Halteres';

  @override
  String get equipmentMachine => 'Máquina';

  @override
  String get equipmentCable => 'Polia';

  @override
  String get equipmentKettlebell => 'Kettlebell';

  @override
  String get equipmentBand => 'Elástico';

  @override
  String get equipmentBodyweight => 'Peso corporal';

  @override
  String get equipmentOther => 'Outro';

  @override
  String get logTypeWeightReps => 'Peso + reps';

  @override
  String get logTypeReps => 'Só reps';

  @override
  String get logTypeTime => 'Tempo';

  @override
  String get logTypeDistance => 'Distância';

  @override
  String get logTypeTimeDistance => 'Distância + tempo';

  @override
  String get exerciseCreateTitle => 'Criar exercício';

  @override
  String get exerciseEditTitle => 'Editar exercício';

  @override
  String get exerciseNameHint => 'Ex.: Agachamento búlgaro';

  @override
  String exerciseDuplicate(String name) {
    return '«$name» já existe. Usar o existente?';
  }

  @override
  String exerciseUseExisting(String name) {
    return 'Usar «$name»';
  }

  @override
  String get exerciseTrackLabel => 'O QUE VOCÊ REGISTRA';

  @override
  String get exerciseMuscleLabel => 'MÚSCULO PRINCIPAL';

  @override
  String get exerciseEquipmentLabel => 'EQUIPAMENTO';

  @override
  String get exerciseIncrementLabel => 'INCREMENTO';

  @override
  String get exerciseRestLabel => 'DESCANSO PADRÃO';

  @override
  String get exerciseSave => 'Salvar exercício';

  @override
  String get exerciseArchive => 'Arquivar exercício';

  @override
  String get exerciseArchived => 'Exercício arquivado. Seu histórico o mantém.';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');
}
