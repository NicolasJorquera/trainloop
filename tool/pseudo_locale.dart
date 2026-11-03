// Genera lib/l10n/app_en_XA.arb a partir de lib/l10n/app_en.arb.
//
// Uso: dart run tool/pseudo_locale.dart && flutter gen-l10n
import 'dart:convert';
import 'dart:io';

import 'package:trainloop/core/l10n/pseudo.dart';

void main() {
  final template = File('lib/l10n/app_en.arb');
  final arb = jsonDecode(template.readAsStringSync()) as Map<String, Object?>;
  final out = File('lib/l10n/app_en_XA.arb')
    ..writeAsStringSync(encodePseudoArb(pseudoArb(arb)));
  stdout.writeln('Escrito ${out.path} (${arb.length} entradas leídas).');
}
