import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/format_datetime.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/visit_complement.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_visit_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_visit_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_name_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visit_complement_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visit_with_details_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visits_by_site_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/save_visit_complement_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_visit_use_case.dart';

final siteVisitsViewModelProvider = StateNotifierProvider.family<
    SiteVisitsViewModel, AsyncValue<List<BaseVisit>>, int>((ref, siteId) {
  final getVisitsBySiteIdUseCase = ref.watch(getVisitsBySiteIdUseCaseProvider);
  final getVisitWithDetailsUseCase =
      ref.watch(getVisitWithDetailsUseCaseProvider);
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

  return SiteVisitsViewModel(
    getVisitsBySiteIdUseCase,
    getVisitWithDetailsUseCase,
    getVisitComplementUseCase,
    saveVisitComplementUseCase,
    createVisitUseCase,
    updateVisitUseCase,
    deleteVisitUseCase,
    getUserIdUseCase,
    getUserNameUseCase,
    siteId,
  );
});

class SiteVisitsViewModel extends StateNotifier<AsyncValue<List<BaseVisit>>> {
  final GetVisitsBySiteIdUseCase _getVisitsBySiteIdUseCase;
  final GetVisitWithDetailsUseCase _getVisitWithDetailsUseCase;
  final GetVisitComplementUseCase _getVisitComplementUseCase;
  final SaveVisitComplementUseCase _saveVisitComplementUseCase;
  final CreateVisitUseCase _createVisitUseCase;
  final UpdateVisitUseCase _updateVisitUseCase;
  final DeleteVisitUseCase _deleteVisitUseCase;
  final GetUserIdFromLocalStorageUseCase _getUserIdUseCase;
  final GetUserNameFromLocalStorageUseCase _getUserNameUseCase;
  final int _siteId;
  bool _mounted = true;

  SiteVisitsViewModel(
    this._getVisitsBySiteIdUseCase,
    this._getVisitWithDetailsUseCase,
    this._getVisitComplementUseCase,
    this._saveVisitComplementUseCase,
    this._createVisitUseCase,
    this._updateVisitUseCase,
    this._deleteVisitUseCase,
    this._getUserIdUseCase,
    this._getUserNameUseCase,
    this._siteId,
  ) : super(const AsyncValue.loading()) {
    loadVisits();
  }

  /// Charge toutes les visites pour le site courant
  Future<void> loadVisits() async {
    if (!_mounted) return;

    try {
      state = const AsyncValue.loading();
      final visits = await _getVisitsBySiteIdUseCase.execute(_siteId);
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

    // Créer une structure JSON qui suit le format attendu par BaseVisit.fromJson()
    final Map<String, dynamic> jsonData = {
      // Champs obligatoires avec valeurs par défaut
      'idBaseVisit': visitId ?? 0,
      'idBaseSite': site.idBaseSite,
      'idDataset':
          1, // Valeur par défaut ou à récupérer depuis la configuration
      'idModule': moduleId ?? 1, // Valeur par défaut si non spécifiée
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
    // Liste des clés à exclure (champs standard)
    const standardFields = {
      'id_base_visit',
      'id_base_site',
      'id_dataset',
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
