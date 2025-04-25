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
      barrierDismissible: true,
      builder: (context) => Dialog.fullscreen(
        child: DefaultTabController(
          length: 2,
          initialIndex: initialIndex,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                typeTitle != null
                    ? 'Conflits de $typeTitle'
                    : 'Détails des conflits',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
              bottom: TabBar(
                tabs: [
                  Tab(
                    icon: const Icon(Icons.compare_arrows),
                    text: 'Conflits de données (${dataConflicts.length})',
                  ),
                  Tab(
                    icon: Icon(
                      Icons.error_outline,
                      color: referenceConflicts.isNotEmpty
                          ? Theme.of(context).colorScheme.error
                          : Colors.grey,
                    ),
                    text: 'Références supprimées (${referenceConflicts.length})',
                  ),
                ],
                labelColor: Theme.of(context).colorScheme.primary,
                indicatorColor: referenceConflicts.isNotEmpty
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
            body: TabBarView(
              children: [
                // Onglet des conflits de données
                _buildEnhancedConflictsList(context, dataConflicts, ConflictType.dataConflict),

                // Onglet des conflits de références supprimées
                _buildEnhancedConflictsList(context, referenceConflicts, ConflictType.deletedReference),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  /// Construit une liste améliorée des conflits avec navigation intégrée
  Widget _buildEnhancedConflictsList(
      BuildContext context, List<SyncConflict> conflicts, ConflictType conflictType) {
    if (conflicts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              conflictType == ConflictType.dataConflict
                  ? Icons.check_circle_outline
                  : Icons.check_circle,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              conflictType == ConflictType.dataConflict
                  ? 'Aucun conflit de données'
                  : 'Aucune référence supprimée',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Explications sur les conflits
          if (conflictType == ConflictType.deletedReference)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.error.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Références à des éléments supprimés',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ces conflits se produisent lorsque des données locales font référence à des éléments qui ont été supprimés sur le serveur. Vous devez résoudre ces conflits en modifiant les données concernées.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          if (conflictType == ConflictType.dataConflict)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Conflits de modifications',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ces conflits se produisent lorsque les mêmes données ont été modifiées à la fois localement et sur le serveur. La stratégie de résolution détermine quelle version est conservée.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            
          // Liste des conflits
          Expanded(
            child: ListView.builder(
              itemCount: conflicts.length,
              itemBuilder: (context, index) {
                final conflict = conflicts[index];
                
                // Détermine si nous avons suffisamment d'informations pour la navigation directe
                bool canNavigate = conflictType == ConflictType.deletedReference &&
                    conflict.localData.containsKey('_context');
                
                if (!canNavigate && conflictType == ConflictType.deletedReference) {
                  // Vérifier si nous avons des informations minimales pour la navigation
                  if (conflict.entityType.toLowerCase() == 'visit' || 
                      conflict.entityType.toLowerCase() == 'observation' ||
                      conflict.entityType.toLowerCase() == 'observationdetail') {
                    canNavigate = true;
                  }
                }
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: conflictType == ConflictType.deletedReference
                          ? Theme.of(context).colorScheme.error.withOpacity(0.3)
                          : Theme.of(context).colorScheme.outline.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      // En-tête avec type d'entité et couleur selon type de conflit
                      Container(
                        color: conflictType == ConflictType.deletedReference
                            ? Theme.of(context).colorScheme.errorContainer.withOpacity(0.2)
                            : Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    _getEntityIcon(conflict.entityType),
                                    size: 20,
                                    color: conflictType == ConflictType.deletedReference
                                        ? Theme.of(context).colorScheme.error
                                        : Theme.of(context).colorScheme.secondary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_getEntityTypeName(conflict.entityType, plural: false)} (ID: ${conflict.entityId})',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            if (canNavigate)
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  iconSize: 14,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  icon: const Icon(Icons.north_east),
                                  tooltip: 'Naviguer vers l\'élément',
                                  onPressed: () {
                                    Navigator.pop(context); // Fermer ce dialogue
                                    _navigateDirectlyToConflictItem(context, conflict);
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                      
                      // Corps - informations sur le conflit
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Informations sur la référence supprimée
                            if (conflictType == ConflictType.deletedReference &&
                                conflict.referencedEntityType != null)
                              Container(
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      _getEntityIcon(conflict.referencedEntityType!),
                                      size: 16,
                                      color: Theme.of(context).colorScheme.error,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '${_getEntityTypeName(conflict.referencedEntityType!, plural: false)} avec ID ${conflict.referencedEntityId} a été supprimé',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Theme.of(context).colorScheme.error,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                            // Champ concerné par le conflit
                            if (conflict.affectedField != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.label_outline,
                                      size: 14,
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Champ: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                                      ),
                                    ),
                                    Text(
                                      conflict.affectedField ?? 'Non spécifié',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                            // Dates de modification (pour les conflits de données)
                            if (conflictType == ConflictType.dataConflict)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          size: 14,
                                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Modifications: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 22.0, top: 4.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Local: ${_formatDate(conflict.localModifiedAt)}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(context).colorScheme.onSurface,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Serveur: ${_formatDate(conflict.remoteModifiedAt)}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(context).colorScheme.onSurface,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                            // Stratégie de résolution
                            Row(
                              children: [
                                Icon(
                                  Icons.merge_type,
                                  size: 14,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Résolution: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                                  ),
                                ),
                                Text(
                                  _getResolutionStrategyName(conflict.resolutionStrategy),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // Bouton de navigation - Pied de carte
                      if (canNavigate)
                        InkWell(
                          onTap: () {
                            Navigator.pop(context); // Fermer ce dialogue
                            _navigateDirectlyToConflictItem(context, conflict);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.edit_outlined,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Modifier cet élément',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Note: Les anciennes méthodes _buildConflictsList et _buildDeletedReferencesList
  // ont été remplacées par la méthode plus complète _buildEnhancedConflictsList.

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

  /// Navigation directe vers l'élément concerné par un conflit
  /// Sans passer par une interface intermédiaire
  Future<void> _navigateDirectlyToConflictItem(
      BuildContext context, SyncConflict conflict) async {
    // Extraire les données de contexte
    final Map<String, dynamic> contextInfo = {};
    bool showLoading = false;

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

    // Déterminer l'élément cible selon la priorité d'accès:
    // détail > observation > visite > site > module
    try {
      // Montrer un indicateur de chargement
      showLoading = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              const Text("Chargement des données..."),
            ],
          ),
        ),
      );

      // Si nous avons un module_id, c'est notre point de départ
      if (contextInfo.containsKey('module_id')) {
        final modulesState = ref.read(userModuleListeProvider);
        
        if (modulesState.data != null) {
          final moduleToOpen = modulesState.data!.values
              .where((m) => m.module.id == contextInfo['module_id'])
              .toList();

          if (moduleToOpen.isNotEmpty) {
            // Récupérer le module
            final moduleInfo = moduleToOpen.first;
            final moduleWithSites = moduleInfo.module;
            
            // Si nous avons un site_id
            if (contextInfo.containsKey('site_id')) {
              final siteId = contextInfo['site_id'];
              final siteToOpen = moduleWithSites.sites
                  ?.where((s) => s.idBaseSite == siteId)
                  .toList();

              if (siteToOpen != null && siteToOpen.isNotEmpty) {
                final site = siteToOpen.first;
                
                // Si nous avons une visite
                if (contextInfo.containsKey('visit')) {
                  final visitId = contextInfo['visit'];
                  final siteVisitsViewModel = ref.read(
                    siteVisitsViewModelProvider(
                      (site.idBaseSite, moduleInfo.module.id)
                    ).notifier
                  );
                  
                  try {
                    final visit = await siteVisitsViewModel.getVisitWithFullDetails(visitId);
                    
                    if (visit != null) {
                      // Si nous avons une observation
                      if (contextInfo.containsKey('observation')) {
                        final observationId = contextInfo['observation'];
                        final observationsViewModel = ref.read(
                          observationsProvider(visitId).notifier
                        );
                        
                        try {
                          final observation = await observationsViewModel.getObservationById(observationId);
                          
                          if (observation != null) {
                            // Obtenir la configuration pour les observations
                            final observationConfig = moduleInfo.module.complement
                                  ?.configuration?.observation;
                            final customConfig = moduleInfo.module.complement
                                  ?.configuration?.custom;
                            final observationDetailConfig = moduleInfo.module.complement
                                  ?.configuration?.observationDetail;
                                  
                            // Si nous avons un détail d'observation
                            if (contextInfo.containsKey('detail')) {
                              final detailId = contextInfo['detail'];
                              final observationDetailViewModel = ref.read(
                                observationDetailsProvider(observationId).notifier
                              );
                              
                              try {
                                final detail = await observationDetailViewModel.getObservationDetailById(detailId);
                                
                                if (detail != null && observationDetailConfig != null) {
                                  // Fermer l'indicateur de chargement
                                  if (showLoading) {
                                    Navigator.of(context).pop();
                                    showLoading = false;
                                  }
                                  
                                  // Naviguer vers le détail d'observation
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ObservationDetailDetailPage(
                                        observationDetail: detail,
                                        config: observationDetailConfig,
                                        customConfig: customConfig,
                                        index: 0,
                                      ),
                                    ),
                                  );
                                  return;
                                }
                              } catch (e) {
                                debugPrint('Erreur lors du chargement du détail: $e');
                              }
                            }
                            
                            // Si pas de détail ou erreur, naviguer vers l'observation
                            if (showLoading) {
                              Navigator.of(context).pop();
                              showLoading = false;
                            }
                            
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ObservationDetailPage(
                                  observation: observation,
                                  visit: visit,
                                  site: site,
                                  moduleInfo: moduleInfo,
                                  observationConfig: observationConfig,
                                  customConfig: customConfig,
                                  observationDetailConfig: observationDetailConfig,
                                ),
                              ),
                            );
                            return;
                          }
                        } catch (e) {
                          debugPrint('Erreur lors du chargement de l\'observation: $e');
                        }
                      }
                      
                      // Si pas d'observation ou erreur, naviguer vers la visite
                      if (showLoading) {
                        Navigator.of(context).pop();
                        showLoading = false;
                      }
                      
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VisitDetailPage(
                            visit: visit,
                            site: site,
                            moduleInfo: moduleInfo,
                          ),
                        ),
                      );
                      return;
                    }
                  } catch (e) {
                    debugPrint('Erreur lors du chargement de la visite: $e');
                  }
                }
                
                // Si pas de visite ou erreur, naviguer vers le site
                if (showLoading) {
                  Navigator.of(context).pop();
                  showLoading = false;
                }
                
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SiteDetailPage(
                      site: site,
                      moduleInfo: moduleInfo,
                    ),
                  ),
                );
                return;
              }
            }
            
            // Si pas de site ou erreur, naviguer vers le module
            if (showLoading) {
              Navigator.of(context).pop();
              showLoading = false;
            }
            
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ModuleDetailPage(
                  moduleInfo: moduleInfo,
                ),
              ),
            );
            return;
          }
        }
      }
      
      // Si nous arrivons ici, c'est que la navigation a échoué
      if (showLoading) {
        Navigator.of(context).pop();
        showLoading = false;
      }
      
      // Afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Impossible d\'accéder directement à l\'élément (${_determineMainEntityName(conflict, contextInfo)})',
            style: const TextStyle(fontSize: 14),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'OK',
            textColor: Theme.of(context).colorScheme.onError,
            onPressed: () {},
          ),
        ),
      );
      
    } catch (e) {
      // En cas d'erreur, fermer l'indicateur de chargement
      if (showLoading) {
        Navigator.of(context).pop();
      }
      
      // Afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la navigation: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
  
  /// Détermine le nom de l'entité principale à partir du conflit et du contexte
  String _determineMainEntityName(SyncConflict conflict, Map<String, dynamic> contextInfo) {
    if (contextInfo.containsKey('detail')) {
      return 'Détail ${contextInfo['detail']}';
    } else if (contextInfo.containsKey('observation')) {
      return 'Observation ${contextInfo['observation']}';
    } else if (contextInfo.containsKey('visit')) {
      return 'Visite ${contextInfo['visit']}';
    } else if (contextInfo.containsKey('site_id')) {
      return 'Site ${contextInfo['site_id']}';
    } else if (contextInfo.containsKey('module_id')) {
      return 'Module ${contextInfo['module_id']}';
    } else {
      return '${conflict.entityType} ${conflict.entityId}';
    }
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
