import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/entity_name_helper.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart' as domain;
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/state/module_download_status.dart';
import 'package:gn_mobile_monitoring/presentation/view/module/module_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation/observation_detail/observation_detail_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation/observation_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/site/site_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/site_group_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/visit/visit_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/modules_utilisateur_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/observation_detail_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/observations_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_visits_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_groups_utilisateur_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sites_utilisateur_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/conflict_resolution_service.dart';

/// Service gérant la navigation vers les éléments en conflit
class ConflictNavigationService {
  /// Détermine le nom principal de l'entité pour l'affichage
  static String determineMainEntityName(
      domain.SyncConflict conflict, Map<String, dynamic> contextInfo) {
    if (contextInfo.containsKey('detail')) {
      return 'Détail ${contextInfo['detail']}';
    } else if (contextInfo.containsKey('observation')) {
      return 'Observation ${contextInfo['observation']}';
    } else if (contextInfo.containsKey('visit')) {
      return 'Visite ${contextInfo['visit']}';
    } else if (contextInfo.containsKey('site_id')) {
      return 'Site ${contextInfo['site_id']}';
    } else if (contextInfo.containsKey('site')) {
      return 'Site ${contextInfo['site']}';
    } else if (contextInfo.containsKey('site_group_id')) {
      return 'Groupe de sites ${contextInfo['site_group_id']}';
    } else if (contextInfo.containsKey('site_group')) {
      return 'Groupe de sites ${contextInfo['site_group']}';
    } else if (contextInfo.containsKey('module_id')) {
      return 'Module ${contextInfo['module_id']}';
    } else if (contextInfo.containsKey('module')) {
      return 'Module ${contextInfo['module']}';
    } else if (conflict.entityType.isNotEmpty && conflict.entityId.isNotEmpty) {
      return '${conflict.entityType} ${conflict.entityId}';
    } else {
      return 'Élément inconnu';
    }
  }


