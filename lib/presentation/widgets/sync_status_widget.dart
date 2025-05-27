import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart' as domain;
import 'package:gn_mobile_monitoring/presentation/state/sync_status.dart';
import 'package:gn_mobile_monitoring/presentation/view/error/sync_error_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sync_service.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/conflict_dialog_widget.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/conflict_navigation_service.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/sync_error_banner.dart';
import 'package:intl/intl.dart';

/// Widget pour afficher le statut de synchronisation
class SyncStatusWidget extends ConsumerStatefulWidget {
  /// Taille du widget - petit ou grand
  final bool isSmall;

  /// Permet de définir si le widget est dans un appbar
  final bool isInAppBar;

  /// Callback appelé lorsqu'on demande une synchronisation manuelle
  final VoidCallback? onSyncRequested;

  const SyncStatusWidget({
    super.key,
    this.isSmall = false,
    this.isInAppBar = false,
    this.onSyncRequested,
  });

  @override
  SyncStatusWidgetState createState() => SyncStatusWidgetState();
}

class SyncStatusWidgetState extends ConsumerState<SyncStatusWidget> {
  // État d'expansion des détails de synchronisation
  bool _detailsExpanded = true;

  @override
  Widget build(BuildContext context) {
    final syncStatus = ref.watch(syncServiceProvider);

    // Debug: Afficher l'état de la synchronisation et les conflits
    debugPrint('SyncStatusWidget - État actuel: ${syncStatus.state}');
    if (syncStatus.conflicts != null) {
      debugPrint(
          'SyncStatusWidget - Nombre de conflits: ${syncStatus.conflicts!.length}');
    }

    // Couleur du texte en fonction du contexte
    final Color textColor = widget.isInAppBar
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSurface;

    // Couleur de l'icône en fonction de l'état
    Color iconColor = textColor;
    if (syncStatus.state == SyncState.failure) {
      iconColor = Theme.of(context).colorScheme.error;
    } else if (syncStatus.state == SyncState.success) {
      iconColor = Theme.of(context).colorScheme.primary;
    } else if (syncStatus.state == SyncState.conflictDetected) {
      iconColor = Theme.of(context).colorScheme.secondary;
    }

    // Icône en fonction de l'état
    IconData iconData;
    switch (syncStatus.state) {
      case SyncState.idle:
        iconData = Icons.sync;
        break;
      case SyncState.inProgress:
        iconData = Icons.sync;
        break;
      case SyncState.success:
        iconData = Icons.check_circle;
        break;
      case SyncState.failure:
        iconData = Icons.error;
        break;
      case SyncState.conflictDetected:
        iconData = Icons.warning;
        break;
    }

    // Version réduite pour l'appbar
    if (widget.isSmall) {
      return Tooltip(
        message: 'Utilisez le menu en haut à droite pour synchroniser',
        child: IconButton(
          icon: Stack(
            alignment: Alignment.center,
            children: [
              _buildIcon(iconData, iconColor, syncStatus),
              if (syncStatus.state == SyncState.inProgress &&
                  syncStatus.currentStep != null &&
                  syncStatus.progress > 0)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        '${(syncStatus.progress * 100).round()}%',
                        style: TextStyle(
                          fontSize: 6,
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Ne pas lancer de synchronisation en cliquant sur l'icône
          // L'utilisateur doit passer par le menu pour synchroniser
          onPressed: null,
        ),
      );
    }

    // Version complète pour ailleurs
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // En-tête cliquable avec informations sur la synchronisation
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Seulement inverser l'état d'expansion des détails au clic
                setState(() {
                  _detailsExpanded = !_detailsExpanded;
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(
                  // Fond légèrement coloré pour indiquer qu'il est cliquable
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    _buildIcon(iconData, iconColor, syncStatus),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getStatusText(syncStatus),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (syncStatus.lastSync != null)
                            Text(
                              'Dernière synchronisation complète: ${_formatDate(syncStatus.lastSync!)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          // Ajouter l'info sur la prochaine synchronisation complète
                          if (syncStatus.nextFullSyncInfo != null)
                            Row(
                              children: [
                                Icon(
                                  Icons.update,
                                  size: 12,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.7),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    syncStatus.nextFullSyncInfo!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.9),
                                          fontStyle: FontStyle.italic,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),

                          // Afficher les conflits s'il y en a - avec un bouton dédié
                          // Afficher les conflits même en cas d'erreur (failure)
                          if (syncStatus.conflicts != null && syncStatus.conflicts!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: ElevatedButton.icon(
                                onPressed: () => _showConflictsDialog(
                                    context, syncStatus.conflicts ?? []),
                                icon: Icon(
                                  Icons.warning_amber_outlined,
                                  size: 14,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                ),
                                label: Text(
                                  'Résoudre ${syncStatus.conflicts!.length} conflits downstream',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .errorContainer,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),

                          // Afficher les erreurs de synchronisation (toutes les erreurs)
                          if (syncStatus.state == SyncState.failure &&
                              syncStatus.errorMessage != null &&
                              syncStatus.errorMessage!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Debug: afficher le message d'erreur dans les logs
                                  debugPrint('=== ERROR BUTTON CLICKED ===');
                                  debugPrint('Error message: ${syncStatus.errorMessage}');
                                  debugPrint('Is upstream error: ${_isUpstreamSyncError(syncStatus.errorMessage!)}');
                                  debugPrint('============================');
                                  
                                  _navigateToErrorPage(context, syncStatus.errorMessage!);
                                },
                                icon: Icon(
                                  Icons.error_outline,
                                  size: 14,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                ),
                                label: Text(
                                  _isUpstreamSyncError(syncStatus.errorMessage!) 
                                    ? 'Voir les erreurs upstream'
                                    : 'Voir les détails de l\'erreur',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .errorContainer,
                                  foregroundColor: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),

                          // Instruction discrète pour indiquer que c'est cliquable
                          Text(
                            'Cliquez pour ${_detailsExpanded ? 'masquer' : 'afficher'} les détails',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontStyle: FontStyle.italic,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.7),
                                      fontSize: 10,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    // Afficher icône d'expansion/réduction
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        _detailsExpanded
                            ? Icons.expand_less
                            : Icons.expand_more,
                        color: Theme.of(context).colorScheme.primary,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Barre de progression (uniquement pendant la synchronisation)
          if (syncStatus.state == SyncState.inProgress)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: LinearProgressIndicator(
                value: syncStatus.progress > 0 ? syncStatus.progress : null,
              ),
            ),

          // Détails de progression si synchro en cours et si l'affichage détaillé est activé
          if (syncStatus.state == SyncState.inProgress &&
              _detailsExpanded &&
              syncStatus.currentStep != null &&
              syncStatus.itemsTotal > 0)
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progression: ${syncStatus.itemsProcessed}/${syncStatus.itemsTotal}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _detailsExpanded = !_detailsExpanded;
                            });
                          },
                          child: Row(
                            children: [
                              Text(
                                'Masquer',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Icon(
                                Icons.expand_less,
                                size: 16,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: syncStatus.progress,
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),

          // Bouton "Voir plus" si synchro en cours et si l'affichage détaillé est désactivé
          if (syncStatus.state == SyncState.inProgress &&
              !_detailsExpanded &&
              syncStatus.currentStep != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _detailsExpanded = !_detailsExpanded;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Voir les détails',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Icon(
                      Icons.expand_more,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ],
                ),
              ),
            ),

          // Affichage des détails de synchronisation (quand _detailsExpanded = true)
          if (_detailsExpanded && syncStatus.additionalInfo != null)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 4.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Détails de la synchronisation',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                          const SizedBox(height: 8),
                          _buildSyncSummary(
                              context, syncStatus.additionalInfo!),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Construit l'icône animée ou statique selon l'état
  Widget _buildIcon(IconData iconData, Color iconColor, SyncStatus syncStatus) {
    // Animer l'icône si synchro en cours
    if (syncStatus.state == SyncState.inProgress) {
      return RotationTransition(
        turns: AlwaysStoppedAnimation(
            DateTime.now().millisecondsSinceEpoch % 3600 / 3600),
        child: Icon(
          iconData,
          color: iconColor,
          size: widget.isSmall ? 24 : 28,
        ),
      );
    }

    // Badge pour nombre de conflits
    if (syncStatus.state == SyncState.conflictDetected &&
        syncStatus.conflicts != null &&
        syncStatus.conflicts!.isNotEmpty) {
      return Badge(
        label: Text(
          syncStatus.conflicts!.length.toString(),
          style: const TextStyle(fontSize: 10),
        ),
        child: Icon(
          iconData,
          color: iconColor,
          size: widget.isSmall ? 24 : 28,
        ),
      );
    }

    // Icône simple
    return Icon(
      iconData,
      color: iconColor,
      size: widget.isSmall ? 24 : 28,
    );
  }

  // Obtient le texte à afficher selon l'état
  String _getStatusText(SyncStatus syncStatus) {
    switch (syncStatus.state) {
      case SyncState.idle:
        return 'En attente de synchronisation';
      case SyncState.inProgress:
        return 'Synchronisation en cours...';
      case SyncState.success:
        return 'Synchronisation réussie';
      case SyncState.failure:
        return 'Échec de la synchronisation';
      case SyncState.conflictDetected:
        return 'Conflits détectés';
    }
  }

  // Formate une date pour l'affichage
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return "Aujourd'hui à ${DateFormat.Hm().format(date)}";
    } else if (dateToCheck == yesterday) {
      return "Hier à ${DateFormat.Hm().format(date)}";
    } else {
      return DateFormat('dd/MM/yyyy à HH:mm').format(date);
    }
  }

  // Affiche une boîte de dialogue d'erreur
  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erreur de synchronisation'),
        content: SelectableText(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  /// Affiche une boîte de dialogue avec les conflits filtrés par type
  void _showConflictsByType(BuildContext context, String conflictType,
      List<domain.SyncConflict> conflicts) {
    // Filtrer uniquement les conflits par type référencé
    final typeConflicts =
        conflicts.where((c) => c.referencedEntityType == conflictType).toList();

    // Mettre une majuscule à la première lettre du type de conflit
    final capitalizedType = conflictType.isEmpty
        ? conflictType
        : '${conflictType[0].toUpperCase()}${conflictType.substring(1)}';

    // Utiliser la boîte de dialogue existante avec les conflits filtrés
    _showConflictsDialog(context, typeConflicts, typeTitle: capitalizedType);
  }

  /// Affiche une boîte de dialogue avec les détails des conflits
  void _showConflictsDialog(
      BuildContext context, List<domain.SyncConflict> conflicts,
      {String? typeTitle}) {
    showDialog(
      context: context,
      builder: (context) => ConflictDialogWidget(
        conflicts: conflicts,
        typeTitle: typeTitle,
      ),
    );
  }

  /// Navigation directe vers l'élément en conflit
  Future<void> _navigateDirectlyToConflictItem(
      BuildContext context, domain.SyncConflict conflict) async {
    ConflictNavigationService.navigateDirectlyToConflictItem(
        context, conflict, ref);
  }

  /// Retourne le nom du type d'entité, au pluriel par défaut (pour les statistiques et conflits)
  String _getEntityTypeName(String entityType, {bool plural = true}) {
    switch (entityType.toLowerCase()) {
      case 'module':
        return plural ? 'modules' : 'Module';
      case 'site':
        return plural ? 'sites' : 'Site';
      case 'sitegroup':
        return plural ? 'groupes de sites' : 'Groupe de sites';
      case 'visit':
        return plural ? 'visites' : 'Visite';
      case 'observation':
        return plural ? 'observations' : 'Observation';
      case 'taxon':
        return plural ? 'taxons' : 'Taxon';
      default:
        return entityType;
    }
  }

  /// Convertit une catégorie de données en type d'entité pour les conflits
  String _getCategoryType(String category) {
    category = category.toLowerCase();

    if (category.contains('module')) return 'module';
    if (category.contains('site') && !category.contains('groupe')) {
      return 'site';
    }
    if (category.contains('groupe')) {
      return 'sitegroup';
    }
    if (category.contains('taxon')) {
      return 'taxon';
    }
    if (category.contains('nomenclature')) {
      return 'nomenclature';
    }
    if (category.contains('visite') || category.contains('visit')) {
      return 'visit';
    }
    if (category.contains('observateur')) {
      return 'observer';
    }

    return category;
  }

  /// Construit un widget pour afficher le résumé de synchronisation de manière structurée
  Widget _buildSyncSummary(BuildContext context, String syncSummary) {
    // Analyser le texte de résumé pour extraire les différentes parties
    final lines = syncSummary.split('\n');

    // Traiter à la fois le résumé final et le résumé incrémental pendant la synchronisation
    bool isIncrementalSummary =
        lines.isNotEmpty && lines[0].contains('Éléments déjà synchronisés');
    bool isFinalSummary =
        lines.isNotEmpty && lines[0].contains('Résumé de la synchronisation');

    // Récupérer les informations sur les conflits pour les associer aux bonnes sections
    final syncStatus = ref.watch(syncServiceProvider);
    final hasConflicts =
        syncStatus.conflicts != null && syncStatus.conflicts!.isNotEmpty;
    final conflicts = syncStatus.conflicts ?? [];

    // Organiser les conflits par type d'entité
    final conflictsByEntityType = <String, List<domain.SyncConflict>>{};

    if (hasConflicts) {
      for (final conflict in conflicts) {
        if (conflict.referencedEntityType != null) {
          final type = conflict.referencedEntityType!.toLowerCase();
          if (!conflictsByEntityType.containsKey(type)) {
            conflictsByEntityType[type] = [];
          }
          conflictsByEntityType[type]!.add(conflict);
        }
      }
    }

    // Extraire les statistiques par catégorie de données
    final Map<String, Map<String, dynamic>> statsByCategory = {};

    if (isFinalSummary) {
      // Traiter le résumé final de synchronisation avec les données par catégorie
      bool isParsingCategory = false;
      String currentCategory = '';

      for (int i = 1; i < lines.length; i++) {
        final line = lines[i].trim();

        if (line.startsWith('•')) {
          // Ligne de catégorie principale
          final parts = line.substring(1).trim().split(':');
          if (parts.length >= 2) {
            currentCategory = parts[0].trim();
            isParsingCategory = true;

            // Initialiser les statistiques pour cette catégorie
            if (!statsByCategory.containsKey(currentCategory)) {
              statsByCategory[currentCategory] = {
                'total': 0,
                'added': 0,
                'updated': 0,
                'skipped': 0,
                'deleted': 0,
                'hasConflicts': false,
              };
            }

            // Extraire les statistiques
            final statsStr = parts[1].trim();
            if (statsStr != 'Aucune donnée' && statsStr != 'Échec') {
              final regex = RegExp(
                  r'(\d+) éléments \((\d+) ajoutés, (\d+) mis à jour, (\d+) ignorés(?:, (\d+) supprimés)?\)');
              final match = regex.firstMatch(statsStr);

              if (match != null) {
                statsByCategory[currentCategory]!['total'] =
                    int.parse(match.group(1) ?? '0');
                statsByCategory[currentCategory]!['added'] =
                    int.parse(match.group(2) ?? '0');
                statsByCategory[currentCategory]!['updated'] =
                    int.parse(match.group(3) ?? '0');
                statsByCategory[currentCategory]!['skipped'] =
                    int.parse(match.group(4) ?? '0');
                statsByCategory[currentCategory]!['deleted'] =
                    int.parse(match.group(5) ?? '0');
              }
            }

            // Vérifier s'il y a des conflits pour cette catégorie
            final categoryType = _getCategoryType(currentCategory);
            statsByCategory[currentCategory]!['hasConflicts'] =
                conflictsByEntityType.containsKey(categoryType) &&
                    conflictsByEntityType[categoryType]!.isNotEmpty;
          }
        }
      }
    } else if (isIncrementalSummary) {
      // Traiter le résumé incrémental de la synchronisation en cours
      for (int i = 1; i < lines.length; i++) {
        final line = lines[i].trim();

        if (line.startsWith('•') && !line.startsWith('• TOTAL')) {
          // Ligne de catégorie
          final parts = line.substring(1).trim().split(':');
          if (parts.length >= 2) {
            final category = parts[0].trim();

            // Initialiser les statistiques pour cette catégorie
            if (!statsByCategory.containsKey(category)) {
              statsByCategory[category] = {
                'total': 0,
                'added': 0,
                'updated': 0,
                'skipped': 0,
                'deleted': 0,
                'hasConflicts': false,
              };
            }

            // Extraire les statistiques
            final statsStr = parts[1].trim();
            if (statsStr != 'Aucune donnée' && statsStr != 'Échec') {
              final regex = RegExp(
                  r'(\d+) éléments \((\d+) ajoutés, (\d+) mis à jour, (\d+) ignorés(?:, (\d+) supprimés)?\)');
              final match = regex.firstMatch(statsStr);

              if (match != null) {
                statsByCategory[category]!['total'] =
                    int.parse(match.group(1) ?? '0');
                statsByCategory[category]!['added'] =
                    int.parse(match.group(2) ?? '0');
                statsByCategory[category]!['updated'] =
                    int.parse(match.group(3) ?? '0');
                statsByCategory[category]!['skipped'] =
                    int.parse(match.group(4) ?? '0');
                statsByCategory[category]!['deleted'] =
                    int.parse(match.group(5) ?? '0');
              }
            }

            // Vérifier s'il y a des conflits pour cette catégorie
            final categoryType = _getCategoryType(category);
            statsByCategory[category]!['hasConflicts'] =
                conflictsByEntityType.containsKey(categoryType) &&
                    conflictsByEntityType[categoryType]!.isNotEmpty;
          }
        }
      }
    }

    // Si nous avons extrait des statistiques, construire un affichage structuré
    if (statsByCategory.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...statsByCategory.entries.map((entry) {
            final category = entry.key;
            final stats = entry.value;
            final hasConflicts = stats['hasConflicts'] as bool;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: InkWell(
                onTap: hasConflicts
                    ? () {
                        // Afficher les conflits pour cette catégorie
                        final categoryType = _getCategoryType(category);
                        if (conflictsByEntityType.containsKey(categoryType)) {
                          _showConflictsByType(
                              context, categoryType, conflicts);
                        }
                      }
                    : null,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: hasConflicts
                        ? Theme.of(context)
                            .colorScheme
                            .errorContainer
                            .withOpacity(0.1)
                        : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: hasConflicts
                          ? Theme.of(context).colorScheme.error.withOpacity(0.3)
                          : Theme.of(context)
                              .colorScheme
                              .outline
                              .withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // En-tête avec le nom de la catégorie et l'indicateur de conflit
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              category,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: hasConflicts
                                        ? Theme.of(context).colorScheme.error
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                  ),
                            ),
                          ),
                          if (hasConflicts)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .error
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.warning_amber_outlined,
                                    size: 12,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Conflit',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Statistiques visuelles
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            // Ajoutés
                            _buildStatIndicator(
                              context,
                              'Ajoutés',
                              stats['added'] as int,
                              Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 4.0),

                            // Mis à jour
                            _buildStatIndicator(
                              context,
                              'Mis à jour',
                              stats['updated'] as int,
                              Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(width: 4.0),

                            _buildStatIndicator(
                              context,
                              'Supprimés',
                              stats['deleted'] as int,
                              Theme.of(context).colorScheme.error,
                            ),
                          ],
                        ),
                      ),

                      if (hasConflicts) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.touch_app,
                              size: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .error
                                  .withOpacity(0.7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Cliquez pour voir les conflits',
                              style: TextStyle(
                                fontSize: 10,
                                fontStyle: FontStyle.italic,
                                color: Theme.of(context)
                                    .colorScheme
                                    .error
                                    .withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }).toList(),

          // Informations supplémentaires si disponibles
          if (lines
              .any((line) => line.contains('Des conflits ont été détectés')))
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(top: 8.0),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .errorContainer
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Theme.of(context).colorScheme.error.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_outlined,
                    size: 16,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Des conflits ont été détectés et nécessitent votre attention',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    }

    // Si aucune statistique n'a pu être extraite, afficher le texte brut
    return Text(
      syncSummary,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  /// Construit un indicateur visuel pour une statistique de synchronisation
  Widget _buildStatIndicator(
      BuildContext context, String label, int value, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 2),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                // Barre de progression (limitée à 100% de largeur)
                FractionallySizedBox(
                  widthFactor: value > 0 ? 1.0 : 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                // Libellé centré
                Center(
                  child: Text(
                    '$value',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Détermine si une erreur provient de la synchronisation ascendante (envoi de données)
  bool _isUpstreamSyncError(String errorMessage) {
    // Identifier les erreurs liées à l'envoi de données vers le serveur
    final upstreamKeywords = [
      'échec de l\'envoi',
      'erreur lors de l\'envoi',
      'synchronisation ascendante',
      'envoi des données',
      'upload failed',
      'post failed',
      'patch failed',
      'failed to send',
      'erreur de sérialisation',
      'validation failed on server',
      'server rejected',
      'échec du post',
      'échec du patch',
      // Ajouter les patterns d'erreurs de synchronisation des visites/observations
      'erreurs lors de la synchronisation des visites',
      'erreurs lors de la synchronisation des observations',
      'erreurs lors de la synchronisation des détails',
      'visite',
      'observation',
      'detail',
      'erreur de validation des données',
      'erreur de synthèse',
      'contrainte de base de données',
      'check_synthese_count_max',
      'synthese',
      'erreur de dénombrement',
      // Patterns génériques pour les erreurs d'entités
      'erreur fatale lors de la synchronisation complète',
      'échec de la synchronisation complète',
    ];

    final lowerError = errorMessage.toLowerCase();
    return upstreamKeywords.any((keyword) => lowerError.contains(keyword));
  }

  /// Navigue vers la page de détail des erreurs de synchronisation
  void _navigateToErrorPage(BuildContext context, String errorMessage) {
    try {
      debugPrint('=== NAVIGATION TO ERROR PAGE ===');
      debugPrint('Context: $context');
      debugPrint('Error message length: ${errorMessage.length}');
      debugPrint('Widget.onSyncRequested: ${widget.onSyncRequested}');
      
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            debugPrint('Building SyncErrorDetailPage...');
            return SyncErrorDetailPage(
              errorMessage: errorMessage,
              errorTitle: 'Erreurs de synchronisation',
              onRetry: widget.onSyncRequested,
            );
          },
        ),
      ).then((result) {
        debugPrint('Navigation completed with result: $result');
      }).catchError((error) {
        debugPrint('Navigation failed with error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'ouverture de la page: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      });
      
      debugPrint('Navigation initiated successfully');
    } catch (e, stackTrace) {
      debugPrint('=== NAVIGATION ERROR ===');
      debugPrint('Error: $e');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('========================');
      
      // Fallback: afficher un dialog simple
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erreur de synchronisation'),
          content: SingleChildScrollView(
            child: Text(errorMessage),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
            if (widget.onSyncRequested != null)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onSyncRequested!();
                },
                child: const Text('Réessayer'),
              ),
          ],
        ),
      );
    }
  }
}
