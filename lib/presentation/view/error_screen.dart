import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gn_mobile_monitoring/core/errors/app_logger.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/error_reporting_widget.dart';

/// Écran d'erreur générique qui affiche des informations sur une erreur
/// et permet à l'utilisateur de signaler le problème.
class ErrorScreen extends StatelessWidget {
  final String title;
  final String message;
  final Object? error;
  final StackTrace? stackTrace;
  final VoidCallback? onRetry;
  final VoidCallback? onGoBack;
  final IconData icon;

  const ErrorScreen({
    super.key,
    this.title = 'Une erreur s\'est produite',
    required this.message,
    this.error,
    this.stackTrace,
    this.onRetry,
    this.onGoBack,
    this.icon = Icons.error_outline,
  });

  /// Constructeur pratique pour les cas d'erreur simple
  ErrorScreen.simple(
    Object e, {
    Key? key,
    String title = 'Une erreur s\'est produite',
    VoidCallback? onRetry,
    VoidCallback? onGoBack,
  }) : this(
          key: key,
          title: title,
          message: e.toString(),
          error: e,
          stackTrace: StackTrace.current,
          onRetry: onRetry,
          onGoBack: onGoBack,
        );

  @override
  Widget build(BuildContext context) {
    // Log l'erreur
    if (error != null) {
      AppLogger().e(
        message,
        tag: 'ERROR_SCREEN',
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (onGoBack != null)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onGoBack,
              tooltip: 'Retour',
            ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.red,
                size: 64,
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (onRetry != null)
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Réessayer'),
                  onPressed: onRetry,
                ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.bug_report),
                label: const Text('Signaler un problème'),
                onPressed: () {
                  context.showErrorReportingDialog(
                    message: message,
                    error: error,
                    stackTrace: stackTrace,
                    onDismiss: onGoBack,
                  );
                },
              ),
              if (error != null && stackTrace != null) ...[
                const SizedBox(height: 24),
                _TechnicalDetailsExpansion(
                  error: error!,
                  stackTrace: stackTrace!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget qui affiche les détails techniques d'une erreur avec possibilité de les copier
class _TechnicalDetailsExpansion extends StatefulWidget {
  final Object error;
  final StackTrace stackTrace;

  const _TechnicalDetailsExpansion({
    required this.error,
    required this.stackTrace,
  });

  @override
  State<_TechnicalDetailsExpansion> createState() => _TechnicalDetailsExpansionState();
}

class _TechnicalDetailsExpansionState extends State<_TechnicalDetailsExpansion> {
  String? _copyStatus;

  /// Copier les détails de l'erreur dans le presse-papiers
  Future<void> _copyErrorToClipboard() async {
    final errorText = '''
ERREUR: ${widget.error}
STACK TRACE:
${widget.stackTrace}
''';

    try {
      await Clipboard.setData(ClipboardData(text: errorText));
      setState(() {
        _copyStatus = 'Erreur copiée dans le presse-papiers';
      });

      // Réinitialiser le statut après 3 secondes
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _copyStatus = null;
          });
        }
      });
    } catch (e) {
      setState(() {
        _copyStatus = 'Échec de la copie: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Détails techniques'),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Erreur:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(widget.error.toString()),
              const SizedBox(height: 16),
              const Text(
                'Stack Trace:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 150,
                child: SingleChildScrollView(
                  child: Text(
                    widget.stackTrace.toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
              if (_copyStatus != null) ...[
                const SizedBox(height: 8),
                Text(
                  _copyStatus!,
                  style: TextStyle(
                    color: _copyStatus!.contains('copiée') ? Colors.green : Colors.red,
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text('Copier'),
                  onPressed: _copyErrorToClipboard,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
