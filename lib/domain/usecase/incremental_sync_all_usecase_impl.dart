import 'package:flutter/foundation.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';
import 'package:gn_mobile_monitoring/domain/repository/sync_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_all_usecase.dart';

class IncrementalSyncAllUseCaseImpl implements IncrementalSyncAllUseCase {
  final SyncRepository _repository;

  IncrementalSyncAllUseCaseImpl(this._repository);

  @override
  Future<Map<String, SyncResult>> execute(
    String token, {
    bool syncConfiguration = true,
    bool syncNomenclatures = true,
    bool syncTaxons = true,
    bool syncObservers = true,
    bool syncModules = true,
    bool syncSites = true,
    bool syncSiteGroups = true,
  }) async {
    final results = <String, SyncResult>{};

    try {
      // Vérifier la connectivité
      final isConnected = await _repository.checkConnectivity();
      if (!isConnected) {
        // Si pas de connexion, retourner un résultat d'échec pour toutes les opérations
        final failureResult = SyncResult.failure(
          errorMessage: 'Pas de connexion Internet',
        );

        return {
          'configuration': failureResult,
          'nomenclatures_datasets': failureResult,
          'taxons': failureResult,
          'observers': failureResult,
          'modules': failureResult,
          'sites': failureResult,
          'siteGroups': failureResult,
        };
      }

      // Synchroniser la configuration
      if (syncConfiguration) {
        try {
          results['configuration'] = await _repository.syncConfiguration(token);
        } catch (e) {
          debugPrint(
              'Erreur lors de la synchronisation de la configuration: $e');
          results['configuration'] = SyncResult.failure(
            errorMessage:
                'Erreur lors de la synchronisation de la configuration: $e',
          );
        }
      }

      // Synchroniser les nomenclatures et datasets
      if (syncNomenclatures) {
        try {
          results['nomenclatures_datasets'] =
              await _repository.syncNomenclaturesAndDatasets(token);
        } catch (e) {
          debugPrint(
              'Erreur lors de la synchronisation des nomenclatures et datasets: $e');
          results['nomenclatures_datasets'] = SyncResult.failure(
            errorMessage:
                'Erreur lors de la synchronisation des nomenclatures et datasets: $e',
          );
        }
      }

      // Synchroniser les taxons
      if (syncTaxons) {
        try {
          results['taxons'] = await _repository.syncTaxons(token);
        } catch (e) {
          debugPrint('Erreur lors de la synchronisation des taxons: $e');
          results['taxons'] = SyncResult.failure(
            errorMessage: 'Erreur lors de la synchronisation des taxons: $e',
          );
        }
      }

      // Synchroniser les observateurs
      if (syncObservers) {
        try {
          results['observers'] = await _repository.syncObservers(token);
        } catch (e) {
          debugPrint('Erreur lors de la synchronisation des observateurs: $e');
          results['observers'] = SyncResult.failure(
            errorMessage:
                'Erreur lors de la synchronisation des observateurs: $e',
          );
        }
      }

      // Synchroniser les modules
      if (syncModules) {
        try {
          results['modules'] = await _repository.syncModules(token);
        } catch (e) {
          debugPrint('Erreur lors de la synchronisation des modules: $e');
          results['modules'] = SyncResult.failure(
            errorMessage: 'Erreur lors de la synchronisation des modules: $e',
          );
        }
      }

      // Synchroniser les sites
      if (syncSites) {
        try {
          results['sites'] = await _repository.syncSites(token);
        } catch (e) {
          debugPrint('Erreur lors de la synchronisation des sites: $e');
          results['sites'] = SyncResult.failure(
            errorMessage: 'Erreur lors de la synchronisation des sites: $e',
          );
        }
      }

      // Synchroniser les groupes de sites
      if (syncSiteGroups) {
        try {
          results['siteGroups'] = await _repository.syncSiteGroups(token);
        } catch (e) {
          debugPrint(
              'Erreur lors de la synchronisation des groupes de sites: $e');
          results['siteGroups'] = SyncResult.failure(
            errorMessage:
                'Erreur lors de la synchronisation des groupes de sites: $e',
          );
        }
      }

      // La synchronisation des observations sera implémentée dans une future version

      return results;
    } catch (e) {
      debugPrint('Erreur globale lors de la synchronisation: $e');
      // En cas d'erreur générale, retourner un résultat d'échec pour toutes les opérations
      final failureResult = SyncResult.failure(
        errorMessage: 'Erreur globale lors de la synchronisation: $e',
      );

      return {
        'configuration': failureResult,
        'nomenclatures_datasets': failureResult,
        'taxons': failureResult,
        'observers': failureResult,
        'modules': failureResult,
        'sites': failureResult,
        'siteGroups': failureResult,
      };
    }
  }
}
