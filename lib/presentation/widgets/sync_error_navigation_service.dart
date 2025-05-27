import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/state/module_download_status.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation/observation_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/visit/visit_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/modules_utilisateur_viewmodel.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';

/// Service gérant la navigation vers les éléments avec erreurs de synchronisation
class SyncErrorNavigationService {
  
  /// Extrait les informations d'entité depuis un message d'erreur
  static Map<String, dynamic>? _extractEntityInfo(String errorMessage) {
    // Formats d'erreur possibles:
    // "ERREUR - Visite 123: ..." 
    // "ERREUR - Observation 456: ..."
    // "ERREUR - Detail 789: ..."
    
    final visitMatch = RegExp(r'ERREUR - Visite (\d+):').firstMatch(errorMessage);
    if (visitMatch != null) {
      return {
        'type': 'visit',
        'id': int.parse(visitMatch.group(1)!),
        'rawMessage': errorMessage,
      };
    }
    
    final observationMatch = RegExp(r'ERREUR - Observation (\d+):').firstMatch(errorMessage);
    if (observationMatch != null) {
      return {
        'type': 'observation', 
        'id': int.parse(observationMatch.group(1)!),
        'rawMessage': errorMessage,
      };
    }
    
    final detailMatch = RegExp(r'ERREUR - Detail (\d+):').firstMatch(errorMessage);
    if (detailMatch != null) {
      return {
        'type': 'observation_detail',
        'id': int.parse(detailMatch.group(1)!),
        'rawMessage': errorMessage,
      };
    }
    
    return null;
  }
  
  /// Enrichit le message d'erreur avec du contexte supplémentaire
  static Future<String> enrichErrorMessage(String rawMessage, WidgetRef ref) async {
    final entityInfo = _extractEntityInfo(rawMessage);
    if (entityInfo == null) return rawMessage;
    
    try {
      final entityType = entityInfo['type'] as String;
      final entityId = entityInfo['id'] as int;
      
      // Récupérer des informations contextuelles selon le type d'entité
      if (entityType == 'visit') {
        return await _enrichVisitErrorMessage(rawMessage, entityId, ref);
      } else if (entityType == 'observation') {
        return await _enrichObservationErrorMessage(rawMessage, entityId, ref);
      }
      
      return rawMessage;
    } catch (e) {
      // En cas d'erreur lors de l'enrichissement, retourner le message original
      return rawMessage;
    }
  }
  
  /// Enrichit un message d'erreur de visite avec le contexte
  static Future<String> _enrichVisitErrorMessage(String rawMessage, int visitId, WidgetRef ref) async {
    try {
      final getVisitWithDetailsUseCase = ref.read(getVisitWithDetailsUseCaseProvider);
      final visit = await getVisitWithDetailsUseCase.execute(visitId);
      
      // Récupérer le nom du module
      final modulesState = ref.read(userModuleListeProvider);
      String moduleName = 'Module ${visit.idModule}';
      String siteName = 'Site ${visit.idBaseSite ?? 'inconnu'}';
      
      if (modulesState.data != null) {
        final moduleInfo = modulesState.data!.values
            .where((m) => m.module.id == visit.idModule)
            .firstOrNull;
        
        if (moduleInfo != null) {
          moduleName = moduleInfo.module.moduleLabel ?? 'Module ${visit.idModule}';
          
          // Chercher le site dans ce module
          final site = moduleInfo.module.sites
              ?.where((s) => s.idBaseSite == visit.idBaseSite)
              .firstOrNull;
          
          if (site != null) {
            siteName = site.baseSiteName ?? 'Site ${visit.idBaseSite}';
          }
        }
      }
      
      // Extraire le message d'erreur technique
      final errorPart = rawMessage.split(':').skip(1).join(':').trim();
      
      // Formater le message enrichi
      return 'Visite $visitId • $siteName • $moduleName\n$errorPart';
      
    } catch (e) {
      return rawMessage;
    }
  }
  
