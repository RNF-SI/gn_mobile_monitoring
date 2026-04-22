import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_group_with_relations_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_site_group_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_groups_by_id_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_site_group_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/form_data_processor.dart';

final siteGroupFormViewModelProvider = StateNotifierProvider.family<
    SiteGroupFormViewModel,
    void,
    (int, int?)>((ref, params) {
  final (moduleId, siteGroupId) = params;
  final createSiteGroupWithRelationsUseCase =
      ref.watch(createSiteGroupWithRelationsUseCaseProvider);
  final updateSiteGroupUseCase = ref.watch(updateSiteGroupUseCaseProvider);
  final deleteSiteGroupUseCase = ref.watch(deleteSiteGroupUseCaseProvider);
  final getUserIdUseCase = ref.watch(getUserIdFromLocalStorageUseCaseProvider);
  final getSiteGroupByIdUseCase = ref.watch(getSiteGroupByIdUseCaseProvider);
  final formDataProcessor = ref.watch(formDataProcessorProvider);

  return SiteGroupFormViewModel(
    createSiteGroupWithRelationsUseCase,
    updateSiteGroupUseCase,
    deleteSiteGroupUseCase,
    getUserIdUseCase,
    getSiteGroupByIdUseCase,
    formDataProcessor,
    moduleId,
    siteGroupId ?? 0,
  );
});

class SiteGroupFormViewModel extends StateNotifier<void> {
  final CreateSiteGroupWithRelationsUseCase _createSiteGroupWithRelationsUseCase;
  final UpdateSiteGroupUseCase _updateSiteGroupUseCase;
  final DeleteSiteGroupUseCase _deleteSiteGroupUseCase;
  final GetUserIdFromLocalStorageUseCase _getUserIdUseCase;
  final GetSiteGroupsByIdUseCase _getSiteGroupByIdUseCase;
  final FormDataProcessor _formDataProcessor;
  final int _moduleId;
  final int _siteGroupId;

  SiteGroupFormViewModel(
    this._createSiteGroupWithRelationsUseCase,
    this._updateSiteGroupUseCase,
    this._deleteSiteGroupUseCase,
    this._getUserIdUseCase,
    this._getSiteGroupByIdUseCase,
    this._formDataProcessor,
    this._moduleId,
    this._siteGroupId,
  ) : super(null);

  /// Crée un nouveau groupe de site à partir des données du formulaire
  /// Retourne l'ID du site créé
  Future<int?> createSiteGroupFromFormData(
    Map<String, dynamic> formData, {
    int? moduleId,
  }) async {
    try {
      // Traiter les données du formulaire
      final processedData = await _formDataProcessor.processFormData(formData);

      // Récupérer l'ID de l'utilisateur connecté
      final userId = await _getUserIdUseCase.execute();

      // Convertir les données en SiteGroup
      final siteGroup = _prepareSiteGroupFromFormData(
        processedData,
        moduleId: moduleId ?? _moduleId,
        userId: userId,
      );

      // Créer le groupe de sites avec ses relations via le use case
      final siteGroupId = await _createSiteGroupWithRelationsUseCase.execute(
        siteGroup: siteGroup,
        moduleId: moduleId ?? _moduleId,
      );

      return siteGroupId;
    } catch (e) {
      debugPrint('Erreur lors de la création du groupe sites: $e');
      rethrow;
    }
  }

  /// Met à jour un groupe de sites existant à partir des données du formulaire
  Future<bool> updateSiteGroupFromFormData(
    Map<String, dynamic> formData,
    SiteGroup existingSiteGroup, {
    int? moduleId,
  }) async {
    try {
      // Traiter les données du formulaire
      final processedData = await _formDataProcessor.processFormData(formData);

      // Récupérer l'ID de l'utilisateur connecté
      final userId = await _getUserIdUseCase.execute();

      // Collecter les champs dynamiques (non base) dans data
      final dynamicData = _extractDynamicFields(processedData);

      // Mettre à jour le groupe de sites avec les nouvelles données
      final updatedSite = existingSiteGroup.copyWith(
        sitesGroupName: processedData['sites_group_name'] as String?,
        sitesGroupCode: processedData['sites_group_code'] as String?,
        sitesGroupDescription: processedData['sites_group_description'] as String?,
        comments: processedData['comments'] as String?,
        altitudeMin: _parseIntOrNull(processedData['altitude_min']),
        altitudeMax: _parseIntOrNull(processedData['altitude_max']),
        metaUpdateDate: DateTime.now(),
        data: dynamicData.isNotEmpty ? jsonEncode(dynamicData) : null,
      );

      // Mettre à jour le site
      final success = await _updateSiteGroupUseCase.execute(updatedSite);

      return success;
    } catch (e) {
      debugPrint('Erreur lors de la mise à jour du groupe de site: $e');
      return false;
    }
  }

  /// Supprime un site
  Future<bool> deleteSiteGroup(int siteGroupId) async {
    try {
      return await _deleteSiteGroupUseCase.execute(siteGroupId);
    } catch (e) {
      debugPrint('Erreur lors de la suppression du groupe de site: $e');
      return false;
    }
  }

  /// Récupère un site group par son ID
  Future<SiteGroup?> getSiteGroupById(int siteGroupId) async {
    try {
      return await _getSiteGroupByIdUseCase.execute(siteGroupId);
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
  }) {
    final now = DateTime.now();

    // Collecter les champs dynamiques (non base) dans data
    final dynamicData = _extractDynamicFields(formData);

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
      isLocal: true,
      data: dynamicData.isNotEmpty ? jsonEncode(dynamicData) : null,
    );
  }

  /// Extrait les champs dynamiques du formulaire (non mappés aux champs de base de SiteGroup)
  Map<String, dynamic> _extractDynamicFields(Map<String, dynamic> formData) {
    const baseFields = {
      'sites_group_name',
      'sites_group_code',
      'sites_group_description',
      'comments',
      'altitude_min',
      'altitude_max',
      'id_digitiser',
      'id_sites_group',
      'meta_create_date',
      'meta_update_date',
      'geom',
      'uuid_sites_group',
    };

    final dynamicData = <String, dynamic>{};
    for (final entry in formData.entries) {
      if (!baseFields.contains(entry.key) && entry.value != null) {
        dynamicData[entry.key] = entry.value;
      }
    }
    return dynamicData;
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

