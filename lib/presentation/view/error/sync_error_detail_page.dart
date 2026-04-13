import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/sync_error_banner.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/sync_error_navigation_service.dart';

/// Page dédiée pour afficher les détails des erreurs de synchronisation
class SyncErrorDetailPage extends ConsumerWidget {
  final String errorMessage;
  final String? errorTitle;
  final VoidCallback? onRetry;

  const SyncErrorDetailPage({
    super.key,
    required this.errorMessage,
    this.errorTitle,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Compter le nombre d'erreurs d'entités pour le titre
    final lines = errorMessage.split('\n');
    final Set<String> uniqueEntities = <String>{};

    for (final line in lines) {
      final errorVisitMatch =
          RegExp(r'ERREUR - Visite (\d+)\s*:|Visite (\d+)\s*:').firstMatch(line);
      final errorObservationMatch =
          RegExp(r'ERREUR - Observation (\d+)\s*:|Observation (\d+)\s*:')
              .firstMatch(line);
      final errorSiteMatch =
          RegExp(r'ERREUR - Site (\d+)\s*:|Site (\d+)\s*:').firstMatch(line);

      if (errorVisitMatch != null) {
        final id = errorVisitMatch.group(1) ?? errorVisitMatch.group(2);
        if (id != null) uniqueEntities.add('Visite-$id');
      } else if (errorObservationMatch != null) {
        final id =
            errorObservationMatch.group(1) ?? errorObservationMatch.group(2);
        if (id != null) uniqueEntities.add('Observation-$id');
      } else if (errorSiteMatch != null) {
        final id = errorSiteMatch.group(1) ?? errorSiteMatch.group(2);
        if (id != null) uniqueEntities.add('Site-$id');
      }
    }

    final String dynamicTitle = uniqueEntities.isNotEmpty
        ? '${uniqueEntities.length} erreur${uniqueEntities.length > 1 ? 's' : ''} de synchronisation'
        : errorTitle ?? 'Erreurs de synchronisation';

    return Scaffold(
      appBar: AppBar(
        title: Text(dynamicTitle),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () => _copyErrorToClipboard(context, ref),
            tooltip: 'Copier le rapport d\'erreur complet',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bannière d'erreur principal
            SyncErrorBanner(
              errorMessage: errorMessage,
              onRetry: onRetry,
            ),

            const SizedBox(height: 24),

            // Section des détails d'erreurs
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Détails des erreurs',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                    const SizedBox(height: 16),

                    // Affichage structuré des erreurs
                    _buildErrorDetails(context, ref),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Section d'aide
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comment résoudre ces erreurs',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildSolutionSuggestions(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: onRetry != null
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry!.call();
              },
              label: const Text('Réessayer'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            )
          : null,
    );
  }

  /// Copie le message d'erreur avec détails techniques dans le presse-papiers
  void _copyErrorToClipboard(BuildContext context, WidgetRef ref) async {
    // Créer un rapport concis et déduplicationné
    String fullErrorMessage = 'RAPPORT D\'ERREUR DE SYNCHRONISATION\n';
    fullErrorMessage += '${'=' * 50}\n\n';
    
    // Ajouter d'abord les erreurs de synchronisation détectées
    final syncErrors = _detectSyncErrors(errorMessage);
    if (syncErrors.isNotEmpty) {
      fullErrorMessage += 'ERREURS DE SYNCHRONISATION (${syncErrors.length}):\n';
      fullErrorMessage += '${'-' * 40}\n';
      for (int i = 0; i < syncErrors.length; i++) {
        final error = syncErrors[i];
        fullErrorMessage += '${i + 1}. Module: ${error['module']}\n';
        fullErrorMessage += '   Type: ${error['errorType']}\n';
        fullErrorMessage += '   Erreur: ${error['error']}\n';
        if (error['suggestion']?.isNotEmpty == true) {
          fullErrorMessage += '   Suggestion: ${error['suggestion']}\n';
        }
        fullErrorMessage += '\n';
      }
      fullErrorMessage += '\n';
    }
    
    // Analyser les erreurs d'entités pour enrichissement contextuel
    final lines = errorMessage.split('\n');
    final List<String> enrichedErrors = [];
    final Set<String> processedEntities = <String>{};

    for (final line in lines) {
      if (line.trim().isNotEmpty) {
        final errorVisitMatch =
            RegExp(r'ERREUR - Visite (\d+)\s*:\s*(.+)|Visite (\d+)\s*:\s*(.+)').firstMatch(line);
        final errorObservationMatch =
            RegExp(r'ERREUR - Observation (\d+)\s*:\s*(.+)|Observation (\d+)\s*:\s*(.+)').firstMatch(line);
        final errorSiteMatch =
            RegExp(r'ERREUR - Site (\d+)\s*:\s*(.+)|Site (\d+)\s*:\s*(.+)').firstMatch(line);

        String? entityKey;
        if (errorVisitMatch != null) {
          final id = errorVisitMatch.group(1) ?? errorVisitMatch.group(3);
          entityKey = 'Visite-$id';
        } else if (errorObservationMatch != null) {
          final id = errorObservationMatch.group(1) ?? errorObservationMatch.group(3);
          entityKey = 'Observation-$id';
        } else if (errorSiteMatch != null) {
          final id = errorSiteMatch.group(1) ?? errorSiteMatch.group(3);
          entityKey = 'Site-$id';
        }

        // Éviter les duplications d'entités
        if (entityKey != null && !processedEntities.contains(entityKey)) {
          processedEntities.add(entityKey);
          try {
            final enrichedMessage =
                await SyncErrorNavigationService.enrichErrorMessage(line, ref);
            enrichedErrors.add(enrichedMessage);
          } catch (e) {
            enrichedErrors.add(line); // Fallback au message original
          }
        }
      }
    }

    // Si on a des erreurs d'entités, les afficher avec contexte
    if (enrichedErrors.isNotEmpty) {
      fullErrorMessage += 'ERREURS D\'ENTITÉS (${enrichedErrors.length}):\n';
      fullErrorMessage += '${'-' * 40}\n';
      for (int i = 0; i < enrichedErrors.length; i++) {
        fullErrorMessage += '${i + 1}. ${enrichedErrors[i]}\n\n';
      }
    }

    // Ajouter le message technique brut SEULEMENT s'il contient des détails non capturés
    String rawTechnicalDetails = _extractTechnicalDetails(errorMessage);
    if (rawTechnicalDetails.isNotEmpty) {
      fullErrorMessage += 'DÉTAILS TECHNIQUES:\n';
      fullErrorMessage += '${'-' * 40}\n';
      fullErrorMessage += '$rawTechnicalDetails\n\n';
    }

    // Informations système concises
    fullErrorMessage += 'INFORMATIONS SYSTÈME:\n';
    fullErrorMessage += '${'-' * 40}\n';
    fullErrorMessage += '- Date: ${DateTime.now().toIso8601String()}\n';
    fullErrorMessage += '- Application: GeoNature Mobile\n';

    Clipboard.setData(ClipboardData(text: fullErrorMessage));

    // Vérifier que le context est toujours valide après l'opération async
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Rapport d\'erreur complet copié (avec détails techniques)'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  /// Extrait les détails techniques importants en évitant les duplications
  String _extractTechnicalDetails(String message) {
    final StringBuffer technicalDetails = StringBuffer();
    final lines = message.split('\n');
    final Set<String> addedLines = <String>{};
    
    for (final line in lines) {
      final trimmed = line.trim();
      
      // Capturer uniquement les lignes techniques importantes
      if (trimmed.startsWith('ERREUR:') || 
          trimmed.startsWith('DÉTAIL :') ||
          trimmed.startsWith('Détails serveur:') ||
          trimmed.startsWith('Détails techniques:') ||
          trimmed.startsWith('CONTEXTE :') ||
          trimmed.contains('psycopg2.errors') ||
          trimmed.contains('CheckViolation') ||
          trimmed.contains('sqlalchemy.exc') ||
          trimmed.contains('constraint') ||
          (trimmed.contains('check_') && trimmed.length < 200)) {
        
        // Éviter les duplications
        if (!addedLines.contains(trimmed) && trimmed.isNotEmpty) {
          addedLines.add(trimmed);
          technicalDetails.writeln(trimmed);
        }
      }
    }
    
    String result = technicalDetails.toString().trim();
    
    // Limiter la taille totale pour éviter un rapport gigantesque
    if (result.length > 1000) {
      final limitedLines = result.split('\n').take(10).join('\n');
      return '$limitedLines\n\n[...détails tronqués pour la lisibilité...]';
    }
    
    return result;
  }


  /// Construit l'affichage détaillé des erreurs
  /// Détecte les erreurs de synchronisation (réseau, configuration, etc.)
  List<Map<String, String>> _detectSyncErrors(String message) {
    final List<Map<String, String>> syncErrors = [];
    final lines = message.split('\n');
    
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      
      // Détecter les erreurs de synchronisation spécifiques
      if (trimmed.contains('Module ') && 
          (trimmed.contains('Erreur DNS') || 
           trimmed.contains('Erreur réseau') ||
           trimmed.contains('Erreur serveur') ||
           trimmed.contains('Timeout') ||
           trimmed.contains('failed host lookup') ||
           trimmed.contains('Erreur d\'autorisation'))) {
        
        // Extraire le module et le type d'erreur
        final moduleMatch = RegExp(r'Module ([^:]+):').firstMatch(trimmed);
        final moduleName = moduleMatch?.group(1) ?? 'Inconnu';
        
        String errorType = 'Erreur générale';
        String suggestion = '';
        
        if (trimmed.contains('failed host lookup') || trimmed.contains('Erreur DNS')) {
          errorType = 'Erreur DNS';
          suggestion = 'Vérifiez votre connexion Internet';
        } else if (trimmed.contains('Erreur réseau') || trimmed.contains('Network error')) {
          errorType = 'Erreur réseau';
          suggestion = 'Vérifiez votre connexion réseau';
        } else if (trimmed.contains('Timeout')) {
          errorType = 'Timeout';
          suggestion = 'Le serveur est lent, réessayez plus tard';
        } else if (trimmed.contains('Erreur serveur') || trimmed.contains('Status code')) {
          errorType = 'Erreur serveur';
          suggestion = 'Problème côté serveur, réessayez plus tard';
        } else if (trimmed.contains('Erreur d\'autorisation')) {
          errorType = 'Erreur d\'autorisation';
          suggestion = 'Reconnectez-vous';
        }
        
        syncErrors.add({
          'type': 'Synchronisation',
          'module': moduleName,
          'errorType': errorType,
          'error': trimmed,
          'suggestion': suggestion,
          'rawLine': line,
        });
      }
      // Détecter les erreurs générales de synchronisation
      else if (trimmed.contains('Erreur lors de la synchronisation') ||
               trimmed.contains('Erreur configuration') ||
               trimmed.contains('Erreur groupes de sites')) {
        
        String errorType = 'Erreur de synchronisation';
        String suggestion = 'Vérifiez votre connexion et réessayez';
        
        if (trimmed.contains('configuration')) {
          errorType = 'Erreur de configuration';
        } else if (trimmed.contains('groupes de sites')) {
          errorType = 'Erreur groupes de sites';
        }
        
        syncErrors.add({
          'type': 'Synchronisation',
          'module': 'Global',
          'errorType': errorType,
          'error': trimmed,
          'suggestion': suggestion,
          'rawLine': line,
        });
      }
    }
    
    return syncErrors;
  }

  Widget _buildErrorDetails(BuildContext context, WidgetRef ref) {
    // Détecter d'abord les erreurs de synchronisation
    final syncErrors = _detectSyncErrors(errorMessage);
    
    // Analyser le message d'erreur pour extraire uniquement les erreurs d'entités spécifiques
    final lines = errorMessage.split('\n');
    final List<Map<String, String>> errors = [];
    final Set<String> seenEntities = <String>{}; // Pour éviter les doublons

    for (final line in lines) {
      if (line.trim().isNotEmpty) {
        // Priorité aux patterns avec ERREUR - (plus informatifs)
        // \s* avant le : pour gérer "Visite 1 : ..." et "Visite 1: ..."
        final errorVisitMatch =
            RegExp(r'ERREUR - Visite (\d+)\s*:\s*(.+)').firstMatch(line);
        final errorObservationMatch =
            RegExp(r'ERREUR - Observation (\d+)\s*:\s*(.+)').firstMatch(line);
        final errorSiteMatch =
            RegExp(r'ERREUR - Site (\d+)\s*:\s*(.+)').firstMatch(line);

        String? entityKey;
        Map<String, String>? errorItem;

        if (errorVisitMatch != null) {
          entityKey = 'Visite-${errorVisitMatch.group(1)}';
          errorItem = {
            'type': 'Visite',
            'id': errorVisitMatch.group(1) ?? '',
            'error': errorVisitMatch.group(2) ?? '',
            'rawLine': line,
          };
        } else if (errorObservationMatch != null) {
          entityKey = 'Observation-${errorObservationMatch.group(1)}';
          errorItem = {
            'type': 'Observation',
            'id': errorObservationMatch.group(1) ?? '',
            'error': errorObservationMatch.group(2) ?? '',
            'rawLine': line,
          };
        } else if (errorSiteMatch != null) {
          entityKey = 'Site-${errorSiteMatch.group(1)}';
          errorItem = {
            'type': 'Site',
            'id': errorSiteMatch.group(1) ?? '',
            'error': errorSiteMatch.group(2) ?? '',
            'rawLine': line,
          };
        } else {
          // Patterns alternatifs seulement si on n'a pas déjà vu cette entité
          final observationMatch =
              RegExp(r'Observation (\d+)\s*:\s*(.+)').firstMatch(line);
          final visitMatch = RegExp(r'Visite (\d+)\s*:\s*(.+)').firstMatch(line);
          final siteMatch = RegExp(r'Site (\d+)\s*:\s*(.+)').firstMatch(line);

          if (observationMatch != null) {
            entityKey = 'Observation-${observationMatch.group(1)}';
            if (!seenEntities.contains(entityKey)) {
              errorItem = {
                'type': 'Observation',
                'id': observationMatch.group(1) ?? '',
                'error': observationMatch.group(2) ?? '',
                'rawLine': line,
              };
            }
          } else if (visitMatch != null) {
            entityKey = 'Visite-${visitMatch.group(1)}';
            if (!seenEntities.contains(entityKey)) {
              errorItem = {
                'type': 'Visite',
                'id': visitMatch.group(1) ?? '',
                'error': visitMatch.group(2) ?? '',
                'rawLine': line,
              };
            }
          } else if (siteMatch != null) {
            entityKey = 'Site-${siteMatch.group(1)}';
            if (!seenEntities.contains(entityKey)) {
              errorItem = {
                'type': 'Site',
                'id': siteMatch.group(1) ?? '',
                'error': siteMatch.group(2) ?? '',
                'rawLine': line,
              };
            }
          }
        }

        // Ajouter l'erreur si elle n'est pas déjà vue et correspond à une entité
        if (errorItem != null && entityKey != null) {
          if (!seenEntities.contains(entityKey)) {
            seenEntities.add(entityKey);
            errors.add(errorItem);
          }
        }
      }
    }

    if (errors.isEmpty) {
      return Column(
        children: [
          // Afficher un aperçu du message d'erreur original
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.error.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aperçu de l\'erreur',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  errorMessage.length > 200 
                      ? '${errorMessage.substring(0, 200)}...'
                      : errorMessage,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                      ),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  'Message complet disponible via le bouton copier (en-tête)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Aucune erreur spécifique d\'entité trouvée dans ce message. L\'erreur peut être d\'ordre général ou technique.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      );
    }

    // Gérer le cas de nombreuses erreurs
    const int maxDisplayedErrors = 5;
    final bool hasMany = errors.length > maxDisplayedErrors;
    final List<Map<String, String>> displayedErrors =
        hasMany ? errors.take(maxDisplayedErrors).toList() : errors;

    return Column(
      children: [
        // Affichage des erreurs de synchronisation en premier (plus importantes)
        if (syncErrors.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.error.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.sync_problem,
                      color: Theme.of(context).colorScheme.error,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Erreurs de synchronisation (${syncErrors.length})',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...syncErrors.map((error) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // En-tête avec module et type d'erreur
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Module: ${error['module']}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                error['errorType'] ?? 'Erreur',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.error,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Message d'erreur
                        Text(
                          error['error'] ?? '',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontFamily: 'monospace',
                              ),
                        ),
                        if (error['suggestion']?.isNotEmpty == true) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Suggestion: ${error['suggestion']}',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
        ],
        
        // Affichage d'un résumé si beaucoup d'erreurs
        if (hasMany) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Résumé des erreurs',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${errors.length} erreurs détectées. Affichage des $maxDisplayedErrors premières.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Consultez le rapport complet via le bouton copier pour voir toutes les erreurs.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
              ],
            ),
          ),
        ],

