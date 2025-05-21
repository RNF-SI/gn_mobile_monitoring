import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/format_datetime.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/dataset.dart';
import 'package:gn_mobile_monitoring/domain/model/visit_complement.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_visit_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_visit_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_name_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visit_complement_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_observations_by_visit_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visit_with_details_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visits_by_site_and_module_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/save_visit_complement_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_visit_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/datasets_service.dart';

final siteVisitsViewModelProvider = StateNotifierProvider.family<
    SiteVisitsViewModel,
    AsyncValue<List<BaseVisit>>,
    (int, int)>((ref, params) {
  final (siteId, moduleId) = params;

  final getVisitsBySiteAndModuleUseCase =
      ref.watch(getVisitsBySiteAndModuleUseCaseProvider);
  final getVisitWithDetailsUseCase =
      ref.watch(getVisitWithDetailsUseCaseProvider);
  final getObservationsByVisitIdUseCase =
      ref.watch(getObservationsByVisitIdUseCaseProvider);
  final getVisitComplementUseCase =
      ref.watch(getVisitComplementUseCaseProvider);
  final saveVisitComplementUseCase =
      ref.watch(saveVisitComplementUseCaseProvider);
  final createVisitUseCase = ref.watch(createVisitUseCaseProvider);
  final updateVisitUseCase = ref.watch(updateVisitUseCaseProvider);
  final deleteVisitUseCase = ref.watch(deleteVisitUseCaseProvider);
  final getUserIdUseCase = ref.watch(getUserIdFromLocalStorageUseCaseProvider);
  final getUserNameUseCase =
      ref.watch(getUserNameFromLocalStorageUseCaseProvider);
  final datasetService = ref.watch(datasetServiceProvider);

  return SiteVisitsViewModel(
    getVisitsBySiteAndModuleUseCase,
    getVisitWithDetailsUseCase,
    getObservationsByVisitIdUseCase,
    getVisitComplementUseCase,
    saveVisitComplementUseCase,
    createVisitUseCase,
    updateVisitUseCase,
    deleteVisitUseCase,
    getUserIdUseCase,
    getUserNameUseCase,
    datasetService,
    siteId,
    moduleId,
  );
});

class SiteVisitsViewModel extends StateNotifier<AsyncValue<List<BaseVisit>>> {
  final GetVisitsBySiteAndModuleUseCase _getVisitsBySiteAndModuleUseCase;
  final GetVisitWithDetailsUseCase _getVisitWithDetailsUseCase;
  final GetObservationsByVisitIdUseCase _getObservationsByVisitIdUseCase;
  final GetVisitComplementUseCase _getVisitComplementUseCase;
  final SaveVisitComplementUseCase _saveVisitComplementUseCase;
  final CreateVisitUseCase _createVisitUseCase;
  final UpdateVisitUseCase _updateVisitUseCase;
  final DeleteVisitUseCase _deleteVisitUseCase;
  final GetUserIdFromLocalStorageUseCase _getUserIdUseCase;
  final GetUserNameFromLocalStorageUseCase _getUserNameUseCase;
  final DatasetService _datasetService;
  final int _siteId;
  final int _moduleId;
  bool _mounted = true;
  
  // Cache pour les datasets du module courant
  List<Dataset>? _moduleDatasets;

  SiteVisitsViewModel(
    this._getVisitsBySiteAndModuleUseCase,
    this._getVisitWithDetailsUseCase,
    this._getObservationsByVisitIdUseCase,
    this._getVisitComplementUseCase,
    this._saveVisitComplementUseCase,
    this._createVisitUseCase,
    this._updateVisitUseCase,
    this._deleteVisitUseCase,
    this._getUserIdUseCase,
    this._getUserNameUseCase,
    this._datasetService,
    this._siteId,
    this._moduleId,
  ) : super(const AsyncValue.loading()) {
    loadVisits();
    _loadDatasets();
  }
  
