import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Valida la ficha de Play (`fastlane/metadata/android/<locale>/`): archivos
/// presentes y límites de caracteres de Play Console.
const _root = 'fastlane/metadata/android';
const _locales = ['es-419', 'en-US', 'pt-BR'];
const _limits = {
  'title.txt': 30,
  'short_description.txt': 80,
  'full_description.txt': 4000,
};
const _changelogLimit = 500;

/// Play cuenta caracteres Unicode, no bytes.
int _chars(String text) => text.trim().runes.length;

int _versionCode() {
  final line = File('pubspec.yaml')
      .readAsLinesSync()
      .firstWhere((l) => l.startsWith('version:'));
  return int.parse(line.split('+').last.trim());
}

void main() {
  for (final locale in _locales) {
    group(locale, () {
      for (final entry in _limits.entries) {
        test('${entry.key} ≤ ${entry.value} caracteres', () {
          final file = File('$_root/$locale/${entry.key}');
          expect(file.existsSync(), isTrue, reason: file.path);
          final n = _chars(file.readAsStringSync());
          expect(n, greaterThan(0), reason: file.path);
          expect(n, lessThanOrEqualTo(entry.value), reason: file.path);
        });
      }

      test('changelog del versionCode actual ≤ $_changelogLimit', () {
        final file = File('$_root/$locale/changelogs/${_versionCode()}.txt');
        expect(file.existsSync(), isTrue, reason: file.path);
        expect(
          _chars(file.readAsStringSync()),
          lessThanOrEqualTo(_changelogLimit),
        );
      });
    });
  }
}
