import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:trainloop/core/l10n/pseudo.dart';

Map<String, Object?> _readArb(String name) =>
    jsonDecode(File('lib/l10n/$name').readAsStringSync())
        as Map<String, Object?>;

Set<String> _messageKeys(Map<String, Object?> arb) =>
    arb.keys.where((k) => !k.startsWith('@')).toSet();

void main() {
  group('pseudoLocalize', () {
    test('acentúa, alarga y marca el texto', () {
      final out = pseudoLocalize('Settings');
      expect(out, startsWith('[Šéţţîñĝš'));
      expect(out, endsWith(']'));
      expect(out.length, greaterThan('Settings'.length * 1.3));
    });

    test('conserva placeholders', () {
      expect(pseudoLocalize('Hi {name}!'), startsWith('[Ĥî {name}!'));
    });

    test('conserva la estructura ICU de plural y select', () {
      const msg =
          '{count, plural, =0{No sets} =1{One set} other{{count} sets}}';
      final out = pseudoLocalize(msg);
      expect(
        out,
        startsWith(
          '[{count, plural, =0{Ñö šéţš} =1{Öñé šéţ} other{{count} šéţš}}',
        ),
      );
      const sel = '{unit, select, kg{Kilos} other{Pounds}}';
      expect(
        pseudoLocalize(sel),
        startsWith('[{unit, select, kg{Ķîļöš} other{Þöûñðš}}'),
      );
    });

    test('copia formatos que no son plural/select', () {
      expect(pseudoLocalize('{d, date, short}'), '[{d, date, short}]');
    });
  });

  group('ARB', () {
    test('app_en_XA.arb está sincronizado con app_en.arb '
        '(regenerar: dart run tool/pseudo_locale.dart)', () {
      final expected = encodePseudoArb(pseudoArb(_readArb('app_en.arb')));
      expect(File('lib/l10n/app_en_XA.arb').readAsStringSync(), expected);
    });

    test('es y pt traducen todos los mensajes de la plantilla', () {
      final template = _messageKeys(_readArb('app_en.arb'));
      for (final name in ['app_es.arb', 'app_pt.arb']) {
        expect(_messageKeys(_readArb(name)), template, reason: name);
      }
    });
  });
}