  /// Charge les datasets associés au module courant
  Future<void> _loadDatasets() async {
    if (!_mounted) return;
    
    try {
      _moduleDatasets = await _datasetService.getDatasetsForModule(_moduleId);
    } catch (e) {
      debugPrint('Erreur lors du chargement des datasets: $e');
      _moduleDatasets = [];
    }
  }

  /// Charge toutes les visites pour le site courant
  Future<void> loadVisits() async {
    if (!_mounted) return;

    try {
      state = const AsyncValue.loading();
      final visits =
          await _getVisitsBySiteAndModuleUseCase.execute(_siteId, _moduleId);
      if (_mounted) {
        state = AsyncValue.data(visits);
      }
    } catch (e, stack) {
      if (_mounted) {
        state = AsyncValue.error(e, stack);
      }
    }
  }

  /// Récupère l'ID de l'utilisateur connecté
  Future<int?> getCurrentUserId() async {
    return _getUserIdUseCase.execute();
  }

  /// Récupère le nom de l'utilisateur connecté
  Future<String?> getCurrentUserName() async {
    return _getUserNameUseCase.execute();
  }

  /// Crée une nouvelle visite à partir des données brutes du formulaire
  /// Retourne l'ID de la visite créée
  Future<int> createVisitFromFormData(
      Map<String, dynamic> formData, BaseSite site,
      {int? moduleId}) async {
    try {
      // Récupérer l'ID de l'utilisateur connecté
      final userId = await _getUserIdUseCase.execute();

      // Ajouter l'utilisateur courant aux observateurs s'il n'est pas déjà présent
      final observers = List<int>.from(formData['observers'] ?? []);
      if (userId != null && !observers.contains(userId)) {
        observers.add(userId);
      }

      // Mettre à jour les observateurs dans les données du formulaire
      final updatedFormData = Map<String, dynamic>.from(formData);
      updatedFormData['observers'] = observers;

      // Convertir les données du formulaire en un format approprié pour BaseVisit
      final jsonData = await _prepareVisitJsonData(updatedFormData, site,
          moduleId: moduleId);

      // Créer l'objet BaseVisit à partir des données JSON
      final visit = BaseVisit.fromJson(jsonData);

      // Créer la visite dans la base de données
      final visitId = await _createVisitUseCase.execute(visit);

      // Recharger la liste des visites
      await loadVisits();

      return visitId;
    } catch (e) {
      debugPrint('Erreur lors de la création de la visite: $e');
      rethrow;
    }
  }

  /// Met à jour une visite existante à partir des données brutes du formulaire
  Future<bool> updateVisitFromFormData(
      Map<String, dynamic> formData, BaseSite site, int visitId,
      {int? moduleId}) async {
    try {
      // Récupérer l'ID de l'utilisateur connecté
      final userId = await _getUserIdUseCase.execute();

      // Ajouter l'utilisateur courant aux observateurs s'il n'est pas déjà présent
      final observers = List<int>.from(formData['observers'] ?? []);
      if (userId != null && !observers.contains(userId)) {
        observers.add(userId);
      }

      // Mettre à jour les observateurs dans les données du formulaire
      final updatedFormData = Map<String, dynamic>.from(formData);
      updatedFormData['observers'] = observers;

      // Convertir les données du formulaire en un format approprié pour BaseVisit
      final jsonData = await _prepareVisitJsonData(updatedFormData, site,
          visitId: visitId, moduleId: moduleId);

      // Créer l'objet BaseVisit à partir des données JSON
      final visit = BaseVisit.fromJson(jsonData);

      // Mettre à jour la visite dans la base de données
      final success = await _updateVisitUseCase.execute(visit);

      // Recharger la liste des visites si la mise à jour a réussi
      if (success) {
        await loadVisits();
      }

      return success;
    } on Exception catch (e) {
      debugPrint('Exception lors de la mise à jour de la visite: $e');
      rethrow;
    } catch (e) {
      debugPrint('Erreur lors de la mise à jour de la visite: $e');
      throw Exception(e.toString());
    }
  }

  /// Compte le nombre d'observations d'une visite
  Future<int> getObservationCountForVisit(int visitId) async {
    try {
      final observations = await _getObservationsByVisitIdUseCase.execute(visitId);
      return observations.length;
    } catch (e) {
      debugPrint('Erreur lors du comptage des observations: $e');
      return 0;
    }
  }

