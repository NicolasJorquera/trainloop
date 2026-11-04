import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/features/diagnostics/application/error_handling.dart';

void main() {
  late Directory dir;
  var now = DateTime.utc(2026, 11, 4, 12);

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('tl_errors');
    now = DateTime.utc(2026, 11, 4, 12);
  });

  tearDown(() => dir.delete(recursive: true));

  ErrorLog open() => ErrorLog(
    directory: () async => dir,
    appVersion: '1.0.0+1',
    clock: () => now,
  );

  test('guarda en archivo y sobrevive a reabrir la app', () async {
    final log = open();
    log.record(
      StateError('boom'),
      StackTrace.current,
      source: ErrorSource.platform,
      fatal: true,
    );
    final entries = await log.entries();
    expect(entries.single.message, 'StateError: Bad state: boom');
    expect(entries.single.fatal, isTrue);
    expect(entries.single.appVersion, '1.0.0+1');
    expect(File('${dir.path}/${ErrorLog.fileName}').existsSync(), isTrue);

    final again = await open().entries();
    expect(again.single.message, entries.single.message);
    expect(again.single.at, now);
  });

  test('anillo acotado: guarda solo las últimas entradas', () async {
    final log = open();
    for (var i = 0; i < ErrorLog.maxEntries + 7; i++) {
      log.record('error $i', null, source: ErrorSource.caught);
    }
    final entries = await log.entries();
    expect(entries, hasLength(ErrorLog.maxEntries));
    expect(entries.first.message, 'String: error 7');
    expect(entries.last.message, 'String: error ${ErrorLog.maxEntries + 6}');
  });

  test('el mismo error seguido se agrupa con un contador', () async {
    final log = open();
    final stack = StackTrace.current;
    for (var i = 0; i < 3; i++) {
      now = now.add(const Duration(seconds: 1));
      log.record('igual', stack, source: ErrorSource.flutter);
    }
    log.record('otro', stack, source: ErrorSource.flutter);
    final entries = await log.entries();
    expect(entries, hasLength(2));
    expect(entries.first.count, 3);
    expect(entries.first.at, DateTime.utc(2026, 11, 4, 12, 0, 3));
  });

  test('recorta mensajes y pilas largas', () async {
    final log = open();
    log.record(
      'x' * 5000,
      StackTrace.fromString(List.generate(100, (i) => '#$i f()').join('\n')),
      source: ErrorSource.caught,
    );
    final e = (await log.entries()).single;
    expect(e.message.length, lessThanOrEqualTo(ErrorLog.maxMessageChars + 1));
    expect(e.stack.split('\n'), hasLength(ErrorLog.maxStackLines + 1));
  });

  test('una línea dañada se salta', () async {
    File('${dir.path}/${ErrorLog.fileName}').writeAsStringSync(
      '{"roto\n'
      '{"at":"2026-11-01T00:00:00.000Z","source":"flutter","fatal":false,'
      '"message":"ok","stack":"","appVersion":"1","count":1}\n',
    );
    expect((await open().entries()).single.message, 'ok');
  });

  test('exporta los errores de Dart y los del motor nativo', () async {
    File(
      '${dir.path}/${ErrorLog.nativeFileName}',
    ).writeAsStringSync('2026-11-02 TimerService\njava.lang.X\n---\n');
    final log = open()..record('dart', null, source: ErrorSource.caught);
    expect(await log.count(), 2);
    final text = await log.exportText();
    expect(text, contains('Trainloop 1.0.0+1'));
    expect(text, contains('String: dart'));
    expect(text, contains('java.lang.X'));

    await log.clear();
    expect(await log.count(), 0);
  });

  test('installErrorHandlers registra errores de Flutter y asíncronos', () {
    final log = ErrorLog.memory();
    final previousFlutter = FlutterError.onError;
    final previousDispatcher = PlatformDispatcher.instance.onError;
    addTearDown(() {
      FlutterError.onError = previousFlutter;
      PlatformDispatcher.instance.onError = previousDispatcher;
    });
    FlutterError.onError = (_) {};
    PlatformDispatcher.instance.onError = null;
    installErrorHandlers(log);

    FlutterError.onError!(FlutterErrorDetails(exception: StateError('build')));
    PlatformDispatcher.instance.onError!(StateError('async'), StackTrace.empty);
    return expectLater(
      log.entries().then((e) => e.map((x) => (x.source, x.fatal))),
      completion([(ErrorSource.flutter, true), (ErrorSource.platform, true)]),
    );
  });
}
