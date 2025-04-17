import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/dataset.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_datasets_for_module_use_case.dart';

/// Fournit un service pour accéder aux datasets de l'application
/// Ce service est accessible via le provider datasetServiceProvider
final datasetServiceProvider = Provider<DatasetService>((ref) {
  final getDatasetsForModuleUseCase = ref.watch(getDatasetsForModuleUseCaseProvider);
  return DatasetService(getDatasetsForModuleUseCase);
});

/// Service pour gérer les datasets
class DatasetService {
  final GetDatasetsForModuleUseCase _getDatasetsForModuleUseCase;
  
  // Cache des datasets par module pour éviter des appels répétés
  final Map<int, List<Dataset>> _datasetsByModule = {};

  DatasetService(this._getDatasetsForModuleUseCase);

  /// Récupère tous les datasets associés à un module
  Future<List<Dataset>> getDatasetsForModule(int moduleId) async {
    // Si les datasets sont déjà en cache, les renvoyer
    if (_datasetsByModule.containsKey(moduleId)) {
      return _datasetsByModule[moduleId]!;
    }

    try {
      // Récupérer les datasets depuis le repository
      final datasets = await _getDatasetsForModuleUseCase.execute(moduleId);
      
      // Stocker en cache pour les prochains appels
      _datasetsByModule[moduleId] = datasets;
      
      return datasets;
    } catch (e) {
      // En cas d'erreur, retourner une liste vide et ne pas mettre en cache
      return [];
    }
  }

  /// Récupère un dataset par son ID
  Future<Dataset?> getDatasetById(int moduleId, int datasetId) async {
    final datasets = await getDatasetsForModule(moduleId);
    return datasets.firstWhere(
      (dataset) => dataset.id == datasetId,
      orElse: () => throw Exception('Dataset with ID $datasetId not found'),
    );
  }

  /// Effacer le cache pour un module spécifique
  void clearCache(int moduleId) {
    _datasetsByModule.remove(moduleId);
  }

  /// Effacer tout le cache
  void clearAllCache() {
    _datasetsByModule.clear();
  }
}