  /// Supprime une visite de la base de données
  Future<bool> deleteVisit(int visitId) async {
    try {
      final success = await _deleteVisitUseCase.execute(visitId);
      if (success) {
        await loadVisits(); // Recharger la liste des visites
      }
      return success;
    } catch (e) {
      debugPrint('Erreur lors de la suppression de la visite: $e');
      rethrow;
    }
  }

  /// Récupère une visite avec tous ses détails (observateurs et données complémentaires)
  Future<BaseVisit> getVisitWithFullDetails(int visitId) async {
    try {
      return await _getVisitWithDetailsUseCase.execute(visitId);
    } catch (e) {
      debugPrint('Erreur lors du chargement des détails de la visite: $e');
      rethrow;
    }
  }

  /// Récupère les données complémentaires d'une visite
  Future<VisitComplement?> getVisitComplement(int visitId) async {
    try {
      return await _getVisitComplementUseCase.execute(visitId);
    } catch (e) {
      debugPrint('Erreur lors du chargement des données complémentaires: $e');
      rethrow;
    }
  }

  /// Sauvegarde des données complémentaires pour une visite
  Future<void> saveVisitComplement(VisitComplement complement) async {
    try {
      await _saveVisitComplementUseCase.execute(complement);
    } catch (e) {
      debugPrint(
          'Erreur lors de la sauvegarde des données complémentaires: $e');
      rethrow;
    }
  }

  /// Sauvegarde les données complémentaires d'une visite à partir d'un Map
  Future<void> saveVisitComplementFromData(
      int visitId, Map<String, dynamic> data) async {
    try {
      final complement = VisitComplement(
        idBaseVisit: visitId,
        data: data.isEmpty ? null : jsonEncode(data),
      );
      await _saveVisitComplementUseCase.execute(complement);
    } catch (e) {
      debugPrint(
          'Erreur lors de la sauvegarde des données complémentaires: $e');
      rethrow;
    }
  }

  /// Récupère les datasets disponibles pour le module courant
  Future<List<Dataset>> getDatasetsForCurrentModule() async {
    if (_moduleDatasets == null) {
      await _loadDatasets();
    }
    return _moduleDatasets ?? [];
  }
  
  /// Récupère un dataset par son ID
  Future<Dataset?> getDatasetById(int datasetId) async {
    final datasets = await getDatasetsForCurrentModule();
    try {
      return datasets.firstWhere((dataset) => dataset.id == datasetId);
    } catch (e) {
      return null;
    }
  }