  /// Navigation directe vers l'élément en conflit
  /// Retourne true si l'élément a été modifié
  static Future<bool> navigateDirectlyToConflictItem(
      BuildContext context, domain.SyncConflict conflict, WidgetRef ref) async {
    // Créer un conflit modifiable pour pouvoir le marquer comme résolu
    domain.SyncConflict mutableConflict = conflict;
    // Extraire les données de contexte
    final Map<String, dynamic> contextInfo = {};
    bool showLoading = false;

    // Overlay pour indiquer le chargement
    OverlayEntry? loadingOverlay;

    // Fonction pour afficher l'indicateur de chargement
    void showLoadingIndicator() {
      loadingOverlay = OverlayEntry(
        builder: (context) => Container(
          color: Colors.black.withOpacity(0.5),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
      Overlay.of(context).insert(loadingOverlay!);
      showLoading = true;
    }

    // Fonction pour cacher l'indicateur de chargement
    void hideLoadingIndicator() {
      if (showLoading && loadingOverlay != null) {
        loadingOverlay!.remove();
        showLoading = false;
      }
    }

    try {
      // Analyser le contexte de conflit pour extraire les identifiants
      if (conflict.navigationPath != null) {
        final String contextStr = conflict.navigationPath!;

        // Debug: Afficher le chemin pour comprendre son format
        debugPrint('ConflictNavigationService - Path: $contextStr');

        if (contextStr.contains('/')) {
          // Format avec slash: /module/22/site/980/visit/5/observation/8

          // Module ID extraction
          final moduleMatch = RegExp(r'/module/(\d+)').firstMatch(contextStr);
          if (moduleMatch != null && moduleMatch.group(1) != null) {
            contextInfo['module_id'] = int.parse(moduleMatch.group(1)!);
          }

          // Site ID extraction
          final siteMatch = RegExp(r'/site/(\d+)').firstMatch(contextStr);
          if (siteMatch != null && siteMatch.group(1) != null) {
            contextInfo['site_id'] = int.parse(siteMatch.group(1)!);
          }

          // Visit ID extraction
          final visitMatch = RegExp(r'/visit/(\d+)').firstMatch(contextStr);
          if (visitMatch != null && visitMatch.group(1) != null) {
            contextInfo['visit'] = int.parse(visitMatch.group(1)!);
          }

          // Observation ID extraction
          final obsMatch = RegExp(r'/observation/(\d+)').firstMatch(contextStr);
          if (obsMatch != null && obsMatch.group(1) != null) {
            contextInfo['observation'] = int.parse(obsMatch.group(1)!);
          }

          // Observation detail ID extraction
          final detailMatch = RegExp(r'/detail/(\d+)').firstMatch(contextStr);
          if (detailMatch != null && detailMatch.group(1) != null) {
            contextInfo['detail'] = int.parse(detailMatch.group(1)!);
          }
          
          // Site group ID extraction
          final siteGroupMatch = RegExp(r'/site_group/(\d+)').firstMatch(contextStr);
          if (siteGroupMatch != null && siteGroupMatch.group(1) != null) {
            contextInfo['site_group_id'] = int.parse(siteGroupMatch.group(1)!);
          }
        } else {
          // Format avec deux points: module:22 ou visit:5

          // Module ID extraction
          final moduleMatch =
              RegExp(r'module[":]*(\d+)').firstMatch(contextStr);
          if (moduleMatch != null && moduleMatch.group(1) != null) {
            contextInfo['module_id'] = int.parse(moduleMatch.group(1)!);
          }

          // Site ID extraction
          final siteMatch = RegExp(r'site[":]*(\d+)').firstMatch(contextStr);
          if (siteMatch != null && siteMatch.group(1) != null) {
            contextInfo['site_id'] = int.parse(siteMatch.group(1)!);
          }

          // Visit ID extraction
          final visitMatch = RegExp(r'visit[":]*(\d+)').firstMatch(contextStr);
          if (visitMatch != null && visitMatch.group(1) != null) {
            contextInfo['visit'] = int.parse(visitMatch.group(1)!);
          }

          // Observation ID extraction
          final obsMatch =
              RegExp(r'observation[":]*(\d+)').firstMatch(contextStr);
          if (obsMatch != null && obsMatch.group(1) != null) {
            contextInfo['observation'] = int.parse(obsMatch.group(1)!);
          }

          // Observation detail ID extraction
          final detailMatch =
              RegExp(r'detail[":]*(\d+)').firstMatch(contextStr);
          if (detailMatch != null && detailMatch.group(1) != null) {
            contextInfo['detail'] = int.parse(detailMatch.group(1)!);
          }
          
          // Site group ID extraction
          final siteGroupMatch = RegExp(r'site_group[":]*(\d+)').firstMatch(contextStr);
          if (siteGroupMatch != null && siteGroupMatch.group(1) != null) {
            contextInfo['site_group_id'] = int.parse(siteGroupMatch.group(1)!);
          }
        }
      }

      // Récupérer le contexte à partir des données locales
      if (contextInfo.isEmpty && conflict.localData.containsKey('_context')) {
        final contextData =
            conflict.localData['_context'] as Map<String, dynamic>;
        contextInfo.addAll(contextData);
      }

      // Essayer d'extraire les informations génériques
      if (contextInfo.isEmpty) {
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
        } else if (conflict.entityType.toLowerCase() == 'site') {
          contextInfo['site_id'] = int.tryParse(conflict.entityId) ?? 0;
        } else if (conflict.entityType.toLowerCase() == 'sitegroup' ||
                   conflict.entityType.toLowerCase() == 'site_group') {
          contextInfo['site_group_id'] = int.tryParse(conflict.entityId) ?? 0;
        }
      }

      // Debug: Afficher le contexte extrait
      debugPrint('ConflictNavigationService - Context Info: $contextInfo');

      // Débuter avec l'indicateur de chargement
      showLoadingIndicator();

      // Déterminer l'élément cible selon la priorité d'accès:
      // détail > observation > visite > site > module

      // Si nous avons un module_id, c'est notre point de départ
      if (contextInfo.containsKey('module_id')) {
        final moduleId = contextInfo['module_id'] as int;

        // Récupérer les modules de l'utilisateur
        final modulesState = ref.read(userModuleListeProvider);

        // Attendre un peu pour que les modules soient chargés si nécessaire
        if (modulesState.isLoading) {
          await Future.delayed(const Duration(milliseconds: 500));
        }

        ModuleInfo? moduleInfo;

        // Rechercher le module dans les données disponibles
        if (modulesState.data != null) {
          final moduleToOpen = modulesState.data!.values
              .where((m) => m.module.id == moduleId)
              .toList();

          if (moduleToOpen.isNotEmpty) {
            // Récupérer le module
            moduleInfo = moduleToOpen.first;

            // Si nous avons un site_id
            if (contextInfo.containsKey('site_id')) {
              final siteId = contextInfo['site_id'] as int;
              final siteToOpen = moduleInfo.module.sites
                  ?.where((s) => s.idBaseSite == siteId)
                  .toList();

              if (siteToOpen != null && siteToOpen.isNotEmpty) {
                final site = siteToOpen.first;

                // Si nous avons une visite
                if (contextInfo.containsKey('visit')) {
                  final visitId = contextInfo['visit'] as int;

                  try {
                    final siteVisitsViewModel = ref.read(
                        siteVisitsViewModelProvider(
                            (site.idBaseSite, moduleInfo.module.id)).notifier);

                    final visit = await siteVisitsViewModel
                        .getVisitWithFullDetails(visitId);

                    if (visit != null) {
                      // Si nous avons une observation
                      if (contextInfo.containsKey('observation')) {
                        final observationId = contextInfo['observation'] as int;
                        final observationsViewModel =
                            ref.read(observationsProvider(visitId).notifier);

                        try {
                          final observation = await observationsViewModel
                              .getObservationById(observationId);

                          if (observation != null) {
                            // Obtenir la configuration pour les observations
                            final observationConfig = moduleInfo
                                .module.complement?.configuration?.observation;
                            final customConfig = moduleInfo
                                .module.complement?.configuration?.custom;
                            final observationDetailConfig = moduleInfo.module
                                .complement?.configuration?.observationDetail;

                            // Si nous avons un détail d'observation
                            if (contextInfo.containsKey('detail')) {
                              final detailId = contextInfo['detail'] as int;
                              final observationDetailViewModel = ref.read(
                                  observationDetailsProvider(observationId)
                                      .notifier);

                              try {
                                final detail = await observationDetailViewModel
                                    .getObservationDetailById(detailId);

                                if (detail != null &&
                                    observationDetailConfig != null) {
                                  // Fermer l'indicateur de chargement
                                  hideLoadingIndicator();

                                  // Naviguer vers le détail d'observation
                                  if (!context.mounted) return false;
                                  final result = await Navigator.push<bool>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ObservationDetailDetailPage(
                                        observationDetail: detail,
                                        config: observationDetailConfig,
                                        customConfig: customConfig,
                                        index: 0,
                                        currentConflict: conflict,
                                      ),
                                    ),
                                  );
                                  
                                  // Si la modification a réussi, marquer le conflit comme résolu
                                  if (result == true) {
                                    ref.read(conflictResolutionProvider.notifier)
                                      .markAsResolved(conflict, 'Détail d\'observation modifié');
                                  }
                                  
                                  return result ?? false;
                                }
                              } catch (e) {
                                debugPrint(
                                    'Erreur lors du chargement du détail: $e');
                              }
                            }

                            // Si pas de détail ou erreur, naviguer vers l'observation
                            hideLoadingIndicator();

                            if (!context.mounted) return false;
                            final result = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ObservationDetailPage(
                                  observation: observation,
                                  visit: visit,
                                  site: site,
                                  moduleInfo: moduleInfo,
                                  observationConfig: observationConfig,
                                  customConfig: customConfig,
                                  observationDetailConfig:
                                      observationDetailConfig,
                                  currentConflict: conflict,
                                ),
                              ),
                            );
                            
                            // Si la modification a réussi, marquer le conflit comme résolu
                            if (result == true) {
                              ref.read(conflictResolutionProvider.notifier)
                                .markAsResolved(conflict, 'Observation modifiée');
                            }
                            
                            return result ?? false;
                          }
                        } catch (e) {
                          debugPrint(
                              'Erreur lors du chargement de l\'observation: $e');
                        }
                      }

                      // Si pas d'observation ou erreur, naviguer vers la visite
                      hideLoadingIndicator();

                      if (!context.mounted) return false;
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VisitDetailPage(
                            visit: visit,
                            site: site,
                            moduleInfo: moduleInfo,
                            currentConflict: conflict,
                          ),
                        ),
                      );
                      
                      // Si la modification a réussi, marquer le conflit comme résolu
                      if (result == true) {
                        ref.read(conflictResolutionProvider.notifier)
                          .markAsResolved(conflict, 'Visite modifiée');
                      }
                      
                      return result ?? false;
                    }
                  } catch (e) {
                    debugPrint('Erreur lors du chargement de la visite: $e');
                  }
                }

                // Si pas de visite ou erreur, naviguer vers le site
                hideLoadingIndicator();

                if (!context.mounted) return false;
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SiteDetailPage(
                      site: site,
                      moduleInfo: moduleInfo,
                      currentConflict: conflict,
                    ),
                  ),
                );
                