  /// Enrichit un message d'erreur d'observation avec le contexte
  static Future<String> _enrichObservationErrorMessage(String rawMessage, int observationId, WidgetRef ref) async {
    try {
      final getObservationByIdUseCase = ref.read(getObservationByIdUseCaseProvider);
      final observation = await getObservationByIdUseCase.execute(observationId);
      
      if (observation == null) return rawMessage;
      
      // Récupérer la visite associée
      final getVisitWithDetailsUseCase = ref.read(getVisitWithDetailsUseCaseProvider);
      final visit = await getVisitWithDetailsUseCase.execute(observation.idBaseVisit!);
      
      // Récupérer le nom du module et du site
      final modulesState = ref.read(userModuleListeProvider);
      String moduleName = 'Module ${visit.idModule}';
      String siteName = 'Site ${visit.idBaseSite ?? 'inconnu'}';
      
      if (modulesState.data != null) {
        final moduleInfo = modulesState.data!.values
            .where((m) => m.module.id == visit.idModule)
            .firstOrNull;
        
        if (moduleInfo != null) {
          moduleName = moduleInfo.module.moduleLabel ?? 'Module ${visit.idModule}';
          
          final site = moduleInfo.module.sites
              ?.where((s) => s.idBaseSite == visit.idBaseSite)
              .firstOrNull;
          
          if (site != null) {
            siteName = site.baseSiteName ?? 'Site ${visit.idBaseSite}';
          }
        }
      }
      
      // Extraire le message d'erreur technique
      final errorPart = rawMessage.split(':').skip(1).join(':').trim();
      
      // Formater le message enrichi
      return 'Observation $observationId • Visite ${observation.idBaseVisit} • $siteName • $moduleName\n$errorPart';
      
    } catch (e) {
      return rawMessage;
    }
  }
  