  /// Convertit les données brutes du formulaire en format JSON compatible avec BaseVisit
  Future<Map<String, dynamic>> _prepareVisitJsonData(
      Map<String, dynamic> formData, BaseSite site,
      {int? visitId, int? moduleId}) async {
    // Récupérer l'ID de l'utilisateur connecté
    final userId = await _getUserIdUseCase.execute();

    // Prétraiter les données du formulaire pour normaliser les champs d'heure
    final Map<String, dynamic> processedFormData = Map.from(formData);
    processedFormData.forEach((key, value) {
      if (key.toLowerCase().contains('time') &&
          !key.toLowerCase().contains('date') &&
          value is String) {
        processedFormData[key] = normalizeTimeFormat(value);
      }
    });
    
    // Récupérer l'ID du dataset s'il est présent dans le formulaire
    int datasetId = 0;
    if (processedFormData.containsKey('id_dataset')) {
      final value = processedFormData['id_dataset'];
      if (value is int) {
        datasetId = value;
      } else if (value is String && int.tryParse(value) != null) {
        datasetId = int.parse(value);
      } else if (value is num) {
        datasetId = value.toInt();
      }
    }
    
    // Si aucun dataset n'a été sélectionné et que nous avons des datasets disponibles, utiliser le premier
    if (datasetId <= 0 && _moduleDatasets != null && _moduleDatasets!.isNotEmpty) {
      datasetId = _moduleDatasets!.first.id;
    }

    // Créer une structure JSON qui suit le format attendu par BaseVisit.fromJson()
    final Map<String, dynamic> jsonData = {
      // Champs obligatoires avec valeurs par défaut
      'idBaseVisit': visitId ?? 0,
      'idBaseSite': site.idBaseSite,
      'idDataset': datasetId > 0 ? datasetId : 1, // Utiliser l'ID du dataset sélectionné ou par défaut
      'idModule': moduleId ?? _moduleId, // Utiliser l'ID du module fourni ou celui courant
      'visitDateMin': _formatDateValue(processedFormData['visit_date_min']) ??
          DateTime.now().toIso8601String(),

      // Champs optionnels
      'idDigitiser': userId,
      'visitDateMax': _formatDateValue(processedFormData['visit_date_max']),
      'comments': processedFormData['comments']?.toString(),
      'idNomenclatureTechCollectCampanule':
          processedFormData['id_nomenclature_tech_collect_campanule'],
      'idNomenclatureGrpTyp': processedFormData['id_nomenclature_grp_typ'],
      'uuidBaseVisit': processedFormData['uuid_base_visit'],
      'metaCreateDate': DateTime.now().toIso8601String(),
      'metaUpdateDate': DateTime.now().toIso8601String(),

      // Données spécifiques au module (exclure les champs standard)
      'data': _extractModuleSpecificData(processedFormData),
    };

    // Gestion des observateurs - ils seront traités séparément par le use case
    List<int> observers = [];

    // Si des observateurs sont déjà dans le formulaire
    if (formData['observers'] is List) {
      final rawObservers = formData['observers'] as List;
      for (final item in rawObservers) {
        if (item is int) {
          observers.add(item);
        } else if (item is String && int.tryParse(item) != null) {
          observers.add(int.parse(item));
        } else if (item is num) {
          observers.add(item.toInt());
        }
      }
    }

    // Ajouter l'utilisateur connecté s'il n'est pas déjà inclus
    if (userId != null && userId > 0 && !observers.contains(userId)) {
      observers.add(userId);
    }

    // Ajouter la liste d'observateurs uniquement si non vide
    if (observers.isNotEmpty) {
      jsonData['observers'] = observers;
    }

    return jsonData;
  }

  /// Formate une valeur de date (String ou DateTime) en chaîne ISO
  String? _formatDateValue(dynamic dateValue) {
    if (dateValue == null) {
      return null;
    }

    if (dateValue is DateTime) {
      return dateValue.toIso8601String();
    }

    return dateValue.toString();
  }

  /// Extrait les données spécifiques au module en excluant les champs standard
  Map<String, dynamic> _extractModuleSpecificData(
      Map<String, dynamic> formData) {
    // Liste des clés à exclure (champs standard qui sont déjà traités séparément)
    const standardFields = {
      'id_base_visit',
      'id_base_site',
      'id_dataset', // id_dataset est maintenant dans idDataset au niveau BaseVisit
      'id_module',
      'visit_date_min',
      'visit_date_max',
      'comments',
      'observers',
    };

    // Créer un nouveau Map avec uniquement les données du module
    final Map<String, dynamic> moduleData = {};

    formData.forEach((key, value) {
      // Ignorer les champs standard et les valeurs null
      if (!standardFields.contains(key) && value != null) {
        // Conversion des types si nécessaire
        if (value is String && double.tryParse(value) != null) {
          // Convertir les nombres en format approprié
          if (double.parse(value) % 1 == 0) {
            moduleData[key] = int.parse(value);
          } else {
            moduleData[key] = double.parse(value);
          }
        } else if (value is DateTime) {
          // Convertir les dates en chaînes ISO
          moduleData[key] = value.toIso8601String();
        } else if (key.toLowerCase().contains('time') &&
            !key.toLowerCase().contains('date') &&
            value is String) {
          // Normaliser les valeurs d'heure pour éviter les problèmes de format
          moduleData[key] = normalizeTimeFormat(value);
        } else {
          moduleData[key] = value;
        }
      }
    });

    return moduleData;
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}
