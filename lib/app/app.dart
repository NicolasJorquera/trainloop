import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/l10n/l10n.dart';
import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';
import '../features/intervals/presentation/active_session.dart';
import '../features/intervals/presentation/session_gate.dart';
import '../features/monetization/presentation/monetization_gate.dart';
import '../features/reminders/presentation/reminder_section.dart';
import '../features/settings/application/settings_controller.dart';

/// Raíz de la app: tema, acento e idioma salen de [settingsControllerProvider]
/// y se aplican en caliente, sin reiniciar.
class TrainloopApp extends ConsumerWidget {
  const TrainloopApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      themeMode: settings.theme.mode,
      theme: buildTrainloopTheme(Brightness.light, settings.accent),
      darkTheme: buildTrainloopTheme(Brightness.dark, settings.accent),
      locale: settings.language.locale,
      supportedLocales: appSupportedLocales,
      localeListResolutionCallback: resolveAppLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        final dark = Theme.of(context).brightness == Brightness.dark;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: (dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
              .copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: Colors.transparent,
              ),
          child: ReminderSync(
            child: SessionGate(
              child: MonetizationGate(child: ActiveSessionFrame(child: child!)),
            ),
          ),
        );
      },
    );
  }
}
