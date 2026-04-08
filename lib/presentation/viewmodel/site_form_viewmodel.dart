import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/data/data_module.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_with_relations_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_by_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_sites_by_site_group_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_site_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_location_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_site_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/form_data_processor.dart';

final siteFormViewModelProvider = StateNotifierProvider.family<
    SiteFormViewModel,
    void,
    (int, int?)>((ref, params) {
  final (moduleId, siteGroupId) = params;
  final getSitesBySiteGroupUseCase =
      ref.watch(getSitesBySiteGroupUseCaseProvider);
  final createSiteWithRelationsUseCase =
      ref.watch(createSiteWithRelationsUseCaseProvider);
  final updateSiteUseCase = ref.watch(updateSiteUseCaseProvider);
  final deleteSiteUseCase = ref.watch(deleteSiteUseCaseProvider);
  final getUserIdUseCase = ref.watch(getUserIdFromLocalStorageUseCaseProvider);
  final getSiteByIdUseCase = ref.watch(getSiteByIdUseCaseProvider);
  final getUserLocationUseCase = ref.watch(getUserLocationUseCaseProvider);
  final formDataProcessor = ref.watch(formDataProcessorProvider);
  final sitesDatabase = ref.watch(siteDatabaseProvider);

  return SiteFormViewModel(
    createSiteWithRelationsUseCase,
    updateSiteUseCase,
    deleteSiteUseCase,
    getUserIdUseCase,
    getSitesBySiteGroupUseCase,
    getSiteByIdUseCase,
    getUserLocationUseCase,
    formDataProcessor,
    sitesDatabase,
    moduleId,
    siteGroupId ?? 0,
  );
});

class SiteFormViewModel extends StateNotifier<void> {
  final CreateSiteWithRelationsUseCase _createSiteWithRelationsUseCase;
  final UpdateSiteUseCase _updateSiteUseCase;
  final DeleteSiteUseCase _deleteSiteUseCase;
  final GetUserIdFromLocalStorageUseCase _getUserIdUseCase;
  final GetSitesBySiteGroupUseCase _getSitesBySiteGroupUseCase;
  final GetSiteByIdUseCase _getSiteByIdUseCase;
  final GetUserLocationUseCase _getUserLocationUseCase;
  final FormDataProcessor _formDataProcessor;
  final SitesDatabase _sitesDatabase;
  final int _moduleId;
  final int _siteGroupId;

  bool _mounted = true;

