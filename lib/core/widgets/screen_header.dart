import 'package:flutter/material.dart';

import '../theme/theme_context.dart';
import '../theme/tokens.dart';
import 'trainloop_symbol.dart';

/// Título de pantalla en estilo `headline`, con acciones opcionales.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    required this.title,
    this.leading,
    this.trailing,
    super.key,
  });

  final String title;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: TlSpace.s4, bottom: TlSpace.s2),
    child: Row(
      children: [
        if (leading != null) ...[leading!, const SizedBox(width: TlSpace.s1)],
        Expanded(
          child: Semantics(
            header: true,
            child: Text(title, style: context.text.headline),
          ),
        ),
        ?trailing,
      ],
    ),
  );
}

/// Cabecera de las cuatro pestañas principales.
///
/// Altura fija para que el título no salte al cambiar de pestaña, con o sin
/// acción a la derecha. El símbolo de marca va siempre a la izquierda y en
/// Inicio el título es el logotipo, al mismo tamaño que los demás títulos.
class TabHeader extends StatelessWidget {
  const TabHeader({
    required this.title,
    this.wordmark = false,
    this.trailing,
    super.key,
  });

  final String title;
  final bool wordmark;
  final Widget? trailing;

  static const _height = 48.0;

  @override
  Widget build(BuildContext context) {
    final headline = context.text.headline;
    final style = wordmark
        ? context.text.logo.copyWith(fontSize: headline.fontSize)
        : headline;
    return Padding(
      padding: const EdgeInsets.only(top: TlSpace.s4, bottom: TlSpace.s2),
      child: SizedBox(
        height: _height,
        child: Row(
          children: [
            const TrainloopSymbol(),
            const SizedBox(width: TlSpace.s2),
            Expanded(
              child: Semantics(header: true, child: Text(title, style: style)),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}
