import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gn_mobile_monitoring/core/errors/app_logger.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/error_reporting_widget.dart';

/// Widget qui capture les erreurs dans son arbre de widgets enfant
/// et affiche un widget de repli en cas d'erreur.
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final String? tag;
  final Widget Function(BuildContext, FlutterErrorDetails)? fallbackBuilder;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.tag,
    this.fallbackBuilder,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  FlutterErrorDetails? _error;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.fallbackBuilder?.call(context, _error!) ??
          _DefaultErrorWidget(
            errorDetails: _error!,
            tag: widget.tag,
          );
    }

    // Configurer le gestionnaire d'erreurs Flutter
    FlutterError.onError = (FlutterErrorDetails errorDetails) {
      _reportError(errorDetails);
    };

    return widget.child;
  }

  void _reportError(FlutterErrorDetails details) {
    AppLogger().e(
      'Widget Error: ${details.exception}',
      tag: widget.tag ?? 'WIDGET',
      error: details.exception,
      stackTrace: details.stack,
    );

    setState(() {
      _error = details;
    });
  }
}

/// Widget d'erreur par défaut
class _DefaultErrorWidget extends StatefulWidget {
  final FlutterErrorDetails errorDetails;
  final String? tag;

  const _DefaultErrorWidget({
    super.key,
    required this.errorDetails,
    this.tag,
  });

  @override
  State<_DefaultErrorWidget> createState() => _DefaultErrorWidgetState();
}

class _DefaultErrorWidgetState extends State<_DefaultErrorWidget> {
  String? _copyStatus;

  /// Copier les détails de l'erreur
  Future<void> _copyErrorToClipboard() async {
    final errorText = '''
ERREUR: ${widget.errorDetails.exception}
DANS: ${widget.tag ?? 'une section inconnue'}
STACK TRACE:
${widget.errorDetails.stack}
''';
    
    try {
      await Clipboard.setData(ClipboardData(text: errorText));
      setState(() {
        _copyStatus = 'Erreur copiée';
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
        _copyStatus = 'Échec de la copie';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Une erreur s\'est produite',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Dans ${widget.tag ?? 'cette section'}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.errorDetails.exception.toString(),
              style: const TextStyle(color: Colors.red),
            ),
            if (_copyStatus != null) ...[
              const SizedBox(height: 8),
              Text(
                _copyStatus!,
                style: TextStyle(
                  color: _copyStatus!.contains('copiée') ? Colors.green : Colors.red,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text('Copier l\'erreur'),
                  onPressed: _copyErrorToClipboard,
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.bug_report),
                  label: const Text('Signaler'),
                  onPressed: () {
                    context.showErrorReportingDialog(
                      message: 'Erreur dans ${widget.tag ?? 'une section'} de l\'application',
                      error: widget.errorDetails.exception,
                      stackTrace: widget.errorDetails.stack,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}