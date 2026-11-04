import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/data/db/app_database.dart';

/// Base en memoria (SQLite nativo de la máquina de pruebas). Cierra las
/// consultas reactivas sin temporizador para no dejar timers pendientes en
/// las pruebas de widgets.
AppDatabase openTestDatabase() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase(
    DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ),
  );
}

/// Cierra [db] en una prueba de widgets sin colgarse: primero desmonta la app
/// (cancela las consultas reactivas) y luego cierra con el reloj real. Si una
/// expectativa falló a mitad de prueba, cerrar dentro del reloj simulado
/// dejaba el archivo de pruebas esperando para siempre.
Future<void> closeTestDatabase(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.runAsync(db.close);
}
