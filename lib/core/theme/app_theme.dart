import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'accent.dart';
import 'tokens.dart';
import 'typography.dart';

/// Construye el [ThemeData] de Pizarra de hierro para un tema y un acento.
ThemeData buildTrainloopTheme(Brightness brightness, AccentPreset accent) {
  final c = TlColors.resolve(brightness, accent);
  final t = TlText.resolve(ink: c.ink, inkMuted: c.inkMuted);
  final scheme = ColorScheme(
    brightness: brightness,
    primary: c.accent,
    onPrimary: c.onAccent,
    primaryContainer: c.accentSoft,
    onPrimaryContainer: c.ink,
    secondary: c.accent,
    onSecondary: c.onAccent,
    error: c.danger,
    onError: brightness == Brightness.dark ? c.bg : Colors.white,
    surface: c.bg,
    onSurface: c.ink,
    onSurfaceVariant: c.inkMuted,
    surfaceContainerLowest: c.bg,
    surfaceContainerLow: c.surface1,
    surfaceContainer: c.surface1,
    surfaceContainerHigh: c.surface2,
    surfaceContainerHighest: c.surface2,
    outline: c.line,
    outlineVariant: c.line,
  );
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: c.bg,
    fontFamily: TlFonts.body,
    textTheme: TextTheme(
      displayLarge: t.displayXl,
      headlineMedium: t.headline,
      titleLarge: t.title,
      labelLarge: t.button,
      bodyLarge: t.body,
      bodyMedium: t.bodySm,
      bodySmall: t.caption,
      labelSmall: t.overline,
    ),
    dividerColor: c.line,
    iconTheme: IconThemeData(color: c.ink, size: 24),
    tooltipTheme: TooltipThemeData(
      textStyle: t.caption.copyWith(color: c.bg),
      decoration: BoxDecoration(
        color: c.ink,
        borderRadius: BorderRadius.circular(TlRadius.sm),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.surface2,
      hintStyle: t.body.copyWith(color: c.inkMuted),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: TlSpace.s4,
        vertical: TlSpace.s3,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TlRadius.md),
        borderSide: BorderSide(color: c.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TlRadius.md),
        borderSide: BorderSide(color: c.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TlRadius.md),
        borderSide: BorderSide(color: c.accent, width: 2),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: c.ink,
      contentTextStyle: t.bodySm.copyWith(color: c.bg),
      actionTextColor: brightness == Brightness.dark ? c.bg : c.accentSoft,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: c.surface1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TlRadius.sheet),
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
    ),
    extensions: [c, t],
  );
}