                // Si la modification a réussi, marquer le conflit comme résolu
                if (result == true) {
                  ref.read(conflictResolutionProvider.notifier)
                    .markAsResolved(conflict, 'Site modifié');
                }
                
                return result ?? false;
              }
            }
          }
        }

        // Si on n'a pas trouvé le module dans les données normales,
        // on en crée un par défaut (cas dégradé)
        if (moduleInfo == null) {
          moduleInfo = ModuleInfo(
            module: Module(id: moduleId),
            downloadStatus: ModuleDownloadStatus.moduleNotDownloaded,
          );
        }

        // Naviguer vers le module (cas par défaut)
        hideLoadingIndicator();

        if (!context.mounted) return false;
        final result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (context) => ModuleDetailPage(
              moduleInfo: moduleInfo!,
            ),
          ),
        );
        
        // Si la modification a réussi, marquer le conflit comme résolu
        if (result == true) {
          ref.read(conflictResolutionProvider.notifier)
            .markAsResolved(conflict, 'Module modifié');
        }
        
        return result ?? false;
      }
      
      // Si nous avons un site_group_id sans module
      if (contextInfo.containsKey('site_group_id')) {
        final siteGroupId = contextInfo['site_group_id'] as int;
        
        // Nous devons récupérer le site group et le module
        showLoadingIndicator();
        try {
          // Récupérer les groupes de sites de l'utilisateur
          final siteGroupListState = ref.read(siteGroupViewModelStateNotifierProvider);
          SiteGroup? siteGroup;
          siteGroupListState.when(
            init: () => throw Exception('Site groups not initialized'),
            success: (siteGroups) {
              siteGroup = siteGroups.firstWhere(
                (sg) => sg.idSitesGroup == siteGroupId,
                orElse: () => throw Exception('Site group not found'),
              );
            },
            loading: () => throw Exception('Site groups loading'),
            error: (message) => throw Exception('Error loading site groups: $message'),
          );
          
          if (siteGroup == null) throw Exception('Site group not found');
          
          // Trouver un module associé à ce groupe de sites
          final moduleListState = ref.read(userModuleListeViewModelStateNotifierProvider);
          ModuleInfo? moduleInfo;
          moduleListState.when(
            init: () => throw Exception('Modules not initialized'),
            success: (modules) {
              // Chercher le premier module qui contient ce groupe de sites
              moduleInfo = modules.values.firstWhere(
                (mi) => mi.module.sitesGroup?.any((sg) => sg.idSitesGroup == siteGroupId) ?? false,
                orElse: () => throw Exception('Module not found for site group'),
              );
            },
            loading: () => throw Exception('Modules loading'),
            error: (message) => throw Exception('Error loading modules: $message'),
          );
          
          if (moduleInfo == null) throw Exception('Module not found');
          
          hideLoadingIndicator();
          
          if (!context.mounted) return false;
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => SiteGroupDetailPage(
                siteGroup: siteGroup!,
                moduleInfo: moduleInfo!,
              ),
            ),
          );
          
          // Si la modification a réussi, marquer le conflit comme résolu
          if (result == true) {
            ref.read(conflictResolutionProvider.notifier)
              .markAsResolved(conflict, 'Groupe de sites modifié');
          }
          
          return result ?? false;
        } catch (e) {
          hideLoadingIndicator();
          debugPrint('Erreur lors de la navigation vers le groupe de sites: $e');
          return false;
        }
      }
      
      // Si nous avons un site_id sans module
      if (contextInfo.containsKey('site_id')) {
        final siteId = contextInfo['site_id'] as int;
        
        // Essayer de trouver le site dans les données disponibles
        final modulesState = ref.read(userModuleListeProvider);
        
        if (modulesState.data != null) {
          for (final moduleInfo in modulesState.data!.values) {
            final siteToOpen = moduleInfo.module.sites
                ?.where((s) => s.idBaseSite == siteId)
                .toList();
                
            if (siteToOpen != null && siteToOpen.isNotEmpty) {
              final site = siteToOpen.first;
              hideLoadingIndicator();
              
              if (!context.mounted) return false;
              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => SiteDetailPage(
                    site: site,
                    moduleInfo: moduleInfo,
                    currentConflict: conflict,
                  ),
                ),
              );
              
              // Si la modification a réussi, marquer le conflit comme résolu
              if (result == true) {
                ref.read(conflictResolutionProvider.notifier)
                  .markAsResolved(conflict, 'Site modifié');
              }
              
              return result ?? false;
            }
          }
        }
      }

      // Si on arrive ici, on n'a pas réussi à naviguer
      if (!context.mounted) return false;
      hideLoadingIndicator();

      // Afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Impossible d\'accéder directement à l\'élément (${determineMainEntityName(conflict, contextInfo)})',
            style: const TextStyle(fontSize: 14),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    } catch (e) {
      hideLoadingIndicator();
      if (!context.mounted) return false;

      // Afficher une erreur générique
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erreur de navigation: ${e.toString()}',
            style: const TextStyle(fontSize: 14),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 5),
        ),
      );
    }
    return false;
  }
}
