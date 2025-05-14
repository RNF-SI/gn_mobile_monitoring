import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gn_mobile_monitoring/core/errors/app_logger.dart';
import 'package:gn_mobile_monitoring/presentation/view/error_screen.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/error_reporting_widget.dart';

/// Un wrapper autour de FutureBuilder qui gère proprement les erreurs.
/// Il capture les exceptions, les journalise et affiche un widget d'erreur personnalisé.
class SafeFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(BuildContext context, T data) builder;
  final Widget? loadingWidget;
  final Widget Function(BuildContext context, Object error, StackTrace? stackTrace)?
      errorBuilder;
  final String? errorTag;

  const SafeFutureBuilder({
    Key? key,
    required this.future,
    required this.builder,
    this.loadingWidget,
    this.errorBuilder,
    this.errorTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        // Gérer l'état de chargement
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget ??
              const Center(child: CircularProgressIndicator());
        }

        // Gérer les erreurs
        if (snapshot.hasError) {
          final error = snapshot.error!;
          final stackTrace = snapshot.stackTrace;
          
          // Journaliser l'erreur
          AppLogger().e(
            'Erreur dans SafeFutureBuilder: $error',
            tag: errorTag ?? 'FUTURE',
            error: error,
            stackTrace: stackTrace,
          );

          // Utiliser le builder d'erreur personnalisé si fourni
          if (errorBuilder != null) {
            return errorBuilder!(context, error, stackTrace);
          }

          // Sinon, afficher notre écran d'erreur par défaut
          return _ErrorDisplay(
            error: error,
            stackTrace: stackTrace,
            tag: errorTag,
          );
        }

        // Données disponibles
        if (snapshot.hasData) {
          try {
            return builder(context, snapshot.data as T);
          } catch (e, stackTrace) {
            // Capturer les erreurs de construction
            AppLogger().e(
              'Erreur lors de la construction du widget avec les données: $e',
              tag: errorTag ?? 'FUTURE_BUILDER',
              error: e,
              stackTrace: stackTrace,
            );
            
            // Afficher une erreur si le builder échoue
            return _ErrorDisplay(
              error: e,
              stackTrace: stackTrace,
              tag: '${errorTag ?? "BUILDER"}_DISPLAY',
              title: 'Problème d\'affichage',
              message: 'Les données ont été chargées, mais un problème est survenu lors de leur affichage.',
              color: Colors.orange[800],
              icon: Icons.warning_amber,
            );
          }
        }

        // Cas où les données sont nulles mais sans erreur
        return builder(context, null as T);
      },
    );
  }
}

/// Widget d'affichage d'erreur avec option de copie et de signalement
class _ErrorDisplay extends StatefulWidget {
  final Object error;
  final StackTrace? stackTrace;
  final String? tag;
  final String title;
  final String message;
  final Color? color;
  final IconData icon;

  const _ErrorDisplay({
    required this.error,
    this.stackTrace,
    this.tag,
    this.title = 'Une erreur s\'est produite',
    this.message = 'Erreur lors du chargement des données',
    this.color,
    this.icon = Icons.error_outline,
  });

  @override
  State<_ErrorDisplay> createState() => _ErrorDisplayState();
}

class _ErrorDisplayState extends State<_ErrorDisplay> {
  String? _copyStatus;

  /// Copier les détails de l'erreur dans le presse-papiers
  Future<void> _copyErrorToClipboard() async {
    final errorText = '''
ERREUR: ${widget.error}
${widget.message}
${widget.tag != null ? 'DANS: ${widget.tag}' : ''}
${widget.stackTrace != null ? 'STACK TRACE:\n${widget.stackTrace}' : ''}
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
    final errorColor = widget.color ?? Colors.red;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: errorColor.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, color: errorColor, size: 48),
                const SizedBox(height: 16),
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: errorColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.error.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: errorColor,
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
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.copy),
                      label: const Text('Copier'),
                      onPressed: _copyErrorToClipboard,
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.email),
                      label: const Text('Signaler'),
                      onPressed: () {
                        context.showErrorReportingDialog(
                          message: widget.message,
                          error: widget.error,
                          stackTrace: widget.stackTrace,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}