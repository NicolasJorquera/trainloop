import 'package:flutter/material.dart';

/// Familias empaquetadas como assets (OFL). Sin descarga en tiempo de ejecución.
abstract final class TlFonts {
  static const display = 'BarlowCondensed';
  static const body = 'Inter';
}

const _tabular = [FontFeature.tabularFigures()];

/// Estilos tipográficos de tokens.json, ya coloreados para el tema.
@immutable
class TlText extends ThemeExtension<TlText> {
  const TlText({
    required this.timer,
    required this.displayXl,
    required this.phase,
    required this.headline,
    required this.title,
    required this.button,
    required this.logo,
    required this.body,
    required this.bodySm,
    required this.caption,
    required this.overline,
  });

  factory TlText.resolve({required Color ink, required Color inkMuted}) =>
      TlText(
        timer: TextStyle(
          fontFamily: TlFonts.display,
          fontSize: 188,
          height: 0.85,
          fontWeight: FontWeight.w800,
          letterSpacing: -3,
          fontFeatures: _tabular,
          color: ink,
        ),
        displayXl: TextStyle(
          fontFamily: TlFonts.display,
          fontSize: 72,
          height: 0.85,
          fontWeight: FontWeight.w800,
          fontFeatures: _tabular,
          color: ink,
        ),
        phase: TextStyle(
          fontFamily: TlFonts.display,
          fontSize: 64,
          height: 0.9,
          fontWeight: FontWeight.w800,
          fontStyle: FontStyle.italic,
          color: ink,
        ),
        headline: TextStyle(
          fontFamily: TlFonts.display,
          fontSize: 32,
          height: 1,
          fontWeight: FontWeight.w800,
          color: ink,
        ),
        title: TextStyle(
          fontFamily: TlFonts.display,
          fontSize: 22,
          height: 1.1,
          fontWeight: FontWeight.w700,
          color: ink,
        ),
        button: TextStyle(
          fontFamily: TlFonts.display,
          fontSize: 22,
          height: 1,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
          color: ink,
        ),
        logo: TextStyle(
          fontFamily: TlFonts.display,
          fontSize: 26,
          height: 1,
          fontWeight: FontWeight.w800,
          fontStyle: FontStyle.italic,
          letterSpacing: 0.5,
          color: ink,
        ),
        body: TextStyle(
          fontFamily: TlFonts.body,
          fontSize: 16,
          height: 24 / 16,
          fontWeight: FontWeight.w400,
          color: ink,
        ),
        bodySm: TextStyle(
          fontFamily: TlFonts.body,
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w400,
          color: ink,
        ),
        caption: TextStyle(
          fontFamily: TlFonts.body,
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w500,
          color: ink,
        ),
        overline: TextStyle(
          fontFamily: TlFonts.body,
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: inkMuted,
        ),
      );

  final TextStyle timer;
  final TextStyle displayXl;
  final TextStyle phase;
  final TextStyle headline;
  final TextStyle title;
  final TextStyle button;
  final TextStyle logo;
  final TextStyle body;
  final TextStyle bodySm;
  final TextStyle caption;
  final TextStyle overline;

  @override
  TlText copyWith() => this;

  @override
  TlText lerp(TlText? other, double t) {
    if (other == null) return this;
    TextStyle l(TextStyle a, TextStyle b) => TextStyle.lerp(a, b, t)!;
    return TlText(
      timer: l(timer, other.timer),
      displayXl: l(displayXl, other.displayXl),
      phase: l(phase, other.phase),
      headline: l(headline, other.headline),
      title: l(title, other.title),
      button: l(button, other.button),
      logo: l(logo, other.logo),
      body: l(body, other.body),
      bodySm: l(bodySm, other.bodySm),
      caption: l(caption, other.caption),
      overline: l(overline, other.overline),
    );
  }
}
