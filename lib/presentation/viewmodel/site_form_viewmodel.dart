import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/data/data_module.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/site_module.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_sites_by_site_group_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_sites_by_site_group_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_site_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_site_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/form_data_processor.dart';

final siteFormViewModelProvider = StateNotifierProvider.family<
    SiteFormViewModel,
    void,
    (int, int?)>((ref, params) {
  final (moduleId, siteGroupId) = params;
  final getSitesBySiteGroupUseCase =
      ref.watch(getSitesBySiteGroupUseCaseProvider);
  final createSiteUseCase = ref.watch(createSiteUseCaseProvider);
  final updateSiteUseCase = ref.watch(updateSiteUseCaseProvider);
  final deleteSiteUseCase = ref.watch(deleteSiteUseCaseProvider);
  final getUserIdUseCase = ref.watch(getUserIdFromLocalStorageUseCaseProvider);
  final formDataProcessor = ref.watch(formDataProcessorProvider);
  final sitesDatabase = ref.watch(siteDatabaseProvider);

  return SiteFormViewModel(
    createSiteUseCase,
    updateSiteUseCase,
    deleteSiteUseCase,
    getUserIdUseCase,
    getSitesBySiteGroupUseCase,
    formDataProcessor,
    sitesDatabase,
    moduleId,
    siteGroupId ?? 0
  );
});

class SiteFormViewModel extends StateNotifier<void> {
  final CreateSiteUseCase _createSiteUseCase;
  final UpdateSiteUseCase _updateSiteUseCase;
  final DeleteSiteUseCase _deleteSiteUseCase;
  final GetUserIdFromLocalStorageUseCase _getUserIdUseCase;
  final GetSitesBySiteGroupUseCase _getSitesBySiteGroupUseCase;
  final FormDataProcessor _formDataProcessor;
  final SitesDatabase _sitesDatabase;
  final int _moduleId;
  final int _siteGroupId;

  bool _mounted = true;

  SiteFormViewModel(
    this._createSiteUseCase,
    this._updateSiteUseCase,
    this._deleteSiteUseCase,
    this._getUserIdUseCase,
    this._getSitesBySiteGroupUseCase,
    this._formDataProcessor,
    this._sitesDatabase,
    this._moduleId,
    this._siteGroupId,
  ) : super(const AsyncValue.loading()) {
    if (_siteGroupId > 0) {
      loadSite();
    }
  }

  /// Charge tous les sites pour le groupe de sites
  Future<void> loadSite() async {
    if (!_mounted) return;

    try {
      state = const AsyncValue.loading();
      final sites =
          await _getSitesBySiteGroupUseCase.execute(_siteGroupId);

      // Traiter les données pour l'affichage - convertir les IDs de nomenclature en objets
      final processedSites =
          await Future.wait(sites.map((site) async {
        final processedData = await _formDataProcessor
            .processFormDataForDisplay(site.data!);
        return site.copyWith(data: processedData);
      }));

      if (_mounted) {
        state = AsyncValue.data(processedSites);
      }
    } catch (e, stack) {
      if (_mounted) {
        state = AsyncValue.error(e, stack);
      }
    }
  }

  /// Crée un nouveau site à partir des données du formulaire
  /// Retourne l'ID du site créé
  Future<int?> createSiteFromFormData(
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
      final site = _prepareSiteFromFormData(
        processedData,
        moduleId: moduleId ?? _moduleId,
        userId: userId,
        selectedSiteTypeId: selectedSiteTypeId,
      );

      // Créer le site
      final siteId = await _createSiteUseCase.execute(site);

      // Créer la relation site-module
      await _sitesDatabase.insertSiteModule(SiteModule(
        idSite: siteId,
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

      // Créer le complément seulement s'il y a des données
      if (complementData.isNotEmpty) {
        await _sitesDatabase.insertSiteComplements([
          SiteComplement(
            idBaseSite: siteId,
            idSitesGroup: _siteGroupId,
            data: jsonEncode(complementData),
          ),
        ]);
      }

      return siteId;
    } catch (e) {
      debugPrint('Erreur lors de la création du site: $e');
      rethrow;
    }
  }

  /// Met à jour un site existant à partir des données du formulaire
  Future<bool> updateSiteFromFormData(
    Map<String, dynamic> formData,
    BaseSite existingSite, {
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
        baseSiteName: processedData['base_site_name'] as String?,
        baseSiteCode: processedData['base_site_code'] as String?,
        baseSiteDescription: processedData['base_site_description'] as String?,
        firstUseDate: processedData['first_use_date'] != null
            ? DateTime.tryParse(processedData['first_use_date'] as String)
            : existingSite.firstUseDate,
        altitudeMin: processedData['altitude_min'] as int?,
        altitudeMax: processedData['altitude_max'] as int?,
        metaUpdateDate: DateTime.now(),
      );

      // Mettre à jour le site
      final success = await _updateSiteUseCase.execute(updatedSite);

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
      return await _deleteSiteUseCase.execute(siteId);
    } catch (e) {
      debugPrint('Erreur lors de la suppression du site: $e');
      return false;
    }
  }

  /// Récupère un site par son ID
  Future<BaseSite?> getSiteById(int siteId) async {
    try {
      return await _sitesDatabase.getSiteById(siteId);
    } catch (e) {
      debugPrint('Erreur lors de la récupération du site: $e');
      return null;
    }
  }

  /// Prépare un objet BaseSite à partir des données du formulaire
  BaseSite _prepareSiteFromFormData(
    Map<String, dynamic> formData, {
    required int moduleId,
    required int userId,
    int? selectedSiteTypeId,
  }) {
    final now = DateTime.now();

    return BaseSite(
      idBaseSite: 0, // Sera remplacé par la base de données (autoIncrement)
      baseSiteName: formData['base_site_name'] as String?,
      baseSiteCode: formData['base_site_code'] as String?,
      baseSiteDescription: formData['base_site_description'] as String?,
      firstUseDate: formData['first_use_date'] != null
          ? DateTime.tryParse(formData['first_use_date'] as String)
          : now,
      altitudeMin: formData['altitude_min'] as int?,
      altitudeMax: formData['altitude_max'] as int?,
      metaCreateDate: now,
      metaUpdateDate: now,
      // geom sera géré séparément si nécessaire
    );
  }
}

