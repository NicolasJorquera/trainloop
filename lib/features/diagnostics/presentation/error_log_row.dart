import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../platform/documents_client.dart';
import '../application/error_handling.dart';

/// S16 → DATOS Y PRIVACIDAD → «Registro de errores»: exporta a mano el
/// registro local (NF-04) con el selector del sistema (SAF). Es la única
/// forma en que sale del teléfono (NF-07).
class ErrorLogRow extends ConsumerWidget {
  const ErrorLogRow({super.key});

  static String fileName(DateTime now) =>
      'trainloop-errors-${now.year.toString().padLeft(4, '0')}-'
      '${now.month.toString().padLeft(2, '0')}-'
      '${now.day.toString().padLeft(2, '0')}.txt';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final count = ref.watch(errorCountProvider).value;
    return MergeSemantics(
      child: Semantics(
        button: true,
        child: InkWell(
          key: const Key('settings-error-log'),
          onTap: () => _export(context, ref),
          child: Container(
            constraints: const BoxConstraints(minHeight: TlSize.touchMin),
            padding: const EdgeInsets.symmetric(vertical: TlSpace.s3),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: c.line)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: TlSpace.s2,
                  children: [
                    Text(l10n.errorLogTitle, style: t.body),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (count != null)
                          Flexible(
                            child: Text(
                              l10n.errorLogCount(count),
                              key: const Key('error-log-count'),
                              style: t.bodySm.copyWith(color: c.inkMuted),
                            ),
                          ),
                        Icon(Icons.ios_share, color: c.inkMuted, size: 20),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: TlSpace.s1),
                Text(
                  l10n.errorLogHelp,
                  style: t.bodySm.copyWith(color: c.inkMuted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final view = View.of(context);
    final direction = Directionality.of(context);
    void say(String message) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
      SemanticsService.sendAnnouncement(view, message, direction);
    }

    final log = ref.read(errorLogProvider);
    if (await log.count() == 0) {
      say(l10n.errorLogEmpty);
      return;
    }
    try {
      final text = await log.exportText();
      final name = await ref
          .read(documentsClientProvider)
          .save(
            name: fileName(DateTime.now()),
            mimeType: 'text/plain',
            bytes: utf8.encode(text),
          );
      if (name != null) say(l10n.errorLogSaved(name));
    } on PlatformException {
      say(l10n.backupErrorIo);
    }
  }
}
