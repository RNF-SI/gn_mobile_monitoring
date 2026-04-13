import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/entity_name_helper.dart';
import 'package:gn_mobile_monitoring/core/helpers/string_formatter.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart' as domain;
import 'package:gn_mobile_monitoring/presentation/widgets/conflict_navigation_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/conflict_resolution_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/nomenclature_service.dart';

/// Widget représentant une carte de conflit individuelle
class ConflictCardWidget extends ConsumerWidget {
  /// Le conflit à afficher
  final domain.SyncConflict conflict;
  
  /// Type de conflit (données ou référence supprimée)
  final domain.ConflictType conflictType;

  const ConflictCardWidget({
    super.key,
    required this.conflict,
    required this.conflictType,
  });

  /// Obtenir le nom d'une entité supprimée (nomenclatures, sites, taxons)
  Future<String> _getDeletedEntityName(WidgetRef ref, domain.SyncConflict conflict) async {
    final entityType = conflict.referencedEntityType?.toLowerCase();
    final entityId = conflict.referencedEntityId;
    
    if (entityId == null) {
      return '${StringFormatter.capitalizeFirst(conflict.referencedEntityType ?? "")} (ID inconnu)';
    }
    
    // Nomenclatures
    if (entityType == 'nomenclature') {
      final nomenclatureService = ref.read(nomenclatureServiceProvider.notifier);
      try {
        final id = int.tryParse(entityId);
        if (id != null) {
          final name = await nomenclatureService.getNomenclatureNameById(id);
          if (!name.contains('non trouvée')) {
            return name;
          }
        }
      } catch (e) {
        // Continue avec fallback
      }
    }
    
    // Taxons
    if (entityType == 'taxon') {
      try {
        // D'abord vérifier si on a les données dans le contexte local
        if (conflict.localData['_context'] != null &&
            conflict.localData['_context']['taxon'] != null) {
          final taxonContext = conflict.localData['_context']['taxon'];
          final nomComplet = taxonContext['nom_complet'] ?? '';
          final nomVern = taxonContext['nom_vern'] ?? '';
          final cdNom = entityId;
          
          String taxonName = nomComplet;
          if (nomVern.isNotEmpty && nomVern != nomComplet) {
            taxonName = '$nomComplet ($nomVern)';
          }
          if (taxonName.isNotEmpty) {
            return '$taxonName (cd_nom: $cdNom)';
          }
        }
        
        // Sinon essayer de récupérer depuis la base de données
        final cdNom = int.tryParse(entityId);
        if (cdNom != null) {
          // TODO: Implémenter la récupération depuis la base si nécessaire
          // Pour l'instant on retourne juste le cd_nom
          return 'Taxon (cd_nom: $cdNom)';
        }
      } catch (e) {
        // Continue avec fallback
      }
    }
    
    // Sites
    if (entityType == 'site' || entityType == 'basesite') {
      try {
        // D'abord vérifier si on a les données dans le contexte local
        if (conflict.localData['_context'] != null &&
            conflict.localData['_context']['site'] != null) {
          final siteContext = conflict.localData['_context']['site'];
          final siteName = siteContext['base_site_name'] ?? siteContext['site_name'] ?? '';
          final siteCode = siteContext['base_site_code'] ?? siteContext['site_code'] ?? '';
          
          if (siteName.isNotEmpty) {
            if (siteCode.isNotEmpty) {
              return '$siteName ($siteCode)';
            }
            return siteName;
          }
        }
        
        // Sinon retourner l'ID
        return 'Site (ID: $entityId)';
      } catch (e) {
        // Continue avec fallback
      }
    }
    
    // Fallback par défaut
    return '${StringFormatter.capitalizeFirst(conflict.referencedEntityType ?? "")} (ID: $entityId)';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Détermine si nous avons suffisamment d'informations pour la navigation directe
    bool canNavigate = true;
    
    // Vérifier si le conflit a été résolu via le service de résolution
    final resolutionService = ref.watch(conflictResolutionProvider.notifier);
    final resolutionState = resolutionService.getResolutionState(conflict);
    final isResolved = resolutionState?.isResolved ?? conflict.isResolved;
    
    // Déterminer le type d'entité principale pour l'affichage
    String entityType = 'inconnu';
    String entityId = 'inconnu';
    
    // Extraire les informations du contexte pour l'entité
    if (conflict.navigationPath != null) {
      final String contextStr = conflict.navigationPath!;
      
      // Afficher le chemin pour debug
      debugPrint('ConflictCardWidget - Path: $contextStr');
      
      // Extraire toutes les entités du chemin de navigation
      if (contextStr.contains('/')) {
        // Format: /module/24/site/113/visit/7/observation/7
        final entities = _extractEntitiesFromPath(contextStr);
        
        // Trouver l'entité la plus spécifique pour l'affichage principal
        if (entities.containsKey('detail')) {
          entityType = 'détail';
          entityId = entities['detail']!;
        } else if (entities.containsKey('observation')) {
          entityType = 'observation';
          entityId = entities['observation']!;
        } else if (entities.containsKey('visit')) {
          entityType = 'visite';
          entityId = entities['visit']!;
        } else if (entities.containsKey('site')) {
          entityType = 'site';
          entityId = entities['site']!;
        } else if (entities.containsKey('module')) {
          entityType = 'module';
          entityId = entities['module']!;
        }
      } else {
        // Format: detail:123 ou observation:123
        final detailMatch = RegExp(r'detail[":]*(\d+)').firstMatch(contextStr);
        final obsMatch = RegExp(r'observation[":]*(\d+)').firstMatch(contextStr);
        final visitMatch = RegExp(r'visit[":]*(\d+)').firstMatch(contextStr);
        final siteMatch = RegExp(r'site[":]*(\d+)').firstMatch(contextStr);
        final moduleMatch = RegExp(r'module[":]*(\d+)').firstMatch(contextStr);
        
        if (detailMatch != null && detailMatch.group(1) != null) {
          entityType = 'détail';
          entityId = detailMatch.group(1)!;
        } else if (obsMatch != null && obsMatch.group(1) != null) {
          entityType = 'observation';
          entityId = obsMatch.group(1)!;
        } else if (visitMatch != null && visitMatch.group(1) != null) {
          entityType = 'visite';
          entityId = visitMatch.group(1)!;
        } else if (siteMatch != null && siteMatch.group(1) != null) {
          entityType = 'site';
          entityId = siteMatch.group(1)!;
        } else if (moduleMatch != null && moduleMatch.group(1) != null) {
          entityType = 'module';
          entityId = moduleMatch.group(1)!;
        }
      }
    } else if (conflict.localData.containsKey('_context')) {
      // Récupérer le contexte à partir des données locales si disponible
      final contextData = conflict.localData['_context'] as Map<String, dynamic>;
      
      if (contextData.containsKey('detail')) {
        entityType = 'détail';
        entityId = contextData['detail'].toString();
      } else if (contextData.containsKey('observation')) {
        entityType = 'observation';
        entityId = contextData['observation'].toString();
      } else if (contextData.containsKey('visit')) {
        entityType = 'visite';
        entityId = contextData['visit'].toString();
      } else if (contextData.containsKey('site_id')) {
        entityType = 'site';
        entityId = contextData['site_id'].toString();
      } else if (contextData.containsKey('module_id')) {
        entityType = 'module';
        entityId = contextData['module_id'].toString();
      }
    } else {
      // Utiliser les champs entity si le navigationPath n'est pas disponible
      entityType = EntityNameHelper.getEntityTypeName(conflict.entityType, false);
      entityId = conflict.entityId;
      
      // Pour les conflits de référence, ajouter des informations si disponible
      if (conflictType == domain.ConflictType.deletedReference && 
          conflict.referencedEntityType != null &&
          conflict.referencedEntityId != null) {
        
        // Essayer d'extraire les informations minimales pour la navigation
        if (conflict.entityType.toLowerCase() == 'visit' || 
            conflict.entityType.toLowerCase() == 'observation' ||
            conflict.entityType.toLowerCase() == 'observationdetail') {
          // Navigation possible...
        } else {
          canNavigate = false;
        }
      }
    }
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isResolved
            ? Colors.green.withOpacity(0.5)
            : conflictType == domain.ConflictType.deletedReference
              ? Theme.of(context).colorScheme.error.withOpacity(0.3)
              : Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec type d'entité et couleur selon type de conflit
          Container(
            color: isResolved
              ? Colors.green.withOpacity(0.1)
              : conflictType == domain.ConflictType.deletedReference
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
                        isResolved
                          ? Icons.check_circle
                          : EntityNameHelper.getEntityIcon(entityType),
                        size: 20,
                        color: isResolved
                          ? Colors.green
                          : conflictType == domain.ConflictType.deletedReference
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$entityType (ID: $entityId)',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (isResolved && resolutionState?.resolutionType != null)
                              Text(
                                'Résolu : ${resolutionState!.resolutionType}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.green[700],
                                ),
                              ),
                          ],
                        ),
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
                      onPressed: () async {
                        final result = await ConflictNavigationService.navigateDirectlyToConflictItem(context, conflict, ref);
                        if (result && context.mounted) {
                          // Si l'élément a été modifié, fermer le dialogue et forcer un rafraîchissement
                          Navigator.of(context).pop(true);
                        }
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
                // Afficher le chemin de navigation complet si disponible
                if (conflict.navigationPath != null && conflict.navigationPath!.contains('/'))
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.account_tree_outlined,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Chemin complet:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        _buildNavigationPathDisplay(context, conflict.navigationPath!),
                      ],
                    ),
                  ),
                
                // Informations sur la référence supprimée
                if (conflictType == domain.ConflictType.deletedReference &&
                    conflict.referencedEntityType != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.error.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          EntityNameHelper.getEntityIcon(conflict.referencedEntityType ?? ''),
                          size: 16,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${EntityNameHelper.getEntityTypeName(conflict.referencedEntityType ?? '', false)} avec ID ${conflict.referencedEntityId} a été supprimé',
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
                        Expanded(
                          child: Text(
                            StringFormatter.formatFieldName(conflict.affectedField),
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                // Affichage des infos de référence supprimée
                if (conflictType == domain.ConflictType.deletedReference &&
                    conflict.referencedEntityType != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: FutureBuilder<String>(
                      future: _getDeletedEntityName(ref, conflict),
                      builder: (context, snapshot) {
                        return Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.error.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                                size: 16,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Référence supprimée: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  snapshot.data ?? 'Chargement...',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  
                // Dates de modification (pour les conflits de données)
                if (conflictType == domain.ConflictType.dataConflict)
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
                                'Local: ${StringFormatter.formatDate(conflict.localModifiedAt)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Serveur: ${StringFormatter.formatDate(conflict.remoteModifiedAt)}',
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
              onTap: () async {
                final result = await ConflictNavigationService.navigateDirectlyToConflictItem(context, conflict, ref);
                if (result && context.mounted) {
                  // Si l'élément a été modifié, fermer le dialogue et forcer un rafraîchissement
                  Navigator.of(context).pop(true);
                }
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
  }


  /// Retourne le nom de la stratégie de résolution
  String _getResolutionStrategyName(domain.ConflictResolutionStrategy strategy) {
    switch (strategy) {
      case domain.ConflictResolutionStrategy.serverWins:
        return 'Serveur prioritaire';
      case domain.ConflictResolutionStrategy.clientWins:
        return 'Local prioritaire';
      case domain.ConflictResolutionStrategy.merge:
        return 'Fusion';
      case domain.ConflictResolutionStrategy.userDecision:
        return 'Décision utilisateur requise';
    }
  }

  
  /// Extrait toutes les entités d'un chemin de navigation au format /type/id/type/id
  Map<String, String> _extractEntitiesFromPath(String path) {
    final entities = <String, String>{};
    
    final moduleMatch = RegExp(r'/module/(\d+)').firstMatch(path);
    if (moduleMatch != null && moduleMatch.group(1) != null) {
      entities['module'] = moduleMatch.group(1)!;
    }
    
    final siteMatch = RegExp(r'/site/(\d+)').firstMatch(path);
    if (siteMatch != null && siteMatch.group(1) != null) {
      entities['site'] = siteMatch.group(1)!;
    }
    
    final visitMatch = RegExp(r'/visit/(\d+)').firstMatch(path);
    if (visitMatch != null && visitMatch.group(1) != null) {
      entities['visit'] = visitMatch.group(1)!;
    }
    
    final obsMatch = RegExp(r'/observation/(\d+)').firstMatch(path);
    if (obsMatch != null && obsMatch.group(1) != null) {
      entities['observation'] = obsMatch.group(1)!;
    }
    
    final detailMatch = RegExp(r'/detail/(\d+)').firstMatch(path);
    if (detailMatch != null && detailMatch.group(1) != null) {
      entities['detail'] = detailMatch.group(1)!;
    }
    
    return entities;
  }
  
  /// Construit un affichage graphique du chemin de navigation
  Widget _buildNavigationPathDisplay(BuildContext context, String path) {
    final entities = _extractEntitiesFromPath(path);
    
    if (entities.isEmpty) {
      return Text(
        path,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      );
    }
    
    // Ordre de hiérarchie
    final order = ['module', 'site', 'visit', 'observation', 'detail'];
    
    // Construire les éléments du chemin de manière plus structurée
    final children = <Widget>[];
    
    // Pour chaque type d'entité dans l'ordre hiérarchique
    for (int i = 0; i < order.length; i++) {
      final type = order[i];
      
      // Ajouter un chip pour chaque entité existante
      if (entities.containsKey(type)) {
        children.add(
          Chip(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            labelPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
            label: Text(
              '${EntityNameHelper.getEntityTypeName(type, false)} ${entities[type]}',
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            avatar: Icon(
              EntityNameHelper.getEntityIcon(type),
              size: 12,
              color: Theme.of(context).colorScheme.primary,
            ),
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
            ),
          ),
        );
        
        // Ajouter une flèche si ce n'est pas la dernière entité
        // et si l'entité suivante existe aussi dans le chemin
        if (i < order.length - 1 && entities.containsKey(order[i + 1])) {
          children.add(
            Icon(
              Icons.arrow_forward_ios,
              size: 10,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
          );
        }
      }
    }
    
    return Wrap(
      spacing: 4,
      children: children,
    );
  }
}