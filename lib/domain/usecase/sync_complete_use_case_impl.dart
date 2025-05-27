import 'package:flutter/foundation.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';
import 'package:gn_mobile_monitoring/domain/repository/sync_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_modules_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/sync_complete_use_case.dart';

/// Implémentation du use case de synchronisation complète
class SyncCompleteUseCaseImpl implements SyncCompleteUseCase {
  final SyncRepository _syncRepository;
  final GetModulesUseCase _getModulesUseCase;

  SyncCompleteUseCaseImpl(
    this._syncRepository,
    this._getModulesUseCase,
  );

  @override
  Future<SyncResult> execute(String token) async {
    try {
      debugPrint('[SYNC_COMPLETE] Début de la synchronisation complète');
      
      // Variables pour consolider les résultats
      int totalItemsProcessed = 0;
      int totalItemsAdded = 0;
      int totalItemsUpdated = 0;
      int totalItemsSkipped = 0;
      int totalItemsDeleted = 0;
      final List<String> allErrors = [];
      bool hasAnySuccess = false;

      // 1. Récupérer tous les modules disponibles
      final modules = await _getModulesUseCase.execute();
      
      if (modules.isEmpty) {
        debugPrint('[SYNC_COMPLETE] Aucun module trouvé');
        return SyncResult.failure(
          errorMessage: 'Aucun module disponible pour la synchronisation',
        );
      }

      debugPrint('[SYNC_COMPLETE] ${modules.length} module(s) trouvé(s)');

      // 2. Synchroniser les visites pour chaque module
      for (final module in modules) {
        if (module.moduleCode == null) {
          debugPrint('[SYNC_COMPLETE] Module sans code ignoré: ${module.moduleLabel}');
          continue;
        }

        debugPrint('[SYNC_COMPLETE] Synchronisation du module: ${module.moduleCode}');
        
        try {
          final result = await _syncRepository.syncVisitsToServer(
            token, 
            module.moduleCode!,
          );

          // Consolider les statistiques
          totalItemsProcessed += result.itemsProcessed;
          totalItemsAdded += result.itemsAdded;
          totalItemsUpdated += result.itemsUpdated;
          totalItemsSkipped += result.itemsSkipped;
          totalItemsDeleted += result.itemsDeleted ?? 0;

          if (result.success) {
            hasAnySuccess = true;
            debugPrint('[SYNC_COMPLETE] Module ${module.moduleCode} synchronisé avec succès');
          } else {
            allErrors.add('Module ${module.moduleCode}: ${result.errorMessage}');
            debugPrint('[SYNC_COMPLETE] Erreur module ${module.moduleCode}: ${result.errorMessage}');
          }

          // Ajouter les informations sur les échecs
          if (result.itemsFailed > 0) {
            allErrors.add('${module.moduleCode}: ${result.itemsFailed} éléments ont échoué');
          }
        } catch (e) {
          final errorMsg = 'Erreur lors de la synchronisation du module ${module.moduleCode}: $e';
          allErrors.add(errorMsg);
          debugPrint('[SYNC_COMPLETE] $errorMsg');
        }
      }

      // 3. Construire le résultat final
      final hasErrors = allErrors.isNotEmpty;
      final success = hasAnySuccess && !hasErrors;

      debugPrint('[SYNC_COMPLETE] Synchronisation terminée - Succès: $success, Erreurs: ${allErrors.length}');

      if (success) {
        return SyncResult.success(
          itemsProcessed: totalItemsProcessed,
          itemsAdded: totalItemsAdded,
          itemsUpdated: totalItemsUpdated,
          itemsSkipped: totalItemsSkipped,
          itemsDeleted: totalItemsDeleted,
        );
      } else {
        return SyncResult.failure(
          errorMessage: hasAnySuccess 
            ? 'Synchronisation partiellement réussie avec ${allErrors.length} erreur(s): ${allErrors.join('; ')}'
            : 'Échec de la synchronisation complète: ${allErrors.join('; ')}',
          itemsProcessed: totalItemsProcessed,
          itemsAdded: totalItemsAdded,
          itemsUpdated: totalItemsUpdated,
          itemsSkipped: totalItemsSkipped,
          itemsDeleted: totalItemsDeleted,
        );
      }
    } catch (e) {
      debugPrint('[SYNC_COMPLETE] Erreur fatale: $e');
      return SyncResult.failure(
        errorMessage: 'Erreur fatale lors de la synchronisation complète: $e',
      );
    }
  }
}