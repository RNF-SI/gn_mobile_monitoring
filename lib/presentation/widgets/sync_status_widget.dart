import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart';
import 'package:gn_mobile_monitoring/presentation/state/sync_status.dart';
import 'package:gn_mobile_monitoring/presentation/view/module/module_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation/observation_detail/observation_detail_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation/observation_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/site/site_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/visit/visit_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/modules_utilisateur_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/observation_detail_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/observations_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_visits_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sites_utilisateur_viewmodel.dart';
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
        if (syncStatus.itemsAdded != null ||
            syncStatus.itemsUpdated != null ||
            syncStatus.itemsDeleted != null) {
          int added = syncStatus.itemsAdded ?? 0;
          int updated = syncStatus.itemsUpdated ?? 0;
          int deleted = syncStatus.itemsDeleted ?? 0;

          List<String> parts = [];
          if (added > 0) parts.add('$added ajoutés');
          if (updated > 0) parts.add('$updated mis à jour');
          if (deleted > 0) parts.add('$deleted supprimés');

          if (parts.isNotEmpty) {
            summaryInfo = ' • ${parts.join(' • ')}';
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
    final syncStatus = ref.read(syncServiceProvider);

    // Analyser le message d'erreur pour extraire les références aux nomenclatures
    final nomenclatureRegex = RegExp(
        r'Nomenclature (\d+): Impossible de supprimer.*référencée par ([^)]+)');
    final matches = nomenclatureRegex.allMatches(errorMessage);

    // Préparer une liste d'ID de nomenclatures concernées pour l'extraction
    final nomenclatureIds = <String>[];
    final entitiesMap = <String, List<String>>{};

    // Extraire les ID et entités référençant
    for (final match in matches) {
      if (match.groupCount >= 2) {
        final nomenclatureId = match.group(1) ?? '';
        final entities = match.group(2) ?? '';

        if (nomenclatureId.isNotEmpty) {
          nomenclatureIds.add(nomenclatureId);
          entitiesMap[nomenclatureId] = entities.split(', ');
        }
      }
    }

    // Vérifier s'il y a des conflits correspondants
    final hasConflicts = syncStatus.conflicts != null &&
        syncStatus.conflicts!.isNotEmpty &&
        nomenclatureIds.isNotEmpty;

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

              // Afficher un résumé structuré des erreurs si ce sont des nomenclatures
              if (matches.isNotEmpty) ...[
                Text(
                  'Des nomenclatures supprimées sont toujours référencées:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
                const SizedBox(height: 8),

                // Afficher les nomenclatures avec leurs références sous forme de liste
                ...nomenclatureIds.map((id) {
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .errorContainer
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .error
                            .withOpacity(0.3),
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.format_list_numbered,
                              size: 16,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Nomenclature ID: $id',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        Text(
                          'Références:',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        if (entitiesMap.containsKey(id) &&
                            entitiesMap[id]!.isNotEmpty)
                          ...entitiesMap[id]!.map((entity) => Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  entity,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              )),

                        // Bouton pour accéder aux détails si des conflits existent
                        if (hasConflicts)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.search, size: 16),
                              label: Text('Voir les détails des références'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                minimumSize: Size(double.infinity, 36),
                              ),
                              onPressed: () {
                                // Fermer ce dialogue
                                Navigator.of(context).pop();
                                // Ouvrir le dialogue des conflits
                                _showConflictsDialog(
                                    context, syncStatus.conflicts ?? []);
                              },
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ],

              // Sinon, montrer le message d'erreur brut
              if (matches.isEmpty)
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.3,
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

  /// Affiche une boîte de dialogue avec les conflits filtrés par type
  void _showConflictsByType(
      BuildContext context, String conflictType, List<SyncConflict> conflicts) {
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
  void _showConflictsDialog(BuildContext context, List<SyncConflict> conflicts,
      {String? typeTitle}) {
    // Séparation des conflits en deux catégories
    final dataConflicts = conflicts
        .where((c) => c.conflictType == ConflictType.dataConflict)
        .toList();
    final referenceConflicts = conflicts
        .where((c) => c.conflictType == ConflictType.deletedReference)
        .toList();

    // Sélectionner l'onglet des références supprimées par défaut s'il y en a
    final initialIndex = referenceConflicts.isNotEmpty ? 1 : 0;

    showDialog(
      context: context,
      builder: (context) => DefaultTabController(
        length: 2,
        initialIndex: initialIndex,
        child: Dialog(
          // Utiliser Dialog au lieu de AlertDialog pour plus de flexibilité
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber_outlined,
                      color: referenceConflicts.isNotEmpty
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.secondary,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            typeTitle != null
                                ? 'Conflits de $typeTitle'
                                : 'Détails des conflits',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          if (referenceConflicts.isNotEmpty)
                            Text(
                              'Références à des éléments supprimés détectées',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.error,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Divider(),
                // TabBar
                TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(Icons.compare_arrows),
                      text: 'Conflits de données (${dataConflicts.length})',
                    ),
                    Tab(
                      icon: Icon(
                        Icons.error_outline,
                        color: referenceConflicts.isNotEmpty
                            ? Theme.of(context).colorScheme.error
                            : Colors.grey,
                      ),
                      text:
                          'Références supprimées (${referenceConflicts.length})',
                    ),
                  ],
                  labelColor: Theme.of(context).colorScheme.primary,
                  indicatorColor: referenceConflicts.isNotEmpty
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                // Contenu
                Expanded(
                  child: TabBarView(
                    children: [
                      // Onglet des conflits de données
                      _buildConflictsList(context, dataConflicts),

                      // Onglet des conflits de références supprimées
                      _buildDeletedReferencesList(context, referenceConflicts),
                    ],
                  ),
                ),
                // Message d'aide et bouton en bas
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Cliquez sur un élément pour accéder directement à l\'entité en conflit',
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Fermer'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construit la liste des conflits de données
  Widget _buildConflictsList(
      BuildContext context, List<SyncConflict> conflicts) {
    if (conflicts.isEmpty) {
      return Center(
        child: Text(
          'Aucun conflit de données',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return ListView.builder(
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
                        _getEntityTypeName(conflict.entityType, plural: false),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
    );
  }

  /// Construit la liste des conflits de références supprimées
  Widget _buildDeletedReferencesList(
      BuildContext context, List<SyncConflict> conflicts) {
    if (conflicts.isEmpty) {
      return Center(
        child: Text(
          'Aucune référence supprimée',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: conflicts.length,
      itemBuilder: (context, index) {
        final conflict = conflicts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête du conflit
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber,
                      size: 16,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getEntityTypeName(conflict.entityType, plural: false),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    // Badge indiquant la disponibilité du chemin de navigation
                    if (conflict.navigationPath != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.navigation,
                              size: 12,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Navigation directe',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const Divider(),
                // Information sur la référence supprimée
                if (conflict.referencedEntityType != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          _getEntityIcon(conflict.referencedEntityType!),
                          size: 14,
                          color: Theme.of(context)
                              .colorScheme
                              .error
                              .withOpacity(0.7),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Référence à ${_getEntityTypeName(conflict.referencedEntityType!, plural: false)} ID: ${conflict.referencedEntityId ?? "inconnu"} supprimée',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Champ affecté
                if (conflict.affectedField != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Champ affecté: ${conflict.affectedField}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),

                // Si le chemin de navigation est disponible, l'afficher
                if (conflict.navigationPath != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.link,
                                size: 12,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.7),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Chemin de navigation:',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            conflict.navigationPath!,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  fontFamily: 'monospace',
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Actions possibles
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.edit, size: 16),
                      label: Text('Modifier pour résoudre le conflit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: () {
                        // Fermer le dialogue des conflits
                        Navigator.of(context).pop();

                        // Construire le chemin de navigation pour résoudre le conflit
                        _navigateToEditConflict(context, conflict);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Méthode pour naviguer vers l'écran d'édition approprié pour résoudre un conflit
  void _navigateToEditConflict(BuildContext context, SyncConflict conflict) {
    _showEnhancedNavigationDialog(context, conflict);
  }

  /// Construit une étape de navigation numérotée avec un style visuel
  Widget _buildNavigationStep(
      BuildContext context, int stepNumber, String instruction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Affichage du numéro d'étape
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              instruction,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
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

  /// Ouvre une boîte de dialogue de navigation améliorée qui guide l'utilisateur
  /// et tente d'ouvrir directement les éléments lorsque possible
  Future<void> _showEnhancedNavigationDialog(
      BuildContext context, SyncConflict conflict) async {
    // Extraire les données de contexte
    final Map<String, dynamic> contextInfo = {};

    // Récupérer le contexte à partir des données locales
    if (conflict.localData.containsKey('_context')) {
      final contextData =
          conflict.localData['_context'] as Map<String, dynamic>;
      contextInfo.addAll(contextData);
    } else {
      // Essayer d'extraire les informations génériques
      if (conflict.entityType.toLowerCase() == 'visit' ||
          conflict.entityType.toLowerCase() == 'visitcomplement') {
        contextInfo['visit'] = int.tryParse(conflict.entityId) ?? 0;
      } else if (conflict.entityType.toLowerCase() == 'observation') {
        contextInfo['observation'] = int.tryParse(conflict.entityId) ?? 0;
        if (conflict.localData.containsKey('id_base_visit')) {
          contextInfo['visit'] = conflict.localData['id_base_visit'];
        }
      } else if (conflict.entityType.toLowerCase() == 'observationdetail') {
        contextInfo['detail'] = int.tryParse(conflict.entityId) ?? 0;
        if (conflict.localData.containsKey('id_observation')) {
          contextInfo['observation'] = conflict.localData['id_observation'];
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.navigation,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text('Navigation vers l\'élément en conflit'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .errorContainer
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.error.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.warning,
                          size: 16,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Ce conflit concerne une référence à ${conflict.referencedEntityType} (ID: ${conflict.referencedEntityId}) qui a été supprimée sur le serveur',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (conflict.affectedField != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Champ concerné: ${conflict.affectedField}',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context)
                              .colorScheme
                              .error
                              .withOpacity(0.8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                'Pour résoudre ce conflit, vous devez modifier l\'élément qui référence cette valeur supprimée:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Construire les étapes de navigation avec des actions si possible
              if (contextInfo.containsKey('module_id'))
                _buildEnhancedNavigationStep(
                  context,
                  1,
                  'Accéder au module ${contextInfo['module'] ?? contextInfo['module_id']}',
                  onNavigate: () async {
                    Navigator.pop(context); // Fermer le dialogue
                    try {
                      // Utiliser le provider correct pour les modules
                      final modulesState = ref.read(userModuleListeProvider);
                      if (modulesState.data != null &&
                          modulesState.data!.values.isNotEmpty) {
                        final moduleToOpen = modulesState.data!.values
                            .where(
                                (m) => m.module.id == contextInfo['module_id'])
                            .toList();

                        if (moduleToOpen.isNotEmpty) {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ModuleDetailPage(
                                  moduleInfo: moduleToOpen.first,
                                ),
                              ));
                          return;
                        }
                      }
                      // Si on n'a pas trouvé le module, afficher un message
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Module ${contextInfo['module_id']} non trouvé, veuillez le sélectionner manuellement'),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ));
                    } catch (e) {
                      debugPrint(
                          'Erreur lors de la navigation vers le module: $e');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Erreur de navigation: $e'),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ));
                    }
                  },
                ),

              if (contextInfo.containsKey('site_id'))
                _buildEnhancedNavigationStep(
                  context,
                  contextInfo.containsKey('module_id') ? 2 : 1,
                  'Accéder au site ${contextInfo['site'] ?? contextInfo['site_id']}',
                  onNavigate: contextInfo.containsKey('module_id')
                      ? () async {
                          Navigator.pop(context); // Fermer le dialogue
                          try {
                            // Trouver le module
                            final modulesState =
                                ref.read(userModuleListeProvider);
                            
                            if (modulesState.data != null) {
                              final moduleToOpen = modulesState.data!.values
                                  .where((m) =>
                                      m.module.id == contextInfo['module_id'])
                                  .toList();

                              if (moduleToOpen.isNotEmpty) {
                                // Récupérer le site directement depuis le module
                                // puisque les modules contiennent déjà leurs sites
                                final moduleWithSites = moduleToOpen.first.module;
                                final siteId = contextInfo['site_id'];
                                final siteToOpen = moduleWithSites.sites
                                    ?.where((s) => s.idBaseSite == siteId)
                                    .toList();

                                if (siteToOpen != null && siteToOpen.isNotEmpty) {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SiteDetailPage(
                                          site: siteToOpen.first,
                                          moduleInfo: moduleToOpen.first,
                                        ),
                                      ));
                                  return;
                                }
                              }
                            }
                            
                            // Si on n'a pas trouvé le site, afficher un message
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Site ${contextInfo['site_id']} non trouvé, veuillez le sélectionner manuellement'),
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ));
                          } catch (e) {
                            debugPrint(
                                'Erreur lors de la navigation vers le site: $e');
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Erreur de navigation: $e'),
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ));
                          }
                        }
                      : null,
                ),

              if (contextInfo.containsKey('visit'))
                _buildEnhancedNavigationStep(
                  context,
                  (contextInfo.containsKey('module_id') ? 1 : 0) +
                      (contextInfo.containsKey('site_id') ? 1 : 0) +
                      1,
                  'Accéder à la visite ${contextInfo['visit']}',
                  onNavigate: contextInfo.containsKey('module_id') && contextInfo.containsKey('site_id')
                      ? () async {
                          Navigator.pop(context); // Fermer le dialogue
                          try {
                            // Trouver le module
                            final modulesState =
                                ref.read(userModuleListeProvider);
                            
                            if (modulesState.data != null) {
                              final moduleToOpen = modulesState.data!.values
                                  .where((m) =>
                                      m.module.id == contextInfo['module_id'])
                                  .toList();

                              if (moduleToOpen.isNotEmpty) {
                                // Récupérer le site directement depuis le module
                                final moduleWithSites = moduleToOpen.first.module;
                                final siteId = contextInfo['site_id'];
                                final siteToOpen = moduleWithSites.sites
                                    ?.where((s) => s.idBaseSite == siteId)
                                    .toList();

                                if (siteToOpen != null && siteToOpen.isNotEmpty) {
                                  // Récupérer la visite via le service
                                  final siteVisitsViewModel = ref.read(
                                    siteVisitsViewModelProvider(
                                      (siteToOpen.first.idBaseSite, moduleToOpen.first.module.id)
                                    ).notifier
                                  );
                                  
                                  // Charger les détails complets de la visite
                                  final visitId = contextInfo['visit'];
                                  try {
                                    final visit = await siteVisitsViewModel.getVisitWithFullDetails(visitId);
                                    
                                    if (visit != null) {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => VisitDetailPage(
                                            visit: visit,
                                            site: siteToOpen.first,
                                            moduleInfo: moduleToOpen.first,
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text('Erreur de chargement de la visite: $e'),
                                      backgroundColor: Theme.of(context).colorScheme.error,
                                    ));
                                  }
                                }
                              }
                            }
                            
                            // Si on n'a pas trouvé la visite, afficher un message
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Visite ${contextInfo['visit']} non trouvée, veuillez la sélectionner manuellement'),
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ));
                          } catch (e) {
                            debugPrint(
                                'Erreur lors de la navigation vers la visite: $e');
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Erreur de navigation: $e'),
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ));
                          }
                        }
                      : null,
                ),

              if (contextInfo.containsKey('observation'))
                _buildEnhancedNavigationStep(
                  context,
                  (contextInfo.containsKey('module_id') ? 1 : 0) +
                      (contextInfo.containsKey('site_id') ? 1 : 0) +
                      (contextInfo.containsKey('visit') ? 1 : 0) +
                      1,
                  'Accéder à l\'observation ${contextInfo['observation']}',
                  onNavigate: contextInfo.containsKey('module_id') && 
                              contextInfo.containsKey('site_id') && 
                              contextInfo.containsKey('visit')
                      ? () async {
                          Navigator.pop(context); // Fermer le dialogue
                          try {
                            // Trouver le module
                            final modulesState =
                                ref.read(userModuleListeProvider);
                            
                            if (modulesState.data != null) {
                              final moduleToOpen = modulesState.data!.values
                                  .where((m) =>
                                      m.module.id == contextInfo['module_id'])
                                  .toList();

                              if (moduleToOpen.isNotEmpty) {
                                // Récupérer le site directement depuis le module
                                final moduleWithSites = moduleToOpen.first.module;
                                final siteId = contextInfo['site_id'];
                                final siteToOpen = moduleWithSites.sites
                                    ?.where((s) => s.idBaseSite == siteId)
                                    .toList();

                                if (siteToOpen != null && siteToOpen.isNotEmpty) {
                                  // Récupérer la visite via le service
                                  final siteVisitsViewModel = ref.read(
                                    siteVisitsViewModelProvider(
                                      (siteToOpen.first.idBaseSite, moduleToOpen.first.module.id)
                                    ).notifier
                                  );
                                  
                                  // Charger les détails complets de la visite
                                  final visitId = contextInfo['visit'];
                                  final observationId = contextInfo['observation'];
                                  
                                  try {
                                    final visit = await siteVisitsViewModel.getVisitWithFullDetails(visitId);
                                    
                                    if (visit != null) {
                                      // Récupérer l'observation
                                      final observationsViewModel = ref.read(
                                        observationsProvider(visitId).notifier
                                      );
                                      
                                      try {
                                        final observation = await observationsViewModel.getObservationById(observationId);
                                        
                                        if (observation != null) {
                                          // Obtenir la configuration pour les observations
                                          final observationConfig = moduleToOpen.first.module.complement
                                                  ?.configuration?.observation;
                                          final customConfig = moduleToOpen.first.module.complement
                                                  ?.configuration?.custom;
                                          final observationDetailConfig = moduleToOpen.first.module.complement
                                                  ?.configuration?.observationDetail;
                                                  
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ObservationDetailPage(
                                                observation: observation,
                                                visit: visit,
                                                site: siteToOpen.first,
                                                moduleInfo: moduleToOpen.first,
                                                observationConfig: observationConfig,
                                                customConfig: customConfig,
                                                observationDetailConfig: observationDetailConfig,
                                              ),
                                            ),
                                          );
                                          return;
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text('Erreur de chargement de l\'observation: $e'),
                                          backgroundColor: Theme.of(context).colorScheme.error,
                                        ));
                                      }
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text('Erreur de chargement de la visite: $e'),
                                      backgroundColor: Theme.of(context).colorScheme.error,
                                    ));
                                  }
                                }
                              }
                            }
                            
                            // Si on n'a pas trouvé l'observation, afficher un message
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Observation ${contextInfo['observation']} non trouvée, veuillez la sélectionner manuellement'),
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ));
                          } catch (e) {
                            debugPrint(
                                'Erreur lors de la navigation vers l\'observation: $e');
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Erreur de navigation: $e'),
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ));
                          }
                        }
                      : null,
                ),

              if (contextInfo.containsKey('detail'))
                _buildEnhancedNavigationStep(
                  context,
                  (contextInfo.containsKey('module_id') ? 1 : 0) +
                      (contextInfo.containsKey('site_id') ? 1 : 0) +
                      (contextInfo.containsKey('visit') ? 1 : 0) +
                      (contextInfo.containsKey('observation') ? 1 : 0) +
                      1,
                  'Accéder au détail ${contextInfo['detail']}',
                  onNavigate: contextInfo.containsKey('module_id') && 
                              contextInfo.containsKey('site_id') && 
                              contextInfo.containsKey('visit') &&
                              contextInfo.containsKey('observation')
                      ? () async {
                          Navigator.pop(context); // Fermer le dialogue
                          try {
                            // Trouver le module
                            final modulesState =
                                ref.read(userModuleListeProvider);
                            
                            if (modulesState.data != null) {
                              final moduleToOpen = modulesState.data!.values
                                  .where((m) =>
                                      m.module.id == contextInfo['module_id'])
                                  .toList();

                              if (moduleToOpen.isNotEmpty) {
                                // Récupérer le site directement depuis le module
                                final moduleWithSites = moduleToOpen.first.module;
                                final siteId = contextInfo['site_id'];
                                final siteToOpen = moduleWithSites.sites
                                    ?.where((s) => s.idBaseSite == siteId)
                                    .toList();

                                if (siteToOpen != null && siteToOpen.isNotEmpty) {
                                  // Récupérer la visite via le service
                                  final siteVisitsViewModel = ref.read(
                                    siteVisitsViewModelProvider(
                                      (siteToOpen.first.idBaseSite, moduleToOpen.first.module.id)
                                    ).notifier
                                  );
                                  
                                  // Charger les détails complets de la visite
                                  final visitId = contextInfo['visit'];
                                  final observationId = contextInfo['observation'];
                                  final detailId = contextInfo['detail'];
                                  
                                  try {
                                    final visit = await siteVisitsViewModel.getVisitWithFullDetails(visitId);
                                    
                                    if (visit != null) {
                                      // Récupérer l'observation
                                      final observationsViewModel = ref.read(
                                        observationsProvider(visitId).notifier
                                      );
                                      
                                      try {
                                        final observation = await observationsViewModel.getObservationById(observationId);
                                        
                                        if (observation != null) {
                                          // Obtenir la configuration pour les observations
                                          final observationConfig = moduleToOpen.first.module.complement
                                                  ?.configuration?.observation;
                                          final customConfig = moduleToOpen.first.module.complement
                                                  ?.configuration?.custom;
                                          final observationDetailConfig = moduleToOpen.first.module.complement
                                                  ?.configuration?.observationDetail;
                                                  
                                          // Accéder au détail
                                          final observationDetailViewModel = ref.read(
                                            observationDetailsProvider(observationId).notifier
                                          );
                                          
                                          try {
                                            final detail = await observationDetailViewModel.getObservationDetailById(detailId);
                                            
                                            if (detail != null) {
                                              // Vérifier que la configuration du détail d'observation est disponible
                                              if (observationDetailConfig != null) {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => ObservationDetailDetailPage(
                                                      observationDetail: detail,
                                                      config: observationDetailConfig,
                                                      customConfig: customConfig,
                                                      index: 0, // Index par défaut pour l'affichage
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                  content: Text('Configuration du détail d\'observation non disponible'),
                                                  backgroundColor: Theme.of(context).colorScheme.error,
                                                ));
                                              }
                                              return;
                                            }
                                          } catch (e) {
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: Text('Erreur de chargement du détail: $e'),
                                              backgroundColor: Theme.of(context).colorScheme.error,
                                            ));
                                          }
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text('Erreur de chargement de l\'observation: $e'),
                                          backgroundColor: Theme.of(context).colorScheme.error,
                                        ));
                                      }
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text('Erreur de chargement de la visite: $e'),
                                      backgroundColor: Theme.of(context).colorScheme.error,
                                    ));
                                  }
                                }
                              }
                            }
                            
                            // Si on n'a pas trouvé le détail, afficher un message
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Détail ${contextInfo['detail']} non trouvé, veuillez le sélectionner manuellement'),
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ));
                          } catch (e) {
                            debugPrint(
                                'Erreur lors de la navigation vers le détail: $e');
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Erreur de navigation: $e'),
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ));
                          }
                        }
                      : null,
                ),

              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Les étapes cliquables tentent d\'ouvrir directement l\'élément concerné. Sinon, naviguez manuellement.',
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
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
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  /// Construit une étape de navigation numérotée avec un style visuel et une action optionnelle
  Widget _buildEnhancedNavigationStep(
      BuildContext context, int stepNumber, String instruction,
      {VoidCallback? onNavigate}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Affichage du numéro d'étape
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: onNavigate != null
                ? InkWell(
                    onTap: onNavigate,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            instruction,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  decoration: TextDecoration.underline,
                                ),
                          ),
                        ),
                        Icon(
                          Icons.open_in_new,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  )
                : Text(
                    instruction,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
          ),
        ],
      ),
    );
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
    final conflictsByEntityType = <String, List<SyncConflict>>{};

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
                      Row(
                        children: [
                          // Ajoutés
                          _buildStatIndicator(
                            context,
                            'Ajoutés',
                            stats['added'] as int,
                            Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8.0),

                          // Mis à jour
                          _buildStatIndicator(
                            context,
                            'Mis à jour',
                            stats['updated'] as int,
                            Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(width: 8.0),

                          // Supprimés (s'il y en a)
                          if ((stats['deleted'] as int) > 0)
                            _buildStatIndicator(
                              context,
                              'Supprimés',
                              stats['deleted'] as int,
                              Theme.of(context).colorScheme.error,
                            ),
                        ],
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
              fontSize: 10,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
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
                      fontSize: 10,
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

  /// Convertit une catégorie de données en type d'entité pour les conflits
  String _getCategoryType(String category) {
    category = category.toLowerCase();

    if (category.contains('module')) return 'module';
    if (category.contains('site') && !category.contains('groupe'))
      return 'site';
    if (category.contains('groupe')) return 'sitegroup';
    if (category.contains('taxon')) return 'taxon';
    if (category.contains('nomenclature')) return 'nomenclature';
    if (category.contains('visite') || category.contains('visit'))
      return 'visit';
    if (category.contains('observateur')) return 'observer';

    return category;
  }
}
