import 'dart:convert';

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
      final baseSiteFields = [
        'id_base_site', 'base_site_name', 'base_site_code', 'base_site_description',
        'first_use_date', 'geom', 'uuid_base_site', 'altitude_min', 'altitude_max',
        'meta_create_date', 'meta_update_date', 'id_module', 'id_digitiser', 'id_inventor'
      ];
      
      for (final entry in processedData.entries) {
        if (!baseSiteFields.contains(entry.key) && !complementData.containsKey(entry.key)) {
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

      // Mettre à jour le site avec les nouvelles données
      final updatedSite = existingSite.copyWith(
        sitesGroupName: processedData['base_site_name'] as String?,
        sitesGroupCode: processedData['base_site_code'] as String?,
        sitesGroupDescription: processedData['base_site_description'] as String?,
        altitudeMin: processedData['altitude_min'] as int?,
        altitudeMax: processedData['altitude_max'] as int?,
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

  /// Prépare un objet BaseSite à partir des données du formulaire
  SiteGroup _prepareSiteGroupFromFormData(
    Map<String, dynamic> formData, {
    required int moduleId,
    required int userId,
    int? selectedSiteTypeId,
  }) {
    final now = DateTime.now();

    return SiteGroup(
      idSitesGroup: 0, // Sera remplacé par la base de données (autoIncrement)
      // geom sera géré séparément si nécessaire
    );
  }
}

