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
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');
}
