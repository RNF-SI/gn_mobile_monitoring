import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart';
import 'package:gn_mobile_monitoring/presentation/state/sync_status.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sync_service.dart';
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
                setState(() {
                  // Inverser l'état d'expansion des détails au clic
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
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
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
                                Text(
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
                                ),
                              ],
                            ),
                          // Instruction discrète pour indiquer que c'est cliquable
                          Text(
                            'Cliquez pour ${_detailsExpanded ? 'masquer' : 'afficher'} les détails',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
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
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        _detailsExpanded ? Icons.expand_less : Icons.expand_more,
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

          // Contenu principal (uniquement si détails sont développés)
          if (_detailsExpanded)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informations de progression et détails (pendant la synchronisation ou après)
                  if ((syncStatus.state == SyncState.inProgress ||
                          syncStatus.additionalInfo != null) &&
                      (syncStatus.itemsTotal > 0 ||
                          syncStatus.additionalInfo != null))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ligne principale avec l'étape et la progression (uniquement pendant la synchronisation)
                        if (syncStatus.state == SyncState.inProgress &&
                            syncStatus.currentStep != null &&
                            syncStatus.itemsTotal > 0)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: syncStatus.currentEntityName ??
                                              _getStepName(
                                                  syncStatus.currentStep!),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                              ),
                                        ),
                                        TextSpan(
                                          text:
                                              ' • ${syncStatus.itemsProcessed}/${syncStatus.itemsTotal}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withOpacity(0.7),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (syncStatus.itemsAdded != null ||
                                    syncStatus.itemsUpdated != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6.0, vertical: 2.0),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: Text(
                                      '${syncStatus.itemsAdded ?? 0}↑ ${syncStatus.itemsUpdated ?? 0}↻',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                        // Afficher les informations détaillées si disponibles
                        if (syncStatus.additionalInfo != null)
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
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

                  // Affichage des erreurs
                  if (syncStatus.state == SyncState.failure &&
                      syncStatus.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Erreur:',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          InkWell(
                            onTap: () => _showErrorDialog(
                                context, syncStatus.errorMessage!),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    syncStatus.errorMessage!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Affichage des conflits
                  if (syncStatus.state == SyncState.conflictDetected)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Conflits:',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          InkWell(
                            onTap: () => _showConflictsDialog(
                                context, syncStatus.conflicts ?? []),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${syncStatus.conflicts?.length ?? 0} conflits détectés',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                  ),
                                ),
                                Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
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
        ],
      ),
    );
  }

  /// Construit l'icône en fonction de l'état de synchronisation
  Widget _buildIcon(IconData iconData, Color iconColor, SyncStatus syncStatus) {
    if (syncStatus.state == SyncState.inProgress) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(iconColor),
          value: syncStatus.progress > 0 ? syncStatus.progress : null,
        ),
      );
    }

    return Icon(iconData, color: iconColor);
  }

  /// Retourne le texte d'état de synchronisation
  String _getStatusText(SyncStatus syncStatus) {
    switch (syncStatus.state) {
      case SyncState.idle:
        return 'En attente de synchronisation';
      case SyncState.inProgress:
        if (syncStatus.currentStep != null) {
          // Utiliser le nom de l'entité personnalisé ou le nom de l'étape par défaut
          String stepName = syncStatus.currentEntityName ??
              _getStepName(syncStatus.currentStep!);

          // Afficher la progression numérique si disponible
          String progress = '';
          if (syncStatus.itemsTotal > 0) {
            int progressPercent = (syncStatus.progress * 100).round();
            progress = ' ($progressPercent%)';
          }

          // Ajouter des informations concises sur les étapes terminées
          String completedInfo = '';
          if (syncStatus.completedSteps.isNotEmpty &&
              syncStatus.completedSteps.length < 3) {
            // N'afficher les étapes terminées que s'il y en a peu pour ne pas surcharger
            completedInfo =
                ' • ${syncStatus.completedSteps.length} étape${syncStatus.completedSteps.length > 1 ? "s" : ""} terminée${syncStatus.completedSteps.length > 1 ? "s" : ""}';
          }

          return 'Synchronisation $stepName$progress$completedInfo';
        }
        return 'Synchronisation en cours...';
      case SyncState.success:
        // En cas de succès, afficher un récapitulatif des éléments traités
        String summaryInfo = '';
        if (syncStatus.itemsAdded != null || syncStatus.itemsUpdated != null) {
          int added = syncStatus.itemsAdded ?? 0;
          int updated = syncStatus.itemsUpdated ?? 0;

          if (added > 0 && updated > 0) {
            summaryInfo = ' • $added ajoutés • $updated mis à jour';
          } else if (added > 0) {
            summaryInfo = ' • $added ajoutés';
          } else if (updated > 0) {
            summaryInfo = ' • $updated mis à jour';
          }
        }

        return 'Synchronisation réussie$summaryInfo';
      case SyncState.failure:
        return 'Échec de la synchronisation';
      case SyncState.conflictDetected:
        int conflictCount = syncStatus.conflicts?.length ?? 0;
        return 'Conflits détectés ($conflictCount)';
    }
  }

  /// Retourne le nom de l'étape de synchronisation
  String _getStepName(SyncStep step) {
    switch (step) {
      case SyncStep.configuration:
        return 'configuration';
      case SyncStep.nomenclatures:
        return 'nomenclatures';
      case SyncStep.taxons:
        return 'taxons';
      case SyncStep.observers:
        return 'observateurs';
      case SyncStep.modules:
        return 'modules';
      case SyncStep.sites:
        return 'sites';
      case SyncStep.siteGroups:
        return 'groupes de sites';
    }
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

  /// Formatte une date pour l'affichage
  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  /// Affiche une boîte de dialogue avec le message d'erreur complet
  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 8),
            const Text('Détails de l\'erreur'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Affichage de l'horodatage
              Text(
                'Date: ${_formatDate(DateTime.now())}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              // Message d'erreur avec possibilité de scroller
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.3,
                ),
                child: SingleChildScrollView(
                  child: Text(
                    errorMessage,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  /// Affiche une boîte de dialogue avec les détails des conflits
  void _showConflictsDialog(
      BuildContext context, List<SyncConflict> conflicts) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_outlined,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(width: 8),
            const Text('Détails des conflits'),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: conflicts.length,
            itemBuilder: (context, index) {
              final conflict = conflicts[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // En-tête du conflit
                      Row(
                        children: [
                          Icon(
                            _getEntityIcon(conflict.entityType),
                            size: 16,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _getEntityTypeName(conflict.entityType,
                                  plural: false),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      // Identifiant de l'entité
                      Text(
                        'ID: ${conflict.entityId}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      // Dates de modification
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Local: ${_formatDate(conflict.localModifiedAt)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Serveur: ${_formatDate(conflict.remoteModifiedAt)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Stratégie de résolution
                      Text(
                        'Résolution: ${_getResolutionStrategyName(conflict.resolutionStrategy)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  /// Retourne une icône en fonction du type d'entité
  IconData _getEntityIcon(String entityType) {
    switch (entityType.toLowerCase()) {
      case 'module':
        return Icons.grid_view;
      case 'site':
        return Icons.place;
      case 'sitegroup':
        return Icons.folder;
      case 'visit':
        return Icons.calendar_today;
      case 'observation':
        return Icons.visibility;
      case 'taxon':
        return Icons.eco;
      default:
        return Icons.data_object;
    }
  }

  /// Retourne le nom de la stratégie de résolution
  String _getResolutionStrategyName(ConflictResolutionStrategy strategy) {
    switch (strategy) {
      case ConflictResolutionStrategy.serverWins:
        return 'Serveur prioritaire';
      case ConflictResolutionStrategy.clientWins:
        return 'Local prioritaire';
      case ConflictResolutionStrategy.merge:
        return 'Fusion';
      case ConflictResolutionStrategy.userDecision:
        return 'Décision utilisateur requise';
    }
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

    if ((isIncrementalSummary || isFinalSummary) && lines.length > 1) {
      // Extraire les lignes contenant des statistiques (celles commençant par •)
      final statLines = lines.where((line) => line.trim().startsWith('•'));

      if (statLines.isNotEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Afficher le titre selon le type de résumé
            Text(
              isIncrementalSummary
                  ? 'Éléments déjà synchronisés:'
                  : 'Résumé de la synchronisation:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 8),
            // Liste des statistiques par type d'élément
            ...statLines.map<Widget>((line) {
              // Extraire les parties de la ligne (nom de l'objet et statistiques)
              final parts = line.split(':');
              if (parts.length < 2) {
                return _buildSimpleSummaryLine(context, line);
              }

              // Récupérer le nom de l'objet (ex: "• Modules")
              final objectName = parts[0].trim();

              // Récupérer les statistiques
              final stats = parts[1].trim();

              // Extraire les chiffres pour les mettre en évidence
              final statsRegex = RegExp(
                  r'(\d+) éléments \((\d+) ajoutés, (\d+) mis à jour, (\d+) ignorés\)');
              final match = statsRegex.firstMatch(stats);

              if (match != null) {
                final total = int.parse(match.group(1) ?? '0');
                final added = int.parse(match.group(2) ?? '0');
                final updated = int.parse(match.group(3) ?? '0');
                final skipped = int.parse(match.group(4) ?? '0');

                return Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Entête avec le nom de l'élément (Module, Taxon, etc.)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withOpacity(0.5),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(7),
                            topRight: Radius.circular(7),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _getObjectIcon(objectName),
                              size: 14,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              objectName.replaceAll('•', '').trim(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const Spacer(),
                            _buildStatChip(
                                context, total, 'total', Colors.blueGrey),
                          ],
                        ),
                      ),
                      // Détails des statistiques avec badges colorés
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            // Badge avec icône pour les éléments ajoutés
                            _buildIconStatBadge(context, added, 'ajoutés',
                                Colors.green, Icons.add_circle_outline),
                            // Badge avec icône pour les éléments mis à jour
                            _buildIconStatBadge(context, updated, 'mis à jour',
                                Colors.blue, Icons.update),
                            // Badge avec icône pour les éléments ignorés (si non nul)
                            if (skipped > 0)
                              _buildIconStatBadge(context, skipped, 'ignorés',
                                  Colors.grey, Icons.remove_circle_outline),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Fallback si le format n'est pas celui attendu
              return _buildSimpleSummaryLine(context, line);
            }),
          ],
        );
      }
    }

    // Affichage des messages en cours de synchronisation qui ne contiennent pas de statistiques
    if (lines.isEmpty || (!isIncrementalSummary && !isFinalSummary)) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            width: 1,
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
                syncSummary,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
          ],
        ),
      );
    }

    // Fallback pour les autres formats de message
    return SelectableText(
      syncSummary,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  /// Retourne une icône appropriée en fonction du nom d'objet
  IconData _getObjectIcon(String objectName) {
    final name = objectName.toLowerCase().replaceAll('•', '').trim();
    if (name.contains('module')) return Icons.extension;
    if (name.contains('taxon')) return Icons.eco;
    if (name.contains('site') && name.contains('groupe')) return Icons.folder;
    if (name.contains('site')) return Icons.place;
    if (name.contains('nomenclature')) return Icons.list_alt;
    if (name.contains('observateur')) return Icons.person;
    if (name.contains('total')) return Icons.all_inclusive;
    return Icons.data_object;
  }

  /// Construit un widget pour une ligne de résumé simple
  Widget _buildSimpleSummaryLine(BuildContext context, String line) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        line,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  /// Construit un badge de statistique avec une icône (plus visuel)
  Widget _buildIconStatBadge(BuildContext context, int value, String label,
      Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            '$value',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  /// Construit une puce de statistique compacte pour l'en-tête
  Widget _buildStatChip(
      BuildContext context, int value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$value $label',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  // Méthode supprimée car les boutons de synchronisation ont été retirés de l'interface
  // La synchronisation se fait uniquement via le menu en haut à droite
}
