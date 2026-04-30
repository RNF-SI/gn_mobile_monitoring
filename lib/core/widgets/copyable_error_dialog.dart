import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Affiche une boîte de dialogue d'erreur dont le contenu est sélectionnable
/// et peut être copié en un clic, pour faciliter le report de bugs
/// (pas besoin de captures d'écran).
Future<void> showCopyableErrorDialog(
  BuildContext context, {
  required String title,
  required String message,
  Map<String, Object?> details = const {},
}) async {
  final fullText = _buildFullText(title, message, details);

  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: SelectableText(title),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              SelectableText(message),
              if (details.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 8),
                for (final entry in details.entries) ...[
                  Text(
                    entry.key,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  SelectableText('${entry.value}'),
                  const SizedBox(height: 8),
                ],
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton.icon(
          icon: const Icon(Icons.copy, size: 18),
          label: const Text('Copier'),
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: fullText));
            if (ctx.mounted) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(
                  content: Text('Erreur copiée dans le presse-papier'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

String _buildFullText(
  String title,
  String message,
  Map<String, Object?> details,
) {
  final buffer = StringBuffer()
    ..writeln(title)
    ..writeln()
    ..writeln(message);

  if (details.isNotEmpty) {
    buffer.writeln();
    for (final entry in details.entries) {
      buffer
        ..writeln('--- ${entry.key} ---')
        ..writeln('${entry.value}');
    }
  }

  return buffer.toString();
}
