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
  String get trainIntervalsEmptyTitle => 'Ainda não há treinos intervalados';

  @override
  String get trainIntervalsEmptyBody =>
      'Crie um com NOVO ou comece por um modelo.';

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

  @override
  String get phaseNamePrepare => 'Preparação';

  @override
  String get phaseNameWarmup => 'Aquecimento';

  @override
  String get phaseNameWork => 'Trabalho';

  @override
  String get phaseNameRest => 'Descanso';

  @override
  String get phaseNameCooldown => 'Desaquecimento';

  @override
  String get timerPhasePrepare => 'PREPARE-SE';

  @override
  String get timerPhaseWarmup => 'AQUECIMENTO';

  @override
  String get timerPhaseCooldown => 'DESAQUECIMENTO';

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
  String get templateWalkRun => 'Caminhar/correr';

  @override
  String get templateRun => 'Correr';

  @override
  String get templateWalk => 'Caminhar';

  @override
  String get templateTag => 'Modelo';

  @override
  String intervalMeta(int rounds, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds rodadas',
      one: '1 rodada',
    );
    return '$_temp0 · $total';
  }

  @override
  String get homeQuickTemplates => 'MODELOS RÁPIDOS';

  @override
  String get trainTemplates => 'MODELOS';

  @override
  String get trainMyIntervals => 'MEUS TREINOS';

  @override
  String get trainNewInterval => 'NOVO';

  @override
  String get intervalNewTooltip => 'Novo treino intervalado';

  @override
  String intervalStart(String name) {
    return 'Começar $name';
  }

  @override
  String intervalActions(String name) {
    return 'Ações de $name';
  }

  @override
  String intervalArchived(String name) {
    return '“$name” arquivado';
  }

  @override
  String get detailCloseTooltip => 'Fechar';

  @override
  String detailMeta(String total, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds rodadas',
      one: '1 rodada',
    );
    return '$total no total · $_temp0';
  }

  @override
  String get repeatCaps => 'REPETIÇÃO';

  @override
  String repeatRounds(int rounds) {
    return '× $rounds RODADAS';
  }

  @override
  String get detailSkipLast => 'O último descanso é omitido';

  @override
  String get alertVoice => 'Voz';

  @override
  String get alertBeeps => 'bipes';

  @override
  String get alertVibration => 'vibração';

  @override
  String alertsOn(String items) {
    return '$items: ativados';
  }

  @override
  String get alertsOff => 'Avisos desativados';

  @override
  String get detailNoVoice => 'Sem voz para este idioma: só bipes';

  @override
  String get detailStart => 'COMEÇAR';

  @override
  String get detailEdit => 'EDITAR';

  @override
  String get detailDuplicate => 'DUPLICAR';

  @override
  String get detailCustomize => 'PERSONALIZAR';

  @override
  String get editorNewTitle => 'NOVO TREINO';

  @override
  String get editorEditTitle => 'EDITAR TREINO';

  @override
  String editorDefaultName(String date) {
    return 'Intervalos $date';
  }

  @override
  String editorLess(String phase) {
    return 'Tirar 5 segundos de $phase';
  }

  @override
  String editorMore(String phase) {
    return 'Somar 5 segundos a $phase';
  }

  @override
  String get editorLessRounds => 'Menos rodadas';

  @override
  String get editorMoreRounds => 'Mais rodadas';

  @override
  String get editorSkipLast => 'Omitir o último descanso';

  @override
  String get editorAddBlock => 'ADICIONAR BLOCO';

  @override
  String get editorAddToRepeat => 'ADICIONAR À REPETIÇÃO';

  @override
  String get editorRepeat => 'Repetição';

  @override
  String get editorAddTitle => 'Adicionar';

  @override
  String get editorErrorNoWork =>
      'Adicione pelo menos um intervalo de trabalho de 1 segundo ou mais.';

  @override
  String get editorErrorEmptyRepeat =>
      'Cada repetição precisa de pelo menos um intervalo.';

  @override
  String get editorErrorTooLong => 'O total não pode passar de 4 horas.';

  @override
  String get editorTotal => 'DURAÇÃO TOTAL';

  @override
  String get editorSave => 'SALVAR';

  @override
  String get editorBlockActions => 'Ações do bloco';

  @override
  String get editorRename => 'Rótulo';

  @override
  String get editorLabelHint => 'Ex.: Agachamentos';

  @override
  String get editorMoveUp => 'Subir';

  @override
  String get editorMoveDown => 'Descer';

  @override
  String get editorRemove => 'Remover';

  @override
  String editorDurationTitle(String phase) {
    return 'Duração de $phase';
  }

  @override
  String get editorMinutes => 'Minutos';

  @override
  String get editorSeconds => 'Segundos';

  @override
  String get dialogCancel => 'Cancelar';

  @override
  String get dialogOk => 'OK';

  @override
  String timerRound(int round, int rounds) {
    return 'RODADA $round/$rounds';
  }

  @override
  String timerSet(int set, int sets) {
    return 'SÉRIE $set/$sets';
  }

  @override
  String timerNext(String phase, String duration) {
    return 'Próximo: $phase $duration';
  }

  @override
  String get timerLast => 'Última fase';

  @override
  String get timerPaused => 'PAUSADO';

  @override
  String get timerTapToResume => 'TOQUE PARA RETOMAR';

  @override
  String get timerPause => 'Pausar';

  @override
  String get timerResume => 'Retomar';

  @override
  String get timerSkip => 'Pular para a próxima fase';

  @override
  String get timerSkipShort => 'Pular';

  @override
  String get timerPrevious => 'Voltar ao início da fase';

  @override
  String get timerHoldToStop => 'SEGURE PARA PARAR';

  @override
  String get timerHoldHint => 'Toque e segure para parar a sessão';

  @override
  String get timerLock => 'Bloquear controles';

  @override
  String get timerLocked =>
      'Controles bloqueados · toque no cadeado para desbloquear';

  @override
  String timerProgress(int current, int total) {
    return 'Fase $current de $total';
  }

  @override
  String get timerChannel => 'Sessão em andamento';

  @override
  String timerNotificationRound(String phase, int round, int rounds) {
    return '$phase · Rodada $round/$rounds';
  }

  @override
  String cueRound(String phase, int round, int rounds) {
    return '$phase, rodada $round de $rounds';
  }

  @override
  String cueThenNext(String phase, String next) {
    return '$phase. A seguir: $next';
  }

  @override
  String get cueFinish => 'Sessão concluída';

  @override
  String get summaryDoneTitle => 'Sessão concluída!';

  @override
  String get summaryStoppedTitle => 'Sessão parada';

  @override
  String summarySubtitle(String name, String date) {
    return '$name · $date';
  }

  @override
  String get summaryTotal => 'TOTAL';

  @override
  String get summaryRounds => 'RODADAS';

  @override
  String get summaryWork => 'TRABALHO';

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
    return '$time pausado';
  }

  @override
  String get summaryNoPauses => 'sem pausas';

  @override
  String get summaryShort => 'Durou menos de 30 segundos. Quer descartar?';

  @override
  String get summaryRpeQuestion => 'QUÃO DIFÍCIL FOI? (OPCIONAL)';

  @override
  String summaryRpeValue(int value) {
    return 'Esforço $value de 10';
  }

  @override
  String get summaryRpeEasy => 'Muito leve';

  @override
  String get summaryRpeMax => 'Máximo';

  @override
  String get summaryNote => 'NOTA';

  @override
  String get summaryNoteHint => 'Ex.: “Joelho incomodando na última rodada”';

  @override
  String get summaryDone => 'PRONTO';

  @override
  String get summaryDiscard => 'Descartar sessão';

  @override
  String get summaryDiscardTitle => 'Descartar esta sessão?';

  @override
  String get summaryDiscardBody =>
      'Ela não será salva no histórico nem contará para a sua semana.';

  @override
  String get summaryDiscardConfirm => 'Descartar';

  @override
  String get notifyTitle => 'ACOMPANHE O TREINO COM A TELA DESLIGADA';

  @override
  String get notifyBody =>
      'O Trainloop mostra uma notificação enquanto você treina para ver a fase e o tempo sem desbloquear o celular.';

  @override
  String get notifyContinue => 'CONTINUAR';

  @override
  String get notifyNotNow => 'Agora não · começar mesmo assim';

  @override
  String get recoveryTitle => 'VOCÊ TEM UM TREINO NÃO CONCLUÍDO';

  @override
  String recoveryRound(int round, int rounds) {
    return 'Rodada $round/$rounds';
  }

  @override
  String recoveryAgo(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'interrompido há $minutes min',
      one: 'interrompido há 1 min',
      zero: 'interrompido agora há pouco',
    );
    return '$_temp0';
  }

  @override
  String get recoveryBody =>
      'O Android fechou o app. Salvamos seu progresso até o último ponto.';

  @override
  String get recoveryResume => 'RETOMAR (PAUSADO)';

  @override
  String get recoverySaveIncomplete => 'SALVAR COMO INCOMPLETA';

  @override
  String get recoveryDiscard => 'DESCARTAR';

  @override
  String batteryTitle(String brand) {
    return 'EVITE QUE A $brand PAUSE O TIMER';
  }

  @override
  String get batteryBody =>
      'A bateria do Trainloop está restrita e o timer pararia com a tela desligada. Você só configura uma vez:';

  @override
  String get batteryStep1 => 'Configurações › Apps › Trainloop';

  @override
  String get batteryStep2 => 'Bateria';

  @override
  String get batteryStep3 => 'Escolha “Sem restrições”';

  @override
  String get batteryOpenSettings => 'ABRIR CONFIGURAÇÕES';

  @override
  String get batteryDone => 'JÁ FIZ';

  @override
  String get batteryLater => 'MAIS TARDE';

  @override
  String get activeSessionTitle => 'Já há uma sessão em andamento';

  @override
  String get activeSessionBody => 'Termine-a antes de começar outra.';

  @override
  String get activeSessionGo => 'VOLTAR À SESSÃO';

  @override
  String get volumeZero =>
      'O volume de mídia está em 0: você não vai ouvir os avisos.';

  @override
  String get settingsAlerts => 'ALERTAS';

  @override
  String get settingsVoice => 'Voz';

  @override
  String get settingsVoiceHelp => 'Diz o nome de cada fase';

  @override
  String get settingsBeeps => 'Bipes 3-2-1';

  @override
  String get settingsBeepsHelp => 'Tom em cada fase e nos últimos 3 segundos';

  @override
  String get settingsVibration => 'Vibração';

  @override
  String get settingsVibrationHelp => 'Longa no trabalho, dupla no descanso';

  @override
  String get homeActiveSession => 'SESSÃO EM ANDAMENTO';

  @override
  String get homeActiveStrength => 'Voltar à sua sessão de força';

  @override
  String get homeRepeatLast => 'REPETIR ÚLTIMO';

  @override
  String homeRepeatMeta(String date) {
    return 'Força · $date';
  }

  @override
  String routineStart(String name) {
    return 'Iniciar $name';
  }

  @override
  String get settingsTraining => 'TREINO';

  @override
  String get settingsUnits => 'Unidades';

  @override
  String get settingsUnitsHelp =>
      'Muda como os pesos são exibidos e digitados. As séries salvas mantêm a unidade original.';

  @override
  String get cueRestOver => 'Próxima série';

  @override
  String get strengthFreeWorkout => 'TREINO LIVRE';

  @override
  String get strengthFreeTitle => 'Treino livre';

  @override
  String get strengthEmptyRoutine =>
      'Esta rotina não tem exercícios. Adicione algum para iniciá-la.';

  @override
  String get strengthEmptyHint =>
      'Adicione os exercícios que você vai fazer. Cada série é salva assim que você a marca.';

  @override
  String get strengthInProgress => 'Sessão em andamento';

  @override
  String get strengthFinish => 'TERMINAR';

  @override
  String strengthProgress(int done, int total) {
    return '$done/$total séries';
  }

  @override
  String get strengthRestLabel => '● DESCANSO';

  @override
  String get strengthRestNotification => 'Descanso';

  @override
  String strengthRestRemaining(String time) {
    return 'Descanso, faltam $time';
  }

  @override
  String get strengthRestOver => 'Bora para a próxima série!';

  @override
  String get strengthMinus15 => '−15';

  @override
  String get strengthPlus15 => '+15';

  @override
  String get strengthPlus15Short => '+15 s';

  @override
  String get strengthMinus15Tooltip => 'Tirar 15 segundos';

  @override
  String get strengthPlus15Tooltip => 'Adicionar 15 segundos';

  @override
  String get strengthSkipRest => 'PULAR';

  @override
  String get strengthSkipRestTooltip => 'Pular o descanso';

  @override
  String strengthRestFor(String time) {
    return 'Descanso $time';
  }

  @override
  String strengthExerciseActions(String name) {
    return 'Opções de $name';
  }

  @override
  String get strengthMoveUp => 'Subir';

  @override
  String get strengthMoveDown => 'Descer';

  @override
  String get strengthRemoveExercise => 'Remover exercício';

  @override
  String strengthRemoveExerciseTitle(String name) {
    return 'Remover $name?';
  }

  @override
  String get strengthRemoveExerciseBody =>
      'As séries feitas serão removidas desta sessão. A rotina não muda.';

  @override
  String get strengthNotesTitle => 'Notas';

  @override
  String get strengthNotesHint => 'Ex.: «Banco na posição 4»';

  @override
  String get strengthNotesSave => 'SALVAR';

  @override
  String get strengthColSet => 'SÉRIE';

  @override
  String get strengthColPrevious => 'ANTERIOR';

  @override
  String get strengthColReps => 'REPS';

  @override
  String get strengthColTime => 'TEMPO';

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
  String get setTagWarmup => 'A';

  @override
  String get setTagFailure => 'F';

  @override
  String get setTagDrop => 'D';

  @override
  String setTagWithType(int number, String type) {
    return '$number$type';
  }

  @override
  String get strengthAddSet => '+ ADICIONAR SÉRIE';

  @override
  String get strengthAddExercise => '+ ADICIONAR EXERCÍCIO';

  @override
  String strengthEditWeight(String set) {
    return 'Editar peso, $set';
  }

  @override
  String strengthEditReps(String set) {
    return 'Editar repetições, $set';
  }

  @override
  String strengthCompleteSet(String set) {
    return 'Concluir $set';
  }

  @override
  String strengthUncompleteSet(String set) {
    return 'Desmarcar $set';
  }

  @override
  String strengthSetHeading(String exercise, int number) {
    return '$exercise · série $number';
  }

  @override
  String strengthSetHeadingWarmup(String exercise) {
    return '$exercise · aquecimento';
  }

  @override
  String strengthNextSet(String exercise, int number) {
    return 'Próximo: $exercise, série $number';
  }

  @override
  String strengthNextWarmup(String exercise) {
    return 'Próximo: $exercise, aquecimento';
  }

  @override
  String strengthLastTime(String values) {
    return 'Da última vez: $values';
  }

  @override
  String strengthWeightLabel(String unit) {
    return 'PESO ($unit)';
  }

  @override
  String get strengthRepsLabel => 'REPETIÇÕES';

  @override
  String get strengthTimeLabel => 'TEMPO';

  @override
  String get strengthRpeLabel => 'ESFORÇO (RPE) · OPCIONAL';

  @override
  String get strengthSetTypeLabel => 'TIPO DE SÉRIE';

  @override
  String get setTypeWarmup => 'Aquecimento';

  @override
  String get setTypeNormal => 'Normal';

  @override
  String get setTypeFailure => 'Até a falha';

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
    return 'Tirar $weight';
  }

  @override
  String strengthWeightPlus(String weight) {
    return 'Adicionar $weight';
  }

  @override
  String get strengthRepsMinus => 'Tirar uma repetição';

  @override
  String get strengthRepsPlus => 'Adicionar uma repetição';

  @override
  String strengthTimeMinus(int seconds) {
    return 'Tirar $seconds segundos';
  }

  @override
  String strengthTimePlus(int seconds) {
    return 'Adicionar $seconds segundos';
  }

  @override
  String get strengthSaveSet => 'SALVAR SÉRIE';

  @override
  String get strengthCloseNoSave => 'Fechar sem salvar';

  @override
  String get strengthRemoveSet => 'Remover série';

  @override
  String setErrorWeightRange(String max) {
    return 'Informe um peso entre 0 e $max.';
  }

  @override
  String setErrorWeightStep(String step) {
    return 'O peso vai em passos de $step.';
  }

  @override
  String setErrorReps(int max) {
    return 'As repetições vão de 0 a $max.';
  }

  @override
  String get setErrorRpe => 'O RPE vai de 6 a 10 em passos de 0,5.';

  @override
  String get setErrorDuration => 'Informe um tempo de até 99:59.';

  @override
  String strengthPendingTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Há $count séries não concluídas',
      one: 'Há 1 série não concluída',
    );
    return '$_temp0';
  }

  @override
  String get strengthPendingBody =>
      'Você pode descartá-las, marcá-las como feitas com os valores sugeridos ou continuar treinando.';

  @override
  String get strengthPendingDiscard => 'DESCARTAR E TERMINAR';

  @override
  String get strengthPendingComplete => 'MARCAR COMO CONCLUÍDAS';

  @override
  String get strengthBackToSession => 'Voltar à sessão';

  @override
  String get strengthNoSetsTitle => 'NENHUMA SÉRIE FEITA';

  @override
  String get strengthNoSetsBody =>
      'Uma sessão sem séries concluídas não é salva. Descartá-la?';

  @override
  String get strengthRecoveryBody =>
      'O Android fechou o app. Cada série que você marcou está salva.';

  @override
  String get strengthRecoveryResume => 'RETOMAR';

  @override
  String strengthSetsDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count séries feitas',
      one: '1 série feita',
      zero: 'sem séries feitas',
    );
    return '$_temp0';
  }

  @override
  String get strengthSavedTitle => 'Sessão salva';

  @override
  String get strengthSummaryDuration => 'DURAÇÃO';

  @override
  String get strengthSummaryVolume => 'VOLUME';

  @override
  String get strengthSummarySets => 'SÉRIES';

  @override
  String strengthMinutes(int minutes) {
    return '$minutes MIN';
  }

  @override
  String get strengthNewRecord => 'NOVO RECORDE';

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
    return 'A estrutura mudou. Atualizar a rotina «$routine»?';
  }

  @override
  String get strengthUpdateRoutineYes => 'SIM, ATUALIZAR';

  @override
  String get strengthUpdateRoutineNo => 'Não';

  @override
  String strengthRoutineUpdated(String routine) {
    return '«$routine» atualizada: exercícios e número de séries.';
  }

  @override
  String get strengthRoutineKept => 'A rotina fica como estava.';

  @override
  String get strengthNoteHint => 'Ex.: «O joelho melhor»';

  @override
  String decimalText(String value) {
    return '$value';
  }

  @override
  String get debugWeekVariant => 'Visão semanal (teste H5)';

  @override
  String get debugWeekVariantHelp =>
      'Ajuste interno para o teste de usabilidade: força e intervalos juntos ou separados.';

  @override
  String get weekVariantUnified => 'UNIFICADA';

  @override
  String get weekVariantSeparate => 'SEPARADA';

  @override
  String get detailColSet => 'SÉRIE';

  @override
  String get detailColReps => 'REPS';

  @override
  String get detailColRpe => 'RPE';

  @override
  String get detailColTime => 'TEMPO';

  @override
  String get detailDelete => 'EXCLUIR';

  @override
  String get detailDeleteTitle => 'Excluir esta sessão?';

  @override
  String get detailDeleteBody =>
      'Seus recordes serão recalculados. Você terá 5 segundos para desfazer.';

  @override
  String get detailDeleted => 'Sessão excluída';

  @override
  String get detailDone => 'PRONTO';

  @override
  String get detailEditHelp =>
      'Toque uma série para mudar peso, reps, RPE ou tipo. Os recordes são recalculados.';

  @override
  String detailEffort(int value) {
    return 'Esforço $value/10';
  }

  @override
  String get detailMissing => 'Esta sessão não está mais no seu histórico.';

  @override
  String get detailNameLabel => 'NOME';

  @override
  String detailNote(String note) {
    return 'Nota: $note';
  }

  @override
  String get detailRecordTag => 'RECORDE';

  @override
  String get detailRecords => 'RECORDES';

  @override
  String get detailRounds => 'RODADAS';

  @override
  String detailRoutineSaved(String name) {
    return 'Rotina «$name» salva';
  }

  @override
  String get detailSaveRoutine => 'SALVAR COMO ROTINA';

  @override
  String get detailSets => 'SÉRIES';

  @override
  String get detailTotal => 'TOTAL';

  @override
  String get detailVolume => 'VOLUME';

  @override
  String get detailWork => 'TRABALHO';

  @override
  String distanceMeters(int meters) {
    return '$meters m';
  }

  @override
  String get exerciseHistory => 'HISTÓRICO';

  @override
  String get exerciseLastMark => 'ÚLTIMA MARCA';

  @override
  String get exerciseNoHistory => 'Ainda não há sessões com este exercício.';

  @override
  String get exerciseNoRecords => 'Ainda não há recordes.';

  @override
  String exerciseOneRm(String value) {
    return '1RM estimado $value';
  }

  @override
  String get exerciseRecords => 'RECORDES';

  @override
  String exerciseTrendMissing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Faltam $count sessões para ver a tendência.',
      one: 'Falta 1 sessão para ver a tendência.',
    );
    return '$_temp0';
  }

  @override
  String exerciseTrendNote(String from, String to, String change) {
    return 'De $from a $to ($change%)';
  }

  @override
  String get exerciseTrendTitle => '1RM ESTIMADO';

  @override
  String historyBlockDone(String day, String name, String minutes) {
    return '✓ $day · $name · $minutes';
  }

  @override
  String get historyBlockEmpty => 'Nada feito nem planejado nesta semana.';

  @override
  String historyBlockStrength(int done, int total) {
    return 'FORÇA · $done DE $total';
  }

  @override
  String historyBlockIntervals(int done, int total) {
    return 'INTERVALOS · $done DE $total';
  }

  @override
  String historyBlockPlanned(String day, String name) {
    return '○ $day · $name (planejado)';
  }

  @override
  String historyCalendarDay(String date, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$date: $count sessões',
      one: '$date: 1 sessão',
      zero: '$date: sem sessões',
    );
    return '$_temp0';
  }

  @override
  String historyDate(String date) {
    return '$date';
  }

  @override
  String get historyDayEmpty => 'Sem sessões neste dia.';

  @override
  String get historyDayFree => 'Livre';

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
  String get historyNextMonth => 'Próximo mês';

  @override
  String get historyPrevMonth => 'Mês anterior';

  @override
  String historyRounds(int done, int total) {
    return '$done/$total rodadas';
  }

  @override
  String historySets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count séries',
      one: '1 série',
    );
    return '$_temp0';
  }

  @override
  String get historyStateDone => 'Feito';

  @override
  String get historyStateIncomplete => 'Incompleta';

  @override
  String get historyStatePlanned => 'Planejado';

  @override
  String get historyTabWeek => 'SEMANA';

  @override
  String get historyTabList => 'LISTA';

  @override
  String get historyTabCalendar => 'CALENDÁRIO';

  @override
  String get historyTabsLabel => 'Visualização do histórico';

  @override
  String get historyThisWeek => 'ESTA SEMANA';

  @override
  String historyWeekGroup(String week, int sessions, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      sessions,
      locale: localeName,
      other: '$week · $sessions SESSÕES · $minutes MIN',
      one: '$week · 1 SESSÃO · $minutes MIN',
    );
    return '$_temp0';
  }

  @override
  String historyWeekHead(int done, int goal) {
    return 'ESTA SEMANA · $done DE $goal';
  }

  @override
  String get historyWeekLegend =>
      'F = força · I = intervalos · cheio = feito · contorno = planejado · pontilhado = descanso ou livre. Toque um dia livre para planejá-lo.';

  @override
  String historyWeekOf(String date) {
    return 'SEMANA DE $date';
  }

  @override
  String get homeSeeProgress => 'VER PROGRESSO';

  @override
  String homeWeekMinutes(int minutes) {
    return '$minutes min ativos';
  }

  @override
  String homeWeekProgressLabel(int done, int goal) {
    return '$done de $goal sessões nesta semana';
  }

  @override
  String get homeWeekSessions => 'sessões da sua meta';

  @override
  String homeWeekStreak(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: '$weeks semanas de sequência',
      one: '1 semana de sequência',
    );
    return '$_temp0';
  }

  @override
  String get planHelp =>
      'Repete toda semana. Só aparece na sua semana: nunca inicia uma sessão.';

  @override
  String get planNone => 'Sem plano';

  @override
  String planTitle(String day) {
    return 'Plano de $day';
  }

  @override
  String progressBarLabel(String date, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Semana de $date: $count sessões',
      one: 'Semana de $date: 1 sessão',
    );
    return '$_temp0';
  }

  @override
  String get progressChartNote =>
      'Força e intervalos contam igual. Toque uma barra para ver suas sessões.';

  @override
  String progressChartSub(String average, int goal) {
    return 'média $average · meta $goal';
  }

  @override
  String get progressChartTitle => 'SESSÕES POR SEMANA';

  @override
  String get progressComplete => 'COMPLETO';

  @override
  String get progressGoalLine => 'meta';

  @override
  String progressGoalSuffix(int goal) {
    return '/$goal';
  }

  @override
  String progressIntervalMark(String rounds, String work) {
    return '$rounds · $work de trabalho';
  }

  @override
  String get progressLastMarks => 'ÚLTIMA MARCA POR EXERCÍCIO';

  @override
  String get progressMinutes => 'min ativos';

  @override
  String get progressRecordBadge => '↑ RECORDE';

  @override
  String get progressSameBadge => '= IGUAL';

  @override
  String get progressSessions => 'sessões';

  @override
  String get progressStreak => 'semanas de sequência';

  @override
  String get progressThisWeekShort => 'Hoje';

  @override
  String progressWeekVolume(String volume) {
    return 'Volume de força nesta semana: $volume';
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
  String get rangeYear => '1 ANO';

  @override
  String get rangeAll => 'TUDO';

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
    return 'Mais reps com $weight';
  }

  @override
  String get recordMaxRepsBodyweight => 'Mais reps';

  @override
  String get recordMaxVolume => 'Maior volume';

  @override
  String get recordMaxDuration => 'Maior duração';

  @override
  String get recordMaxDistance => 'Maior distância';

  @override
  String get settingsWeekStart => 'A semana começa na';

  @override
  String get settingsMonday => 'SEGUNDA';

  @override
  String get settingsSunday => 'DOMINGO';

  @override
  String get settingsWeeklyGoal => 'Meta semanal (sessões)';

  @override
  String get settingsGoalLess => 'Menos sessões';

  @override
  String get settingsGoalMore => 'Mais sessões';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');
}
