/// Pseudo-localización estilo en-XA: acentúa letras, alarga ~40 % y envuelve
/// cada mensaje en `[` `]` para detectar textos no localizados o recortados.
///
/// Respeta la sintaxis ICU de los ARB: los placeholders (`{name}`) y las
/// palabras clave de `plural`/`select` se copian sin cambios; solo se
/// transforma el texto visible.
library;

import 'dart:convert';

/// Marca de inicio que llevan todos los textos pseudo-localizados.
const pseudoOpen = '[';

/// Marca de cierre que llevan todos los textos pseudo-localizados.
const pseudoClose = ']';

const _map = {
  'a': 'á', 'b': 'ƀ', 'c': 'ç', 'd': 'ð', 'e': 'é', 'f': 'ƒ', 'g': 'ĝ',
  'h': 'ĥ', 'i': 'î', 'j': 'ĵ', 'k': 'ķ', 'l': 'ļ', 'm': 'ɱ', 'n': 'ñ',
  'o': 'ö', 'p': 'þ', 'q': 'ǫ', 'r': 'ŕ', 's': 'š', 't': 'ţ', 'u': 'û',
  'v': 'ṽ', 'w': 'ŵ', 'x': 'ẋ', 'y': 'ý', 'z': 'ž', //
  'A': 'Å', 'B': 'Ɓ', 'C': 'Ç', 'D': 'Ð', 'E': 'É', 'F': 'Ƒ', 'G': 'Ĝ',
  'H': 'Ĥ', 'I': 'Î', 'J': 'Ĵ', 'K': 'Ķ', 'L': 'Ļ', 'M': 'Ṁ', 'N': 'Ñ',
  'O': 'Ö', 'P': 'Þ', 'Q': 'Ǫ', 'R': 'Ŕ', 'S': 'Š', 'T': 'Ţ', 'U': 'Û',
  'V': 'Ṽ', 'W': 'Ŵ', 'X': 'Ẋ', 'Y': 'Ý', 'Z': 'Ž',
};

/// Pseudo-localiza un mensaje ICU.
String pseudoLocalize(String message) {
  final parser = _IcuTransformer(message);
  final body = parser.text(nested: false);
  final pad = parser.letters == 0 ? 0 : (parser.letters * 0.4).ceil();
  final padding = pad == 0 ? '' : ' ${'·' * pad}';
  return '$pseudoOpen$body$padding$pseudoClose';
}

/// Genera el ARB pseudo-localizado a partir del ARB plantilla (en).
Map<String, Object?> pseudoArb(
  Map<String, Object?> templateArb, {
  String locale = 'en_XA',
}) {
  final out = <String, Object?>{'@@locale': locale};
  for (final entry in templateArb.entries) {
    if (entry.key.startsWith('@')) continue;
    out[entry.key] = pseudoLocalize(entry.value! as String);
  }
  return out;
}

/// Serializa el ARB generado (formato estable para el test de sincronía).
String encodePseudoArb(Map<String, Object?> arb) =>
    '${const JsonEncoder.withIndent('  ').convert(arb)}\n';

class _IcuTransformer {
  _IcuTransformer(this.s);

  final String s;
  int i = 0;
  int letters = 0;

  String text({required bool nested}) {
    final b = StringBuffer();
    while (i < s.length) {
      final c = s[i];
      if (c == '{') {
        b.write(_argument());
        continue;
      }
      if (c == '}' && nested) break;
      final mapped = _map[c];
      if (mapped != null) letters++;
      b.write(mapped ?? c);
      i++;
    }
    return b.toString();
  }

  /// Lee `{name}` o `{name, plural|select, ...}` empezando en `{`.
  String _argument() {
    final start = i;
    final nameEnd = _indexOfAny(i + 1);
    if (nameEnd < 0) return _copyTo(s.length);
    if (s[nameEnd] == '}') return _copyTo(nameEnd + 1);
    final typeEnd = _indexOfAny(nameEnd + 1);
    if (typeEnd < 0) return _copyTo(s.length);
    if (s[typeEnd] == '}') return _copyTo(typeEnd + 1);
    final type = s.substring(nameEnd + 1, typeEnd).trim();
    if (type != 'plural' && type != 'select') {
      // Formatos (number, date...): se copian completos.
      return _copyTo(_matchingBrace(start) + 1);
    }
    final b = StringBuffer(s.substring(start, typeEnd + 1));
    i = typeEnd + 1;
    while (i < s.length) {
      final c = s[i];
      if (c == '}') {
        b.write(c);
        i++;
        break;
      }
      if (c == '{') {
        i++;
        b
          ..write('{')
          ..write(text(nested: true));
        if (i < s.length) {
          b.write('}');
          i++;
        }
        continue;
      }
      b.write(c);
      i++;
    }
    return b.toString();
  }

  String _copyTo(int end) {
    final out = s.substring(i, end);
    i = end;
    return out;
  }

  int _indexOfAny(int from) {
    for (var j = from; j < s.length; j++) {
      if (s[j] == ',' || s[j] == '}') return j;
    }
    return -1;
  }

  int _matchingBrace(int open) {
    var depth = 0;
    for (var j = open; j < s.length; j++) {
      if (s[j] == '{') depth++;
      if (s[j] == '}' && --depth == 0) return j;
    }
    return s.length - 1;
  }
}
