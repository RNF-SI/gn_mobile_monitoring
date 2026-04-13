import 'package:flutter/material.dart';
import 'package:gn_mobile_monitoring/presentation/view/error/sync_error_detail_page.dart';

/// Widget affichant un bandeau d'information sur les erreurs de synchronisation ascendante
class SyncErrorBanner extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;
  final bool showDetailButton;
  final String? detailButtonText;

  const SyncErrorBanner({
    super.key,
    required this.errorMessage,
    this.onRetry,
    this.showDetailButton = false,
    this.detailButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.error,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.error,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Erreur de synchronisation',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _formatErrorMessage(errorMessage),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (onRetry != null || showDetailButton) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                if (onRetry != null) ...[
                  ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Réessayer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Theme.of(context).colorScheme.onError,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  if (showDetailButton) const SizedBox(width: 8),
                ],
                if (showDetailButton)
                  ElevatedButton.icon(
                    onPressed: () => _navigateToDetailPage(context),
                    icon: const Icon(Icons.info_outline, size: 16),
                    label: Text(detailButtonText ?? 'Voir détails'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Formate le message d'erreur pour un affichage plus user-friendly
  String _formatErrorMessage(String message) {
    // Extraire les erreurs spécifiques d'observations si présentes
    if (message.contains('Observation') && message.contains(':')) {
      final lines = message.split('\n');
      final observationErrors = <String>[];
      
      for (final line in lines) {
        if (line.trim().startsWith('Observation') && line.contains(':')) {
          // Extraire le message d'erreur après les ":"
          final parts = line.split(':');
          if (parts.length > 1) {
            observationErrors.add(parts.sublist(1).join(':').trim());
          }
        }
      }
      
      if (observationErrors.isNotEmpty) {
        if (observationErrors.length == 1) {
          return 'Erreur lors de l\'envoi d\'une observation :\n${observationErrors.first}';
        } else {
          return 'Erreurs lors de l\'envoi de ${observationErrors.length} observations :\n• ${observationErrors.join('\n• ')}';
        }
      }
    }
    
    // Extraire les erreurs de visite si présentes
    if (message.contains('Visite') && message.contains(':')) {
      final lines = message.split('\n');
      final visitErrors = <String>[];
      
      for (final line in lines) {
        if (line.trim().startsWith('Visite') && line.contains(':')) {
          final parts = line.split(':');
          if (parts.length > 1) {
            visitErrors.add(parts.sublist(1).join(':').trim());
          }
        }
      }
      
      if (visitErrors.isNotEmpty) {
        if (visitErrors.length == 1) {
          return 'Erreur lors de l\'envoi d\'une visite :\n${visitErrors.first}';
        } else {
          return 'Erreurs lors de l\'envoi de ${visitErrors.length} visites :\n• ${visitErrors.join('\n• ')}';
        }
      }
    }
    
    // Simplifier les messages génériques
    if (message.contains('Pas de connexion Internet')) {
      return 'Aucune connexion Internet disponible. Vérifiez votre connexion et réessayez.';
    }
    
    if (message.contains('Utilisateur non connecté')) {
      return 'Session expirée. Veuillez vous reconnecter.';
    }
    
    // Traitement intelligent des erreurs PostgreSQL/techniques
    if (message.contains('psycopg2') || message.contains('constraint') || 
        message.contains('CheckViolation') || message.contains('ERREUR:') ||
        message.contains('DÉTAIL :') || message.contains('CONTEXTE :')) {
      return _formatTechnicalError(message);
    }
    
    // Raccourcir les messages trop longs pour les autres cas
    if (message.length > 200) {
      return '${message.substring(0, 200)}...\n\nMessage complet disponible via "Voir détails"';
    }
    
    return message;
  }

  /// Formate intelligemment les erreurs techniques avec un résumé très concis
  String _formatTechnicalError(String message) {
    // Identifier le type d'erreur et donner un message utilisateur simple
    
    if (message.contains('check_synthese_count_max')) {
      return 'Erreur de validation: Contrainte de dénombrement non respectée.\n\n💡 Détails techniques complets via "Voir détails"';
    }
    
    if (message.contains('check_') && message.contains('constraint')) {
      // Extraire le nom de la contrainte
      final constraintMatch = RegExp(r'check_\w+').firstMatch(message);
      String constraintName = constraintMatch?.group(0) ?? 'contrainte inconnue';
      return 'Erreur de validation: La contrainte "$constraintName" a été violée.\n\n💡 Détails techniques complets via "Voir détails"';
    }
    
    if (message.contains('unique') && message.contains('constraint')) {
      return 'Erreur de doublon: Cette donnée existe déjà sur le serveur.\n\n💡 Détails techniques complets via "Voir détails"';
    }
    
    if (message.contains('foreign key') || message.contains('fkey')) {
      return 'Erreur de référence: Un élément référencé n\'existe pas.\n\n💡 Détails techniques complets via "Voir détails"';
    }
    
    if (message.contains('not null') || message.contains('null value')) {
      return 'Erreur de données: Un champ obligatoire est manquant.\n\n💡 Détails techniques complets via "Voir détails"';
    }
    
    if (message.contains('psycopg2') || message.contains('CheckViolation')) {
      return 'Erreur de base de données: Problème lors de l\'enregistrement.\n\n💡 Détails techniques complets via "Voir détails"';
    }
    
    if (message.contains('ERREUR:')) {
      return 'Erreur serveur: Problème technique détecté.\n\n💡 Détails techniques complets via "Voir détails"';
    }
    
    // Fallback: message court générique
    return 'Erreur technique détectée.\n\n💡 Détails complets disponibles via "Voir détails"';
  }

  /// Navigue vers la page de détail des erreurs
  void _navigateToDetailPage(BuildContext context) {
    // Utiliser WidgetsBinding pour s'assurer que la navigation se fait après le build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SyncErrorDetailPage(
              errorMessage: errorMessage,
              errorTitle: 'Détails des erreurs de synchronisation',
              onRetry: onRetry,
            ),
          ),
        );
      }
    });
  }
}