import 'package:flutter/material.dart';
import 'package:gn_mobile_monitoring/core/errors/log_export_service.dart';

/// Widget pour exporter et copier les logs de l'application
class LogExportWidget extends StatefulWidget {
  /// Titre du widget (optionnel)
  final String? title;
  
  /// Afficher les options avancées par défaut
  final bool showAdvancedOptions;

  const LogExportWidget({
    super.key,
    this.title,
    this.showAdvancedOptions = false,
  });

  @override
  State<LogExportWidget> createState() => _LogExportWidgetState();
}

class _LogExportWidgetState extends State<LogExportWidget> {
  final LogExportService _logExportService = LogExportService();
  bool _isLoading = false;
  Map<String, int>? _logStats;
  bool _showAdvanced = false;

  @override
  void initState() {
    super.initState();
    _showAdvanced = widget.showAdvancedOptions;
    _loadLogStatistics();
  }

  Future<void> _loadLogStatistics() async {
    final stats = await _logExportService.getLogStatistics();
    if (mounted) {
      setState(() {
        _logStats = stats;
      });
    }
  }

  Future<void> _copyLogs({
    bool errorsOnly = false,
    bool recentOnly = false,
    List<String>? tags,
  }) async {
    setState(() {
      _isLoading = true;
    });

    bool success = false;
    String message = '';

    try {
      if (errorsOnly) {
        success = await _logExportService.copyErrorLogsToClipboard();
        message = success 
          ? 'Logs d\'erreur copiés dans le presse-papiers'
          : 'Échec de la copie des logs d\'erreur';
      } else if (recentOnly) {
        success = await _logExportService.copyRecentLogsToClipboard();
        message = success 
          ? 'Logs récents (24h) copiés dans le presse-papiers'
          : 'Échec de la copie des logs récents';
      } else if (tags != null) {
        success = await _logExportService.copyLogsByTags(tags);
        message = success 
          ? 'Logs filtrés copiés dans le presse-papiers'
          : 'Échec de la copie des logs filtrés';
      } else {
        success = await _logExportService.copyLogsToClipboard();
        message = success 
          ? 'Tous les logs copiés dans le presse-papiers'
          : 'Échec de la copie des logs';
      }
    } catch (e) {
      success = false;
      message = 'Erreur lors de la copie: $e';
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: success ? Colors.green : Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Titre
            Row(
              children: [
                const Icon(Icons.bug_report, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.title ?? 'Export des logs',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(_showAdvanced ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _showAdvanced = !_showAdvanced;
                    });
                  },
                  tooltip: _showAdvanced ? 'Masquer les options' : 'Afficher les options',
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Statistiques des logs
            if (_logStats != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistiques des logs:',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 16,
                      runSpacing: 4,
                      children: [
                        _buildStatChip('Total', _logStats!['total'] ?? 0, Colors.blue),
                        _buildStatChip('Erreurs', _logStats!['error'] ?? 0, Colors.red),
                        _buildStatChip('Avertissements', _logStats!['warning'] ?? 0, Colors.orange),
                        _buildStatChip('Info', _logStats!['info'] ?? 0, Colors.green),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Boutons principaux
            if (_isLoading) ...[
              const Center(
                child: CircularProgressIndicator(),
              ),
            ] else ...[
              // Bouton principal - Copier tous les logs
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _copyLogs(),
                  icon: const Icon(Icons.copy),
                  label: const Text('Copier tous les logs'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Boutons rapides
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _copyLogs(errorsOnly: true),
                      icon: const Icon(Icons.error_outline, size: 16),
                      label: const Text('Erreurs'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _copyLogs(recentOnly: true),
                      icon: const Icon(Icons.schedule, size: 16),
                      label: const Text('24h'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        side: const BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),

              // Options avancées
              if (_showAdvanced) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                
                Text(
                  'Options avancées:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Boutons par catégorie
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildTagButton('AUTH', 'Authentification', Colors.purple),
                    _buildTagButton('SYNC', 'Synchronisation', Colors.cyan),
                    _buildTagButton('API', 'Réseau', Colors.green),
                    _buildTagButton('DB', 'Base de données', Colors.brown),
                    _buildTagButton('FORM', 'Formulaires', Colors.indigo),
                    _buildTagButton('NAV', 'Navigation', Colors.teal),
                  ],
                ),
              ],
            ],

            const SizedBox(height: 12),

            // Note explicative
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Les logs sont copiés dans le presse-papiers. Vous pouvez les coller dans un email ou un message.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, int value, Color color) {
    return Chip(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      label: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
    );
  }

  Widget _buildTagButton(String tag, String label, Color color) {
    return SizedBox(
      height: 32,
      child: OutlinedButton(
        onPressed: () => _copyLogs(tags: [tag]),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          visualDensity: VisualDensity.compact,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}

/// Dialog pour afficher le widget d'export des logs
class LogExportDialog extends StatelessWidget {
  const LogExportDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 500,
          maxHeight: 600,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text('Export des logs'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Expanded(
              child: SingleChildScrollView(
                child: LogExportWidget(
                  showAdvancedOptions: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Méthode statique pour afficher le dialog
  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const LogExportDialog(),
    );
  }
}