  SiteFormViewModel(
    this._createSiteWithRelationsUseCase,
    this._updateSiteUseCase,
    this._deleteSiteUseCase,
    this._getUserIdUseCase,
    this._getSitesBySiteGroupUseCase,
    this._getSiteByIdUseCase,
    this._getUserLocationUseCase,
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
  /// Si [geomOverride] est fourni, il est utilisé directement comme géométrie GeoJSON.
  /// Sinon, la position GPS de l'utilisateur est récupérée automatiquement.
  Future<int?> createSiteFromFormData(
    Map<String, dynamic> formData, {
    int? moduleId,
    String? geomOverride,
  }) async {
    try {
      // Traiter les données du formulaire
      final processedData = await _formDataProcessor.processFormData(formData);

      // Récupérer l'ID de l'utilisateur connecté
      final userId = await _getUserIdUseCase.execute();

      // Utiliser la géométrie fournie ou récupérer la position GPS
      String? geomGeoJson;
      if (geomOverride != null) {
        geomGeoJson = geomOverride;
      } else {
        final locationResult = await _getUserLocationUseCase.execute();
        if (locationResult != null) {
          geomGeoJson = jsonEncode({
            'type': 'Point',
            'coordinates': [
              locationResult.position.longitude,
              locationResult.position.latitude,
            ],
          });
        }
      }

      // Convertir les données en BaseSite
      final site = _prepareSiteFromFormData(
        processedData,
        moduleId: moduleId ?? _moduleId,
        userId: userId,
        geom: geomGeoJson,
      );

      // Préparer le complément de site
      final complementData = _prepareComplementData(processedData);

      // Créer le complément seulement s'il y a des données
      SiteComplement? complement;
      if (complementData.isNotEmpty) {
        complement = SiteComplement(
          idBaseSite: 0, // Sera mis à jour par le use case
          idSitesGroup: _siteGroupId,
          data: jsonEncode(complementData),
        );
      }

      // Créer le site avec ses relations via le use case
      final siteId = await _createSiteWithRelationsUseCase.execute(
        site: site,
        moduleId: moduleId ?? _moduleId,
        complement: complement,
      );

      return siteId;
    } catch (e) {
      debugPrint('Erreur lors de la création du site: $e');
      rethrow;
    }
  }

  /// Prépare les données du complément de site
  Map<String, dynamic> _prepareComplementData(
    Map<String, dynamic> processedData,
  ) {
    final complementData = <String, dynamic>{};

    // Ajouter le groupe de sites si spécifié
    if (_siteGroupId > 0) {
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

    // Convertir types_site de List<String> (format datalist) en List<int>
    if (complementData.containsKey('types_site') && complementData['types_site'] is List) {
      complementData['types_site'] = (complementData['types_site'] as List)
          .map((e) => int.tryParse(e.toString()))
          .where((e) => e != null)
          .toList();
    }

    return complementData;
  }

  /// Met à jour un site existant à partir des données du formulaire.
  /// Si [geomOverride] est fourni, il est utilisé directement comme géométrie GeoJSON.
  Future<bool> updateSiteFromFormData(
    Map<String, dynamic> formData,
    BaseSite existingSite, {
    int? moduleId,
    String? geomOverride,
  }) async {
    try {
      // Vérifier que le site a été créé localement et n'a pas été synchronisé
      if (existingSite.isLocal != true) {
        debugPrint('Erreur: Impossible de modifier un site qui n\'a pas été créé localement');
        return false;
      }
      if (existingSite.serverSiteId != null) {
        debugPrint('Erreur: Impossible de modifier un site déjà synchronisé avec le serveur');
        return false;
      }

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
        geom: geomOverride ?? existingSite.geom,
        metaUpdateDate: DateTime.now(),
      );

      // Mettre à jour le site
      final success = await _updateSiteUseCase.execute(updatedSite);

      // Mettre à jour SiteComplement avec les champs dynamiques
      if (success) {
        final complementData = _prepareComplementData(processedData);

        if (complementData.isNotEmpty) {
          final complement = SiteComplement(
            idBaseSite: existingSite.idBaseSite,
            idSitesGroup: _siteGroupId > 0 ? _siteGroupId : null,
            data: jsonEncode(complementData),
          );
          await _sitesDatabase.insertSiteComplements([complement]);
        }
      }

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
      return await _getSiteByIdUseCase.execute(siteId);
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
    String? geom,
  }) {
    final now = DateTime.now();

    // Filet de sécurité : générer un nom de site si null
    final siteName = formData['base_site_name'] as String?;
    final fallbackName = siteName ?? 'Site-${now.millisecondsSinceEpoch}';

    return BaseSite(
      idBaseSite: 0, // Sera remplacé par la base de données (autoIncrement)
      baseSiteName: fallbackName,
      baseSiteCode: formData['base_site_code'] as String?,
      baseSiteDescription: formData['base_site_description'] as String?,
      firstUseDate: formData['first_use_date'] != null
          ? DateTime.tryParse(formData['first_use_date'] as String)
          : now,
      geom: geom,
      altitudeMin: formData['altitude_min'] as int?,
      altitudeMax: formData['altitude_max'] as int?,
      idInventor: userId,
      idDigitiser: userId,
      metaCreateDate: now,
      metaUpdateDate: now,
      isLocal: true, // Site créé localement
    );
  }
}