        // Affichage des erreurs (limitées)
        ...displayedErrors.map((error) => _buildErrorItem(context, error, ref)),

        // Bouton pour afficher plus si nécessaire
        if (hasMany) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                Text(
                  '+ ${errors.length - maxDisplayedErrors} erreurs supplémentaires',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Utilisez le bouton copier (en-tête) pour obtenir le rapport complet avec toutes les erreurs détaillées.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  /// Construit un élément d'erreur individuel
  Widget _buildErrorItem(
      BuildContext context, Map<String, String> error, WidgetRef ref) {
    final String type = error['type'] ?? '';
    final String id = error['id'] ?? '';
    final String errorText = error['error'] ?? '';
    final String rawLine = error['rawLine'] ?? '';

    Color entityColor;

    switch (type) {
      case 'Observation':
        entityColor = Theme.of(context).colorScheme.secondary;
        break;
      case 'Visite':
        entityColor = Theme.of(context).colorScheme.primary;
        break;
      default:
        entityColor = Theme.of(context).colorScheme.error;
    }

    // Déterminer si on peut naviguer vers cet élément
    final bool canNavigate =
        id.isNotEmpty && (type == 'Observation' || type == 'Visite' || type == 'Site');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: canNavigate
              ? () => _navigateToErrorItem(context, type, id, ref)
              : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.error.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête avec type et bouton d'action
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (id.isNotEmpty)
                            Text(
                              '$type $id',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: entityColor,
                                  ),
                            ),
                          if (canNavigate)
                            // Message enrichi avec contexte sera affiché ici
                            FutureBuilder<String>(
                              future:
                                  SyncErrorNavigationService.enrichErrorMessage(
                                      rawLine, ref),
                              builder: (context, snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.data != rawLine) {
                                  final enrichedLines =
                                      snapshot.data!.split('\n');
                                  if (enrichedLines.length >= 2) {
                                    return Text(
                                      enrichedLines[
                                          0], // Première ligne avec contexte
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: entityColor.withOpacity(0.8),
                                            fontWeight: FontWeight.w500,
                                          ),
                                    );
                                  }
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                        ],
                      ),
                    ),
                    if (canNavigate)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: entityColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Ouvrir',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: entityColor,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                // Message d'erreur simplifié
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .errorContainer
                        .withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: FutureBuilder<String>(
                    future: SyncErrorNavigationService.enrichErrorMessage(
                        rawLine, ref),
                    builder: (context, snapshot) {
                      String userMessage = errorText;

                      if (snapshot.hasData && snapshot.data != rawLine) {
                        final enrichedLines = snapshot.data!.split('\n');
                        if (enrichedLines.length >= 2) {
                          userMessage = enrichedLines.sublist(1).join('\n');
                        }
                      }

                      // Afficher seulement le message utilisateur (sans les détails techniques)
                      if (userMessage.contains('\nDétails techniques:')) {
                        final parts =
                            userMessage.split('\nDétails techniques:');
                        userMessage = parts[0];
                      }

                      return Text(
                        userMessage,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onErrorContainer,
                              fontWeight: FontWeight.w500,
                            ),
                      );
                    },
                  ),
                ),

                if (canNavigate) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Cliquez pour ouvrir et corriger cette erreur',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: entityColor.withOpacity(0.7),
                        ),
                  ),
                ],

                // Indication pour les détails techniques via copie
                const SizedBox(height: 8),
                Text(
                  'Détails techniques complets disponibles via le bouton copier (en-tête)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.7),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construit les suggestions de solution
  Widget _buildSolutionSuggestions(BuildContext context) {
    final List<Map<String, String>> suggestions = [];

    // Analyser le type d'erreurs pour suggérer des solutions
    if (errorMessage.contains('count_max') ||
        errorMessage.contains('dénombrement') ||
        errorMessage.contains('check_synthese_count_max')) {
      suggestions.add({
        'title': 'Erreur de dénombrement',
        'solution':
            'Le nombre maximum doit être supérieur ou égal au nombre minimum. Vérifiez les champs de dénombrement dans vos observations. Cette erreur peut aussi se produire si des valeurs nulles ou négatives sont présentes.',
      });
    }

    if (errorMessage.contains('cd_nom')) {
      suggestions.add({
        'title': 'Espèce manquante',
        'solution':
            'Vérifiez que toutes les observations ont une espèce sélectionnée avant la synchronisation.',
      });
    }

    if (errorMessage.contains('synthese') ||
        errorMessage.contains('Synthèse')) {
      suggestions.add({
        'title': 'Erreur de synthèse',
        'solution':
            'Problème lors de l\'intégration dans la synthèse GeoNature. Vérifiez que tous les champs obligatoires sont remplis correctement.',
      });
    }

    if (errorMessage.contains('constraint') ||
        errorMessage.contains('Constraint') ||
        errorMessage.contains('CheckViolation') ||
        errorMessage.contains('psycopg2.errors')) {
      suggestions.add({
        'title': 'Contrainte de base de données',
        'solution':
            'Une règle de validation de la base de données a été violée. Vérifiez la cohérence de vos données et assurez-vous que tous les champs respectent les contraintes requises (valeurs minimales/maximales, formats attendus, etc.).',
      });
    }

    if (errorMessage.contains('Timeout') || errorMessage.contains('timeout')) {
      suggestions.add({
        'title': 'Problème de connexion',
        'solution':
            'Vérifiez votre connexion internet et réessayez. Si le problème persiste, contactez l\'administrateur.',
      });
    }

    if (errorMessage.contains('permission') || errorMessage.contains('403')) {
      suggestions.add({
        'title': 'Permissions insuffisantes',
        'solution':
            'Vous n\'avez pas les droits nécessaires pour effectuer cette action. Contactez votre administrateur.',
      });
    }

    if (errorMessage.contains('duplicate') || errorMessage.contains('409')) {
      suggestions.add({
        'title': 'Données en conflit',
        'solution':
            'Cette donnée existe déjà sur le serveur. Supprimez la donnée locale ou contactez l\'administrateur.',
      });
    }

    // Suggestions générales si aucune spécifique trouvée
    if (suggestions.isEmpty) {
      suggestions.addAll([
        {
          'title': 'Vérifier la connexion',
          'solution': 'Assurez-vous d\'avoir une connexion internet stable.',
        },
        {
          'title': 'Réessayer plus tard',
          'solution': 'Le serveur peut être temporairement indisponible.',
        },
        {
          'title': 'Vérifier les données',
          'solution':
              'Assurez-vous que toutes les données obligatoires sont remplies.',
        },
      ]);
    }

    // Toujours ajouter la suggestion de contact administrateur
    suggestions.add({
      'title': 'Contacter l\'administrateur',
      'solution':
          'Si le problème persiste, contactez votre administrateur système. Si le problème est lié au code, contactez le développeur de l\'application à l\'adresse : si@rnfrance.org en joignant le rapport d\'erreur complet (bouton copier).',
    });

    return Column(
      children: suggestions
          .map((suggestion) => _buildSuggestionItem(context, suggestion))
          .toList(),
    );
  }

  /// Construit un élément de suggestion
  Widget _buildSuggestionItem(
      BuildContext context, Map<String, String> suggestion) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            suggestion['title'] ?? '',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            suggestion['solution'] ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  /// Navigue vers l'élément qui a causé l'erreur
  void _navigateToErrorItem(
      BuildContext context, String type, String id, WidgetRef ref) {
    // Utiliser WidgetsBinding pour s'assurer que la navigation se fait après le build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;

      try {
        final int entityId = int.parse(id);

        // Afficher un dialog de confirmation avec les options
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Ouvrir $type $id'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Que souhaitez-vous faire avec ${type.toLowerCase()} $id ?'),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Vous serez redirigé vers la page de ${type.toLowerCase()} pour corriger le problème.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _performNavigation(context, type, entityId, ref);
                },
                child: const Text('Ouvrir'),
              ),
            ],
          ),
        );
      } catch (e) {
        // Si l'ID n'est pas un nombre valide
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Impossible d\'ouvrir $type $id : ID invalide'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    });
  }

  /// Effectue la navigation vers l'élément spécifié en utilisant le service de navigation
  void _performNavigation(
      BuildContext context, String type, int entityId, WidgetRef ref) {
    // Créer un message d'erreur factice pour extraire les informations
    String fakeErrorMessage =
        'ERREUR - ${type.capitalize()} $entityId: erreur de test';

    // Utiliser notre service de navigation
    SyncErrorNavigationService.navigateToSyncErrorItem(
      context,
      fakeErrorMessage,
      ref,
    ).then((success) {
      if (!success) {
        // Si la navigation a échoué, afficher un message d'erreur
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Impossible de naviguer vers $type $entityId'),
              backgroundColor: Theme.of(context).colorScheme.error,
              action: SnackBarAction(
                label: 'OK',
                onPressed: () =>
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              ),
            ),
          );
        }
      }
    }).catchError((error) {
      // Si une erreur s'est produite pendant la navigation
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la navigation: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });
  }
}

/// Extension pour capitaliser la première lettre d'une chaîne
extension SyncErrorStringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