  /// Navigation directe vers l'élément avec erreur de synchronisation
  /// Retourne true si la navigation a réussi
  static Future<bool> navigateToSyncErrorItem(
      BuildContext context, String errorMessage, WidgetRef ref) async {
    
    // Extraire les informations de l'entité depuis le message d'erreur
    final entityInfo = _extractEntityInfo(errorMessage);
    if (entityInfo == null) {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Impossible d\'identifier l\'élément depuis ce message d\'erreur'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return false;
    }
    
    final entityType = entityInfo['type'] as String;
    final entityId = entityInfo['id'] as int;
    
    // Overlay pour indiquer le chargement
    OverlayEntry? loadingOverlay;
    bool showLoading = false;
    
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
      showLoadingIndicator();
      
      if (entityType == 'visit') {
        return await _navigateToVisit(context, ref, entityId, hideLoadingIndicator);
      } else if (entityType == 'observation') {
        return await _navigateToObservation(context, ref, entityId, hideLoadingIndicator);
      } else if (entityType == 'observation_detail') {
        return await _navigateToObservationDetail(context, ref, entityId, hideLoadingIndicator);
      }
      
      hideLoadingIndicator();
      return false;
      
    } catch (e) {
      hideLoadingIndicator();
      if (!context.mounted) return false;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur de navigation: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 5),
        ),
      );
      return false;
    }
  }
  
  /// Navigation vers une visite spécifique
  static Future<bool> _navigateToVisit(BuildContext context, WidgetRef ref, 
      int visitId, VoidCallback hideLoading) async {
    
    try {
      // Récupérer la visite avec tous ses détails en utilisant le use case
      final getVisitWithDetailsUseCase = ref.read(getVisitWithDetailsUseCaseProvider);
      final visit = await getVisitWithDetailsUseCase.execute(visitId);
      
      // Récupérer le module et le site associés
      final moduleId = visit.idModule;
      final siteId = visit.idBaseSite;
      
      if (siteId == null) {
        hideLoading();
        if (!context.mounted) return false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Site associé à la visite introuvable'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return false;
      }
      
      // Récupérer les modules de l'utilisateur
      final modulesState = ref.read(userModuleListeProvider);
      
      if (modulesState.isLoading) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
      
      ModuleInfo? moduleInfo;
      BaseSite? site;
      
      // Rechercher le module dans les données disponibles
      if (modulesState.data != null) {
        final moduleToOpen = modulesState.data!.values
            .where((m) => m.module.id == moduleId)
            .toList();
        
        if (moduleToOpen.isNotEmpty) {
          moduleInfo = moduleToOpen.first;
          
          // Rechercher le site dans ce module
          final siteToOpen = moduleInfo.module.sites
              ?.where((s) => s.idBaseSite == siteId)
              .toList();
          
          if (siteToOpen != null && siteToOpen.isNotEmpty) {
            site = siteToOpen.first;
          }
        }
      }
      
      // Si on n'a pas trouvé le module dans les données normales,
      // on en crée un par défaut (cas dégradé)
      moduleInfo ??= ModuleInfo(
        module: Module(id: moduleId),
        downloadStatus: ModuleDownloadStatus.moduleNotDownloaded,
      );
      
      // Si on n'a pas trouvé le site, créer un site par défaut
      site ??= BaseSite(
        idBaseSite: siteId,
        baseSiteName: 'Site $siteId',
        baseSiteCode: 'SITE_$siteId',
      );
      
      hideLoading();
      
      if (!context.mounted) return false;
      
      // Navigation directe vers la visite avec tout le contexte (module → site → visite)
      // Cela suit le même pattern que ConflictNavigationService
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => VisitDetailPage(
            visit: visit,
            site: site!,
            moduleInfo: moduleInfo!,
            // Indiquer que c'est depuis une erreur de sync pour différencier le contexte si nécessaire
          ),
        ),
      );
      
      return result ?? false;
      
    } catch (e) {
      hideLoading();
      debugPrint('Erreur lors de la navigation vers la visite: $e');
      rethrow;
    }
  }
  
  /// Navigation vers une observation spécifique
  static Future<bool> _navigateToObservation(BuildContext context, WidgetRef ref, 
      int observationId, VoidCallback hideLoading) async {
    
    try {
      // Récupérer l'observation en utilisant le use case
      final getObservationByIdUseCase = ref.read(getObservationByIdUseCaseProvider);
      final observation = await getObservationByIdUseCase.execute(observationId);
      
      if (observation == null) {
        hideLoading();
        if (!context.mounted) return false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Observation $observationId introuvable'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return false;
      }
      
      // Récupérer la visite associée en utilisant le use case
      final visitId = observation.idBaseVisit;
      final getVisitWithDetailsUseCase = ref.read(getVisitWithDetailsUseCaseProvider);
      final visit = await getVisitWithDetailsUseCase.execute(visitId!);
      
      // Récupérer le module et le site
      final moduleId = visit.idModule;
      final siteId = visit.idBaseSite;
      
      if (siteId == null) {
        hideLoading();
        if (!context.mounted) return false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Site associé introuvable'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return false;
      }
      
      // Récupérer les informations du module
      final modulesState = ref.read(userModuleListeProvider);
      
      if (modulesState.isLoading) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
      
      ModuleInfo? moduleInfo;
      BaseSite? site;
      
      if (modulesState.data != null) {
        final moduleToOpen = modulesState.data!.values
            .where((m) => m.module.id == moduleId)
            .toList();
        
        if (moduleToOpen.isNotEmpty) {
          moduleInfo = moduleToOpen.first;
          
          final siteToOpen = moduleInfo.module.sites
              ?.where((s) => s.idBaseSite == siteId)
              .toList();
          
          if (siteToOpen != null && siteToOpen.isNotEmpty) {
            site = siteToOpen.first;
          }
        }
      }
      
      // Cas dégradés si les données ne sont pas trouvées
      moduleInfo ??= ModuleInfo(
        module: Module(id: moduleId),
        downloadStatus: ModuleDownloadStatus.moduleNotDownloaded,
      );
      
      site ??= BaseSite(
        idBaseSite: siteId,
        baseSiteName: 'Site $siteId',
        baseSiteCode: 'SITE_$siteId',
      );
      
      hideLoading();
      
      if (!context.mounted) return false;
      
      // Naviguer vers la page de détail de l'observation
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => ObservationDetailPage(
            observation: observation,
            visit: visit,
            site: site!,
            moduleInfo: moduleInfo!,
            observationConfig: moduleInfo.module.complement?.configuration?.observation,
            customConfig: moduleInfo.module.complement?.configuration?.custom,
            observationDetailConfig: moduleInfo.module.complement?.configuration?.observationDetail,
          ),
        ),
      );
      
      return result ?? false;
      
    } catch (e) {
      hideLoading();
      debugPrint('Erreur lors de la navigation vers l\'observation: $e');
      rethrow;
    }
  }
  
  /// Navigation vers un détail d'observation spécifique
  static Future<bool> _navigateToObservationDetail(BuildContext context, WidgetRef ref, 
      int detailId, VoidCallback hideLoading) async {
    
    hideLoading();
    if (!context.mounted) return false;
    
    // Pour les détails d'observation, on affiche un message informatif
    // car la navigation nécessiterait plus de contexte
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigation vers le détail d\'observation $detailId non implémentée'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 3),
      ),
    );
    
    return false;
  }
}

