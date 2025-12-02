
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/data/data_module.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/model/sites_group_module.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_group_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_site_group_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_site_group_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/form_data_processor.dart';

final siteGroupFormViewModelProvider = StateNotifierProvider.family<
    SiteGroupFormViewModel,
    void,
    (int, int?)>((ref, params) {
  final (moduleId, siteGroupId) = params;

  final createSiteGroupUseCase = ref.watch(createSiteGroupUseCaseProvider);
  final updateSiteGroupUseCase = ref.watch(updateSiteGroupUseCaseProvider);
  final deleteSiteGroupUseCase = ref.watch(deleteSiteGroupUseCaseProvider);
  final getUserIdUseCase = ref.watch(getUserIdFromLocalStorageUseCaseProvider);
  final formDataProcessor = ref.watch(formDataProcessorProvider);
  final sitesDatabase = ref.watch(siteDatabaseProvider);

  return SiteGroupFormViewModel(
    createSiteGroupUseCase,
    updateSiteGroupUseCase,
    deleteSiteGroupUseCase,
    getUserIdUseCase,
    formDataProcessor,
    sitesDatabase,
    moduleId,
    siteGroupId,
  );
});

class SiteGroupFormViewModel extends StateNotifier<void> {
  final CreateSiteGroupUseCase _createSiteGroupUseCase;
  final UpdateSiteGroupUseCase _updateSiteGroupUseCase;
  final DeleteSiteGroupUseCase _deleteSiteGroupUseCase;
  final GetUserIdFromLocalStorageUseCase _getUserIdUseCase;
  final FormDataProcessor _formDataProcessor;
  final SitesDatabase _sitesDatabase;
  final int _moduleId;
  final int? _siteGroupId;

  SiteGroupFormViewModel(
    this._createSiteGroupUseCase,
    this._updateSiteGroupUseCase,
    this._deleteSiteGroupUseCase,
    this._getUserIdUseCase,
    this._formDataProcessor,
    this._sitesDatabase,
    this._moduleId,
    this._siteGroupId,
  ) : super(null);

  /// Crée un nouveau groupe de site à partir des données du formulaire
  /// Retourne l'ID du site créé
  Future<int?> createSiteGroupFromFormData(
    Map<String, dynamic> formData, {
    int? moduleId,
    int? selectedSiteTypeId,
  }) async {
    try {
      // Traiter les données du formulaire
      final processedData = await _formDataProcessor.processFormData(formData);

      // Récupérer l'ID de l'utilisateur connecté
      final userId = await _getUserIdUseCase.execute();

      // Convertir les données en BaseSite
      final siteGroup = _prepareSiteGroupFromFormData(
        processedData,
        moduleId: moduleId ?? _moduleId,
        userId: userId,
        selectedSiteTypeId: selectedSiteTypeId,
      );

      // Créer le site
      final siteGroupId = await _createSiteGroupUseCase.execute(siteGroup);

      // Créer la relation site-module
      await _sitesDatabase.insertSiteGroupModule(SitesGroupModule (
        idSitesGroup: siteGroupId,
        idModule: moduleId ?? _moduleId,
      ));

      // Créer le complément de site si nécessaire
      final complementData = <String, dynamic>{};
      
      // Ajouter le type de site si spécifié
      if (selectedSiteTypeId != null) {
        complementData['id_nomenclature_type_site'] = selectedSiteTypeId;
      }
      
      // Ajouter le groupe de sites si spécifié
      if (_siteGroupId != null) {
        complementData['id_sites_group'] = _siteGroupId;
      }
      
      // Ajouter les autres champs spécifiques du formulaire qui ne sont pas dans BaseSite
      final specificFields = ['id_sites_group', 'id_nomenclature_type_site', 'initial_code'];
      for (final field in specificFields) {
        if (processedData.containsKey(field) && !complementData.containsKey(field)) {
          complementData[field] = processedData[field];
        }
      }
      
      // Ajouter tous les autres champs qui ne sont pas des champs de base
      final baseSiteGroupFields = [
        'id_sites_group', 'sites_group_name', 'sites_group_code', 'sites_group_description',
        'geom', 'uuid_sites_group', 'altitude_min', 'altitude_max',
        'meta_create_date', 'meta_update_date', 'id_module', 'id_digitiser', 'comments'
      ];
      
      for (final entry in processedData.entries) {
        if (!baseSiteGroupFields.contains(entry.key) && !complementData.containsKey(entry.key)) {
          complementData[entry.key] = entry.value;
        }
      }

      // // Créer le complément seulement s'il y a des données
      // if (complementData.isNotEmpty) {
      //   await _sitesDatabase.insertSiteComplements([
      //     SiteComplement(
      //       idBaseSite: siteId,
      //       idSitesGroup: _siteGroupId,
      //       data: jsonEncode(complementData),
      //     ),
      //   ]);
      // }

      return siteGroupId;
    } catch (e) {
      debugPrint('Erreur lors de la création du site: $e');
      rethrow;
    }
  }

