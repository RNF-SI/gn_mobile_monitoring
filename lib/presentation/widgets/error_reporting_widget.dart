import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gn_mobile_monitoring/core/errors/app_error_reporter.dart';
import 'package:gn_mobile_monitoring/core/errors/app_logger.dart';
import 'package:url_launcher/url_launcher.dart';

/// Widget pour afficher une boîte de dialogue de rapport d'erreur
class ErrorReportingDialog extends StatefulWidget {
  final String errorMessage;
  final Object? error;
  final StackTrace? stackTrace;
  final VoidCallback? onDismiss;

  const ErrorReportingDialog({
    super.key,
    required this.errorMessage,
    this.error,
    this.stackTrace,
    this.onDismiss,
  });

  @override
  State<ErrorReportingDialog> createState() => _ErrorReportingDialogState();
}

class _ErrorReportingDialogState extends State<ErrorReportingDialog> {
  final TextEditingController _descriptionController = TextEditingController();
  bool _isSending = false;
  String? _resultMessage;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  /// Récupérer le texte complet de l'erreur pour la copie
  String _getErrorTextForCopy() {
    final StringBuffer buffer = StringBuffer();
    
    buffer.writeln('ERREUR: ${widget.errorMessage}');
    buffer.writeln('');
    
    if (widget.error != null) {
      buffer.writeln('DÉTAILS: ${widget.error.toString()}');
      buffer.writeln('');
    }
    
    if (widget.stackTrace != null) {
      buffer.writeln('STACK TRACE:');
      buffer.writeln(widget.stackTrace.toString());
    }
    
    return buffer.toString();
  }
  
  /// Envoyer un email au développeur avec les détails de l'erreur
  Future<void> _sendEmailReport() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'antoine.schlegel@rnfrance.org',
      query: _encodeQueryParameters({
        'subject': 'Rapport d\'erreur GN Mobile Monitoring',
        'body': '''
Description: ${_descriptionController.text}

----------
ERREUR: ${widget.errorMessage}
${widget.error != null ? '\nDÉTAILS: ${widget.error.toString()}' : ''}
${widget.stackTrace != null ? '\nSTACK TRACE:\n${widget.stackTrace.toString()}' : ''}
''',
      }),
    );
    
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        
        setState(() {
          _resultMessage = 'Client email ouvert';
        });
      } else {
        setState(() {
          _resultMessage = 'Impossible d\'ouvrir le client email';
        });
      }
    } catch (e) {
      setState(() {
        _resultMessage = 'Erreur lors de l\'ouverture du client email: $e';
      });
    }
  }
  
  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((entry) => 
            '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}')
        .join('&');
  }
  
  /// Copier les détails de l'erreur dans le presse-papiers
  Future<void> _copyErrorToClipboard() async {
    final String errorText = _getErrorTextForCopy();
    
    try {
      await Clipboard.setData(ClipboardData(text: errorText));
      setState(() {
        _resultMessage = 'Erreur copiée dans le presse-papiers';
      });
    } catch (e) {
      setState(() {
        _resultMessage = 'Échec de la copie: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Une erreur s\'est produite'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.errorMessage,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pour nous aider à résoudre ce problème, veuillez décrire ce que vous faisiez au moment de l\'erreur:',
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Description (optionnelle)',
              ),
            ),
            if (_resultMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _resultMessage!,
                style: TextStyle(
                  color: _resultMessage!.contains('succès') || _resultMessage!.contains('copié')
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ],
            if (_isSending) ...[
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
            ],
            const SizedBox(height: 8),
            Visibility(
              visible: widget.error != null || widget.stackTrace != null,
              child: ExpansionTile(
                title: const Text('Détails techniques'),
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.error != null) ...[
                          const Text(
                            'Erreur:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(widget.error.toString()),
                          const SizedBox(height: 8),
                        ],
                        if (widget.stackTrace != null) ...[
                          const Text(
                            'Stack Trace:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.stackTrace.toString().length > 500
                                ? '${widget.stackTrace.toString().substring(0, 500)}...'
                                : widget.stackTrace.toString(),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              icon: const Icon(Icons.copy),
                              label: const Text('Copier'),
                              onPressed: _copyErrorToClipboard,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSending
              ? null
              : () {
                  Navigator.of(context).pop();
                  if (widget.onDismiss != null) {
                    widget.onDismiss!();
                  }
                },
          child: const Text('Annuler'),
        ),
        OutlinedButton.icon(
          icon: const Icon(Icons.email),
          label: const Text('Email'),
          onPressed: _isSending ? null : _sendEmailReport,
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.save),
          label: const Text('Enregistrer'),
          onPressed: _isSending ? null : _sendReport,
        ),
      ],
    );
  }

  Future<void> _sendReport() async {
    if (_isSending) return;

    setState(() {
      _isSending = true;
      _resultMessage = null;
    });

    try {
      // Log l'erreur avec les détails
      AppLogger().e(
        widget.errorMessage,
        tag: 'USER_REPORT',
        error: widget.error,
        stackTrace: widget.stackTrace,
      );

      // Envoyer le rapport
      final success = await AppErrorReporter().sendErrorReport(
        userDescription: _descriptionController.text,
        error: widget.error,
        stackTrace: widget.stackTrace,
      );

      setState(() {
        _isSending = false;
        _resultMessage = success
            ? 'Rapport envoyé avec succès. Merci!'
            : 'Échec de l\'envoi du rapport. Veuillez réessayer.';
      });

      if (success) {
        // Fermer la boîte de dialogue après un court délai
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.of(context).pop();
            if (widget.onDismiss != null) {
              widget.onDismiss!();
            }
          }
        });
      }
    } catch (e) {
      setState(() {
        _isSending = false;
        _resultMessage = 'Erreur lors de l\'envoi: $e';
      });
    }
  }
}

/// Extension de BuildContext pour faciliter l'affichage des dialogues d'erreur
extension ErrorReportingExtension on BuildContext {
  /// Affiche une boîte de dialogue de rapport d'erreur
  Future<void> showErrorReportingDialog({
    required String message,
    Object? error,
    StackTrace? stackTrace,
    VoidCallback? onDismiss,
  }) async {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) => ErrorReportingDialog(
        errorMessage: message,
        error: error,
        stackTrace: stackTrace,
        onDismiss: onDismiss,
      ),
    );
  }
}