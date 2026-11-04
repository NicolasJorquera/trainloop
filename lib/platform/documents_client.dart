import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Archivo elegido en el selector del sistema.
class PickedDocument {
  const PickedDocument({required this.bytes, this.name});

  final Uint8List bytes;
  final String? name;
}

/// Selector de documentos del sistema (Storage Access Framework): guardar
/// y abrir archivos sin permisos de almacenamiento. Nativo en
/// `android/.../files/DocumentsBridge.kt`.
abstract interface class DocumentsClient {
  /// Abre «Guardar como» con [name]; devuelve el nombre final o `null` si
  /// la persona canceló.
  Future<String?> save({
    required String name,
    required String mimeType,
    required List<int> bytes,
  });

  /// Abre el selector para elegir un archivo; `null` si se canceló.
  Future<PickedDocument?> open();
}

class MethodChannelDocumentsClient implements DocumentsClient {
  static const _channel = MethodChannel('trainloop/documents');

  @override
  Future<String?> save({
    required String name,
    required String mimeType,
    required List<int> bytes,
  }) => _channel.invokeMethod<String>('create', {
    'name': name,
    'mimeType': mimeType,
    'bytes': Uint8List.fromList(bytes),
  });

  @override
  Future<PickedDocument?> open() async {
    final map = await _channel.invokeMapMethod<String, Object?>('open');
    if (map == null) return null;
    return PickedDocument(
      bytes: map['bytes']! as Uint8List,
      name: map['name'] as String?,
    );
  }
}

final documentsClientProvider = Provider<DocumentsClient>(
  (ref) => MethodChannelDocumentsClient(),
);