  /// Met à jour un site existant à partir des données du formulaire
  Future<bool> updateSiteFromFormData(
    Map<String, dynamic> formData,
    SiteGroup existingSite, {
    int? moduleId,
    int? selectedSiteTypeId,
  }) async {
    try {
      // Traiter les données du formulaire
      final processedData = await _formDataProcessor.processFormData(formData);

      // Récupérer l'ID de l'utilisateur connecté
      final userId = await _getUserIdUseCase.execute();

      // Mettre à jour le groupe de sites avec les nouvelles données
      final updatedSite = existingSite.copyWith(
        sitesGroupName: processedData['sites_group_name'] as String?,
        sitesGroupCode: processedData['sites_group_code'] as String?,
        sitesGroupDescription: processedData['sites_group_description'] as String?,
        comments: processedData['comments'] as String?,
        altitudeMin: _parseIntOrNull(processedData['altitude_min']),
        altitudeMax: _parseIntOrNull(processedData['altitude_max']),
        metaUpdateDate: DateTime.now(),
      );

      // Mettre à jour le site
      final success = await _updateSiteGroupUseCase.execute(updatedSite);

      // TODO: Mettre à jour SiteComplement si nécessaire

      return success;
    } catch (e) {
      debugPrint('Erreur lors de la mise à jour du site: $e');
      return false;
    }
  }

  /// Supprime un site
  Future<bool> deleteSite(int siteId) async {
    try {
      return await _deleteSiteGroupUseCase.execute(siteId);
    } catch (e) {
      debugPrint('Erreur lors de la suppression du site: $e');
      return false;
    }
  }

   /// Récupère un site group par son ID
  Future<SiteGroup?> getSiteGroupById(int siteGroupId) async {
    try {
      return await _sitesDatabase.getSiteGroupById(siteGroupId);
    } catch (e) {
      debugPrint('Erreur lors de la récupération du groupe de site: $e');
      return null;
    }
  }

  /// Prépare un objet SiteGroup à partir des données du formulaire
  SiteGroup _prepareSiteGroupFromFormData(
    Map<String, dynamic> formData, {
    required int moduleId,
    required int userId,
    int? selectedSiteTypeId,
  }) {
    final now = DateTime.now();

    return SiteGroup(
      idSitesGroup: 0, // Sera remplacé par la base de données (autoIncrement)
      sitesGroupName: formData['sites_group_name'] as String?,
      sitesGroupCode: formData['sites_group_code'] as String?,
      sitesGroupDescription: formData['sites_group_description'] as String?,
      comments: formData['comments'] as String?,
      altitudeMin: _parseIntOrNull(formData['altitude_min']),
      altitudeMax: _parseIntOrNull(formData['altitude_max']),
      idDigitiser: userId,
      metaCreateDate: now,
      metaUpdateDate: now,
      // geom sera géré séparément si nécessaire
    );
  }

  /// Convertit une valeur en int? de manière sécurisée
  /// Gère les cas où la valeur est déjà un int, une String, ou null
  int? _parseIntOrNull(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      final parsed = int.tryParse(value);
      return parsed;
    }
    if (value is num) return value.toInt();
    return null;
  }
}

