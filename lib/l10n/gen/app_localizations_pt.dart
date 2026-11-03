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
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');
}
